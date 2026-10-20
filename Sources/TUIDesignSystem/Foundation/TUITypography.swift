import SwiftUI
import UIKit

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

    public var swiftUITextStyle: Font.TextStyle {
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

    var uiKitTextStyle: UIFont.TextStyle {
        switch self {
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
    case uiXXSmall = "Typography/UI/2XS"
    case uiXXSmallBold = "Typography/UI/2XS Bold"
    case uiXXXSmall = "Typography/UI/3XS"
    case uiXXXSmallBold = "Typography/UI/3XS Bold"
    case capsSmall = "Typography/Caps/S"
    case capsSmallBold = "Typography/Caps/S Bold"
    case capsXXSmall = "Typography/Caps/2XS"
    case capsXXSmallBold = "Typography/Caps/2XS Bold"
    case numberXXLarge = "Typography/Numbers/2XL"
    case numberXLarge = "Typography/Numbers/XL"
    case numberMedium = "Typography/Numbers/M"

    /// Exact Dynamic Type association from Foundations, node 12472:11173.
    /// A role's base point size can differ from the associated system style.
    public var textStyle: TUITextStyle {
        switch self {
        case .headingLarge, .numberXXLarge: .largeTitle
        case .headingMedium, .numberMedium: .title3
        case .headingSmall, .headingSmallBold: .headline
        case .bodyLarge, .bodyLargeBold, .uiLarge, .uiLargeBold: .body
        case .bodyMedium, .bodyMediumBold, .uiMedium, .uiMediumBold: .subheadline
        case .bodySmall, .bodySmallBold, .uiSmall, .uiSmallBold,
             .capsSmall, .capsSmallBold: .footnote
        case .bodyXSmall, .bodyXSmallBold, .uiXSmall, .uiXSmallBold: .caption1
        case .uiXXSmall, .uiXXSmallBold, .uiXXXSmall, .uiXXXSmallBold,
             .capsXXSmall, .capsXXSmallBold: .caption2
        case .numberXLarge: .title1
        }
    }

    public var isUppercase: Bool {
        switch self {
        case .capsSmall, .capsSmallBold, .capsXXSmall, .capsXXSmallBold: true
        default: false
        }
    }

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
    /// Figma's reference tracking. The iOS specification states that the
    /// platform supplies this spacing automatically; tuiTypography does not
    /// add it to the system font a second time.
    public let letterSpacing: CGFloat

    public var font: Font {
        Font(nativeFont(at: size))
    }

    func nativeFont(at pointSize: CGFloat) -> UIFont {
        let font = UIFont.systemFont(ofSize: pointSize, weight: nativeWeight)
        guard family.localizedCaseInsensitiveContains("Rounded"),
              let descriptor = font.fontDescriptor.withDesign(.rounded) else { return font }
        return UIFont(descriptor: descriptor, size: pointSize)
    }

    private var nativeWeight: UIFont.Weight {
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
    @ScaledMetric private var fontSize: CGFloat
    @ScaledMetric private var lineHeight: CGFloat

    init(role: TUITypographyRole) {
        self.role = role
        let metrics = role.metrics
        let style = role.textStyle.swiftUITextStyle
        _fontSize = ScaledMetric(wrappedValue: metrics.size, relativeTo: style)
        _lineHeight = ScaledMetric(wrappedValue: metrics.lineHeight, relativeTo: style)
    }

    public func body(content: Content) -> some View {
        let metrics = role.metrics
        let font = metrics.nativeFont(at: fontSize)
        content
            .font(Font(font))
            // Point size is not a native line's height. Add only the leading
            // missing from the token's line height; never shrink the font's
            // natural line box and clip accents or descenders.
            .lineSpacing(max(0, lineHeight - font.lineHeight))
            .textCase(role.isUppercase ? .uppercase : nil)
    }
}

public extension View {
    func tuiTypography(_ role: TUITypographyRole) -> some View {
        modifier(TUITypographyModifier(role: role))
    }
}
