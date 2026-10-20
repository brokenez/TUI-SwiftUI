import SwiftUI

struct TUIHeaderCardPlayground: View {
    @State private var variant = TUIHeaderCard.Variant.avatar
    @State private var title = "Header"
    @State private var subheader = "Subheader"
    @State private var caption = "Caption"
    @State private var showsSubheader = true
    @State private var showsDescription = false
    @State private var showsCaption = true
    @State private var showsBadge = false
    @State private var showsHint = false
    @State private var switchOn = false
    @State private var actionCount = 0
    @State private var hintCount = 0
    @State private var enlarged = false
    @State private var reflows = false
    @State private var animates = true
    @State private var theme = TUITheme.day
    @State private var overflow = TUIHeaderCard.TextOverflow.multiline

    private var header: TUIHeaderCard {
        var result = TUIHeaderCard(title, subheader: subheader, caption: caption, variant: variant,
                                  showsSubheader: showsSubheader, showsDescription: showsDescription,
                                  showsCaption: showsCaption, badgeCount: showsBadge ? 124 : nil,
                                  badgeAccessibilityValue: showsBadge ? "124 уведомления" : nil,
                                  actionTitle: "Label", accessoryAction: { actionCount += 1 },
                                  isOn: $switchOn, isSkeletonAnimating: animates)
            .textStyles(title: .init(overflow: overflow), subheader: .init(overflow: overflow))
        result.reflowsAccessoryAtAX1 = reflows
        if showsHint { result = result.hint("Подробнее о разделе") { hintCount += 1 } }
        return result
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            header.frame(width: 375).background(TUIColor.backgroundPrimary)
                .environment(\.colorScheme, theme == .day ? .light : .dark)
                .environment(\.dynamicTypeSize, enlarged ? .accessibility1 : .large)
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("headerCardPreview")
                // Keep the preview clear of the native List row's rounded clip.
                .padding(.top, TUISpacing.x10)
            Text("Кнопка: \(actionCount)").accessibilityIdentifier("headerCardActionCount")
            Text("Подсказка: \(hintCount)").accessibilityIdentifier("headerCardHintCount")
            Text("Переключатель: \(switchOn ? "включён" : "выключен")")
                .accessibilityIdentifier("headerCardSwitchState")
            Text("Перенос ещё проверяется: caption использует системный Medium; отдельная визуальная приёмка и спецификация вложенных кнопок остаются открытыми.")
                .font(.footnote).foregroundStyle(.secondary)
            VStack(spacing: TUISpacing.x3) {
                Picker("Вариант Figma", selection: $variant) {
                    ForEach(TUIHeaderCard.Variant.allCases, id: \.self) {
                        Text("\($0.accessoryName) · \($0.isExtended ? "Extended" : "Standard")\($0.isSkeleton ? " · Skeleton" : "")")
                            .tag($0)
                    }
                }
                .accessibilityIdentifier("headerCardVariantPicker")
                TextField("Заголовок", text: $title)
                TextField("Подзаголовок", text: $subheader)
                TextField("Caption", text: $caption)
                Toggle("Подзаголовок", isOn: $showsSubheader)
                Toggle("Описание", isOn: $showsDescription)
                Toggle("Caption", isOn: $showsCaption)
                Toggle("Badge · 124 уведомления", isOn: $showsBadge)
                Toggle("Подсказка", isOn: $showsHint)
                Toggle("AX1", isOn: $enlarged)
                Toggle("Accessory под текстом на AX1", isOn: $reflows)
                Toggle("Анимация Skeleton", isOn: $animates)
                Picker("Переполнение текста", selection: $overflow) {
                    Text("Несколько строк").tag(TUIHeaderCard.TextOverflow.multiline)
                    Text("Одна строка с fade").tag(TUIHeaderCard.TextOverflow.singleLineFade)
                    Text("Две строки с fade").tag(TUIHeaderCard.TextOverflow.multilineFade(lineLimit: 2))
                }
                Picker("Тема", selection: $theme) {
                    ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented)
                Text("Figma: \(variant.figmaNodeID)").font(.caption.monospaced())
            }.padding(.horizontal, TUISpacing.x4)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
