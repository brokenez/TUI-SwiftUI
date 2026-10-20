import SwiftUI

public enum TUISystemRadioButtonState: String, CaseIterable, Sendable {
    case normal
    case selected
    case selectedDisabled = "selected-disabled"
    case disabled

    var figmaNodeID: String {
        switch self {
        case .selected: "12092:40318"
        case .selectedDisabled: "12092:40322"
        case .normal: "12092:40325"
        case .disabled: "12092:40328"
        }
    }

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
    public let accessibilityManagedByParent: Bool

    public init(state: Binding<TUISystemRadioButtonState>, accessibilityManagedByParent: Bool = true) {
        self._state = state
        self.accessibilityManagedByParent = accessibilityManagedByParent
    }

    public var body: some View {
        Group {
            if accessibilityManagedByParent {
                control.accessibilityHidden(true)
            } else {
                control
                    .accessibilityLabel("Radio button")
                    .accessibilityValue(state.rawValue)
            }
        }
    }

    private var control: some View {
        Button {
            state = .selected
        } label: {
            TUISelectionGlyph(state: state.checkboxState)
                .frame(width: TUIControlSize.medium, height: TUIControlSize.medium)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(state == .selectedDisabled || state == .disabled)
    }
}
