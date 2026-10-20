import SwiftUI
import TUIDesignSystem

/// Uses the public package only. Data, routes and state belong to this app.
struct HeaderCardConsumerScreen: View {
    @State private var variant: TUIHeaderCard.Variant
    @State private var selected = false
    @State private var enabled = true
    @State private var night = false
    @State private var slots = false
    @State private var presses = 0
    @State private var hints = 0
    @State private var slotPresses = 0
    @State private var links: [String] = []
    @State private var showsDetails = false
    @State private var snapshot = "[]"
    @State private var actionResult = ""

    init() {
        let argument = ProcessInfo.processInfo.arguments.first { $0.hasPrefix("--header-card-variant=") }
        _variant = State(initialValue: argument.flatMap {
            TUIHeaderCard.Variant(rawValue: String($0.dropFirst("--header-card-variant=".count)))
        } ?? .avatar)
    }

    private func linked(_ text: String, word: String, target: String) -> AttributedString {
        var value = AttributedString(text)
        if let range = value.range(of: word) { value[range].link = URL(string: "tui-consumer://header-card/" + target) }
        return value
    }

    private var header: TUIHeaderCard {
        var value = TUIHeaderCard(
            title: linked("Настройки уведомлений", word: "уведомлений", target: "title"),
            subheader: linked("Получать новости", word: "новости", target: "subheader"),
            description: linked("Подробнее об условиях сервиса", word: "Подробнее", target: "description"),
            caption: "Подписка", variant: variant, showsDescription: true,
            badgeCount: 124, badgeAccessibilityValue: "124 уведомления",
            actionTitle: "Открыть условия", accessoryAction: { presses += 1; showsDetails = true },
            isOn: $selected, isEnabled: enabled, isSkeletonAnimating: false)
            .hint("Подробнее об уведомлениях") { hints += 1; showsDetails = true }
        if slots {
            value = value.subheaderLeading { Text("До") }
                .subheaderTrailing { Button("Условия") { slotPresses += 1 } }
        }
        return value
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                header.frame(width: 375).background(TUIColor.backgroundPrimary)
                    .environment(\.colorScheme, night ? .dark : .light)
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier("consumerHeaderCard")
                VStack(alignment: .leading, spacing: TUISpacing.x2) {
                    Text("Кнопка: \(presses)").accessibilityIdentifier("consumerHeaderCardPresses")
                    Text("Подсказки: \(hints)").accessibilityIdentifier("consumerHeaderCardHints")
                    Text("Слот: \(slotPresses)").accessibilityIdentifier("consumerHeaderCardSlot")
                    Text("Переключатель: \(selected ? "включён" : "выключен")")
                        .accessibilityIdentifier("consumerHeaderCardState")
                    Text("Ссылок: \(links.count)").accessibilityIdentifier("consumerHeaderCardLinks")
                    Text(links.joined(separator: ", ")).accessibilityIdentifier("consumerHeaderCardTargets")
                    Text("Figma: \(variant.figmaNodeID)").accessibilityIdentifier("consumerHeaderCardNode")
                    Picker("Вариант Figma", selection: $variant) {
                        ForEach(TUIHeaderCard.Variant.allCases, id: \.self) { Text($0.figmaNodeID).tag($0) }
                    }.accessibilityIdentifier("consumerHeaderCardVariant")
                    Toggle("Действия доступны", isOn: $enabled).accessibilityIdentifier("consumerHeaderCardEnabled")
                    Toggle("Ночная тема", isOn: $night).accessibilityIdentifier("consumerHeaderCardNight")
                    Toggle("Слоты подзаголовка", isOn: $slots).accessibilityIdentifier("consumerHeaderCardSlots")
                    if ProcessInfo.processInfo.arguments.contains("--header-card-ax-probe") {
                        Button("Снять AX-снимок") { snapshot = HeaderAccessibilityProbe.snapshot() }
                            .accessibilityIdentifier("consumerHeaderCardAXSnapshot")
                        Text(snapshot).font(.caption).lineLimit(1)
                            .accessibilityIdentifier("consumerHeaderCardAXPayload")
                        ForEach(["уведомлений", "новости", "Подробнее", "Подробнее об уведомлениях"], id: \.self) { label in
                            Button("AX: " + label) {
                                let actionName = label == "Подробнее об уведомлениях" ? label : "Открыть ссылку: " + label
                                actionResult = HeaderAccessibilityProbe.performLinkAction(label: actionName)
                                    ? "AX action: success" : "AX action: unavailable"
                            }.accessibilityIdentifier("consumerHeaderCardAX-" + label)
                        }
                        Text(actionResult).accessibilityIdentifier("consumerHeaderCardAXResult")
                    }
                }.padding(.horizontal, TUISpacing.x5)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .environment(\.openURL, OpenURLAction { url in links.append(url.absoluteString); return .handled })
        .navigationTitle("Header Card из пакета")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showsDetails) {
            NavigationStack {
                Text("Действие Header Card обработано приложением")
                    .padding(TUISpacing.x5)
                    .navigationTitle("Условия")
                    .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Готово") { showsDetails = false } } }
            }
        }
    }
}
