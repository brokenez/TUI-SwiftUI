import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class TypographyConsumerTests: XCTestCase {
    // Foundations iOS table 12472:11173. Expectations deliberately do not read
    // role.textStyle: that association was previously ignored by consumers.
    private let styles: [(UIFont.TextStyle, [TUITypographyRole])] = [
        (.largeTitle, [.headingLarge, .numberXXLarge]),
        (.title1, [.numberXLarge]),
        (.title3, [.headingMedium, .numberMedium]),
        (.headline, [.headingSmall, .headingSmallBold]),
        (.body, [.bodyLarge, .bodyLargeBold, .uiLarge, .uiLargeBold]),
        (.subheadline, [.bodyMedium, .bodyMediumBold, .uiMedium, .uiMediumBold]),
        (.footnote, [.bodySmall, .bodySmallBold, .uiSmall, .uiSmallBold, .capsSmall, .capsSmallBold]),
        (.caption1, [.bodyXSmall, .bodyXSmallBold, .uiXSmall, .uiXSmallBold]),
        (.caption2, [.uiXXSmall, .uiXXSmallBold, .uiXXXSmall, .uiXXXSmallBold, .capsXXSmall, .capsXXSmallBold])
    ]

    @MainActor func testAllRoleOverridesKeepNativeFaceSpacingAndRoleScalingInEverySlot() throws {
        XCTAssertEqual(styles.flatMap { $0.1 }.count, 31)
        for size in [DynamicTypeSize.large, .accessibility1, .accessibility5] {
            let category: UIContentSizeCategory = size == .large ? .large : .accessibilityMedium
            let traits = UITraitCollection(preferredContentSizeCategory: category)
            for (textStyle, roles) in styles {
                for role in roles {
                    let metrics = role.metrics
                    let weight: UIFont.Weight = metrics.weight >= 650 ? .bold : metrics.weight >= 550 ? .semibold
                        : metrics.weight >= 450 ? .medium : .regular
                    let system = UIFont.systemFont(ofSize: metrics.size, weight: weight)
                    let base = metrics.family.contains("Rounded")
                        ? UIFont(descriptor: try XCTUnwrap(system.fontDescriptor.withDesign(.rounded)), size: metrics.size) : system
                    let expected = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: base, compatibleWith: traits)
                    var actual: [(UIFont, CGFloat)] = []
                    for (title, description) in [(true, false), (false, true), (false, false)] {
                        let header = TUIHeaderFontMetrics.make(style: .init(role: role), title: title,
                                                              description: description, size: size)
                        actual.append((header.font, header.tracking))
                    }
                    for kind in [TUIHeaderCardTextKind.title, .subheader, .description, .caption] {
                        let header = TUIHeaderCardFontMetrics.make(kind: kind, style: .init(role: role), size: size)
                        actual.append((header.font, header.tracking))
                    }
                    for title in [true, false] {
                        let card = TUICardMediumFontMetrics.make(style: .init(role: role), title: title, size: size)
                        actual.append((card.font, card.tracking))
                    }
                    for (font, tracking) in actual {
                        XCTAssertEqual(font.fontName, expected.fontName, role.rawValue)
                        XCTAssertEqual(font.pointSize, expected.pointSize, accuracy: 0.001, role.rawValue)
                        XCTAssertEqual(tracking, 0, role.rawValue)
                    }
                }
            }
        }
    }

    @MainActor func testExplicitTrackingOverridesAndCustomFontsRemainSupported() {
        let custom = UIFont.monospacedSystemFont(ofSize: 24, weight: .medium)
        for role in [TUITypographyRole.headingLarge, .uiXXXSmallBold, .numberXLarge] {
            let header = TUIHeaderFontMetrics.make(style: .init(role: role, tracking: 1.25),
                                                   title: true, description: false, size: .large)
            let card = TUICardMediumFontMetrics.make(style: .init(role: role, tracking: 1.25), title: false, size: .large)
            XCTAssertEqual(header.tracking, 1.25)
            XCTAssertEqual(card.tracking, 1.25)
        }
        let header = TUIHeaderFontMetrics.make(style: .init(font: custom), title: true, description: false, size: .large)
        let card = TUICardMediumFontMetrics.make(style: .init(font: custom), title: true, size: .large)
        let headerCard = TUIHeaderCardFontMetrics.make(kind: .title, style: .init(font: custom), size: .large)
        for (font, tracking) in [(header.font, header.tracking), (card.font, card.tracking), (headerCard.font, headerCard.tracking)] {
            XCTAssertEqual(font.fontName, custom.fontName)
            XCTAssertEqual(font.pointSize, 24)
            XCTAssertEqual(tracking, 0)
        }
    }

    @MainActor func testCapsRenderUppercaseAcrossFiveConsumersIncludingLineMeasurement() throws {
        for role in [TUITypographyRole.capsSmall, .capsSmallBold, .capsXXSmall, .capsXXSmallBold] {
            for size in [DynamicTypeSize.large, .accessibility1] {
                let value = "Разные регистры текста и переносы строк"
                func views(_ title: String) -> [AnyView] {
                    [
                        AnyView(TUIHeaderLarge(title, showsSubheader: false).textStyles(title: .init(role: role))),
                        AnyView(TUIHeaderCard(title, variant: .none, showsSubheader: false, showsCaption: false)
                            .textStyles(title: .init(role: role))),
                        AnyView(TUICardMedium(title, subtitle: "", variant: .textBottomFill,
                            style: .init(title: .init(role: role)))),
                        AnyView(TUICell(title, showsAvatar: false, showsDescription: false)
                            .textStyle(.init(role: role), for: .title)),
                        AnyView(TUICellCheckicon(title: title, variant: .flexibleHeight,
                            textOptions: .init(title: .init(role: role)), showAvatar: false,
                            showDescription: false, showSelected: false, action: {}))
                    ]
                }
                for (index, pair) in zip(views(value), views(value.uppercased())).enumerated() {
                    let actual = try render(pair.0, size: size)
                    let expected = try render(pair.1, size: size)
                    XCTAssertEqual(actual.size, expected.size, "Consumer \(index) / \(role)")
                    XCTAssertEqual(actual.pngData(), expected.pngData(), "Consumer \(index) / \(role)")
                }
            }
        }
    }

    @MainActor private func render(_ view: AnyView, size: DynamicTypeSize) throws -> UIImage {
        let renderer = ImageRenderer(content: view.frame(width: 375).background(Color.white)
            .environment(\.colorScheme, .light).environment(\.dynamicTypeSize, size))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }
}
