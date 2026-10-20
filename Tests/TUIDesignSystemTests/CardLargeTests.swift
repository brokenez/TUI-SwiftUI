import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class CardLargeTests: XCTestCase {
    @MainActor func testElevatedShadowWithFullFigmaEffectBounds() throws {
        for variant in [TUICardLarge.Variant.header, .headerSubheader, .headerSubheaderWithFooter] {
            for mode in ["production", "composited-blur", "composited-half-blur"] {
                let card = TUICardLarge(variant: variant, style: .init(showsShadow: mode == "production")) {
                    TUIHeaderCard(variant: .avatar, showsSubheader: variant.preset == .headerSubheader)
                } content: { EmptyView() } footer: {
                    if variant.hasFooter { TUIButton("Label", appearance: .secondary, size: .medium) {} }
                }
                // Figma/CSS blur and SwiftUI radius may have different meanings.
                // Capture the real production shadow and a measured conversion probe;
                // neither is accepted until compared against the original export.
                let blur = CGFloat(TUITokenCatalog.shared.number(named: "Hide from publishing/Shadow/Medium/Blur",
                    collection: "Theme", mode: "Day") ?? 0)
                let offset = CGFloat(TUITokenCatalog.shared.number(named: "Hide from publishing/Shadow/Medium/Y-axis",
                    collection: "Theme", mode: "Day") ?? 0)
                XCTAssertEqual(blur, 34); XCTAssertEqual(offset, 6)
                let canvas = card.frame(width: 375)
                    .compositingGroup()
                    .shadow(color: mode != "production" ? TUIColor.named("Hide from publishing/Shadow/Medium/Color") : .clear,
                            radius: mode == "composited-half-blur" ? blur / 2 : blur, x: 0, y: offset)
                    .padding(EdgeInsets(top: 28, leading: 18, bottom: 40, trailing: 18))
                    .environment(\.colorScheme, .light)
                let renderer = ImageRenderer(content: canvas)
                renderer.scale = 3
                let image = try XCTUnwrap(renderer.uiImage)
                let naturalHeight = variant.preset == .header ? 72 : (variant.hasFooter ? 144 : 84)
                XCTAssertEqual(image.size, CGSize(width: 411, height: naturalHeight + 68))
                if mode == "production" {
                    let (rgba, width) = try pixels(image)
                    // These source-white points sit beside/below the avatar.
                    // A shadow applied to child layers makes them gray.
                    for point in [(341, 92), (321, 42), (300, 60)] {
                        let index = (point.1 * 3 * width + point.0 * 3) * 4
                        XCTAssertGreaterThanOrEqual(rgba[index], 254)
                        XCTAssertGreaterThanOrEqual(rgba[index + 1], 254)
                        XCTAssertGreaterThanOrEqual(rgba[index + 2], 254)
                        XCTAssertEqual(rgba[index + 3], 255)
                    }
                }
                let attachment = XCTAttachment(image: image)
                attachment.name = "card-large-full-shadow-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(mode)-day-3x"
                attachment.lifetime = .keepAlways; add(attachment)
            }
        }
    }

    @MainActor func testSixSourceHeaderCompositionsUsePublicChildrenInBothThemes() throws {
        for theme in TUITheme.allCases {
            for variant in [TUICardLarge.Variant.header, .headerFlat, .headerSubheader,
                            .headerSubheaderFlat, .headerSubheaderWithFooter, .headerSubheaderFlatWithFooter] {
                var presses = 0
                let card = TUICardLarge(variant: variant) {
                    TUIHeaderCard(variant: .avatar, showsSubheader: variant.preset == .headerSubheader)
                } content: {
                    EmptyView()
                } footer: {
                    if variant.hasFooter {
                        TUIButton("Label", appearance: .secondary, size: .medium) { presses += 1 }
                    }
                }
                let renderer = ImageRenderer(content: card.frame(width: 375)
                    .environment(\.colorScheme, theme == .day ? .light : .dark))
                renderer.scale = 3
                let image = try XCTUnwrap(renderer.uiImage)
                let height = variant.preset == .header ? 72 : (variant.hasFooter ? 144 : 84)
                XCTAssertEqual(image.size, CGSize(width: 375, height: height), variant.figmaNodeID)
                XCTAssertEqual(presses, 0, "Rendering must not invoke the footer action")
                let attachment = XCTAttachment(image: image)
                attachment.name = "card-large-composition-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x"
                attachment.lifetime = .keepAlways; add(attachment)
            }
        }
    }

    @MainActor func testMatrixPreservesEveryImportedIOSPropertyIncludingCyrillicKey() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "figma-component-variants", withExtension: "json",
                                                 subdirectory: "Metadata")
            ?? Bundle.module.url(forResource: "figma-component-variants", withExtension: "json"))
        let root = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any])
        let all = try XCTUnwrap(root["variants"] as? [[String: Any]])
        let source = all.filter { $0["setId"] as? String == TUICardLarge.figmaComponentSetID &&
            ($0["variantProperties"] as? [String: String])?["Systеm"] == "iOS" }
        XCTAssertEqual(source.count, 24)
        XCTAssertEqual(Set(source.compactMap { $0["id"] as? String }),
                       Set(TUICardLarge.Variant.allCases.map(\.figmaNodeID)))
        for row in source {
            let variant = try XCTUnwrap(TUICardLarge.Variant(rawValue: try XCTUnwrap(row["id"] as? String)))
            XCTAssertEqual(variant.figmaProperties, row["variantProperties"] as? [String: String])
        }
    }

    @MainActor func testSourceContainerGeometryWithMeasuredSlotFixtures() throws {
        for variant in TUICardLarge.Variant.allCases {
            let image = try render(fixture(variant), width: variant.preset == .small ? 187.5 : 375)
            let expected: CGFloat
            switch variant.preset {
            case .scrollCard: expected = variant.hasFooter ? 276 : 212
            case .custom, .small: expected = variant.hasFooter ? 186 : 122
            case .cellList: expected = variant.hasFooter ? 364 : 300
            case .cell, .cellClose: expected = 80
            case .header: expected = 72
            case .headerSubheader: expected = variant.hasFooter ? 144 : 84
            case .map: expected = 196
            case .cellButton: expected = 144
            }
            XCTAssertEqual(image.size.height, expected, accuracy: 0.01, variant.figmaNodeID)
            XCTAssertEqual(image.size.width, variant.preset == .small ? 187.5 : 375, accuracy: 0.01)
            let attachment = XCTAttachment(image: image)
            attachment.name = "card-large-container-fixture-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    @MainActor func testSmallPresetHasNoScreenInsetAndCustomPreservesSixteenPoints() throws {
        for (variant, width, inset) in [(TUICardLarge.Variant.smallFlat, 187.5, 0.0), (.customFlat, 375.0, 16.0)] {
            let image = try render(fixture(variant), width: width)
            let span = try opaqueSpan(image, row: 60)
            XCTAssertEqual(span.lowerBound, Int(inset * 2))
            XCTAssertEqual(span.upperBound, Int((width - inset) * 2) - 1)
        }
    }

    @MainActor func testMinimumHeightDoesNotClipLargerContentAndFooterCanMoveToBottom() throws {
        for placement in TUICardLarge.FooterPlacement.allCases {
            let short = TUICardLarge(variant: .customWithFooter,
                                    style: .init(minimumHeight: 280, showsShadow: false, footerPlacement: placement)) {
                Color.blue.frame(height: 52)
            } content: { Color.green.frame(height: 50) } footer: { Color.red.frame(height: 44) }
            let shortImage = try render(short, width: 375)
            XCTAssertEqual(shortImage.size.height, 280)
            let footerRow = placement == .bottom ? 230 : 145
            XCTAssertTrue(try containsRed(shortImage, row: footerRow))
            let long = TUICardLarge(variant: .customWithFooter,
                                   style: .init(minimumHeight: 280, showsShadow: false, footerPlacement: placement)) {
                Color.blue.frame(height: 52)
            } content: { Color.green.frame(height: 300) } footer: { Color.red.frame(height: 44) }
            XCTAssertEqual(try render(long, width: 375).size.height, 436)
        }
    }

    @MainActor private func fixture(_ variant: TUICardLarge.Variant) -> some View {
        if variant.isSkeleton {
            return AnyView(TUICardLarge(isSkeletonAnimating: false))
        }
        let headerHeight: CGFloat = variant.preset == .header ? 68 : variant.preset == .headerSubheader ? 80 : 52
        let contentHeight: CGFloat = variant.preset == .cellList ? 236 : variant.preset == .scrollCard ? 140
            : variant.preset == .map ? 120 : [.cell, .cellClose, .cellButton].contains(variant.preset) ? 56 : 50
        return AnyView(TUICardLarge(variant: variant, style: .init(showsShadow: false)) {
            if ![.cell, .cellClose, .cellButton].contains(variant.preset) { Color.blue.frame(height: headerHeight) }
        } content: {
            if ![.header, .headerSubheader].contains(variant.preset) { Color.green.frame(height: contentHeight) }
        } footer: { Color.red.frame(height: 44) })
    }

    @MainActor private func render<V: View>(_ view: V, width: CGFloat) throws -> UIImage {
        let renderer = ImageRenderer(content: view.frame(width: width))
        renderer.scale = 2
        return try XCTUnwrap(renderer.uiImage)
    }

    private func pixels(_ image: UIImage) throws -> ([UInt8], Int) {
        let cg = try XCTUnwrap(image.cgImage)
        var bytes = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
        let context = try XCTUnwrap(CGContext(data: &bytes, width: cg.width, height: cg.height, bitsPerComponent: 8,
            bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue))
        context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        return (bytes, cg.width)
    }

    private func opaqueSpan(_ image: UIImage, row: Int) throws -> ClosedRange<Int> {
        let (bytes, width) = try pixels(image)
        let columns = (0..<width).filter { bytes[(row * 2 * width + $0) * 4 + 3] > 250 }
        return try XCTUnwrap(columns.first)...XCTUnwrap(columns.last)
    }

    private func containsRed(_ image: UIImage, row: Int) throws -> Bool {
        let (bytes, width) = try pixels(image)
        let index = (row * 2 * width + width / 2) * 4
        // SwiftUI's semantic red is not literal #FF0000 on iOS.
        return bytes[index] > 200 && bytes[index + 1] < 100 && bytes[index + 2] < 100
    }
}
