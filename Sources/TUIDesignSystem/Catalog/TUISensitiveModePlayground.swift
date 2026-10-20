import SwiftUI

public struct TUISensitiveModePlayground: View {
    @State private var fontSize = TUISensitiveFontSize.bodyLarge
    @State private var hidden = true
    @State private var width = 170.0
    @State private var colorToken = "Text/Primary"
    @State private var buttonPresses = 0
    @State private var linkPresses = 0
    private let sum = "1 000 ₽"

    public init() {}

    public var body: some View {
        Group {
            TUISensitiveMode(fontSize: fontSize, color: TUIColor.named(colorToken), width: width)
                .accessibilityIdentifier("sensitiveSourceMask")
            LabeledContent("Figma node", value: fontSize.figmaNodeID).font(.caption)
                .accessibilityIdentifier("sensitiveSelectedNode")
            Picker("Font Size", selection: $fontSize) {
                ForEach(TUISensitiveFontSize.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }.pickerStyle(.menu).accessibilityIdentifier("sensitiveFontSizePicker")
            Picker("Цвет скрытого текста", selection: $colorToken) {
                ForEach(["Text/Primary", "Text/Secondary", "Text/Action", "Text/Positive"], id: \.self) {
                    Text($0).tag($0)
                }
            }.pickerStyle(.menu)
            Slider(value: $width, in: 40...260, step: 1)
            LabeledContent("Ширина маски", value: "\(Int(width)) pt")
            Toggle("Скрывать сумму", isOn: $hidden)
                .toggleStyle(.switch).accessibilityIdentifier("sensitiveHiddenToggle")
            TUIButton("Оплатить \(sum)", sensitiveText: hidden ? sum : nil) { buttonPresses += 1 }
                .accessibilityIdentifier("sensitiveDemoButton")
            Text("Нажатий: \(buttonPresses)").accessibilityIdentifier("sensitiveButtonCount")
            TUISensitiveText(linkText)
                .tuiTypography(.bodyLarge)
                .environment(\.openURL, OpenURLAction { _ in linkPresses += 1; return .handled })
                .accessibilityIdentifier("sensitiveDemoLink")
            Text("Переходов: \(linkPresses)").accessibilityIdentifier("sensitiveLinkCount")
            Text("Текст не меняет размеры при скрытии. Маскирование всей поверхности:")
                .font(.caption).foregroundStyle(.secondary)
            Button("Sensitive text") { buttonPresses += 1 }
                .buttonStyle(.plain)
                .tuiTypography(.uiSmall)
                .padding(TUISpacing.x2)
                .background(TUIColor.action, in: Capsule())
                .tuiSensitive(isHidden: hidden, color: TUIColor.action, cornerRadius: TUIRadius.round)
                .accessibilityIdentifier("sensitiveWholeComponent")
        }
        .onChange(of: fontSize) { _, value in width = value.sourceSize.width }
    }

    private var linkText: Text {
        var prefix = AttributedString("Потратили ")
        var value = AttributedString(sum)
        let url = URL(string: "https://www.figma.com/design/qT8MjPknoT5knKCjHxwG7e/tui-sensitive?node-id=1-8621")!
        prefix.link = url
        value.link = url
        return Text("\(Text(prefix).foregroundStyle(TUIColor.action))\(Text(value).tuiSensitive(isHidden: hidden, color: TUIColor.action))")
    }
}
