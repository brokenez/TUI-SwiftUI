import SwiftUI

public enum TUITextStyle: String, CaseIterable, Sendable {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2

    public var font: Font {
        switch self {
        case .largeTitle: .largeTitle
        case .title1: .title
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .body: .body
        case .callout: .callout
        case .subheadline: .subheadline
        case .footnote: .footnote
        case .caption1: .caption
        case .caption2: .caption2
        }
    }
}

public struct TUITextStyleModifier: ViewModifier {
    let style: TUITextStyle
    let weight: Font.Weight?

    public func body(content: Content) -> some View {
        content
            .font(style.font)
            .fontWeight(weight)
    }
}

public extension View {
    func tuiTextStyle(_ style: TUITextStyle, weight: Font.Weight? = nil) -> some View {
        modifier(TUITextStyleModifier(style: style, weight: weight))
    }
}

public enum TUITypographyRole: String, CaseIterable, Sendable {
    case headingLarge = "Typography/Heading Mobile/L"
    case headingMedium = "Typography/Heading Mobile/M"
    case headingSmall = "Typography/Heading Mobile/S"
    case headingSmallBold = "Typography/Heading Mobile/S Bold"
    case bodyLarge = "Typography/Body/L"
    case bodyLargeBold = "Typography/Body/L Bold"
    case bodyMedium = "Typography/Body/M"
    case bodyMediumBold = "Typography/Body/M Bold"
    case bodySmall = "Typography/Body/S"
    case bodySmallBold = "Typography/Body/S Bold"
    case bodyXSmall = "Typography/Body/XS"
    case bodyXSmallBold = "Typography/Body/XS Bold"
    case uiLarge = "Typography/UI/L"
    case uiLargeBold = "Typography/UI/L Bold"
    case uiMedium = "Typography/UI/M"
    case uiMediumBold = "Typography/UI/M Bold"
    case uiSmall = "Typography/UI/S"
    case uiSmallBold = "Typography/UI/S Bold"
    case uiXSmall = "Typography/UI/XS"
    case uiXSmallBold = "Typography/UI/XS Bold"
    case numberXXLarge = "Typography/Numbers/2XL"
    case numberXLarge = "Typography/Numbers/XL"
    case numberMedium = "Typography/Numbers/M"

    public var metrics: TUITypographyMetrics {
        let catalog = TUITokenCatalog.shared
        func number(_ suffix: String) -> CGFloat? {
            catalog.number(named: rawValue + "/" + suffix, collection: "Platform", mode: TUIPlatform.iOS.rawValue).map { CGFloat($0) }
        }
        let family = catalog.value(
            named: rawValue + "/Font Family",
            collection: "Platform",
            mode: TUIPlatform.iOS.rawValue
        ) as? String ?? "SF Pro"
        return TUITypographyMetrics(
            family: family,
            size: number("Font Size") ?? 17,
            weight: number("Font Weight") ?? 400,
            lineHeight: number("Line Height") ?? 22,
            letterSpacing: number("Letter Spacing*") ?? number("Letter Spacing") ?? 0
        )
    }
}

public struct TUITypographyMetrics: Sendable, Hashable {
    public let family: String
    public let size: CGFloat
    public let weight: CGFloat
    public let lineHeight: CGFloat
    public let letterSpacing: CGFloat

    public var font: Font {
        .system(size: size, weight: swiftUIWeight, design: family.localizedCaseInsensitiveContains("Rounded") ? .rounded : .default)
    }

    private var swiftUIWeight: Font.Weight {
        switch weight {
        case 650...: .bold
        case 550...: .semibold
        case 450...: .medium
        default: .regular
        }
    }
}

public struct TUITypographyModifier: ViewModifier {
    let role: TUITypographyRole

    public func body(content: Content) -> some View {
        let metrics = role.metrics
        content
            .font(metrics.font)
            .tracking(metrics.letterSpacing)
            .lineSpacing(max(0, metrics.lineHeight - metrics.size))
    }
}

public extension View {
    func tuiTypography(_ role: TUITypographyRole) -> some View {
        modifier(TUITypographyModifier(role: role))
    }
}
