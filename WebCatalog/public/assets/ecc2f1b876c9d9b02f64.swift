import SwiftUI

/// Icon-only add action from the six iOS variants of `tui-button [add-card]`.
/// Intended for dark account/card backgrounds; the surrounding surface belongs to the caller.
public struct TUIButtonAddCard: View {
    public enum Size: String, CaseIterable, Sendable {
        case large = "large 54x36"
        case medium = "medium 48x32"
        case small = "small 40x26"

        public var width: CGFloat {
            switch self { case .large: 54; case .medium: TUISpacing.x12; case .small: TUISpacing.x10 }
        }
        public var height: CGFloat {
            switch self { case .large: 36; case .medium: TUISpacing.x8; case .small: 26 }
        }
        public var iconSize: CGFloat {
            switch self { case .large: TUISpacing.x4; case .medium: 14; case .small: TUISpacing.x3 }
        }
        public func figmaNodeID(state: State) -> String {
            switch (self, state) {
            case (.large, .normal): "7319:38984"
            case (.large, .pressed): "7319:38987"
            case (.medium, .normal): "7319:38990"
            case (.medium, .pressed): "7319:38993"
            case (.small, .normal): "7319:38996"
            case (.small, .pressed): "7319:38999"
            }
        }
    }

    public enum State: String, CaseIterable, Sendable { case normal, pressed }

    // The specification requires proportional enlargement of the button and glyph.
    // Use the native iOS Dynamic Type curve; there is no label to measure.
    @ScaledMetric(relativeTo: .body) private var contentScale: CGFloat = 1
    public let size: Size
    public let state: State
    public let accessibilityLabel: String
    public let accessibilityHint: String
    private let action: () -> Void

    public init(
        size: Size = .large,
        state: State = .normal,
        accessibilityLabel: String = "Добавить",
        accessibilityHint: String = "Выпустить карту или открыть счёт",
        action: @escaping () -> Void
    ) {
        self.size = size
        self.state = state
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    public var figmaNodeID: String { size.figmaNodeID(state: state) }

    public var body: some View {
        Button(action: action) {
            Image("tui-button-add-card-plus", bundle: .module)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                .frame(width: size.iconSize * contentScale, height: size.iconSize * contentScale)
                .accessibilityHidden(true)
        }
        .buttonStyle(TUIButtonAddCardStyle(size: size, contentScale: contentScale, state: state))
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityIdentifier("tuiButtonAddCard-\(figmaNodeID)")
    }
}

private struct TUIButtonAddCardStyle: ButtonStyle {
    let size: TUIButtonAddCard.Size
    let contentScale: CGFloat
    let state: TUIButtonAddCard.State

    func makeBody(configuration: Configuration) -> some View {
        let pressed = state == .pressed || configuration.isPressed
        configuration.label
            .frame(width: size.width * contentScale, height: size.height * contentScale)
            // The source layer has an explicit radius of 6 pt, including its enlarged example.
            .background(TUIColor.named("Background/Neutral 1 On Dark"),
                        in: RoundedRectangle(cornerRadius: 6, style: .circular))
            .scaleEffect(pressed ? 0.95 : 1)
            .frame(width: size.width * contentScale, height: size.height * contentScale)
            .contentShape(Rectangle())
    }
}
