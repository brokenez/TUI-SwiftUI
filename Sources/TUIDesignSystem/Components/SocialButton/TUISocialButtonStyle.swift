import SwiftUI

public enum TUISocialButtonAppearance: String, CaseIterable, Sendable {
    case secondary
    case glassOnLight = "glass-on-light"
    case glassOnDark = "glass-on-dark"

    var normalFill: Color {
        switch self {
        case .secondary: TUIColor.named("Background/Neutral 1")
        case .glassOnLight: TUIColor.named("Background/Overlay Glass On Light")
        case .glassOnDark: TUIColor.named("Background/Overlay Glass On Dark")
        }
    }

    var pressedFill: Color {
        switch self {
        case .secondary: TUIColor.named("State/Background/Neutral 1 Pressed")
        case .glassOnLight: TUIColor.named("State/Background/Overlay Glass On Light Pressed")
        case .glassOnDark: TUIColor.named("State/Background/Overlay Glass On Dark Pressed")
        }
    }

    var outlineColor: Color {
        self == .secondary ? TUIColor.action : TUIColor.named("Text/Primary On Dark")
    }
}

public enum TUISocialButtonState: String, CaseIterable, Sendable {
    case normal
    case pressed
}

enum TUISocialButtonMetrics {
    static func iconSize(for typeSize: DynamicTypeSize) -> CGFloat {
        TUISpacing.x6 * (typeSize.isAccessibilitySize ? 1.25 : 1)
    }

    static func diameter(for typeSize: DynamicTypeSize) -> CGFloat {
        // Source retains 10 pt padding on both sides of the enlarged AX1 icon.
        TUIControlSize.medium + iconSize(for: typeSize) - TUISpacing.x6
    }
}

struct TUISocialIconButtonStyle: ButtonStyle {
    let appearance: TUISocialButtonAppearance
    let state: TUISocialButtonState
    let fadesStates: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let pressed = state == .pressed || configuration.isPressed
        configuration.label
            .background {
                if appearance == .secondary {
                    Circle().fill(pressed ? appearance.pressedFill : appearance.normalFill)
                } else {
                    // Temporary material implementation: its tint/blur requires
                    // comparison against the source on a matching patterned backdrop.
                    // Coverage stays in-progress until that comparison passes.
                    Circle().fill(.ultraThinMaterial)
                        .overlay { Circle().fill(pressed ? appearance.pressedFill : appearance.normalFill) }
                }
            }
            .animation(fadesStates && !reduceMotion
                ? TUIMotionCurve.productiveStandard.animation(duration: .fastest) : nil,
                value: pressed)
    }
}
