import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class SensitiveModeTests: XCTestCase {
    func testEveryImportedFontSizeMapsToItsActualSourceFrame() throws {
        let imported = TUILibraryCatalog.shared.variants(for: TUISensitiveMode.figmaComponentSetID)
        XCTAssertEqual(imported.count, 5)
        XCTAssertEqual(Set(imported.map(\.id)), Set(TUISensitiveFontSize.allCases.map(\.figmaNodeID)))
        for value in TUISensitiveFontSize.allCases {
            let variant = try XCTUnwrap(imported.first { $0.id == value.figmaNodeID })
            XCTAssertEqual(variant.properties["Font Size"], value.rawValue)
            XCTAssertEqual(variant.width, value.sourceSize.width)
            XCTAssertEqual(variant.height, value.sourceSize.height)
            XCTAssertEqual(TUISensitiveMode(fontSize: value).figmaNodeID, variant.id)
        }
    }

    func testRowsChangeAtTheExactSpecifiedHeightThresholds() {
        for (height, rows) in [(14.0, 2), (20, 2), (31.999, 2), (32, 3), (47.999, 3), (48, 4), (64, 5), (80, 6)] {
            XCTAssertEqual(TUISensitivePixelGrid.rowCount(height: height), rows)
        }
    }

    func testAdaptiveGridUsesSquaresAndOnlyTheSpecifiedOpacityRange() {
        for size in [CGSize(width: 1, height: 14), CGSize(width: 135, height: 18),
                     CGSize(width: 170, height: 32), CGSize(width: 240, height: 64)] {
            let bounds = CGRect(origin: CGPoint(x: 13, y: 7), size: size)
            let tiles = TUISensitivePixelGrid.tiles(in: bounds, seed: 17)
            let rows = TUISensitivePixelGrid.rowCount(height: size.height)
            let side = size.height / CGFloat(rows)
            XCTAssertEqual(tiles.count, rows * Int((size.width / side).rounded(.up)))
            XCTAssertEqual(Set(tiles.map { $0.rect.minY }).count, rows)
            XCTAssertGreaterThanOrEqual(tiles.map(\.rect.maxX).max()!, bounds.maxX)
            XCTAssertEqual(tiles.map(\.rect.maxY).max()!, bounds.maxY, accuracy: 0.001)
            for tile in tiles {
                XCTAssertEqual(tile.rect.width, side)
                XCTAssertEqual(tile.rect.height, side)
                XCTAssertGreaterThanOrEqual(tile.opacity, 0.2)
                XCTAssertLessThanOrEqual(tile.opacity, 0.4)
            }
            XCTAssertEqual(tiles.map(\.opacity), TUISensitivePixelGrid.tiles(in: bounds, seed: 17).map(\.opacity))
            XCTAssertNotEqual(tiles.map(\.opacity), TUISensitivePixelGrid.tiles(in: bounds, seed: 18).map(\.opacity))
        }
        XCTAssertTrue(TUISensitivePixelGrid.tiles(in: .zero, seed: 0).isEmpty)
    }

    @MainActor func testBothThemesRenderAllFiveSourceSizes() throws {
        for theme in TUITheme.allCases {
            for size in TUISensitiveFontSize.allCases {
                let image = try render(TUISensitiveMode(fontSize: size), theme: theme)
                XCTAssertEqual(image.size, size.sourceSize)
                attach(image, name: "sensitive-\(size.figmaNodeID)-\(theme.rawValue)-3x")
            }
        }
    }

    @MainActor func testComponentMaskCoversContainerAndInheritsRadius() throws {
        let red = Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1)
        let blue = Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 1)
        let original = red.frame(width: 80, height: 40)
        let masked = try render(original.tuiSensitive(isHidden: true, color: blue, cornerRadius: 12))
        let visible = try render(original.tuiSensitive(isHidden: false, color: blue, cornerRadius: 12))
        XCTAssertEqual(masked.size, visible.size)
        XCTAssertEqual(try pixel(masked, x: 0, y: 0), [255, 255, 255, 255])
        XCTAssertEqual(try pixel(visible, x: 1, y: 1), [255, 0, 0, 255])
        let center = try pixel(masked, x: 40, y: 20)
        XCTAssertEqual(center[0], center[1])
        XCTAssertEqual(center[2], 255)
        XCTAssertTrue((153...204).contains(Int(center[0])))
        attach(masked, name: "sensitive-component-inherited-radius")
    }

    @MainActor func testPartialNativeTextPreservesKerningWidthAndWrapping() throws {
        for text in ["Оплатить 1 000 ₽", "1 000 ₽ и ещё 1 000 ₽", "👨‍👩‍👧‍👦 Оплатить 1 000 ₽ сегодня"] {
            for width in [90.0, 220.0] {
                let original = Text(verbatim: text).tuiTypography(.bodyLarge).frame(width: width)
                let masked = TUISensitiveText(text, masking: "1 000 ₽").tuiTypography(.bodyLarge).frame(width: width)
                let visibleImage = try render(original)
                let maskedImage = try render(masked)
                XCTAssertEqual(maskedImage.size, visibleImage.size)
                XCTAssertNotEqual(maskedImage.pngData(), visibleImage.pngData())
                attach(maskedImage, name: "sensitive-native-wrap-\(width)-\(text.count)")
            }
        }
        let text = "100% %@ literal"
        let original = try render(Text(verbatim: text).tuiTypography(.bodyLarge))
        for hidden in ["", "missing"] {
            let image = try render(TUISensitiveText(text, masking: hidden).tuiTypography(.bodyLarge))
            XCTAssertEqual(image.pngData(), original.pngData())
        }
    }

    @MainActor func testDifferentTextFragmentsRetainTheirOwnMaskColor() throws {
        let text = Text("\(Text("MMMM").tuiSensitive(color: .red)) \(Text("MMMM").tuiSensitive(color: .blue))")
        let image = try render(TUISensitiveText(text).tuiTypography(.bodyLarge))
        let left = try pixel(image, x: 15, y: image.size.height / 2)
        let right = try pixel(image, x: image.size.width - 15, y: image.size.height / 2)
        XCTAssertEqual(left[0], 255); XCTAssertLessThan(left[1], 240)
        XCTAssertEqual(right[2], 255); XCTAssertLessThan(right[0], 240)
        attach(image, name: "sensitive-mixed-text-colors")
    }

    @MainActor func testButtonMaskPreservesSizeVariantAndLoadingSkeletonStates() throws {
        for theme in TUITheme.allCases {
            for size in TUIButtonSize.allCases {
                for state in TUIButtonState.allCases {
                    let original = TUIButton("Оплатить 1 000 ₽", size: size, state: state, width: 280, action: {})
                    let masked = TUIButton("Оплатить 1 000 ₽", size: size, state: state, width: 280,
                                           sensitiveText: "1 000 ₽", action: {})
                    let before = try render(original, theme: theme)
                    let after = try render(masked, theme: theme)
                    XCTAssertEqual(before.size, after.size)
                    XCTAssertEqual(original.figmaNodeID, masked.figmaNodeID)
                    if state != .loading { XCTAssertNotEqual(before.pngData(), after.pngData()) }
                    if state == .normal { attach(after, name: "sensitive-button-\(size.rawValue)-\(theme.rawValue)") }
                }
                let skeleton = try render(TUIButton("Оплатить 1 000 ₽", size: size, skeleton: true, width: 280, action: {}))
                let hiddenSkeleton = try render(TUIButton("Оплатить 1 000 ₽", size: size, skeleton: true, width: 280,
                    sensitiveText: "1 000 ₽", action: {}))
                XCTAssertEqual(skeleton.pngData(), hiddenSkeleton.pngData())
            }
        }
        let visible = try render(TUIButton("Label", size: .small, action: {}))
        XCTAssertEqual(try render(TUIButton("Label", size: .small, sensitiveText: "", action: {})).pngData(), visible.pngData())
    }

    @MainActor private func render<V: View>(_ view: V, theme: TUITheme = .day) throws -> UIImage {
        let renderer = ImageRenderer(content: view
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, .large)
            .background(theme == .day ? Color.white : Color.black))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }

    private func pixel(_ image: UIImage, x: CGFloat, y: CGFloat) throws -> [UInt8] {
        let cgImage = try XCTUnwrap(image.cgImage)
        let bytes = try XCTUnwrap(cgImage.dataProvider?.data) as Data
        let offset = Int(y * image.scale) * cgImage.bytesPerRow + Int(x * image.scale) * 4
        let raw = Array(bytes[offset..<offset + 4])
        return cgImage.bitmapInfo.contains(.byteOrder32Little) ? [raw[2], raw[1], raw[0], raw[3]] : raw
    }

    private func attach(_ image: UIImage, name: String) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name.replacingOccurrences(of: ":", with: "-")
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
