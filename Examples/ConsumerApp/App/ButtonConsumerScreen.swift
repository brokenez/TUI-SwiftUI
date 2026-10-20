import SwiftUI
import TUIDesignSystem

/// Public package API and original package resources; no component copies.
struct ButtonConsumerScreen: View {
    @State private var size = TUIButtonSize.large
    @State private var state = TUIButtonState.normal
    @State private var taps = 0

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            Picker("Размер", selection: $size) {
                ForEach(TUIButtonSize.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .pickerStyle(.segmented)
            .accessibilityIdentifier("consumerButtonSize")
            Spacer()
            TUIButton("Отправить документ", size: size, state: state, showsIcon: true,
                icon: Image("tui-link-arrow-right-circle", bundle: TUIResources.bundle),
                smallIcon: Image("tui-button-close-cross", bundle: TUIResources.bundle),
                backgroundColor: TUIColor.named("Background/Neutral 1 Opaque"),
                textColor: TUIColor.named("Text/Action"),
                iconColor: TUIColor.named("Status/Positive"),
                cornerRadius: TUIRadius.round, width: 280) {
                taps += 1
                state = .loading
            }
            .accessibilityIdentifier("consumerButtonComponent")
            Spacer()
            LabeledContent("Нажатий") {
                Text(String(taps)).accessibilityIdentifier("consumerButtonTapCount")
            }
            Button("Завершить загрузку") { state = .normal }
                .accessibilityIdentifier("consumerButtonFinishLoading")
            Text("Иконки из ресурсов пакета; состояние и действие принадлежат приложению.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(TUISpacing.x4)
        .navigationTitle("Button из пакета")
        .navigationBarTitleDisplayMode(.inline)
    }
}
