import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class ButtonColorTests: XCTestCase {
    private func metadata(_ name: String) throws -> [String: Any] {
        let url = try XCTUnwrap(Bundle.module.url(forResource: name, withExtension: "json"))
        return try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any])
    }

    private func bindings() throws -> [String: String] {
        let rows = try XCTUnwrap(try metadata("figma-button-variable-bindings")["variables"] as? [[String: String]])
        return Dictionary(uniqueKeysWithValues: try rows.map { row in
            XCTAssertEqual(row["collection"], "Theme")
            return (try XCTUnwrap(row["key"]), try XCTUnwrap(row["name"]))
        })
    }

    private func tokenName(_ paint: [String: Any], bindings: [String: String]) throws -> String {
        let alias = try XCTUnwrap(paint["alias"] as? String)
        XCTAssertTrue(alias.hasPrefix("VariableID:"))
        let key = try XCTUnwrap(alias.dropFirst("VariableID:".count).split(separator: "/").first)
        return try XCTUnwrap(bindings[String(key)], "Unmapped original Variable key: \(alias)")
    }

    private func rgba(_ name: String, theme: TUITheme) throws -> [Double] {
        let value = try XCTUnwrap(TUITokenCatalog.shared.value(named: name, collection: "Theme", mode: theme.rawValue) as? [String: NSNumber])
        return try ["r", "g", "b", "a"].map { try XCTUnwrap(value[$0]).doubleValue }
    }

    func testEveryBoundPaintHasAnExactKeyAndPreservesSourceDayRGBA() throws {
        let map = try bindings()
        let styles = try XCTUnwrap(try metadata("figma-button-styles")["styles"] as? [[String: Any]])
        var count = 0
        var keys: Set<String> = []
        for style in styles {
            let text = style["text"] as? [String: Any]
            for paint in [style["fill"] as? [String: Any], text?["fill"] as? [String: Any]].compactMap({ $0 }) {
                let name = try tokenName(paint, bindings: map)
                let source = try XCTUnwrap(paint["color"] as? [String: NSNumber])
                let day = try rgba(name, theme: .day)
                let expected = try ["r", "g", "b"].map { try XCTUnwrap(source[$0]).doubleValue }
                    + [(source["a"]?.doubleValue ?? 1) * ((paint["opacity"] as? NSNumber)?.doubleValue ?? 1)]
                for (actual, channel) in zip(day, expected) { XCTAssertEqual(actual, channel, accuracy: 0.00001, name) }
                XCTAssertEqual(try rgba(name, theme: .night).count, 4)
                keys.insert(name)
                count += 1
            }
        }
        XCTAssertEqual(styles.count, 147)
        XCTAssertEqual(keys.count, 22)
        XCTAssertEqual(count, 228)
    }

    @MainActor func testNativeBackgroundPixelsResolveThemeAndAlphaForEveryNonGlassVariant() throws {
        let map = try bindings()
        let styles = try XCTUnwrap(try metadata("figma-button-styles")["styles"] as? [[String: Any]])
        var count = 0
        for theme in TUITheme.allCases {
            let surface = theme == .day ? 1.0 : 0.0
            for style in styles {
                let properties = try XCTUnwrap(style["properties"] as? [String: String])
                let appearance = try XCTUnwrap(TUIButtonAppearance(rawValue: try XCTUnwrap(properties["appearance"])))
                // The backdrop filter needs a real composited scene; do not
                // claim a flat-color assertion verifies glass/material.
                if appearance == .glass { continue }
                let size = try XCTUnwrap(TUIButtonSize(rawValue: try XCTUnwrap(properties["size"])))
                let state = try XCTUnwrap(TUIButtonState(rawValue: try XCTUnwrap(properties["state"])))
                let skeleton = properties["skeleton"] == "on"
                let color: [Double]
                if skeleton { color = try rgba("Service/Skeleton", theme: theme) }
                else if let paint = style["fill"] as? [String: Any] {
                    color = try rgba(tokenName(paint, bindings: map), theme: theme)
                } else { color = [0, 0, 0, 0] }
                let view = TUIButton("MMMMMMMMMMMMMMMMMMMMMMMMMMMM", appearance: appearance, size: size,
                                    state: state, skeleton: skeleton, action: {})
                    .frame(width: 335).background(theme == .day ? Color.white : Color.black)
                    .environment(\.colorScheme, theme == .day ? .light : .dark)
                    .environment(\.dynamicTypeSize, .large)
                let renderer = ImageRenderer(content: view)
                renderer.scale = 3
                let image = try XCTUnwrap(renderer.uiImage?.cgImage)
                var bytes = [UInt8](repeating: 0, count: image.width * image.height * 4)
                let context = try XCTUnwrap(CGContext(data: &bytes, width: image.width, height: image.height,
                    bitsPerComponent: 8, bytesPerRow: image.width * 4, space: CGColorSpaceCreateDeviceRGB(),
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
                context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
                let offset = (9 * image.width + image.width / 2) * 4
                let message = "\(style["id"] ?? "") / \(theme.rawValue)"
                for channel in 0..<3 {
                    let expected = (color[channel] * color[3] + surface * (1 - color[3])) * 255
                    XCTAssertEqual(Double(bytes[offset + channel]), expected, accuracy: 1.1, message)
                }
                XCTAssertEqual(bytes[offset + 3], 255, message)
                if !skeleton, let text = style["text"] as? [String: Any], let paint = text["fill"] as? [String: Any] {
                    let ink = try rgba(tokenName(paint, bindings: map), theme: theme)
                    let backdrop = (0..<3).map { color[$0] * color[3] + surface * (1 - color[3]) }
                    let expected = (0..<3).map { (ink[$0] * ink[3] + backdrop[$0] * (1 - ink[3])) * 255 }
                    var closest = Double.infinity
                    // Find fully covered native glyph pixels, allowing normal
                    // antialiasing at the contour rather than sampling a stem.
                    for y in stride(from: 12, to: image.height - 12, by: 3) {
                        for x in stride(from: image.width / 2 - 90, to: image.width / 2 + 90, by: 2) {
                            let pixel = (y * image.width + x) * 4
                            let error = (0..<3).map { abs(Double(bytes[pixel + $0]) - expected[$0]) }.max() ?? 0
                            closest = min(closest, error)
                        }
                    }
                    XCTAssertLessThanOrEqual(closest, 1.1, "Native label tint: \(message)")
                }
                count += 1
            }
        }
        XCTAssertEqual(count, 270)
    }
}
