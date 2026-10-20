import SwiftUI
import TUIDesignSystem

/// Only public package APIs; native links remain owned by the consumer.
struct SensitiveModeConsumerScreen: View {
    @State private var hidden = true
    @State private var buttonPresses = 0
    @State private var linkPresses = 0
    @State private var size = TUIButtonSize.large

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            Toggle("Скрывать сумму", isOn: $hidden)
                .accessibilityIdentifier("consumerSensitiveToggle")
            Picker("Размер кнопки", selection: $size) {
                ForEach(TUIButtonSize.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented).accessibilityIdentifier("consumerSensitiveSize")
            TUIButton("Оплатить 1 000 ₽", size: size, width: 280,
                      sensitiveText: hidden ? "1 000 ₽" : nil) { buttonPresses += 1 }
                .accessibilityIdentifier("consumerSensitiveButton")
            Text(String(buttonPresses)).accessibilityIdentifier("consumerSensitiveButtonCount")
            TUISensitiveText(linkText).tuiTypography(.bodyLarge)
                .environment(\.openURL, OpenURLAction { _ in linkPresses += 1; return .handled })
                .accessibilityIdentifier("consumerSensitiveLink")
            Text(String(linkPresses)).accessibilityIdentifier("consumerSensitiveLinkCount")
            Button("Баланс 120 500 ₽") { buttonPresses += 1 }
                .tuiTypography(.bodyLarge).padding(TUISpacing.x3)
                .background(TUIColor.action, in: RoundedRectangle(cornerRadius: TUIRadius.medium))
                .tuiSensitive(isHidden: hidden, color: TUIColor.action, cornerRadius: TUIRadius.medium)
                .accessibilityIdentifier("consumerSensitiveWholeComponent")
            Spacer()
        }.padding(TUISpacing.x4)
            .navigationTitle("Sensitive Mode из пакета")
            .navigationBarTitleDisplayMode(.inline)
    }

    private var linkText: Text {
        var prefix = AttributedString("Потратили ")
        var amount = AttributedString("1 000 ₽")
        let url = URL(string: "https://www.figma.com/design/qT8MjPknoT5knKCjHxwG7e/tui-sensitive?node-id=1-8621")!
        prefix.link = url; amount.link = url
        return Text("\(Text(prefix).foregroundStyle(TUIColor.action))\(Text(amount).tuiSensitive(isHidden: hidden, color: TUIColor.action))")
    }
}
