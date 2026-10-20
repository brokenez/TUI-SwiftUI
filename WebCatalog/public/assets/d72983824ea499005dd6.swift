import SwiftUI

/// TUI's custom search input, styled to match the iOS design without replacing the system search API.
public struct TUISearchInput: View {
    public enum State: String, CaseIterable, Sendable {
        case normal
        case focus
        case disabled
        case pressed
    }

    @Binding private var text: String
    public let state: State
    public let placeholder: String
    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        state: State = .normal,
        placeholder: String = "Поиск"
    ) {
        _text = text
        self.state = state
        self.placeholder = placeholder
    }

    private var isDisabled: Bool { state == .disabled }
    private var isFilled: Bool { !text.isEmpty }

    public var body: some View {
        HStack(spacing: state == .focus ? 3 : 0) {
            Image("tui-search-input-search", bundle: .module)
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(TUIColor.named("Text/Secondary"))

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .tuiTypography(.bodyLarge)
                        .foregroundStyle(TUIColor.named("Text/Secondary"))
                        .accessibilityHidden(true)
                }
                TextField("", text: $text)
                    .tuiTypography(.bodyLarge)
                    .foregroundStyle(text.isEmpty ? Color.clear : TUIColor.named("Text/Primary"))
                    .tint(TUIColor.named("Background/Accent 2"))
                    .focused($isFocused)
                    .disabled(isDisabled || state == .pressed)
                    .accessibilityLabel(placeholder)
            }
            .padding(.leading, 3)

            if isFilled && !isDisabled {
                Button {
                    text = ""
                } label: {
                    Image("tui-search-input-clear", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(TUIColor.named("Text/Secondary"))
                        .frame(width: 32, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Очистить поиск")
            } else if state == .normal || state == .pressed || isDisabled {
                Color.clear.frame(width: 8)
            }
        }
        .padding(.leading, 4)
        .padding(.trailing, isFilled && !isDisabled ? 0 : 8)
        .frame(height: 36)
        .background(
            TUIColor.named(state == .pressed ? "State/Background/Neutral 2 Pressed" : "Background/Neutral 2"),
            in: RoundedRectangle(cornerRadius: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .opacity(isDisabled ? 0.5 : 1)
        .onAppear { isFocused = state == .focus }
        .onChange(of: state) { _, newState in isFocused = newState == .focus }
    }
}
