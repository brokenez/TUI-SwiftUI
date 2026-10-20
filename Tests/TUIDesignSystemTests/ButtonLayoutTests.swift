import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class ButtonLayoutTests: XCTestCase {
    @MainActor
    func testOverflowFadeMatchesSourceGradientAndKeepsUnfadedGlyphs() throws {
        // Figma guide 1052:3325 / I1052:3325;41658:296911:
        // primary-fade stays opaque through 85.065%, then fades to zero.
        let title = String(repeating: "M", count: 120)
        for size in TUIButtonSize.allCases {
            let font = size == .small ? UIFont.systemFont(ofSize: 13, weight: .semibold)
                : TUIFigmaTextFont.regular(size: size == .large ? 17 : 15)
            let tracking: CGFloat = size == .large ? -0.41 : size == .medium ? -0.24 : -0.08
            let inset: CGFloat = size == .large ? 24 : size == .medium ? 18 : 11
            let plain = ImageRenderer(content: Text(title).font(Font(font)).kerning(tracking)
                .foregroundStyle(Color.black).fixedSize())
            plain.scale = 3
            let reference = try alphaColumns(XCTUnwrap(plain.uiImage))
            for theme in TUITheme.allCases {
                for width in [CGFloat(180), 240, 323] {
                    let renderer = ImageRenderer(content: TUIButton(title, size: size,
                        backgroundColor: .clear, textColor: .black, cornerRadius: 0,
                        width: width, action: {})
                        .environment(\.dynamicTypeSize, .large)
                        .environment(\.colorScheme, theme == .day ? .light : .dark))
                    renderer.scale = 3
                    let image = try XCTUnwrap(renderer.uiImage)
                    let actual = try alphaColumns(image)
                    let offset = Int(inset * 3)
                    let labelPixels = Int((width - 2 * inset) * 3)
                    XCTAssertEqual(image.size.width, width)
                    XCTAssertEqual(image.size.height, size == .large ? 56 : size == .medium ? 44 : 30)
                    var fadedGlyphColumns = 0
                    for x in 0..<labelPixels where reference[x] >= 200 {
                        let fraction = (Double(x) + 0.5) / Double(labelPixels)
                        let alpha = fraction <= 0.85065 ? 1 : (1 - fraction) / (1 - 0.85065)
                        XCTAssertEqual(Double(actual[offset + x]) / Double(reference[x]), alpha,
                                       accuracy: 0.09, "\(size)/\(theme)/\(width), text column \(x)")
                        if fraction > 0.9 { fadedGlyphColumns += 1 }
                    }
                    XCTAssertGreaterThan(fadedGlyphColumns, 5, "Must inspect actual glyphs inside the fade")
                    XCTAssertTrue(actual.prefix(offset).allSatisfy { $0 == 0 })
                    XCTAssertTrue(actual.suffix(offset).allSatisfy { $0 == 0 })
                    let attachment = XCTAttachment(image: image)
                    attachment.name = "button-overflow-fade-\(size.rawValue)-\(theme.rawValue)-\(Int(width))-3x"
                    attachment.lifetime = .keepAlways
                    add(attachment)
                }
            }
        }
    }

    @MainActor
    func testShortLabelsRetainFullOpacityAndExportsOriginalGuideExample() throws {
        for size in TUIButtonSize.allCases {
            let renderer = ImageRenderer(content: TUIButton("MMMMM", size: size,
                backgroundColor: .clear, textColor: .black, width: 323, action: {})
                .environment(\.dynamicTypeSize, .large))
            renderer.scale = 3
            let columns = try alphaColumns(XCTUnwrap(renderer.uiImage))
            let occupied = columns.indices.filter { columns[$0] > 0 }
            let first = try XCTUnwrap(occupied.first), last = try XCTUnwrap(occupied.last)
            let lastGlyphStart = last - (last - first) / 5
            XCTAssertGreaterThan(try XCTUnwrap(columns[lastGlyphStart...last].max()), 240,
                                 "A fitting final glyph must remain fully opaque")
        }
        let sourceTitle = "Фикс размер с обрезанием текс"
        let font = TUIFigmaTextFont.regular(size: 17)
        let literal = ImageRenderer(content: Text(sourceTitle).font(Font(font)).kerning(-0.41).fixedSize())
        literal.scale = 3
        let measured = try XCTUnwrap(literal.uiImage).size
        let data = try JSONSerialization.data(withJSONObject: [
            "sourceTitle": sourceTitle, "font": font.fontName,
            "nativeLiteralWidth": measured.width, "nativeLiteralHeight": measured.height,
            "sourceLabelWidth": 262, "sourceLabelHeight": 20,
            "nativeLiteralOverflows": measured.width > 262,
            "sourceFadeStart": 0.85065
        ], options: [.prettyPrinted, .sortedKeys])
        let measurement = XCTAttachment(data: data, uniformTypeIdentifier: "public.json")
        measurement.name = "button-guide-native-literal-measurement"
        measurement.lifetime = .keepAlways
        add(measurement)
        let renderer = ImageRenderer(content: TUIButton(sourceTitle, width: 310, action: {})
            .environment(\.dynamicTypeSize, .large).environment(\.colorScheme, .light))
        renderer.scale = 3
        let image = try XCTUnwrap(renderer.uiImage)
        XCTAssertEqual(image.size, CGSize(width: 310, height: 56))
        let attachment = XCTAttachment(image: image)
        attachment.name = "button-guide-1052-3325-day-3x"
        attachment.lifetime = .keepAlways
        add(attachment)
        let fullLabel = ImageRenderer(content: TUIButton("Фикс размер с обрезанием текста", width: 310, action: {})
            .environment(\.dynamicTypeSize, .large).environment(\.colorScheme, .light))
        fullLabel.scale = 3
        let fullAttachment = XCTAttachment(image: try XCTUnwrap(fullLabel.uiImage))
        fullAttachment.name = "button-guide-complete-label-day-3x"
        fullAttachment.lifetime = .keepAlways
        add(fullAttachment)
    }

    private func alphaColumns(_ image: UIImage) throws -> [UInt8] {
        let cg = try XCTUnwrap(image.cgImage)
        var pixels = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        let context = try XCTUnwrap(CGContext(data: &pixels, width: cg.width, height: cg.height,
            bitsPerComponent: 8, bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        return (0..<cg.width).map { x in
            (0..<cg.height).map { pixels[($0 * cg.width + x) * 4 + 3] }.max() ?? 0
        }
    }

    @MainActor
    func testFloatingButtonSourceEffectBoundsAndNightShadowRemoval() throws {
        let variants = TUILibraryCatalog.shared.variants(for: TUIButton.figmaComponentSetID)
            .filter { $0.properties["appearance"] == "floating" }
        XCTAssertEqual(variants.count, 12)
        for variant in variants {
            let size = try XCTUnwrap(TUIButtonSize(rawValue: try XCTUnwrap(variant.properties["size"])))
            let state = try XCTUnwrap(TUIButtonState(rawValue: try XCTUnwrap(variant.properties["state"])))
            let node = variant.id.replacingOccurrences(of: ":", with: "-")
            let width = variant.width, height = variant.height
            for theme in TUITheme.allCases {
                let renderer = ImageRenderer(content: TUIButton("Label", appearance: .floating,
                    size: size, state: state, width: width, action: {})
                    // Figma full-effect exports: x=20, y=15; the bottom reaches height+25.
                    .padding(EdgeInsets(top: 15, leading: 20, bottom: 25, trailing: 20))
                    .environment(\.dynamicTypeSize, .large)
                    .environment(\.colorScheme, theme == .day ? .light : .dark))
                renderer.scale = 3
                let image = try XCTUnwrap(renderer.uiImage)
                XCTAssertEqual(image.size, CGSize(width: width + 40, height: height + 40))
                let columns = try alphaColumns(image)
                let outside = columns.prefix(60) + columns.suffix(60)
                if theme == .night {
                    XCTAssertTrue(outside.allSatisfy { $0 == 0 }, "Night must remove the external shadow")
                } else {
                    XCTAssertTrue(outside.contains { $0 > 0 }, "Day must render an actual external shadow")
                }
                let attachment = XCTAttachment(image: image)
                attachment.name = "button-floating-full-shadow-\(node)-\(theme.rawValue)-3x"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }

    // Mobile guide 26:72691: Medium supports both Hug and Fill. Verify
    // native SwiftUI layout before adding another public configuration API.
    @MainActor
    func testMediumHugUsesContentWidthAndRetainsItInEveryState() throws {
        for theme in TUITheme.allCases {
            for showsIcon in [false, true] {
                for title in ["Готово", "Продолжить перевод"] {
                    var normalSize: CGSize?
                    for state in TUIButtonState.allCases {
                        let button = TUIButton(title, size: .medium, state: state,
                                               showsIcon: showsIcon, action: {})
                        let renderer = ImageRenderer(content: button
                            .fixedSize(horizontal: true, vertical: false)
                            .environment(\.dynamicTypeSize, .large)
                            .environment(\.colorScheme, theme == .day ? .light : .dark))
                        renderer.scale = 3
                        let image = try XCTUnwrap(renderer.uiImage)
                        XCTAssertEqual(image.size.height, 44)
                        XCTAssertGreaterThan(image.size.width, 36)
                        XCTAssertLessThan(image.size.width, 323)
                        if let normalSize {
                            XCTAssertEqual(image.size, normalSize, "Hug must not collapse while loading")
                        } else {
                            normalSize = image.size
                        }
                        let attachment = XCTAttachment(image: image)
                        attachment.name = "medium-hug-\(theme.rawValue)-\(showsIcon)-\(title)-\(state.rawValue)"
                        attachment.lifetime = .keepAlways
                        add(attachment)
                    }
                }
            }
        }
    }

    @MainActor
    func testMediumFillFollowsParentWidthInEveryState() throws {
        for theme in TUITheme.allCases {
            for width in [CGFloat(180), 240, 323] {
                for state in TUIButtonState.allCases {
                    let renderer = ImageRenderer(content: TUIButton("Продолжить перевод",
                        size: .medium, state: state, showsIcon: true, action: {})
                        .frame(width: width)
                        .environment(\.dynamicTypeSize, .large)
                        .environment(\.colorScheme, theme == .day ? .light : .dark))
                    renderer.scale = 3
                    XCTAssertEqual(try XCTUnwrap(renderer.uiImage).size, CGSize(width: width, height: 44))
                }
            }
        }
    }
}
