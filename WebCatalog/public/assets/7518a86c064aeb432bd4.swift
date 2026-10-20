import SwiftUI

/// A native selection button representing all twelve iOS Like variants.
public struct TUIButtonLike: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding public var isSelected: Bool
    public let appearance: TUISocialButtonAppearance
    public let state: TUISocialButtonState
    public let accessibilityLabel: String
    private let action: () -> Void

    public init(
        isSelected: Binding<Bool>,
        appearance: TUISocialButtonAppearance = .secondary,
        state: TUISocialButtonState = .normal,
        accessibilityLabel: String = "В избранное",
        action: @escaping () -> Void = {}
    ) {
        self._isSelected = isSelected
        self.appearance = appearance
        self.state = state
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var figmaNodeID: String {
        switch (appearance, isSelected, state) {
        case (.secondary, false, .normal): "44290:299175"
        case (.secondary, true, .normal): "44290:299177"
        case (.secondary, false, .pressed): "44290:299191"
        case (.secondary, true, .pressed): "44290:299193"
        case (.glassOnLight, false, .normal): "44290:299167"
        case (.glassOnLight, true, .normal): "44290:299169"
        case (.glassOnLight, false, .pressed): "44290:299183"
        case (.glassOnLight, true, .pressed): "44290:299185"
        case (.glassOnDark, false, .normal): "26951:46960"
        case (.glassOnDark, true, .normal): "26951:46966"
        case (.glassOnDark, false, .pressed): "26951:46984"
        case (.glassOnDark, true, .pressed): "26951:46990"
        }
    }

    public var body: some View {
        let iconSize = TUISocialButtonMetrics.iconSize(for: typeSize)
        let diameter = TUISocialButtonMetrics.diameter(for: typeSize)
        Button {
            isSelected.toggle()
            action()
        } label: {
            ZStack {
                Image(isSelected ? "tui-button-like-filled" : "tui-button-like-outline", bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(isSelected ? TUIColor.negative : appearance.outlineColor)
                    .id(isSelected)
                    .transition(.opacity)
            }
            .frame(width: diameter, height: diameter)
            .contentShape(Circle())
            .animation(reduceMotion ? nil
                : TUIMotionCurve.productiveStandard.animation(duration: .fastest), value: isSelected)
        }
        .buttonStyle(TUISocialIconButtonStyle(appearance: appearance, state: state, fadesStates: true))
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("tuiButtonLike-\(figmaNodeID)")
    }
}
