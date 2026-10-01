import SwiftUI

public enum TUISystemCheckboxState: String, CaseIterable, Sendable {
    case normal
    case selected
    case indeterminate
    case selectedDisabled = "selected-disabled"
    case disabled
}

/// Interactive iOS rendition of the 22 pt `system-checkbox` component.
public struct TUISystemCheckbox: View {
    @Binding public var state: TUISystemCheckboxState

    public init(state: Binding<TUISystemCheckboxState>) {
        self._state = state
    }

    public var body: some View {
        Button {
            switch state {
            case .normal: state = .selected
            case .selected, .indeterminate: state = .normal
            case .selectedDisabled, .disabled: break
            }
        } label: {
            TUISelectionGlyph(state: state)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(state == .selectedDisabled || state == .disabled)
        .accessibilityLabel("Checkbox")
        .accessibilityValue(state.rawValue)
    }

}

struct TUISelectionGlyph: View {
    let state: TUISystemCheckboxState

    var body: some View {
        ZStack {
            Circle()
                .fill(background)
            if state == .normal || state == .disabled {
                Circle()
                    .strokeBorder(Color(red: 0, green: 16 / 255, blue: 36 / 255).opacity(state == .normal ? 0.22 : 0.06), lineWidth: 1)
            }
            if state == .selected || state == .selectedDisabled {
                Image("tui-checkbox-check", bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 16, height: 16)
            } else if state == .indeterminate {
                Capsule()
                    .fill(.white)
                    .frame(width: 12, height: 2.3)
            }
        }
        .frame(width: 22, height: 22)
    }

    private var background: Color {
        switch state {
        case .selected, .indeterminate: Color(red: 66 / 255, green: 139 / 255, blue: 249 / 255)
        case .selectedDisabled: Color(red: 0, green: 16 / 255, blue: 36 / 255).opacity(0.12)
        case .normal, .disabled: .clear
        }
    }
}
