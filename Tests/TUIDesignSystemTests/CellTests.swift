import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class CellTests: XCTestCase {
    @MainActor func testCustomAccessoryDoesNotRequireAnUnusedHintAction() throws {
        let variants = TUICell.Variant.allCases.filter { $0.rightSide == .accessory && !$0.isSkeleton }
        XCTAssertEqual(variants.count, 5)
        for variant in variants {
            for theme in TUITheme.allCases {
                // The public builder replaces both default accessories. Keeping
                // showsHint true must not require a callback for the absent hint.
                let cell = TUICell(variant: variant).accessory {
                    Color(uiColor: .green).frame(width: 24, height: 24)
                }
                XCTAssertTrue(cell.showsHint)
                let image = try render(cell, theme: theme)
                XCTAssertEqual(image.size, CGSize(width: 375, height: variant.minimumHeight), variant.rawValue)
                let customAccessory = try markerX(image, .green)
                XCTAssertEqual(customAccessory.max - customAccessory.min, 24, accuracy: 0.5)
                attach(image, "cell-custom-accessory-no-hint-action-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x")
            }
        }
    }

    @MainActor func testHiddenBuiltInHintDoesNotRequireActionAndPreservesBadge() throws {
        let variants = TUICell.Variant.allCases.filter { $0.rightSide == .accessory && !$0.isSkeleton }
        XCTAssertEqual(variants.count, 5)
        for variant in variants {
            for theme in TUITheme.allCases {
                let image = try render(TUICell(variant: variant, showsHint: false), theme: theme)
                XCTAssertEqual(image.size, CGSize(width: 375, height: variant.minimumHeight), variant.rawValue)
                let badge = try markerX(image, .red)
                XCTAssertGreaterThan(badge.max - badge.min, 10, "Hiding the hint must preserve the default badge")
                attach(image, "cell-hidden-built-in-hint-no-action-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x")
            }
        }
    }

    @MainActor func testAllIOSVariantsPreserveSourcePropertiesAndRenderBothThemes() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "figma-component-variants", withExtension: "json"))
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any])
        let variants = try XCTUnwrap(json["variants"] as? [[String: Any]])
        let source = variants.filter { $0["setId"] as? String == TUICell.figmaComponentSetID &&
            ($0["variantProperties"] as? [String: String])?["system"] == "iOS" }
        XCTAssertEqual(source.count, 21)
        XCTAssertEqual(Set(source.compactMap { $0["id"] as? String }), Set(TUICell.Variant.allCases.map(\.rawValue)))
        for entry in source {
            let variant = try XCTUnwrap(TUICell.Variant(rawValue: try XCTUnwrap(entry["id"] as? String)))
            XCTAssertEqual(variant.figmaProperties, entry["variantProperties"] as? [String: String])
            for theme in TUITheme.allCases {
                let cell = TUICell(variant: variant, hintAction: {}, isSkeletonAnimating: false).frame(width: 375)
                    .environment(\.colorScheme, theme == .day ? .light : .dark)
                let renderer = ImageRenderer(content: cell); renderer.scale = 3
                let image = try XCTUnwrap(renderer.uiImage)
                XCTAssertEqual(image.size, CGSize(width: 375, height: (entry["height"] as? NSNumber)?.doubleValue ?? 0), variant.rawValue)
                let attachment = XCTAttachment(image: image)
                attachment.name = "cell-\(variant.rawValue.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x"
                attachment.lifetime = .keepAlways; add(attachment)
            }
        }
    }

    @MainActor func testFlexibleTextGrowsAndAccessibilitySizeDoesNotClipContent() throws {
        let long = "Подробное описание перевода зарплаты с несколькими условиями и дополнительной информацией"
        for variant in [TUICell.Variant.defaultFlexibleNone, .compactFlexibleText] {
            let image = try XCTUnwrap(ImageRenderer(content: TUICell(long, description: long, variant: variant,
                showsAvatar: false).frame(width: 180)).uiImage)
            XCTAssertGreaterThan(image.size.height, variant.minimumHeight)
        }
        let regular = try XCTUnwrap(ImageRenderer(content: TUICell().frame(width: 375)).uiImage)
        let enlarged = try XCTUnwrap(ImageRenderer(content: TUICell().frame(width: 375)
            .environment(\.dynamicTypeSize, .accessibility1)).uiImage)
        XCTAssertGreaterThan(enlarged.size.height, regular.size.height)
    }

    @MainActor func testCardCellCompositionsUseThePublicCell() throws {
        for variant in [TUICardLarge.Variant.cell, .cellFlat] {
            for theme in TUITheme.allCases {
                let card = TUICardLarge(variant: variant) { EmptyView() } content: { TUICell() }
                let canvas = card.frame(width: 375)
                    .environment(\.colorScheme, theme == .day ? .light : .dark)
                let renderer = ImageRenderer(content: canvas); renderer.scale = 3
                let image = try XCTUnwrap(renderer.uiImage)
                XCTAssertEqual(image.size, CGSize(width: 375, height: 80))
                attach(image, "card-large-cell-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x")
                if !variant.isFlat && theme == .day {
                    // Same effect canvas as the existing Header Card composition probe.
                    let full = ImageRenderer(content: canvas.padding(EdgeInsets(top: 28, leading: 18, bottom: 40, trailing: 18)))
                    full.scale = 3
                    let fullImage = try XCTUnwrap(full.uiImage)
                    XCTAssertEqual(fullImage.size, CGSize(width: 411, height: 148))
                    attach(fullImage, "card-large-cell-full-shadow-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-day-3x")
                }
            }
        }
    }

    @MainActor func testAX1StacksTextByDefaultAndAccessoryOnlyWhenRequested() throws {
        var text = TUICell(variant: .defaultText, showsAvatar: false, showsDescription: false)
        let stacked = try render(text, size: .accessibility1)
        text.reflowsTextAtAX1 = false
        let alongside = try render(text, size: .accessibility1)
        XCTAssertGreaterThan(stacked.size.height, alongside.size.height)
        var compact = TUICell(variant: .compactText, showsAvatar: false, showsDescription: false)
        XCTAssertEqual(try render(compact, size: .accessibility1).size.height, stacked.size.height,
                       "Compact also preserves the source's four-point gap between stacked blocks")
        compact.reflowsTextAtAX1 = false
        XCTAssertEqual(try render(compact, size: .accessibility1).size.height, alongside.size.height)
        var accessory = TUICell(variant: .defaultAccessory, showsAvatar: false, showsDescription: false, hintAction: {})
        let defaultAccessory = try render(accessory, size: .accessibility1)
        accessory.reflowsAccessoryAtAX1 = true
        let movedAccessory = try render(accessory, size: .accessibility1)
        XCTAssertGreaterThan(movedAccessory.size.height, defaultAccessory.size.height)
        XCTAssertEqual(try render(accessory, size: .accessibility5).pngData(), movedAccessory.pngData())
        attach(stacked, "cell-text-default-reflow-ax1")
        attach(alongside, "cell-text-reflow-disabled-ax1")
        attach(defaultAccessory, "cell-accessory-default-alongside-ax1")
        attach(movedAccessory, "cell-accessory-optional-reflow-ax1")
    }

    @MainActor func testExplicitLineLimitsReleaseAtAX1AndCanBeRetained() throws {
        let long = String(repeating: "Подробная информация о переводе зарплаты. ", count: 6)
        var cell = TUICell(long, variant: .defaultFlexibleNone, showsAvatar: false, showsDescription: false)
            .textStyle(.init(overflow: .multilineFade(lineLimit: 2)), for: .title)
        let limited = try render(cell, width: 180)
        let full = try render(TUICell(long, variant: .defaultFlexibleNone, showsAvatar: false, showsDescription: false), width: 180)
        XCTAssertLessThan(limited.size.height, full.size.height)
        XCTAssertEqual(limited.size.height, 56)
        let released = try render(cell, width: 180, size: .accessibility1)
        cell.removesLineLimitsAtAX1 = false
        let retained = try render(cell, width: 180, size: .accessibility1)
        XCTAssertGreaterThan(released.size.height, retained.size.height)
        XCTAssertLessThanOrEqual(retained.size.height, 100)
        attach(limited, "cell-title-two-lines-regular")
        attach(released, "cell-title-line-limits-released-ax1")
        attach(retained, "cell-title-line-limits-retained-ax1")
    }

    @MainActor func testNonExtendedInlineSuffixSurvivesTextFade() throws {
        let cell = TUICell(String(repeating: "Длинный заголовок ", count: 12), variant: .defaultNone,
                           showsAvatar: false, showsDescription: false)
            .inlineContent(.title, placement: .trailing) {
                Color(uiColor: .green).frame(width: 24, height: 24)
            }
        let image = try render(cell)
        let cg = try XCTUnwrap(image.cgImage)
        var pixels = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        let context = try XCTUnwrap(CGContext(data: &pixels, width: cg.width, height: cg.height,
            bitsPerComponent: 8, bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        var solidGreen = 0
        for index in stride(from: 0, to: pixels.count, by: 4) {
            if pixels[index] < 5 && pixels[index + 1] > 250 && pixels[index + 2] < 5 && pixels[index + 3] > 250 {
                solidGreen += 1
            }
        }
        // The suffix remains a full 24×24 component even when its label fades.
        XCTAssertEqual(solidGreen, 24 * 24 * 9)
        attach(image, "cell-default-non-extended-suffix-outside-label-fade")
    }

    @MainActor func testLongValuesPreserveFullCellWidthFractionAndBothPriorities() throws {
        let long = String(repeating: "Длинное значение ", count: 12)
        let base = TUICell(long, value: long, variant: .defaultText, showsAvatar: false, showsDescription: false)
            .inlineContent(.title, placement: .leading) { Color.green.frame(width: 2, height: 20) }
            .inlineContent(.title, placement: .trailing) { Color.red.frame(width: 2, height: 20) }
            .inlineContent(.value, placement: .leading) { Color.blue.frame(width: 2, height: 20) }
            .inlineContent(.value, placement: .trailing) { Color.yellow.frame(width: 2, height: 20) }
        for avatarWidth in [CGFloat(0), 40, 80] {
            var cell = base.avatar { Color.gray.frame(width: avatarWidth, height: 40) }
            cell.showsAvatar = avatarWidth > 0
            let image = try render(cell)
            XCTAssertEqual(image.size.height, 56, "A long fixed-height value must fade instead of wrapping")
            let leftStart = try markerX(image, .green).min
            let leftEnd = try markerX(image, .red).max
            XCTAssertEqual(leftStart, 16 + (avatarWidth > 0 ? avatarWidth + 16 : 0), accuracy: 0.5)
            XCTAssertEqual(leftEnd - leftStart, 375 * 0.3, accuracy: 0.5,
                           "The minimum comes from the full cell, including the measured custom avatar")
            XCTAssertEqual(try markerX(image, .yellow).max, 359, accuracy: 0.5)
            attach(image, "cell-long-right-priority-avatar-\(Int(avatarWidth))")
        }
        var left = base
        left.textPriority = .left
        let leftImage = try render(left)
        XCTAssertEqual(try markerX(leftImage, .yellow).max - markerX(leftImage, .blue).min,
                       375 * 0.3, accuracy: 0.5)
        attach(leftImage, "cell-long-left-priority")
        let custom = try render(base.minimumTextWidthFraction(0.45))
        XCTAssertEqual(try markerX(custom, .red).max - markerX(custom, .green).min,
                       375 * 0.45, accuracy: 0.5)
        attach(custom, "cell-long-custom-width-fraction")
        let narrow = try render(base, width: 180)
        XCTAssertEqual(try markerX(narrow, .red).max - markerX(narrow, .green).min, 54, accuracy: 0.5)
        XCTAssertEqual(narrow.size.height, 56)
        attach(narrow, "cell-long-right-priority-width-180")
    }

    private enum Marker { case red, green, blue, yellow }
    private func markerX(_ image: UIImage, _ marker: Marker) throws -> (min: CGFloat, max: CGFloat) {
        let cg = try XCTUnwrap(image.cgImage)
        var pixels = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        let context = try XCTUnwrap(CGContext(data: &pixels, width: cg.width, height: cg.height,
            bitsPerComponent: 8, bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        var columns: [Int] = []
        for pixel in 0..<(cg.width * cg.height) {
            let i = pixel * 4
            let r = pixels[i], g = pixels[i + 1], b = pixels[i + 2]
            let matches: Bool
            switch marker {
            case .red: matches = r > 180 && g < 110 && b < 110
            case .green: matches = g > 120 && r < 100 && b < 140
            case .blue: matches = b > 180 && r < 100 && g < 160
            case .yellow: matches = r > 180 && g > 160 && b < 110
            }
            if matches && pixels[i + 3] > 240 { columns.append(pixel % cg.width) }
        }
        return (CGFloat(try XCTUnwrap(columns.min())) / image.scale,
                CGFloat(try XCTUnwrap(columns.max()) + 1) / image.scale)
    }

    @MainActor private func render<Content: View>(_ content: Content, width: CGFloat = 375,
                                                size: DynamicTypeSize = .large,
                                                theme: TUITheme = .day) throws -> UIImage {
        let renderer = ImageRenderer(content: content.frame(width: width)
            .environment(\.colorScheme, theme == .day ? .light : .dark).environment(\.dynamicTypeSize, size))
        renderer.scale = 3; return try XCTUnwrap(renderer.uiImage)
    }
    private func attach(_ image: UIImage, _ name: String) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
