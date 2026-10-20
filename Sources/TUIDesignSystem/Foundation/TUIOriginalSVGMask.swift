import Foundation
import SwiftUI

/// Reads the original Figma paths and alpha gradients. This intentionally
/// supports the mask subset present in the verified source assets, not SVG in
/// general: unsupported features fail instead of silently changing the glyph.
struct TUIOriginalSVGMask: View {
    let resource: String

    var body: some View {
        let asset = TUISVGMaskCache.load(resource)
        Canvas { context, size in
            guard let asset else { return }
            context.scaleBy(x: size.width / asset.size.width, y: size.height / asset.size.height)
            for item in asset.paths {
                var layer = context
                layer.opacity = item.opacity
                layer.clip(to: Path(item.path), style: FillStyle(eoFill: item.evenOdd))
                if let gradientID = item.gradientID, let gradient = asset.gradients[gradientID] {
                    layer.fill(Path(CGRect(origin: .zero, size: asset.size)),
                        with: .linearGradient(Gradient(stops: gradient.stops.map {
                            .init(color: .white.opacity($0.opacity), location: $0.position)
                        }), startPoint: gradient.start, endPoint: gradient.end))
                } else {
                    layer.fill(Path(CGRect(origin: .zero, size: asset.size)), with: .color(.white))
                }
            }
        }
        .accessibilityHidden(true)
    }
}

@MainActor
private enum TUISVGMaskCache {
    static var assets: [String: TUIParsedSVGMask] = [:]

    static func load(_ name: String) -> TUIParsedSVGMask? {
        if let asset = assets[name] { return asset }
        do {
            guard let url = Bundle.module.url(forResource: name, withExtension: "svg") else {
                throw TUISVGMaskError.unsupported("Missing original SVG: " + name)
            }
            let asset = try TUIParsedSVGMask(data: Data(contentsOf: url))
            assets[name] = asset
            return asset
        } catch {
            assertionFailure(String(describing: error))
            return nil
        }
    }
}

enum TUISVGMaskError: Error { case malformed, unsupported(String) }

struct TUIParsedSVGMask {
    struct Item {
        let path: CGPath
        let opacity: Double
        let evenOdd: Bool
        let gradientID: String?
    }
    struct Gradient {
        struct Stop { let position: CGFloat; let opacity: Double }
        let start: CGPoint
        let end: CGPoint
        var stops: [Stop]
    }
    let size: CGSize
    let paths: [Item]
    let gradients: [String: Gradient]

    init(data: Data) throws {
        let delegate = TUISVGMaskXMLParser()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        guard parser.parse(), delegate.error == nil,
              delegate.size.width > 0, delegate.size.height > 0, !delegate.paths.isEmpty else {
            throw delegate.error ?? TUISVGMaskError.malformed
        }
        for item in delegate.paths {
            if let id = item.gradientID, delegate.gradients[id]?.stops.isEmpty != false {
                throw TUISVGMaskError.unsupported("Undefined alpha gradient: " + id)
            }
        }
        size = delegate.size
        paths = delegate.paths
        gradients = delegate.gradients
    }
}

private final class TUISVGMaskXMLParser: NSObject, XMLParserDelegate {
    var size = CGSize.zero
    var paths: [TUIParsedSVGMask.Item] = []
    var gradients: [String: TUIParsedSVGMask.Gradient] = [:]
    var error: Error?
    private var inMask = false
    private var hasMask = false
    private var currentGradient: String?

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes: [String: String]) {
        do {
            if attributes["transform"] != nil || attributes["filter"] != nil {
                throw TUISVGMaskError.unsupported("Unverified SVG transform/filter")
            }
            switch elementName {
            case "svg":
                guard let width = attributes["width"].flatMap(Double.init),
                      let height = attributes["height"].flatMap(Double.init),
                      attributes["viewBox"] == "0 0 \(attributes["width"]!) \(attributes["height"]!)" else {
                    throw TUISVGMaskError.unsupported("Unverified SVG viewBox")
                }
                size = CGSize(width: width, height: height)
            case "mask":
                guard !hasMask, attributes["style"]?.contains("mask-type:alpha") == true else {
                    throw TUISVGMaskError.unsupported("Only one original alpha mask is supported")
                }
                inMask = true
                hasMask = true
                paths.removeAll()
            case "path" where inMask || !hasMask:
                guard let d = attributes["d"], attributes["stroke"] == nil else {
                    throw TUISVGMaskError.unsupported("Unverified stroked path")
                }
                let fill = attributes["fill"] ?? "black"
                let gradientID = fill.hasPrefix("url(#") && fill.hasSuffix(")")
                    ? String(fill.dropFirst(5).dropLast()) : nil
                paths.append(.init(path: try TUISVGSourcePath.parse(d),
                    opacity: (attributes["opacity"].flatMap(Double.init) ?? 1)
                        * (attributes["fill-opacity"].flatMap(Double.init) ?? 1),
                    evenOdd: attributes["fill-rule"] == "evenodd", gradientID: gradientID))
            case "linearGradient":
                guard attributes["gradientUnits"] == "userSpaceOnUse", let id = attributes["id"],
                      let x1 = attributes["x1"].flatMap(Double.init), let y1 = attributes["y1"].flatMap(Double.init),
                      let x2 = attributes["x2"].flatMap(Double.init), let y2 = attributes["y2"].flatMap(Double.init) else {
                    throw TUISVGMaskError.unsupported("Unverified gradient coordinates")
                }
                currentGradient = id
                gradients[id] = .init(start: CGPoint(x: x1, y: y1), end: CGPoint(x: x2, y: y2), stops: [])
            case "stop":
                guard let id = currentGradient else { throw TUISVGMaskError.malformed }
                let offset = attributes["offset"] ?? "0"
                guard let value = Double(offset.replacingOccurrences(of: "%", with: "")) else {
                    throw TUISVGMaskError.malformed
                }
                gradients[id]?.stops.append(.init(position: value / (offset.hasSuffix("%") ? 100 : 1),
                    opacity: attributes["stop-opacity"].flatMap(Double.init) ?? 1))
            case "circle", "ellipse", "rect", "polygon", "polyline", "image", "use", "radialGradient":
                throw TUISVGMaskError.unsupported("Unverified mask element: " + elementName)
            default: break
            }
        } catch {
            self.error = error
            parser.abortParsing()
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "mask" { inMask = false }
        if elementName == "linearGradient" { currentGradient = nil }
    }
}

/// Original path data stays in the exported SVG. No icon geometry is authored here.
private enum TUISVGSourcePath {
    static func parse(_ source: String) throws -> CGPath {
        let regex = try NSRegularExpression(pattern: "[A-Za-z]|[-+]?(?:[0-9]*\\.[0-9]+|[0-9]+\\.?[0-9]*)(?:[eE][-+]?[0-9]+)?")
        let tokens = regex.matches(in: source, range: NSRange(source.startIndex..., in: source))
            .compactMap { Range($0.range, in: source).map { String(source[$0]) } }
        let path = CGMutablePath()
        var index = 0
        var command = ""
        var current = CGPoint.zero
        var start = CGPoint.zero
        func number() throws -> CGFloat {
            guard index < tokens.count, let value = Double(tokens[index]) else { throw TUISVGMaskError.malformed }
            index += 1
            return CGFloat(value)
        }
        func point(relative: Bool) throws -> CGPoint {
            let x = try number(), y = try number()
            return CGPoint(x: x + (relative ? current.x : 0), y: y + (relative ? current.y : 0))
        }
        while index < tokens.count {
            if tokens[index].first?.isLetter == true {
                command = tokens[index]
                index += 1
            }
            let relative = command == command.lowercased()
            switch command.uppercased() {
            case "M":
                current = try point(relative: relative)
                path.move(to: current)
                start = current
                command = relative ? "l" : "L"
            case "L": current = try point(relative: relative); path.addLine(to: current)
            case "H": current.x = try number() + (relative ? current.x : 0); path.addLine(to: current)
            case "V": current.y = try number() + (relative ? current.y : 0); path.addLine(to: current)
            case "C":
                let first = try point(relative: relative), second = try point(relative: relative), end = try point(relative: relative)
                path.addCurve(to: end, control1: first, control2: second)
                current = end
            case "Q":
                let control = try point(relative: relative), end = try point(relative: relative)
                path.addQuadCurve(to: end, control: control)
                current = end
            case "Z": path.closeSubpath(); current = start; command = ""
            default: throw TUISVGMaskError.unsupported("Unverified SVG path command: " + command)
            }
        }
        return path
    }
}
