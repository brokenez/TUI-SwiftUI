import CoreText
import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

/// Diagnoses public system-font geometry. Historical pre-migration results
/// retain their old labels; the current compatibility adapter uses native SF.
/// Successful execution is not visual acceptance.
final class SystemFontDistributionProbeTests: XCTestCase {
    @MainActor
    func testPublicOpticalSizeAndVariationProfiles() throws {
        var records: [[String: Any]] = []
        let availableNames = (CTFontManagerCopyAvailablePostScriptNames() as? [String] ?? [])
            .filter { $0.localizedCaseInsensitiveContains("SF") }.sorted()
        for (name, size, weight, tracking, specimen, legacy) in [
            ("header", CGFloat(30), UIFont.Weight.bold, CGFloat(0.36), "Зарплатный клуб", true),
            ("description", 17, .regular, -0.41, "Переведите зарплату в Т-Банк,", true),
            ("subheader", 15, .regular, -0.24, "Нужна помощь с выбором", true),
            ("card-title", 15, .semibold, -0.24, "Title · Зарплатный клуб", false),
            ("card-subtitle", 13, .regular, -0.08, "Subtitle · Все преимущества", true)
        ] {
            let system = UIFont.systemFont(ofSize: size, weight: weight)
            var profiles: [(String, UIFont)] = [("system", system)]
            let graphics = CTFontCopyGraphicsFont(system as CTFont, nil)
            let graphicsCopy = CTFontCreateWithGraphicsFont(graphics, size, nil, nil)
            profiles.append(("graphics-copy", graphicsCopy as UIFont))
            let descriptorCopy = CTFontCreateWithFontDescriptor(CTFontCopyFontDescriptor(system as CTFont), size, nil)
            profiles.append(("descriptor-copy", descriptorCopy as UIFont))
            for mode in ["none", "auto"] {
                let descriptor = system.fontDescriptor.addingAttributes([
                    UIFontDescriptor.AttributeName(rawValue: kCTFontOpticalSizeAttribute as String): mode
                ])
                profiles.append(("optical-" + mode, UIFont(descriptor: descriptor, size: size)))
            }
            for fontName in availableNames where (name == "header"
                ? fontName.localizedCaseInsensitiveContains("Display") && fontName.hasSuffix("Bold")
                : fontName.localizedCaseInsensitiveContains("Text") && fontName.hasSuffix(weight == .semibold ? "Semibold" : "Regular")) {
                if let font = UIFont(name: fontName, size: size) { profiles.append(("available-" + fontName, font)) }
            }
            if legacy {
                profiles.insert(("native-compatibility-adapter", name == "header"
                    ? TUIFigmaTextFont.displayBold(size: size) : TUIFigmaTextFont.regular(size: size)), at: 0)
            }
            for opticalSize in [17.0, 20.0, 30.0, 96.0] {
                let opticalDescriptor = system.fontDescriptor.addingAttributes([
                    UIFontDescriptor.AttributeName(rawValue: kCTFontOpticalSizeAttribute as String): opticalSize
                ])
                profiles.append(("optical-\(Int(opticalSize))", UIFont(descriptor: opticalDescriptor, size: size)))
                let variationDescriptor = system.fontDescriptor.addingAttributes([
                    UIFontDescriptor.AttributeName(rawValue: kCTFontVariationAttribute as String):
                        [NSNumber(value: 0x6F70737A): NSNumber(value: opticalSize)]
                ])
                profiles.append(("variation-\(Int(opticalSize))", UIFont(descriptor: variationDescriptor, size: size)))
            }
            for (profile, font) in profiles {
                let line = CTLineCreateWithAttributedString(NSAttributedString(string: specimen,
                    attributes: [.font: font, .kern: tracking]))
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                var leading: CGFloat = 0
                let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
                let axes = CTFontCopyVariationAxes(font as CTFont) as? [[String: Any]] ?? []
                let variation = CTFontCopyVariation(font as CTFont) as? [NSNumber: NSNumber] ?? [:]
                let glyphEvidence = Array("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЭЮЯабвгдеёжзийклмнопрстуфхцчшщыэюяTitleSubtitle0123456789".utf16).map { character -> [String: Any] in
                    var character = character
                    var glyph: CGGlyph = 0
                    CTFontGetGlyphsForCharacters(font as CTFont, &character, &glyph, 1)
                    var advance = CGSize.zero
                    CTFontGetAdvancesForGlyphs(font as CTFont, .horizontal, &glyph, &advance, 1)
                    var segments: [[Double]] = []
                    CTFontCreatePathForGlyph(font as CTFont, glyph, nil)?.applyWithBlock { pointer in
                        let element = pointer.pointee
                        let count: Int
                        switch element.type {
                        case .moveToPoint, .addLineToPoint: count = 1
                        case .addQuadCurveToPoint: count = 2
                        case .addCurveToPoint: count = 3
                        default: count = 0
                        }
                        var values = [Double(element.type.rawValue)]
                        for index in 0..<count {
                            values.append(Double(element.points[index].x / size))
                            values.append(Double(element.points[index].y / size))
                        }
                        segments.append(values)
                    }
                    return ["character": Int(character), "advance": advance.width,
                            "outline": segments]
                }
                records.append([
                    "case": name, "profile": profile, "fontName": font.fontName,
                    "size": font.pointSize, "tracking": tracking, "specimen": specimen,
                    "width": width, "ascent": ascent, "descent": descent, "leading": leading,
                    "variation": Dictionary(uniqueKeysWithValues: variation.map { (String(describing: $0.key), $0.value) }),
                    "axes": axes.map { axis in Dictionary(uniqueKeysWithValues: axis.map { ($0.key, String(describing: $0.value)) }) },
                    "descriptor": String(describing: font.fontDescriptor.fontAttributes),
                    "glyphs": glyphEvidence,
                    "availablePostScriptNamesBeforeLegacyRegistration": availableNames
                ])
            }
            let renderer = ImageRenderer(content: VStack(alignment: .leading, spacing: 12) {
                ForEach(profiles.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profiles[index].0).font(.system(size: 10, design: .monospaced)).foregroundStyle(.gray)
                        Text(specimen).font(Font(profiles[index].1)).kerning(tracking).foregroundStyle(.black)
                    }
                }
            }.padding(16).frame(width: 500, alignment: .leading).background(.white)
                .environment(\.dynamicTypeSize, .large))
            renderer.scale = 3
            let image = try XCTUnwrap(renderer.uiImage)
            let attachment = XCTAttachment(image: image)
            attachment.name = "system-font-profiles-" + name
            attachment.lifetime = .keepAlways
            add(attachment)
        }
        let data = try JSONSerialization.data(withJSONObject: records, options: [.prettyPrinted, .sortedKeys])
        let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.json")
        attachment.name = "system-font-public-profiles"
        attachment.lifetime = .keepAlways
        add(attachment)
        XCTAssertEqual(records.filter { $0["profile"] as? String == "system" }.count, 5)
        XCTAssertTrue(records.allSatisfy { ($0["width"] as? Double ?? 0) > 0 })
    }
}
