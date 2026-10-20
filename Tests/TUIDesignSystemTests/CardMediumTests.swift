import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

final class CardMediumTests: XCTestCase {
    @MainActor func testCompleteSourceMatrixAndLegacyBadgeExceptionArePreserved() throws {
        let source = TUILibraryCatalog.shared.variants(for: TUICardMedium.figmaComponentSetID)
        XCTAssertEqual(source.count, 21)
        XCTAssertEqual(Set(source.map(\.id)), Set(TUICardMedium.Variant.allCases.map(\.figmaNodeID)))
        for variant in TUICardMedium.Variant.allCases {
            let imported = try XCTUnwrap(source.first { $0.id == variant.figmaNodeID })
            XCTAssertEqual(imported.properties["content"], variant.content.rawValue)
            XCTAssertEqual(imported.properties["text-position"], variant.textPosition.rawValue)
            XCTAssertEqual(imported.properties["background"], variant.background.rawValue)
            XCTAssertEqual(imported.properties["skeleton"], variant.isSkeleton ? "on" : "off")
        }
        XCTAssertEqual(TUICardMedium.Variant.allCases.filter(\.isSkeleton), [.textBottomSkeleton])
        XCTAssertEqual(TUICardMedium.Variant.allCases.filter(\.supportsNotification), [.avatarBottomImage, .avatarBottomFill])
        XCTAssertEqual(TUICardMedium.Variant.badgeBottomImage.badgeHeight, 24)
        for variant in [TUICardMedium.Variant.badgeBottomFill, .badgeTopImage, .badgeTopFill] {
            XCTAssertEqual(variant.badgeHeight, 20)
        }
    }

    @MainActor func testNativeMatrixRendersAllVariantsAndResourcesInBothThemes() throws {
        for theme in TUITheme.allCases {
            for variant in TUICardMedium.Variant.allCases {
                let image = try render(TUICardMedium(variant: variant, isSkeletonAnimating: false), theme: theme)
                XCTAssertEqual(image.size, CGSize(width: 140, height: 140), variant.rawValue)
                XCTAssertEqual(image.cgImage?.width, 420)
                attach(image, name: "card-medium-\(variant.figmaNodeID.replacingOccurrences(of: ":", with: "-"))-\(theme.rawValue.lowercased())-3x")
            }
        }
    }

    @MainActor func testAX1ScalingIsCappedAtAX5AndInsetsRemainUnscaled() throws {
        let standard = try render(TUICardMedium(variant: .avatarBottomFill))
        let ax1 = try render(TUICardMedium(variant: .avatarBottomFill), size: .accessibility1)
        let ax5 = try render(TUICardMedium(variant: .avatarBottomFill), size: .accessibility5)
        XCTAssertGreaterThan(ax1.size.width, standard.size.width)
        XCTAssertEqual(ax1.size, ax5.size)
        XCTAssertEqual(ax1.pngData(), ax5.pngData())
        let metrics = TUICardMediumFontMetrics.make(style: .init(), title: true, size: .large)
        XCTAssertEqual(metrics.font.pointSize, 15)
        XCTAssertEqual(metrics.lineHeight, 18)
        XCTAssertEqual(metrics.tracking, -0.24, accuracy: 0.0001)
        attach(ax1, name: "card-medium-avatar-ax1-3x")
        attach(ax5, name: "card-medium-avatar-ax5-capped-3x")
    }

    @MainActor func testLongLabelsAndBadgeKeepFullAccessibleContent() throws {
        let title = "Очень длинный заголовок, который занимает несколько строк и продолжается за пределами карточки"
        let subtitle = "Подпись с подробностями и явным переносом\nСледующий абзац не склеивается с предыдущим"
        let badge = "Очень длинная подпись Pro"
        let card = TUICardMedium(title, subtitle: subtitle, variant: .badgeBottomFill,
                                 badgeText: badge, style: .init(title: .init(maximumLines: 2), subtitle: .init(maximumLines: 1)))
        XCTAssertEqual(card.combinedLabel, title + ", " + subtitle)
        XCTAssertEqual(card.combinedValue, "Pro, " + badge)
        attach(try render(card), name: "card-medium-independent-fades-and-badge-3x")
        let overridden = TUICardMedium(title, variant: .avatarBottomFill,
            accessibilityLabel: "Счёт", accessibilityValue: "Непрочитанное уведомление")
        XCTAssertEqual(overridden.combinedLabel, "Счёт")
        XCTAssertEqual(overridden.combinedValue, "Непрочитанное уведомление")
        let replaced = TUICardMedium(variant: .badgeBottomFill).accessory { Color.blue.frame(width: 40, height: 40) }
        XCTAssertEqual(replaced.combinedValue, "", "A custom accessory must not announce the removed source Pro badge")
    }

    @MainActor func testCustomBackgroundAccessoryAndSizeUsePublicAPI() throws {
        let card = TUICardMedium("Действие", subtitle: "Описание", style: .init(width: 200, height: 160))
            .cardBackground { Color.red }
            .accessory { Rectangle().fill(Color.blue).frame(width: 40, height: 40) }
        let image = try render(card)
        XCTAssertEqual(image.size, CGSize(width: 200, height: 160))
        attach(image, name: "card-medium-public-customization-3x")
    }

    @MainActor func testExplicitFontOverrideKeepsNaturalLineHeightAndRolesUseFoundationMetrics() throws {
        let font = UIFont.systemFont(ofSize: 26, weight: .medium)
        let custom = TUICardMediumFontMetrics.make(style: .init(font: font), title: true, size: .large)
        XCTAssertEqual(custom.font.pointSize, 26)
        XCTAssertEqual(custom.lineHeight, font.lineHeight.rounded(), "A larger explicit font must not remain in the legacy 18-point box")
        let role = TUITypographyRole.bodyLarge
        let token = TUICardMediumFontMetrics.make(style: .init(role: role), title: true, size: .large)
        XCTAssertEqual(token.lineHeight, role.metrics.lineHeight.rounded())
        XCTAssertEqual(token.tracking, 0, "Foundation system roles use automatic iOS spacing")
        attach(try render(TUICardMedium("Крупный шрифт", subtitle: "", variant: .textBottomFill,
            style: .init(width: 200, height: 160, title: .init(font: font)))), name: "card-medium-explicit-font-natural-line-box-3x")
    }

    @MainActor private func render<V: View>(_ view: V, theme: TUITheme = .day, size: DynamicTypeSize = .large) throws -> UIImage {
        let renderer = ImageRenderer(content: view.environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, size))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }

    private func attach(_ image: UIImage, name: String) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
