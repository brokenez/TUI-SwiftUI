import SwiftUI

/// A single placeholder line with the exact legacy iOS text-style geometry from Figma.
/// Heights are component metrics, not the line heights of the current typography tokens.
public struct TUISkeletonText: View {
    public enum TextStyle: String, CaseIterable, Sendable {
        case headingLarge = "heading-l"
        case headingMedium = "heading-m"
        case headingSmall = "heading-s"
        case bodyLarge = "body-l"
        case bodyMedium = "body-m"
        case bodySmall = "body-s"
        case uiLarge = "ui-l"
        case uiMedium = "ui-m"
        case uiSmall = "ui-s"
        case uiXSmall = "ui-xs"
        case uiXXSmall = "ui-xxs"
        case numbersXLarge = "numbers-xl"
        case numbersMedium = "numbers-m"

        public var figmaNodeID: String {
            switch self {
            case .headingLarge: "37840:45837"
            case .headingMedium: "37840:45849"
            case .headingSmall: "37840:45853"
            case .bodyLarge: "37840:45857"
            case .bodyMedium: "37840:45861"
            case .bodySmall: "37840:45865"
            case .uiLarge: "37840:45869"
            case .uiMedium: "37840:45873"
            case .uiSmall: "37840:45877"
            case .uiXSmall: "37840:45881"
            case .uiXXSmall: "37840:45883"
            case .numbersXLarge: "37840:45839"
            case .numbersMedium: "37840:45843"
            }
        }

        public var barHeight: CGFloat {
            switch self {
            case .headingLarge, .numbersXLarge: TUISpacing.x6
            case .headingMedium, .numbersMedium: TUISpacing.x4
            case .headingSmall, .bodyLarge, .uiLarge: 14
            case .bodyMedium, .uiMedium: TUISpacing.x3
            case .bodySmall, .uiSmall, .uiXSmall: 10
            case .uiXXSmall: 9
            }
        }

        public var verticalInset: CGFloat {
            switch self {
            case .headingLarge, .numbersXLarge: 6
            case .headingMedium, .numbersMedium: TUISpacing.x1
            case .uiXSmall, .uiXXSmall: TUISpacing.x0_5
            default: 3
            }
        }

        public var height: CGFloat { barHeight + 2 * verticalInset }
    }

    public let textStyle: TextStyle
    public let width: CGFloat
    public let isAnimating: Bool

    public init(textStyle: TextStyle = .headingLarge, width: CGFloat = 92, isAnimating: Bool = true) {
        self.textStyle = textStyle
        self.width = max(0, width)
        self.isAnimating = isAnimating
    }

    public var body: some View {
        TUISkeleton(width: width, height: textStyle.barHeight, isAnimating: isAnimating)
            .padding(.vertical, textStyle.verticalInset)
            .accessibilityHidden(true)
    }
}
