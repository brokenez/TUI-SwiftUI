import SwiftUI

public enum TUIButtonVerticalState: String, CaseIterable, Sendable {
    case normal
    case pressed
    case disabled
}

/// A 90-point vertical action from TUI Mobile, with its iOS visual states.
public struct TUIButtonVertical: View {
    public let title: String
    public let state: TUIButtonVerticalState
    public let skeleton: Bool
    public let icon: Image?
    private let action: () -> Void

    public init(
        _ title: String,
        state: TUIButtonVerticalState = .normal,
        skeleton: Bool = false,
        icon: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.state = state
        self.skeleton = skeleton
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            EmptyView()
        }
        .buttonStyle(VerticalStyle(title: title, state: state, skeleton: skeleton, icon: icon))
        .disabled(state == .disabled || skeleton)
    }
}

private struct VerticalStyle: ButtonStyle {
    let title: String
    let state: TUIButtonVerticalState
    let skeleton: Bool
    let icon: Image?

    func makeBody(configuration: Configuration) -> some View {
        let shownState: TUIButtonVerticalState = state == .normal && configuration.isPressed ? .pressed : state
        return VStack(spacing: 8) {
            if let icon {
                icon
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(shownState == .disabled ? TUIColor.named("Text/Tertiary") : TUIColor.named("Text/Action"))
                    .frame(width: 24, height: 24)
            } else {
                Image(shownState == .disabled ? "tui-button-vertical-star-disabled" : "tui-button-vertical-star", bundle: .module)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            Text(title)
                .tuiTypography(.uiXSmall)
                .foregroundStyle(shownState == .disabled ? TUIColor.named("Text/Tertiary") : TUIColor.named("Text/Action"))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .opacity(skeleton ? 0 : 1)
        .padding(12)
        .frame(width: 90)
        .frame(minHeight: 68)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(background(for: shownState))
        }
        .overlay {
            if skeleton {
                RoundedRectangle(cornerRadius: 12)
                    .fill(TUIColor.named("Service/Skeleton"))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityLabel(title)
        .accessibilityAddTraits(skeleton ? [] : [.isButton])
    }

    private func background(for state: TUIButtonVerticalState) -> Color {
        if skeleton { return .clear }
        return switch state {
        case .normal: TUIColor.named("Component/Button Vertical")
        case .pressed: TUIColor.named("State/Component/Button Vertical Pressed")
        case .disabled: TUIColor.named("Background/Neutral 1")
        }
    }
}
