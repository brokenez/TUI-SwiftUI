#if DEBUG
import SwiftUI
import TUIDesignSystem

/// Runs the public Button in a real scene; no copied implementation.
struct ButtonInteractionProbe: View {
    @State private var state: TUIButtonState
    @State private var taps = 0
    private let size: TUIButtonSize
    private let skeleton: Bool
    private let iconOnly: Bool
    private let loadOnTap: Bool
    private let night: Bool
    private let customized: Bool

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        func value(_ key: String) -> String? {
            guard let index = arguments.firstIndex(of: key), index + 1 < arguments.count else { return nil }
            return arguments[index + 1]
        }
        _state = State(initialValue: TUIButtonState(rawValue: value("--state") ?? "normal") ?? .normal)
        size = TUIButtonSize(rawValue: value("--size") ?? "large") ?? .large
        skeleton = arguments.contains("--skeleton")
        iconOnly = arguments.contains("--icon-only")
        loadOnTap = arguments.contains("--load-on-tap")
        night = value("--theme") == "night"
        customized = arguments.contains("--customized")
    }

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            Spacer()
            TUIButton(iconOnly ? "Добавить документ" : "Отправить документ", size: size,
                      state: state, skeleton: skeleton, showsIcon: iconOnly || customized, showsLabel: !iconOnly,
                      icon: customized ? Image("tui-link-arrow-right-circle", bundle: TUIResources.bundle) : nil,
                      smallIcon: customized ? Image("tui-button-close-cross", bundle: TUIResources.bundle) : nil,
                      backgroundColor: customized ? TUIColor.named("Background/Neutral 1 Opaque") : nil,
                      textColor: customized ? TUIColor.named("Text/Action") : nil,
                      iconColor: customized ? TUIColor.named("Status/Positive") : nil,
                      cornerRadius: customized ? TUIRadius.round : nil,
                      width: customized ? 240 : nil) {
                taps += 1
                if loadOnTap { state = .loading }
            }
            .accessibilityIdentifier("buttonProbeComponent")
            Spacer()
            Text(String(taps)).accessibilityIdentifier("buttonProbeTapCount")
            Text(state.rawValue).accessibilityIdentifier("buttonProbeState")
            Button("Завершить загрузку") { state = .normal }
                .accessibilityIdentifier("buttonProbeFinishLoading")
        }
        .padding(TUISpacing.x4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(night ? Color.black : Color.white)
        .environment(\.colorScheme, night ? .dark : .light)
        .navigationTitle("Button QA")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#endif
