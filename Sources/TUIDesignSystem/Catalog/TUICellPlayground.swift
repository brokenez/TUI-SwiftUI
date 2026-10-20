import SwiftUI

struct TUICellPlayground: View {
    @State private var variant = TUICell.Variant.defaultAccessory
    @State private var title = "Title"
    @State private var description = "Description"
    @State private var caption = "Caption"
    @State private var value = "Value"
    @State private var valueDescription = "Description"
    @State private var showsAvatar = true
    @State private var showsDescription = true
    @State private var showsCaption = false
    @State private var showsBadge = true
    @State private var showsHint = true
    @State private var hintCount = 0
    @State private var enlarged = false
    @State private var reflowsText = true
    @State private var reflowsAccessory = false
    @State private var removesLineLimits = true
    @State private var twoTitleLines = false
    @State private var showsInlineBadge = false
    @State private var textPriority = TUICell.TextPriority.right
    @State private var minimumTextFraction = 0.3

    private var cell: TUICell {
        var result = TUICell(title, description: description, caption: caption, value: value, valueDescription: valueDescription,
            variant: variant, showsAvatar: showsAvatar, showsCaption: showsCaption,
            showsDescription: showsDescription, showsBadge: showsBadge, showsHint: showsHint,
            hintAction: { hintCount += 1 }, isSkeletonAnimating: false)
        result.reflowsTextAtAX1 = reflowsText
        result.reflowsAccessoryAtAX1 = reflowsAccessory
        result.removesLineLimitsAtAX1 = removesLineLimits
        result.textPriority = textPriority
        result = result.minimumTextWidthFraction(minimumTextFraction)
        if twoTitleLines { result = result.textStyle(.init(overflow: .multilineFade(lineLimit: 2)), for: .title) }
        if showsInlineBadge {
            result = result.inlineContent(.title, placement: .trailing) {
                TUINotificationBadge("2", size: .small)
                    .accessibilityElement(children: .ignore).accessibilityHidden(false)
                    .accessibilityLabel("Дополнительный бейдж: 2")
            }
        }
        return result
    }

    var body: some View {
        // Keep native controls in separate Form rows. A single VStack lets the
        // automatic Picker row action intercept taps on neighboring controls.
        Group {
            Picker("Вариант Cell", selection: $variant) {
                ForEach(TUICell.Variant.allCases, id: \.self) {
                    Text("\($0.kind.rawValue) · \($0.rightSide.rawValue) · \($0.fixedHeight ? "fixed" : "flexible")\($0.isSkeleton ? " · skeleton" : "")").tag($0)
                }
            }
            .pickerStyle(.menu)
            .accessibilityIdentifier("cellVariantPicker")
            cell
                .environment(\.dynamicTypeSize, enlarged ? .accessibility1 : .large)
            Text("Нажатий на подсказку: \(hintCount)").accessibilityIdentifier("cellHintCount")
            Toggle("Аватар", isOn: $showsAvatar)
            Toggle("Описание", isOn: $showsDescription)
            Toggle("Caption", isOn: $showsCaption)
            Toggle("Бейдж", isOn: $showsBadge)
            Toggle("Подсказка", isOn: $showsHint)
            Toggle("Увеличенный текст", isOn: $enlarged)
                .accessibilityIdentifier("cellEnlarged")
            Toggle("Перенос Value при AX1", isOn: $reflowsText)
            Toggle("Перенос Accessory при AX1", isOn: $reflowsAccessory)
            Toggle("Снимать лимиты строк при AX1", isOn: $removesLineLimits)
            Toggle("Title: максимум две строки", isOn: $twoTitleLines)
            Toggle("Бейдж рядом с Title", isOn: $showsInlineBadge)
                .accessibilityIdentifier("cellInlineToggle")
            TextField("Title", text: $title)
            TextField("Description", text: $description)
            TextField("Caption", text: $caption)
            TextField("Value", text: $value)
            TextField("Value Description", text: $valueDescription)
            Picker("Приоритет текста", selection: $textPriority) {
                Text("Правый").tag(TUICell.TextPriority.right)
                Text("Левый").tag(TUICell.TextPriority.left)
            }.pickerStyle(.menu)
            VStack(alignment: .leading) {
                Text("Минимальная ширина скрываемой части: \(Int((minimumTextFraction * 100).rounded()))%")
                Slider(value: $minimumTextFraction, in: 0...1, step: 0.05)
            }
            Text("Figma: \(variant.figmaNodeID)").font(.caption.monospaced())
            Text("InlineContent работает во всех вариантах. При AX1 Value переносится под основной текст; Accessory переносится опционально. Нажатие всей ячейки и полная приёмка ещё не завершены.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }
}
