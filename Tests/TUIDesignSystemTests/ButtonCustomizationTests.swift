import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class ButtonCustomizationTests: XCTestCase {
    private let red = Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1)
    private let blue = Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 1)
    private let green = Color(.sRGB, red: 0, green: 1, blue: 0, opacity: 1)
    @MainActor
    func testEverySourceVariantResolvesThroughPublicAPIWithoutFallback() throws {
        let variants = TUILibraryCatalog.shared.variants(for: TUIButton.figmaComponentSetID)
        XCTAssertEqual(variants.count, 147)
        for variant in variants {
            let p = variant.properties
            let button = TUIButton("Label",
                appearance: try XCTUnwrap(TUIButtonAppearance(rawValue: try XCTUnwrap(p["appearance"]))),
                size: try XCTUnwrap(TUIButtonSize(rawValue: try XCTUnwrap(p["size"]))),
                state: try XCTUnwrap(TUIButtonState(rawValue: try XCTUnwrap(p["state"]))),
                skeleton: p["skeleton"] == "on", action: {})
            XCTAssertEqual(button.figmaNodeID, variant.id)
        }
        XCTAssertNil(TUIButton("Label", appearance: .flat, skeleton: true, action: {}).figmaNodeID)
    }
    @MainActor
    func testCustomIconsFitOversizedArtworkAndRetainSmallerArtwork() throws {
        let artworkSizes = [CGSize(width: 8, height: 12), CGSize(width: 16, height: 16),
                            CGSize(width: 48, height: 24), CGSize(width: 30, height: 60)]
        for size in TUIButtonSize.allCases {
            let slot: CGFloat = size == .small ? 16 : 24
            for type in [DynamicTypeSize.large, .accessibility1, .accessibility5] {
                let scale: CGFloat = type == .large ? 1 : 1.25
                for artwork in artworkSizes {
                    let image = fixture(artwork)
                    let button = TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false,
                                          icon: image, smallIcon: image, iconColor: red, action: {})
                    let rendered = try render(button, type: type)
                    let bounds = try coloredBounds(rendered, color: [255, 0, 0])
                    let fit = min(1, slot / artwork.width, slot / artwork.height)
                    XCTAssertEqual(bounds.width / 3, artwork.width * fit * scale, accuracy: 0.7)
                    XCTAssertEqual(bounds.height / 3, artwork.height * fit * scale, accuracy: 0.7)
                    XCTAssertEqual(bounds.midX / 3, rendered.size.width / 2, accuracy: 0.5)
                    XCTAssertEqual(bounds.midY / 3, rendered.size.height / 2, accuracy: 0.5)
                }
            }
        }
    }

    @MainActor
    func testMediumAndSmallInstanceSwapsRemainIndependent() throws {
        let icon = fixture(CGSize(width: 8, height: 12))
        let smallIcon = fixture(CGSize(width: 12, height: 8))
        for size in TUIButtonSize.allCases {
            let selected = TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false,
                                     icon: icon, smallIcon: smallIcon, iconColor: red, action: {})
            let bounds = try coloredBounds(render(selected), color: [255, 0, 0])
            XCTAssertEqual(bounds.width / 3, size == .small ? 12 : 8, accuracy: 0.7)
            XCTAssertEqual(bounds.height / 3, size == .small ? 8 : 12, accuracy: 0.7)
            let original = try render(TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false, action: {}))
            let unrelated = try render(TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false,
                icon: size == .small ? icon : nil, smallIcon: size == .small ? nil : smallIcon, action: {}))
            XCTAssertEqual(original.pngData(), unrelated.pngData())
        }
    }

    @MainActor
    func testTextColorOverrideDoesNotChangeIconAndBothColorsAreIndependent() throws {
        for size in TUIButtonSize.allCases {
            for theme in TUITheme.allCases {
                let icon = fixture(CGSize(width: 8, height: 12))
                let originalIcon = try render(TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false,
                                                        icon: icon, smallIcon: icon, action: {}), theme: theme)
                let changedText = try render(TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false,
                    icon: icon, smallIcon: icon, textColor: blue, action: {}), theme: theme)
                XCTAssertEqual(originalIcon.pngData(), changedText.pngData(), "Text override must not leak into icon tint")
                let independent = try render(TUIButton("MMMM", size: size, showsIcon: true,
                    icon: icon, smallIcon: icon, backgroundColor: green, textColor: blue, iconColor: red,
                    width: 220, action: {}), theme: theme)
                XCTAssertGreaterThan(try coloredBounds(independent, color: [255, 0, 0]).width, 0)
                XCTAssertGreaterThan(try coloredBounds(independent, color: [0, 0, 255]).width, 0)
                XCTAssertEqual(try pixel(independent, x: independent.size.width / 2, y: 3), [0, 255, 0, 255])
            }
        }
    }

    @MainActor
    func testExplicitWidthAndCustomRadiusApplyToActualContainerAndLoading() throws {
        for size in TUIButtonSize.allCases {
            for state in TUIButtonState.allCases {
                let image = try render(TUIButton("Продолжить", size: size, state: state,
                    backgroundColor: blue, cornerRadius: 0, width: 180, action: {}))
                XCTAssertEqual(image.size.width, 180)
                XCTAssertEqual(image.size.height, size == .large ? 56 : size == .medium ? 44 : 30)
                XCTAssertEqual(try pixel(image, x: 1, y: 1), [0, 0, 255, 255],
                               "Explicit width must stretch the fill, not an empty wrapper")
            }
        }
        for size in [TUIButtonSize.large, .medium] {
            let square = try render(TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false,
                backgroundColor: blue, cornerRadius: 0, action: {}))
            let round = try render(TUIButton("Добавить", size: size, showsIcon: true, showsLabel: false,
                backgroundColor: blue, cornerRadius: TUIRadius.round, action: {}))
            XCTAssertEqual(try pixel(square, x: 1, y: 1), [0, 0, 255, 255])
            XCTAssertEqual(try pixel(round, x: 1, y: 1), [255, 255, 255, 255])
            XCTAssertEqual(try pixel(round, x: round.size.width / 2, y: 3), [0, 0, 255, 255])
        }
    }

    @MainActor
    func testPackageExportsResourcesWithoutCatalogDependency() throws {
        for name in ["tui-button-star", "tui-button-star-small", "tui-link-arrow-right-circle", "tui-button-close-cross"] {
            let source = try XCTUnwrap(UIImage(named: name, in: TUIResources.bundle, compatibleWith: nil), name)
            XCTAssertGreaterThan(source.size.width, 0)
            XCTAssertGreaterThan(source.size.height, 0)
            let image = try render(TUIButton("Добавить", showsIcon: true, showsLabel: false,
                icon: Image(name, bundle: TUIResources.bundle), iconColor: blue, action: {}))
            XCTAssertGreaterThan(try coloredBounds(image, color: [0, 0, 255]).width, 0,
                                 "Loaded source artwork must actually render")
        }
    }

    @MainActor
    func testOriginalRenderingPreservesMulticolorArtwork() throws {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let artwork = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16), format: format).image { context in
            UIColor(red: 1, green: 0, blue: 0, alpha: 1).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 8, height: 16))
            UIColor(red: 0, green: 0, blue: 1, alpha: 1).setFill()
            context.fill(CGRect(x: 8, y: 0, width: 8, height: 16))
        }
        let image = try render(TUIButton("Добавить", showsIcon: true, showsLabel: false,
            icon: Image(uiImage: artwork), iconRenderingMode: .original, iconColor: green, action: {}))
        XCTAssertGreaterThan(try coloredBounds(image, color: [255, 0, 0]).width, 0)
        XCTAssertGreaterThan(try coloredBounds(image, color: [0, 0, 255]).width, 0)
    }

    @MainActor
    func testEveryNonGlassVariantProducesNativeRenderAtSourceFrameSize() throws {
        var count = 0
        for theme in TUITheme.allCases {
            for variant in TUILibraryCatalog.shared.variants(for: TUIButton.figmaComponentSetID) {
                let p = variant.properties
                let appearance = try XCTUnwrap(TUIButtonAppearance(rawValue: try XCTUnwrap(p["appearance"])))
                if appearance == .glass { continue } // A real backdrop scene is required.
                let button = TUIButton("Label", appearance: appearance,
                    size: try XCTUnwrap(TUIButtonSize(rawValue: try XCTUnwrap(p["size"]))),
                    state: try XCTUnwrap(TUIButtonState(rawValue: try XCTUnwrap(p["state"]))),
                    skeleton: p["skeleton"] == "on", width: variant.width, action: {})
                let image = try render(button, theme: theme)
                XCTAssertEqual(image.size.width, variant.width, accuracy: 0.34)
                XCTAssertEqual(image.size.height, variant.height, accuracy: 0.34)
                let attachment = XCTAttachment(image: image)
                attachment.name = "button-\(variant.id.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-source-frame-3x"
                attachment.lifetime = .keepAlways
                add(attachment)
                count += 1
            }
        }
        XCTAssertEqual(count, 270)
    }

    @MainActor
    func testSkeletonUsesEachSourceSizeCornerRadius() throws {
        // Figma skeleton variants 55915:350412/350432/350422 retain
        // the Large/Medium/Small root radii 16/12/100.
        for theme in TUITheme.allCases {
            let background: [UInt8] = theme == .day ? [255, 255, 255, 255] : [0, 0, 0, 255]
            for size in TUIButtonSize.allCases {
                let sourceWidth: CGFloat = size == .small ? 57 : 323
                let sourceHeight: CGFloat = size == .large ? 56 : size == .medium ? 44 : 30
                let button = TUIButton("Label", size: size, skeleton: true, width: sourceWidth, action: {})
                let image = try render(button, theme: theme)
                XCTAssertEqual(image.size, CGSize(width: sourceWidth, height: sourceHeight))
                let corner = try pixel(image, x: 5, y: 3)
                if size == .medium {
                    XCTAssertNotEqual(corner, background, "Medium 12 pt radius must cover the inner corner")
                } else {
                    XCTAssertEqual(corner, background, "\(size) must preserve its source corner")
                }
                let attachment = XCTAttachment(image: image)
                attachment.name = "button-skeleton-\(try XCTUnwrap(button.figmaNodeID))-\(theme.rawValue)-3x"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }

    @MainActor
    private func fixture(_ size: CGSize) -> Image {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let image = UIGraphicsImageRenderer(size: size, format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return Image(uiImage: image)
    }

    @MainActor
    private func render(_ button: TUIButton, type: DynamicTypeSize = .large, theme: TUITheme = .day) throws -> UIImage {
        let renderer = ImageRenderer(content: button.background(theme == .day ? Color.white : Color.black)
            .environment(\.dynamicTypeSize, type).environment(\.colorScheme, theme == .day ? .light : .dark))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }

    private func bytes(_ image: UIImage) throws -> (pixels: [UInt8], width: Int, height: Int) {
        let cg = try XCTUnwrap(image.cgImage)
        var pixels = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        let context = try XCTUnwrap(CGContext(data: &pixels, width: cg.width, height: cg.height,
            bitsPerComponent: 8, bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        return (pixels, cg.width, cg.height)
    }

    private func pixel(_ image: UIImage, x: CGFloat, y: CGFloat) throws -> [UInt8] {
        let data = try bytes(image)
        let scale = CGFloat(data.width) / image.size.width
        let index = (Int(y * scale) * data.width + Int(x * scale)) * 4
        return Array(data.pixels[index..<(index + 4)])
    }

    private func coloredBounds(_ image: UIImage, color: [UInt8]) throws -> CGRect {
        let data = try bytes(image)
        var minX = data.width, minY = data.height, maxX = -1, maxY = -1
        for y in 0..<data.height {
            for x in 0..<data.width {
                let i = (y * data.width + x) * 4
                if (0..<3).allSatisfy({ abs(Int(data.pixels[i + $0]) - Int(color[$0])) <= 2 }) {
                    minX = min(minX, x); maxX = max(maxX, x)
                    minY = min(minY, y); maxY = max(maxY, y)
                }
            }
        }
        XCTAssertGreaterThanOrEqual(maxX, 0, "Expected artwork color not rendered")
        return CGRect(x: minX, y: minY, width: max(0, maxX - minX + 1), height: max(0, maxY - minY + 1))
    }
}
