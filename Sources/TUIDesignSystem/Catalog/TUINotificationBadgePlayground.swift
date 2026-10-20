import SwiftUI

struct TUINotificationBadgePlayground: View {
    @State private var size: TUINotificationBadgeSize = .medium
    @State private var text = "1"
    @State private var actualCount = "1"
    @State private var typeSize = DynamicTypeSize.large
    @State private var theme = TUITheme.day
    @State private var presses = 0

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            VStack(spacing: TUISpacing.x4) {
                TUINotificationBadge(text, size: size)
                Button {
                    presses += 1
                } label: {
                    HStack(spacing: TUISpacing.x2) {
                        Text("Уведомления")
                        TUINotificationBadge(text, size: size)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Уведомления")
                    .accessibilityValue(size == .small ? "" : "Обновлений: \(actualCount)")
                    .accessibilityIdentifier("notificationBadgeParent")
                }
                .buttonStyle(.bordered)
            }
            .environment(\.dynamicTypeSize, typeSize)
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(TUIColor.backgroundPrimary, in: RoundedRectangle(cornerRadius: TUIRadius.large))
            .environment(\.colorScheme, theme == .day ? .light : .dark)

            Text("Открытий: \(presses)").accessibilityIdentifier("notificationBadgePresses")
            Picker("Размер", selection: $size) {
                ForEach(TUINotificationBadgeSize.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .accessibilityIdentifier("notificationBadgeSize")
            TextField("Текст бейджа", text: $text)
                .accessibilityIdentifier("notificationBadgeText")
            TextField("Фактическое число обновлений", text: $actualCount)
                .keyboardType(.numberPad)
                .accessibilityIdentifier("notificationBadgeActualCount")
            Picker("Размер текста", selection: $typeSize) {
                Text("Стандартный").tag(DynamicTypeSize.large)
                Text("AX1").tag(DynamicTypeSize.accessibility1)
                Text("AX5 → ограничение AX1").tag(DynamicTypeSize.accessibility5)
            }
            .accessibilityIdentifier("notificationBadgeDynamicType")
            Picker("Тема", selection: $theme) {
                ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            LabeledContent("Figma node", value: size.figmaNodeID)
            Text("Бейдж не получает отдельный фокус. Родитель объявляет фактическое число обновлений, даже если на бейдже показано 99+; точка small по умолчанию не объявляется.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
