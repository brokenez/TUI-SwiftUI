import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class HeaderCardTests: XCTestCase {
    @MainActor
    func testImportedMatrixMatchesEveryImplementedVariant() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "figma-component-variants", withExtension: "json"))
        let data = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any])
        let variants = try XCTUnwrap(data["variants"] as? [[String: Any]])
        let expected = variants.filter { $0["setId"] as? String == "44217:298609"
            && ($0["variantProperties"] as? [String: String])?["System"] == "iOS" }
        XCTAssertEqual(Set(expected.compactMap { $0["id"] as? String }), Set(TUIHeaderCard.Variant.allCases.map(\.figmaNodeID)))
        for variant in TUIHeaderCard.Variant.allCases {
            XCTAssertEqual(expected.first { $0["id"] as? String == variant.figmaNodeID }?["variantProperties"] as? [String: String], variant.figmaProperties)
        }
    }

    @MainActor
    func testEightSwiftUIVariantsRenderInBothThemes() throws {
        var buttonCount = 0
        for theme in TUITheme.allCases {
            for variant in TUIHeaderCard.Variant.allCases {
                // UIKit-backed Switch is captured by HeaderCardUITests inside
                // the real catalog app; ImageRenderer cannot render it.
                if variant == .switch { continue }
                let header = TUIHeaderCard(variant: variant, accessoryAction: { buttonCount += 1 },
                                          isOn: .constant(false), isSkeletonAnimating: false)
                let image = try render(header, theme: theme)
                XCTAssertEqual(image.size, CGSize(width: 375, height: variant.isExtended ? 100 : 80), variant.rawValue)
                attach(image, "header-card-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x")
            }
        }
        XCTAssertEqual(buttonCount, 0, "Rendering does not invoke actions")
    }


    @MainActor
    func testLineMetricsCapAndLongContent() throws {
        for kind in [TUIHeaderCardTextKind.title, .subheader, .description, .caption] {
            let base = TUIHeaderCardFontMetrics.make(kind: kind, style: .init(), size: .large)
            let ax1 = TUIHeaderCardFontMetrics.make(kind: kind, style: .init(), size: .accessibility1)
            let ax5 = TUIHeaderCardFontMetrics.make(kind: kind, style: .init(), size: .accessibility5)
            XCTAssertGreaterThan(ax1.font.pointSize, base.font.pointSize)
            XCTAssertEqual(ax1.font.pointSize, ax5.font.pointSize)
            XCTAssertEqual(ax1.lineHeight, ax5.lineHeight)
        }
        let title = TUIHeaderCardFontMetrics.make(kind: .title, style: .init(), size: .large)
        XCTAssertEqual(title.font.fontName, "SFProDisplay-Bold")
        XCTAssertEqual(title.font.pointSize, 20)
        XCTAssertEqual(title.lineHeight, 24)
        XCTAssertEqual(title.tracking, 0.38)
        let wrapped = TUIHeaderCard("Заголовок карточки, занимающий несколько строк", subheader: "Подзаголовок со всеми подробностями без сокращения", variant: .none)
        XCTAssertGreaterThan(try render(wrapped).size.height, 80)
        let faded = wrapped.textStyles(title: .init(overflow: .singleLineFade), subheader: .init(overflow: .singleLineFade))
        XCTAssertEqual(try render(faded).size.height, 80)
        XCTAssertEqual(try render(TUIHeaderCard(variant: .none, showsSubheader: false)).size.height, 52)
        XCTAssertEqual(try render(TUIHeaderCard(variant: .none, showsDescription: true)).size.height, 108)
        attach(try render(wrapped), "header-card-wrap-day-3x")
        attach(try render(faded), "header-card-fade-day-3x")
    }

    @MainActor
    func testCustomSlotsAndAccessoryReflowRetainContent() throws {
        let header = TUIHeaderCard("Заголовок для проверки увеличенного текста", variant: .extended)
            .subheaderLeading { Text("До").foregroundStyle(.red) }
            .subheaderTrailing { Text("После").foregroundStyle(.red) }
        let inline = header.accessory { TUISystemSwitch("Выбрать", isOn: .constant(true)) }
        let reflow = header.accessory(reflowsAtAX1: true) { TUISystemSwitch("Выбрать", isOn: .constant(true)) }
        let a = try render(reflow, size: .accessibility1)
        let b = try render(reflow, size: .accessibility5)
        XCTAssertEqual(a.size, b.size)
        XCTAssertGreaterThan(a.size.height, 100)
        attach(a, "header-card-reflow-ax1-3x")
        attach(try render(inline, size: .accessibility1), "header-card-inline-ax1-3x")
    }

    @MainActor
    func testBooleanContentPropertiesRemoveTheirSourceContainers() throws {
        for caption in [false, true] {
            for subheader in [false, true] {
                for description in [false, true] {
                    let header = TUIHeaderCard(variant: .extended, showsSubheader: subheader,
                                              showsDescription: description, showsCaption: caption)
                    let image = try render(header)
                    // Figma: 28 pt outer insets + 24 pt title; optional caption
                    // 12 + 8, subheader 18 + 2 + 8, description 20 + 8.
                    let sourceHeight = 52 + (caption ? 20 : 0) + (subheader ? 28 : 0) + (description ? 28 : 0)
                    XCTAssertEqual(image.size, CGSize(width: 375, height: sourceHeight))
                    attach(image, "header-card-content-caption-\(caption)-subheader-\(subheader)-description-\(description)")
                }
            }
        }
    }

    @MainActor
    func testTitleCentersInsideTallerAvatarWhenSubheaderIsHidden() throws {
        let header = TUIHeaderCard(variant: .avatar, showsSubheader: false)
        let image = try render(header)
        XCTAssertEqual(image.size, CGSize(width: 375, height: 68))
        let textOnly = try render(TUIHeaderCard(variant: .none, showsSubheader: false))
        let a = try XCTUnwrap(image.cgImage)
        let b = try XCTUnwrap(textOnly.cgImage)
        // The source's 40 pt avatar stretches the 24 pt text column. Its
        // contents are centered: 8 pt extra above and below, with no font edit.
        let titleA = try XCTUnwrap(a.cropping(to: CGRect(x: 20 * 3, y: 24 * 3, width: 200 * 3, height: 24 * 3)))
        let titleB = try XCTUnwrap(b.cropping(to: CGRect(x: 20 * 3, y: 16 * 3, width: 200 * 3, height: 24 * 3)))
        XCTAssertEqual(UIImage(cgImage: titleA).pngData(), UIImage(cgImage: titleB).pngData())
        attach(image, "header-card-avatar-without-subheader-centered-title")
    }

    @MainActor
    private func render<Content: View>(_ content: Content, theme: TUITheme = .day,
                                      size: DynamicTypeSize = .large) throws -> UIImage {
        let renderer = ImageRenderer(content: content.frame(width: 375)
            .background(theme == .day ? Color.white : Color.black)
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, size))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }
    private func attach(_ image: UIImage, _ name: String) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
