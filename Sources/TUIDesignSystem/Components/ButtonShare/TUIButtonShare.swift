import SwiftUI

/// The six iOS states of the Figma Share style, with a native Button action.
public struct TUIButtonShare: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    public let appearance: TUISocialButtonAppearance
    public let state: TUISocialButtonState
    public let accessibilityLabel: String
    private let action: () -> Void

    public init(
        appearance: TUISocialButtonAppearance = .secondary,
        state: TUISocialButtonState = .normal,
        accessibilityLabel: String = "Поделиться",
        action: @escaping () -> Void
    ) {
        self.appearance = appearance
        self.state = state
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var figmaNodeID: String {
        switch (appearance, state) {
        case (.secondary, .normal): "44290:299204"
        case (.secondary, .pressed): "52061:47184"
        case (.glassOnLight, .normal): "44290:299200"
        case (.glassOnLight, .pressed): "52061:47210"
        case (.glassOnDark, .normal): "26951:47046"
        case (.glassOnDark, .pressed): "52061:47166"
        }
    }

    public var body: some View {
        let iconSize = TUISocialButtonMetrics.iconSize(for: typeSize)
        let diameter = TUISocialButtonMetrics.diameter(for: typeSize)
        Button(action: action) {
            Image("tui-button-share", bundle: .module)
                .renderingMode(.template)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(appearance.outlineColor)
                .frame(width: diameter, height: diameter)
                .contentShape(Circle())
        }
        .buttonStyle(TUISocialIconButtonStyle(appearance: appearance, state: state, fadesStates: false))
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier("tuiButtonShare-\(figmaNodeID)")
    }
}
