import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

/// Independent expectations transcribed from the iOS table in Foundations
/// 12472:11173, retrieved 2026-10-08. These are runtime checks, not visual acceptance.
final class TypographySpecificationTests: XCTestCase {
    private let sourceGroups: [(TUITextStyle, CGFloat, [TUITypographyRole])] = [
        (.largeTitle, 30, [.headingLarge]),
        (.title3, 20, [.headingMedium, .numberMedium]),
        (.headline, 17, [.headingSmall, .headingSmallBold]),
        (.body, 17, [.bodyLarge, .bodyLargeBold, .uiLarge, .uiLargeBold]),
        (.subheadline, 15, [.bodyMedium, .bodyMediumBold, .uiMedium, .uiMediumBold]),
        (.footnote, 13, [.bodySmall, .bodySmallBold, .uiSmall, .uiSmallBold, .capsSmall, .capsSmallBold]),
        (.caption1, 12, [.bodyXSmall, .bodyXSmallBold, .uiXSmall, .uiXSmallBold]),
        (.caption2, 11, [.uiXXSmall, .uiXXSmallBold, .capsXXSmall, .capsXXSmallBold]),
        (.caption2, 9, [.uiXXXSmall, .uiXXXSmallBold]),
        (.largeTitle, 48, [.numberXXLarge]),
        (.title1, 30, [.numberXLarge])
    ]

    func testEveryDocumentedIOSRoleHasTheSpecifiedBaseSizeAndDynamicTypeStyle() {
        let documented = sourceGroups.flatMap { $0.2 }
        XCTAssertEqual(documented.count, 31)
        XCTAssertEqual(Set(documented), Set(TUITypographyRole.allCases))
        for (style, size, roles) in sourceGroups {
            for role in roles {
                XCTAssertEqual(role.textStyle, style, role.rawValue)
                XCTAssertEqual(role.metrics.size, size, role.rawValue)
            }
        }
    }

    func testSmallUIAndCapsPreserveIOSWeightsTrackingAndLineHeight() {
        let rows: [(TUITypographyRole, CGFloat, CGFloat, CGFloat)] = [
            (.uiXXSmall, 400, 13, 0.06), (.uiXXSmallBold, 600, 13, 0.06),
            (.uiXXXSmall, 400, 11, 0.17), (.uiXXXSmallBold, 700, 11, 0.17),
            (.capsSmall, 400, 16, -0.08), (.capsSmallBold, 500, 16, -0.08),
            (.capsXXSmall, 400, 13, 0.06), (.capsXXSmallBold, 500, 13, 0.06)
        ]
        for (role, weight, lineHeight, tracking) in rows {
            XCTAssertEqual(role.metrics.family, "SF Pro")
            XCTAssertEqual(role.metrics.weight, weight, role.rawValue)
            XCTAssertEqual(role.metrics.lineHeight, lineHeight, role.rawValue)
            XCTAssertEqual(role.metrics.letterSpacing, tracking, accuracy: 0.00001, role.rawValue)
        }
    }

    @MainActor func testAllRolesRenderAtNativeScaledSizesInBothThemes() throws {
        for theme in TUITheme.allCases {
            for size in [DynamicTypeSize.large, .accessibility5] {
                let category: UIContentSizeCategory = size == .large ? .large : .accessibilityExtraExtraExtraLarge
                let trait = UITraitCollection(preferredContentSizeCategory: category)
                for (style, baseSize, roles) in sourceGroups {
                    let scaler = UIFontMetrics(forTextStyle: uiKitStyle(style))
                    for role in roles {
                        let metrics = role.metrics
                        let pointSize = scaler.scaledValue(for: baseSize, compatibleWith: trait)
                        let base = UIFont.systemFont(ofSize: pointSize, weight: uiKitWeight(metrics.weight))
                        let font = metrics.family.localizedCaseInsensitiveContains("Rounded")
                            ? UIFont(descriptor: try XCTUnwrap(base.fontDescriptor.withDesign(.rounded)), size: pointSize)
                            : base
                        let text = role.isUppercase ? "ТЕСТ 123" : "Тест 123"
                        let actual = try render(Text("Тест 123").tuiTypography(role), theme: theme, size: size)
                        // Letter Spacing* is a Figma-only reference. Native
                        // iOS tracking must remain automatic (UI, node 8705:3304).
                        let expected = try render(Text(text).font(Font(font)), theme: theme, size: size)
                        XCTAssertEqual(actual.size, expected.size, role.rawValue + " / " + String(describing: size))
                        XCTAssertEqual(actual.pngData(), expected.pngData(), role.rawValue + " / " + String(describing: size))
                        if size == .accessibility5 {
                            let standard = try render(Text("Тест 123").tuiTypography(role), theme: theme, size: .large)
                            XCTAssertGreaterThan(actual.size.height, standard.size.height, role.rawValue)
                        }
                    }
                }
            }
        }
    }

    @MainActor func testNativeTypographyOverviewsIncludeEveryRoleAndTheme() throws {
        for theme in TUITheme.allCases {
            for size in [DynamicTypeSize.large, .accessibility5] {
                let view = VStack(alignment: .leading, spacing: 12) {
                    ForEach(TUITypographyRole.allCases, id: \.self) { role in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(role.rawValue).font(.system(size: 10))
                            Text("Зарплатный клуб 123").tuiTypography(role)
                        }
                    }
                }.padding(16)
                let image = try render(view, theme: theme, size: size)
                let attachment = XCTAttachment(image: image)
                attachment.name = "typography-31-roles-\(theme.rawValue)-\(size)-3x"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }

    @MainActor func testBodyBaselineDistancesUseTokenLineHeightRatherThanPointSize() throws {
        // Current iOS table in Body 8705:3272: L 24, M 20, S 18, XS 17.
        let rows: [(TUITypographyRole, CGFloat)] = [
            (.bodyLarge, 24), (.bodyLargeBold, 24),
            (.bodyMedium, 20), (.bodyMediumBold, 20),
            (.bodySmall, 18), (.bodySmallBold, 18),
            (.bodyXSmall, 17), (.bodyXSmallBold, 17)
        ]
        var evidence: [[String: Any]] = []
        for size in [DynamicTypeSize.large, .accessibility5] {
            let category: UIContentSizeCategory = size == .large ? .large : .accessibilityExtraExtraExtraLarge
            let trait = UITraitCollection(preferredContentSizeCategory: category)
            for (role, sourceLineHeight) in rows {
                let expected = UIFontMetrics(forTextStyle: uiKitStyle(role.textStyle))
                    .scaledValue(for: sourceLineHeight, compatibleWith: trait)
                for softWrap in [false, true] {
                    let probe = TypographyBaselineStore()
                    let text = softWrap
                        ? "Длинный текст переносится автоматически и сохраняет расстояние между строками при системном увеличении размера шрифта"
                        : "Первая строка\nВторая строка\nТретья строка"
                    _ = try render(Text(text).tuiTypography(role)
                        .textRenderer(TypographyBaselineRenderer(store: probe))
                        .frame(width: softWrap ? 180 : nil), theme: .day, size: size)
                    let origins = probe.origins
                    if softWrap {
                        XCTAssertGreaterThan(origins.count, 1, role.rawValue)
                    } else {
                        XCTAssertEqual(origins.count, 3, role.rawValue)
                    }
                    let distances = zip(origins, origins.dropFirst()).map { $1 - $0 }
                    for distance in distances {
                        XCTAssertEqual(distance, expected, accuracy: 1.0 / 3.0, role.rawValue + " / " + String(describing: size))
                    }
                    evidence.append(["role": role.rawValue, "dynamicType": String(describing: size),
                                     "layout": softWrap ? "soft-wrap" : "explicit-breaks",
                                     "expectedBaselineDistance": expected, "actualBaselineDistances": distances])
                }
            }
        }
        let attachment = XCTAttachment(data: try JSONSerialization.data(withJSONObject: evidence, options: [.prettyPrinted, .sortedKeys]),
                                       uniformTypeIdentifier: "public.json")
        attachment.name = "body-token-native-baseline-distances"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor private func render<V: View>(_ view: V, theme: TUITheme, size: DynamicTypeSize) throws -> UIImage {
        let renderer = ImageRenderer(content: view
            .foregroundStyle(TUIColor.textPrimary)
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, size)
            .fixedSize()
            .background(TUIColor.backgroundPrimary))
        renderer.scale = 3
        return try XCTUnwrap(renderer.uiImage)
    }

    private func uiKitStyle(_ style: TUITextStyle) -> UIFont.TextStyle {
        switch style {
        case .largeTitle: .largeTitle
        case .title1: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .body: .body
        case .callout: .callout
        case .subheadline: .subheadline
        case .footnote: .footnote
        case .caption1: .caption1
        case .caption2: .caption2
        }
    }

    private func uiKitWeight(_ weight: CGFloat) -> UIFont.Weight {
        switch weight {
        case 650...: .bold
        case 550...: .semibold
        case 450...: .medium
        default: .regular
        }
    }
}

private final class TypographyBaselineStore: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [CGFloat] = []
    var origins: [CGFloat] { lock.withLock { storage } }
    func set(_ values: [CGFloat]) { lock.withLock { storage = values } }
}

private struct TypographyBaselineRenderer: TextRenderer {
    let store: TypographyBaselineStore
    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        store.set(layout.map { $0.origin.y })
        for line in layout { context.draw(line) }
    }
}
