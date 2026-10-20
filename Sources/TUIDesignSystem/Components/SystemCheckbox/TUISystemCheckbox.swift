import SwiftUI

public enum TUISystemCheckboxState: String, CaseIterable, Sendable {
    case normal
    case selected
    case indeterminate
    case selectedDisabled = "selected-disabled"
    case disabled

    var figmaNodeID: String {
        switch self {
        case .selected: "106:482"
        case .indeterminate: "10672:39004"
        case .selectedDisabled: "106:496"
        case .normal: "106:480"
        case .disabled: "10312:104"
        }
    }
}

/// Interactive iOS rendition of the 22 pt `system-checkbox` component.
public struct TUISystemCheckbox: View {
    @Binding public var state: TUISystemCheckboxState
    public let accessibilityManagedByParent: Bool

    public init(state: Binding<TUISystemCheckboxState>, accessibilityManagedByParent: Bool = true) {
        self._state = state
        self.accessibilityManagedByParent = accessibilityManagedByParent
    }

    public var body: some View {
        Group {
            if accessibilityManagedByParent {
                control.accessibilityHidden(true)
            } else {
                control
                    .accessibilityLabel("Checkbox")
                    .accessibilityValue(state.rawValue)
            }
        }
    }

    private var control: some View {
        Button {
            switch state {
            case .normal: state = .selected
            case .selected, .indeterminate: state = .normal
            case .selectedDisabled, .disabled: break
            }
        } label: {
            TUISelectionGlyph(state: state)
                .frame(width: TUIControlSize.medium, height: TUIControlSize.medium)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(state == .selectedDisabled || state == .disabled)
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
                    .strokeBorder(borderColor, lineWidth: 1)
            }
            if state == .selected || state == .selectedDisabled {
                Image("tui-checkbox-check", bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(TUIColor.named("Text/Primary On Dark", fallback: 0xFFFFFF))
                    .frame(width: 16, height: 16)
            } else if state == .indeterminate {
                Capsule()
                    .fill(TUIColor.named("Text/Primary On Dark", fallback: 0xFFFFFF))
                    .frame(width: 12, height: 2.3)
            }
        }
        .frame(width: 22, height: 22)
    }

    private var background: Color {
        switch state {
        case .selected, .indeterminate: TUIColor.named("Background/Accent 2", fallback: 0x428BF9)
        case .selectedDisabled: TUIColor.named("Background/Neutral 3", fallback: 0x0010241F)
        case .normal, .disabled: .clear
        }
    }

    private var borderColor: Color {
        TUIColor.named(state == .normal ? "Background/Neutral 4" : "Background/Neutral 2", fallback: 0x00102438)
    }
}
