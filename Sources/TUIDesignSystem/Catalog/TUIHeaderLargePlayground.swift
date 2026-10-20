import SwiftUI

struct TUIHeaderLargePlayground: View {
    @State private var variant = TUIHeaderLarge.Variant.subheaderLeading
    @State private var title = "Header"
    @State private var subheader = "Subheader"
    @State private var description = "Description"
    @State private var showsSubheader = true
    @State private var showsIcon = false
    @State private var animates = true
    @State private var customAccessory = false
    @State private var accessorySelected = false
    @State private var reflows = false
    @State private var hasLink = false
    @State private var linkOpened = false
    @State private var overflow = TUIHeaderLarge.TextOverflow.multiline
    @State private var accessoryAlignment = TUIHeaderLarge.AccessoryAlignment.firstLineCenter
    @State private var typeSize = DynamicTypeSize.large
    @State private var theme = TUITheme.day
    @State private var inlineSymbol = false
    @State private var slotAlignment = TUIHeaderLarge.AccessoryAlignment.center

    private var heading: TUIHeaderLarge {
        func text(_ value: String) -> AttributedString {
            var result = AttributedString(value)
            if hasLink {
                result.link = URL(string: "https://go.tcsbank.ru/tui-header-specs")
                result.foregroundColor = TUIColor.action
            }
            return result
        }
        let style = TUIHeaderLarge.TextStyle(overflow: overflow)
        let header = TUIHeaderLarge(title: text(title), subheader: text(subheader),
                             description: text(description), variant: variant,
                             showsSubheader: showsSubheader, showsIcon: showsIcon,
                             isSkeletonAnimating: animates)
            .textStyles(title: style, subheader: style, description: style)
            .textSlotAlignments(title: slotAlignment, secondary: slotAlignment)
        return inlineSymbol ? header.titleInlineText(Text("\(Text(text(title))) \(Image("tui-header-large-star", bundle: .module).renderingMode(.template))")) : header
    }

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            Group {
                if customAccessory {
                    heading.accessory(alignment: accessoryAlignment, reflowsAtAX1: reflows) {
                        Toggle("Выбрано", isOn: $accessorySelected)
                            .labelsHidden()
                            .accessibilityLabel("Выбрать раздел")
                    }
                } else { heading }
            }
            .background(TUIColor.backgroundPrimary)
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .environment(\.dynamicTypeSize, typeSize)
            .environment(\.openURL, OpenURLAction { _ in
                linkOpened = true
                return .handled
            })

            VStack(spacing: TUISpacing.x3) {
                Picker("Вариант Figma", selection: $variant) {
                    ForEach(TUIHeaderLarge.Variant.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .accessibilityIdentifier("headerVariantPicker")
                TextField("Заголовок", text: $title)
                TextField("Подзаголовок", text: $subheader)
                TextField("Описание", text: $description)
                Toggle("Подзаголовок", isOn: $showsSubheader)
                Toggle("Иконка справа", isOn: $showsIcon)
                Toggle("Анимация skeleton", isOn: $animates)
                Toggle("Интерактивный accessory", isOn: $customAccessory)
                    .accessibilityIdentifier("headerCustomAccessory")
                Toggle("Accessory под текстом на AX1", isOn: $reflows)
                Toggle("Ссылки в текстовых блоках", isOn: $hasLink)
                    .accessibilityIdentifier("headerTitleLink")
                Toggle("Иконка внутри текста", isOn: $inlineSymbol)
                Picker("Выравнивание слотов текста", selection: $slotAlignment) {
                    ForEach(TUIHeaderLarge.AccessoryAlignment.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                Picker("Выравнивание accessory", selection: $accessoryAlignment) {
                    ForEach(TUIHeaderLarge.AccessoryAlignment.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                Picker("Переполнение текста", selection: $overflow) {
                    Text("Несколько строк").tag(TUIHeaderLarge.TextOverflow.multiline)
                    Text("Одна строка с fade").tag(TUIHeaderLarge.TextOverflow.singleLineFade)
                    Text("Две строки с fade").tag(TUIHeaderLarge.TextOverflow.multilineFade(lineLimit: 2))
                    Text("Три строки с fade").tag(TUIHeaderLarge.TextOverflow.multilineFade(lineLimit: 3))
                }
                Picker("Размер текста", selection: $typeSize) {
                    Text("Стандартный").tag(DynamicTypeSize.large)
                    Text("AX1").tag(DynamicTypeSize.accessibility1)
                    Text("AX5 → ограничение AX1").tag(DynamicTypeSize.accessibility5)
                }
                Picker("Тема", selection: $theme) {
                    ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                LabeledContent("Figma node", value: variant.figmaNodeID)
                    .font(.caption.monospaced())
                NavigationLink("Матрица всех 10 вариантов") { TUIHeaderLargeVariantMatrix() }
            }
            .padding(.horizontal, TUISpacing.x4)
        }
        .alert("Ссылка сработала", isPresented: $linkOpened) {
            Button("Закрыть", role: .cancel) {}
        } message: { Text("Каталог обработал действие ссылки. В приложении обработчик задаёт потребитель.") }
    }
}

private struct TUIHeaderLargeVariantMatrix: View {
    @State private var theme = TUITheme.day

    var body: some View {
        ScrollView {
            VStack(spacing: TUISpacing.x4) {
                Picker("Тема", selection: $theme) {
                    ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                ForEach(TUIHeaderLarge.Variant.allCases, id: \.self) { variant in
                    VStack(alignment: .leading, spacing: TUISpacing.x1) {
                        Text(variant.rawValue + " · " + variant.figmaNodeID)
                            .font(.caption.monospaced())
                            .padding(.horizontal, TUISpacing.x4)
                        TUIHeaderLarge(variant: variant, isSkeletonAnimating: false)
                            .background(TUIColor.backgroundPrimary)
                            .environment(\.colorScheme, theme == .day ? .light : .dark)
                    }
                }
            }
            .padding(.vertical, TUISpacing.x4)
        }
        .navigationTitle("Header Large · матрица iOS")
        .navigationBarTitleDisplayMode(.inline)
    }
}
