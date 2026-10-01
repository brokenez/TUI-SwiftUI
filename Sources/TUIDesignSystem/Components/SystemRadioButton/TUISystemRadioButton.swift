import SwiftUI

public enum TUISystemRadioButtonState: String, CaseIterable, Sendable {
    case normal
    case selected
    case selectedDisabled = "selected-disabled"
    case disabled

    var checkboxState: TUISystemCheckboxState {
        switch self {
        case .normal: .normal
        case .selected: .selected
        case .selectedDisabled: .selectedDisabled
        case .disabled: .disabled
        }
    }
}

/// iOS radio control; Figma specifies the same 22 pt glyph as `system-checkbox`.
public struct TUISystemRadioButton: View {
    @Binding public var state: TUISystemRadioButtonState

    public init(state: Binding<TUISystemRadioButtonState>) {
        self._state = state
    }

    public var body: some View {
        Button {
            state = .selected
        } label: {
            TUISelectionGlyph(state: state.checkboxState)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(state == .selectedDisabled || state == .disabled)
        .accessibilityLabel("Radio button")
        .accessibilityValue(state.rawValue)
    }
}
