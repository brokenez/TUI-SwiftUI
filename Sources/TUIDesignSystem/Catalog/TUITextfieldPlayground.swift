import SwiftUI

struct TUITextfieldPlayground: View {
    @State private var text = "Value"
    @State private var state = TUITextfieldState.normal
    @State private var showsLabel = true
    @State private var skeleton = false
    @State private var showsClear = true
    @State private var loading = false
    @State private var alwaysHint = false
    @State private var limited = false
    @State private var showsHint = true
    @State private var submitCount = 0
    @State private var sourceID = "65702:51290"
    @State private var sourceMode = false
    @State private var dark = false
    @State private var customActions = false
    @State private var tapOnly = false
    @State private var startCount = 0
    @State private var endCount = 0
    @State private var hintCount = 0
    @State private var tapCount = 0
    @State private var validationTrigger = 0
    @State private var textAlignment = TUITextfield.TextAlignment.leading
    @State private var trailingAccessoryInset = true

    private var field: TUITextfield {
        TUITextfield(text: $text, state: $state, label: showsLabel ? "Label" : nil,
            placeholder: showsLabel || state.isFocused ? "Placeholder" : "Label", isSkeleton: skeleton,
            isSkeletonAnimating: !sourceMode,
            showsClearButton: showsClear, isLoading: loading,
            startContent: customActions ? AnyView(Button("Слева") { startCount += 1 }
                .buttonStyle(.plain).accessibilityIdentifier("textfieldStartAction")) : nil,
            endContent: customActions ? AnyView(Button("Справа") { endCount += 1 }
                .buttonStyle(.plain).accessibilityIdentifier("textfieldEndAction")) : nil,
            hint: customActions ? AnyView(Button("Ссылка") { hintCount += 1 }
                .buttonStyle(.plain).accessibilityIdentifier("textfieldHintAction"))
                : !sourceMode && showsHint ? AnyView(Text("Hint text").font(.init(TUIFigmaTextFont.regular(size: 15)))
                .kerning(TUITypographyRole.bodyMedium.metrics.letterSpacing)) : nil,
            errorHint: sourceMode ? nil : AnyView(Text("Проверьте значение").font(.init(TUIFigmaTextFont.regular(size: 15)))
                .kerning(TUITypographyRole.bodyMedium.metrics.letterSpacing).foregroundStyle(TUIColor.negative)),
            errorText: sourceMode && state == .invalidFocus ? "Error" : nil,
            hintVisibility: alwaysHint || customActions ? .always : .focused, characterLimit: limited ? 5 : nil,
            validationTrigger: validationTrigger,
            returnKeyType: .done, textAlignment: textAlignment, trailingAccessoryInset: trailingAccessoryInset,
            onSubmit: { submitCount += 1; state = .normal },
            action: tapOnly ? { tapCount += 1 } : nil)
    }

    var body: some View {
        Group {
            field
                .padding(.horizontal, sourceMode ? TUISpacing.x4 : 0)
                .frame(width: sourceMode ? 320 : nil)
                .background(dark ? Color.black : Color.white)
                .environment(\.colorScheme, dark ? .dark : .light)
                .accessibilityElement(children: .contain).accessibilityIdentifier("textfieldPreview")
            Text("Состояние: \(state.rawValue) · значение: \(text) · отправок: \(submitCount)")
                .font(.caption).accessibilityIdentifier("textfieldStateValue")
            if customActions || tapOnly {
                Text("Слева: \(startCount) · справа: \(endCount) · ссылка: \(hintCount) · поле: \(tapCount)")
                    .font(.caption).accessibilityIdentifier("textfieldActionCounts")
            }
            Text("Figma: \(field.figmaNodeID ?? "нет отдельного исходного варианта")")
                .font(.caption.monospaced()).accessibilityIdentifier("textfieldSourceID")
            HStack {
                Button("Готово") { state = state.isInvalid ? .invalid : .normal }
                    .accessibilityIdentifier("textfieldDone")
                Button("Ошибка") {
                    state = state.isFocused ? .invalidFocus : .invalid
                    validationTrigger += 1
                }
                    .accessibilityIdentifier("textfieldInvalidate")
                Button("Заполнить") { text = "Value" }
                    .accessibilityIdentifier("textfieldFill")
            }.buttonStyle(.borderless)
            HStack {
                Button("Действия слотов") { customActions.toggle(); state = .normal; sourceMode = false }
                    .accessibilityIdentifier("textfieldCustomActions")
                Button("Только нажатие") { tapOnly.toggle(); state = .normal; sourceMode = false }
                    .accessibilityIdentifier("textfieldTapOnly")
            }.buttonStyle(.borderless)
            NavigationLink("Форма: фокус и клавиатура") { TUITextfieldFormPlayground() }
                .accessibilityIdentifier("textfieldFormDemo")
            HStack {
                Button("В начало") {
                    if let id = TUILibraryCatalog.shared.variants(for: TUITextfield.figmaComponentSetID).first?.id {
                        sourceID = id; apply(id)
                    }
                }.accessibilityIdentifier("textfieldFirstVariant")
                Button("Далее") {
                    let variants = TUILibraryCatalog.shared.variants(for: TUITextfield.figmaComponentSetID)
                    let current = variants.firstIndex { $0.id == sourceID } ?? 0
                    sourceID = variants[(current + 1) % variants.count].id; apply(sourceID)
                }.accessibilityIdentifier("textfieldNextVariant")
                Button(dark ? "Night" : "Day") { dark.toggle() }
                    .accessibilityIdentifier("textfieldTheme")
            }.buttonStyle(.borderless)
            Picker("Состояние", selection: $state) {
                ForEach(TUITextfieldState.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.menu).accessibilityIdentifier("textfieldStatePicker")
            Picker("Вариант Figma", selection: $sourceID) {
                ForEach(TUILibraryCatalog.shared.variants(for: TUITextfield.figmaComponentSetID)) {
                    Text($0.name).tag($0.id)
                }
            }.pickerStyle(.menu).accessibilityIdentifier("textfieldVariantPicker")
                .onChange(of: sourceID) { _, id in apply(id) }
            Toggle("Label", isOn: $showsLabel)
            Toggle("Очистка", isOn: $showsClear)
            Toggle("Loader", isOn: $loading)
            Toggle("Skeleton", isOn: $skeleton).accessibilityIdentifier("textfieldSkeletonToggle")
            Toggle("Подсказка", isOn: $showsHint)
            Toggle("Подсказка всегда", isOn: $alwaysHint)
            Toggle("Лимит 5 символов", isOn: $limited).accessibilityIdentifier("textfieldLimitToggle")
            Picker("Выравнивание текста", selection: $textAlignment) {
                Text("По левому краю").tag(TUITextfield.TextAlignment.leading)
                Text("По центру").tag(TUITextfield.TextAlignment.center)
            }
            .accessibilityIdentifier("textfieldAlignmentPicker")
            .onChange(of: textAlignment) { _, alignment in
                if alignment == .center {
                    sourceMode = false
                    showsLabel = false; showsClear = false; loading = false; customActions = false
                    state = .normal
                }
            }
            Toggle("Правый отступ аксессуара", isOn: $trailingAccessoryInset)
                .accessibilityIdentifier("textfieldAccessoryInsetToggle")
            if textAlignment == .center {
                Text("По спецификации: без label, аксессуаров и очистки. Placeholder скрыт в фокусе.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Toggle("Тёмная тема компонента", isOn: $dark)
            Text("Отправок: \(submitCount)").accessibilityIdentifier("textfieldSubmits")
            Text("Приёмка не завершена: сравнение всех вариантов, fade длинного текста, selection token и временная проверка shake ещё нужны.")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    private func apply(_ id: String) {
        guard let p = TUILibraryCatalog.shared.variants(for: TUITextfield.figmaComponentSetID)
            .first(where: { $0.id == id })?.properties,
            let newState = TUITextfieldState(rawValue: p["state"] ?? "") else { return }
        state = newState; text = p["is-filled"] == "on" ? "Value" : ""
        showsLabel = p["show-label"] == "on"; skeleton = p["skeleton"] == "on"
        sourceMode = true; loading = false; showsClear = true; alwaysHint = false; limited = false
        textAlignment = .leading; trailingAccessoryInset = true
        customActions = false; tapOnly = false
    }
}
