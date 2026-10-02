import SwiftUI
import Foundation

public struct TUIComponentCatalogView: View {
    private let catalog = TUILibraryCatalog.shared
    @State private var query = ""

    public init() {}

    public var body: some View {
        List {
            if query.isEmpty {
                Section("Интерактивные компоненты") {
                    if let button = catalog.components(matching: "tui-button").first(where: { $0.id == "41658:296906" }) {
                        NavigationLink("tui-button · 147 вариантов") {
                            TUIComponentReferenceView(component: button)
                        }
                    }
                    if let checkbox = catalog.components(matching: "system-checkbox").first(where: { $0.id == "10312:84" }) {
                        NavigationLink("system-checkbox · 5 вариантов iOS") {
                            TUIComponentReferenceView(component: checkbox)
                        }
                    }
                    if let radio = catalog.components(matching: "system-radiobutton").first(where: { $0.id == "28036:523553" }) {
                        NavigationLink("system-radiobutton · 4 варианта iOS") {
                            TUIComponentReferenceView(component: radio)
                        }
                    }
                    if let bullet = catalog.components(matching: ".bullet").first(where: { $0.id == "53309:296335" }) {
                        NavigationLink(".bullet · 3 варианта") {
                            TUIComponentReferenceView(component: bullet)
                        }
                    }
                    if let loader = catalog.components(matching: "tui-loader").first(where: { $0.id == "9999:26" }) {
                        NavigationLink("tui-loader · 5 размеров") {
                            TUIComponentReferenceView(component: loader)
                        }
                    }
                    if let link = catalog.components(matching: "tui-link").first(where: { $0.id == "55278:70443" }) {
                        NavigationLink("tui-link · 15 вариантов iOS") {
                            TUIComponentReferenceView(component: link)
                        }
                    }
                    if let progress = catalog.components(matching: "tui-progress-circle").first(where: { $0.id == "25942:708453" }) {
                        NavigationLink("tui-progress-circle · 217 вариантов iOS") {
                            TUIComponentReferenceView(component: progress)
                        }
                    }
                    if let rating = catalog.components(matching: "tui-rating").first(where: { $0.id == "10467:91596" }) {
                        NavigationLink("tui-rating · 6 состояний") {
                            TUIComponentReferenceView(component: rating)
                        }
                    }
                    if let skeleton = catalog.components(matching: "tui-skeleton").first(where: { $0.id == "37840:45833" }) {
                        NavigationLink("tui-skeleton · 2 кадра") {
                            TUIComponentReferenceView(component: skeleton)
                        }
                    }
                    if let badge = catalog.components(matching: "tui-badge notification").first(where: { $0.id == "25738:689227" }) {
                        NavigationLink("tui-badge notification · 3 размера iOS") {
                            TUIComponentReferenceView(component: badge)
                        }
                    }
                    if let clientBadge = catalog.components(matching: "tui-badge [t-client]").first(where: { $0.id == "6392:51900" }) {
                        NavigationLink("tui-badge [t-client] · 1 вариант iOS") {
                            TUIComponentReferenceView(component: clientBadge)
                        }
                    }
                }
                Section("Списки") {
                    ForEach(["53190:295267", "79180:42849", "79180:42610", "79180:42880"], id: \.self) { identifier in
                        if let component = catalog.components(matching: "tui-list").first(where: { $0.id == identifier }) {
                            NavigationLink(component.name) {
                                TUIComponentReferenceView(component: component)
                            }
                        }
                    }
                }
                Section("Чипы") {
                    if let group = catalog.components(matching: "tui-chip-group").first(where: { $0.id == "115603:32334" }) {
                        NavigationLink("tui-chip-group · 4 варианта iOS") {
                            TUIComponentReferenceView(component: group)
                        }
                    }
                    if let chip = catalog.components(matching: "tui-chip").first(where: { $0.id == "42638:295990" }) {
                        NavigationLink("tui-chip · 60 вариантов iOS") {
                            TUIComponentReferenceView(component: chip)
                        }
                    }
                }
                Section("Кнопки") {
                    if let verticalButton = catalog.components(matching: "tui-button [vertical]").first(where: { $0.id == "41691:305320" }) {
                        NavigationLink("tui-button [vertical] · 4 варианта iOS") {
                            TUIComponentReferenceView(component: verticalButton)
                        }
                    }
                }
                Section("Нотификации") {
                    if let notification = catalog.components(matching: "tui-notification-middle").first(where: { $0.id == "39739:293413" }) {
                        NavigationLink("tui-notification-middle · 2 варианта iOS") {
                            TUIComponentReferenceView(component: notification)
                        }
                    }
                }
                Section("Бейджи") {
                    if let subscriptionBadge = catalog.components(matching: "tui-badge [subscription-icon]").first(where: { $0.id == "87688:44061" }) {
                        NavigationLink("tui-badge [subscription-icon] · 4 размера iOS") {
                            TUIComponentReferenceView(component: subscriptionBadge)
                        }
                    }
                    if let badgedContent = catalog.components(matching: "tui-badged-content").first(where: { $0.id == "25745:690323" }) {
                        NavigationLink("tui-badged-content · 5 вариантов iOS") {
                            TUIComponentReferenceView(component: badgedContent)
                        }
                    }
                }
                Section("Системные iOS-компоненты") {
                    ForEach(["9940:39560", "9151:1662", "24689:584469", "53362:296599", "44720:304564", "91657:37703"], id: \.self) { identifier in
                        if let component = catalog.components(matching: "system-").first(where: { $0.id == identifier }) {
                            NavigationLink(component.name) {
                                TUIComponentReferenceView(component: component)
                            }
                        }
                    }
                }
            }
            Section("Компоненты Figma") {
                ForEach(catalog.components(matching: query)) { component in
                    NavigationLink {
                        TUIComponentReferenceView(component: component)
                    } label: {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(component.name)
                            Text("\(catalog.variants(for: component.id).count) iOS / \(component.variantCount) total")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            if query.isEmpty {
                Section("Figma snapshot") {
                    LabeledContent("Variables", value: "957")
                    LabeledContent("Component sets", value: "128")
                    LabeledContent("Variants", value: "3 927")
                    LabeledContent("Assets", value: "3 518")
                }
                Section("TUI Typography · iOS") {
                    ForEach(TUITypographyRole.allCases, id: \.self) { role in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(role.rawValue.split(separator: "/").suffix(2).joined(separator: " / "))
                                .tuiTypography(role)
                            Text(typographyDetails(role.metrics))
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("TUI Design System")
        .searchable(text: $query, prompt: "Найти компонент")
    }

    private func typographyDetails(_ metrics: TUITypographyMetrics) -> String {
        "\(metrics.family) · \(Int(metrics.size)) / \(Int(metrics.lineHeight)) · tracking \(String(format: "%.2f", Double(metrics.letterSpacing)))"
    }
}

private struct TUIComponentReferenceView: View {
    let component: TUIComponentReference
    private let catalog = TUILibraryCatalog.shared
    @State private var nativeSearchText = ""
    @State private var nativeSearchPlacement: TUISystemSearchFieldPlacement = .floating
    @State private var nativeSearchFocused = false

    var body: some View {
        let variants = catalog.variants(for: component.id)
        List {
            if component.id == "41658:296906" {
                Section("Живой компонент") {
                    TUIButtonPlayground()
                }
            } else if component.id == "10312:84" {
                Section("Живой компонент") {
                    TUISystemCheckboxPlayground()
                }
            } else if component.id == "28036:523553" {
                Section("Живой компонент") {
                    TUISystemRadioButtonPlayground()
                }
            } else if component.id == "53309:296335" {
                Section("Живой компонент") {
                    TUIBulletPlayground()
                }
            } else if component.id == "9999:26" {
                Section("Живой компонент") {
                    TUILoaderPlayground()
                }
            } else if component.id == "55278:70443" {
                Section("Живой компонент") {
                    TUILinkPlayground()
                }
            } else if component.id == "25942:708453" {
                Section("Живой компонент") {
                    TUIProgressCirclePlayground()
                }
            } else if component.id == "10467:91596" {
                Section("Живой компонент") {
                    TUIRatingPlayground()
                }
            } else if component.id == "37840:45833" {
                Section("Живой компонент") {
                    TUISkeletonPlayground()
                }
            } else if component.id == "25738:689227" {
                Section("Живой компонент") {
                    TUINotificationBadgePlayground()
                }
            } else if ["53190:295267", "79180:42849", "79180:42610", "79180:42880"].contains(component.id) {
                Section("Живой компонент") {
                    TUIListPlayground(componentID: component.id)
                }
            } else if ["9940:39560", "9151:1662", "24689:584469", "53362:296599", "44720:304564"].contains(component.id) {
                Section("Живой компонент") {
                    TUISystemControlsPlayground(componentID: component.id)
                }
            } else if component.id == "91657:37703" {
                Section("Живой компонент") {
                    TUISystemSearchFieldPlayground(
                        placement: $nativeSearchPlacement,
                        text: $nativeSearchText,
                        focused: $nativeSearchFocused
                    )
                }
            } else if component.id == "43816:296032" {
                Section("Живой компонент") {
                    TUIIllustrationScreenPlayground()
                }
            } else if component.id == "115603:32334" {
                Section("Живой компонент") {
                    TUIChipGroupPlayground()
                }
            } else if component.id == "42638:295990" {
                Section("Живой компонент") {
                    TUIChipPlayground()
                }
            } else if component.id == "41691:305320" {
                Section("Живой компонент") {
                    TUIButtonVerticalPlayground()
                }
            } else if component.id == "39739:293413" {
                Section("Живой компонент") {
                    TUINotificationMiddlePlayground()
                }
            } else if component.id == "25745:690323" {
                Section("Живой компонент") {
                    TUIBadgedContentPlayground()
                }
            } else if component.id == "87688:44061" {
                Section("Живой компонент") {
                    TUISubscriptionBadgePlayground()
                }
            } else if component.id == "6392:51900" {
                Section("Живой компонент") {
                    TUIClientBadge()
                        .frame(maxWidth: .infinity)
                        .frame(height: 88)
                        .background(.white, in: RoundedRectangle(cornerRadius: 16))
                }
            }
            Section("Coverage") {
                LabeledContent("Status", value: ["6392:51900", "87688:44061"].contains(component.id) ? "Complete" : (["41658:296906", "10312:84", "28036:523553", "53309:296335", "9999:26", "55278:70443", "25942:708453", "10467:91596", "37840:45833", "25738:689227", "53190:295267", "79180:42849", "79180:42610", "79180:42880", "9940:39560", "9151:1662", "24689:584469", "53362:296599", "44720:304564", "91657:37703", "25745:690323", "39739:293413", "41691:305320", "42638:295990", "115603:32334", "43816:296032"].contains(component.id) ? "In progress" : "Catalogued"))
                LabeledContent("iOS variants", value: "\(variants.count)")
                LabeledContent("All variants", value: "\(component.variantCount)")
            }
            if !component.specificationURLs.isEmpty {
                Section("Specification") {
                    ForEach(component.specificationURLs, id: \.self) { url in
                        Link(url.absoluteString, destination: url)
                    }
                }
            }
            if !component.properties.isEmpty {
                Section("Component properties") {
                    ForEach(component.properties, id: \.self) { Text($0) }
                }
            }
            Section("iOS variant matrix") {
                ForEach(variants) { variant in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(variant.name).font(.subheadline.weight(.semibold))
                        Text(variant.properties.keys.sorted().map { "\($0)=\(variant.properties[$0]!)" }.joined(separator: ", "))
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle(component.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TUIIllustrationScreenPlayground: View {
    @State private var isPresented = false
    @State private var title = "Title"
    @State private var subtitle = "Subtitle"
    @State private var showPlaceholder = false
    @State private var actionCount = 0

    var body: some View {
        VStack(spacing: 16) {
            TUIButton("Открыть экран", appearance: .primary) {
                isPresented = true
            }
            TextField("Заголовок", text: $title)
            TextField("Подзаголовок", text: $subtitle)
            Toggle("Показывать placeholder", isOn: $showPlaceholder)
            LabeledContent("Нажатий на действия", value: "\(actionCount)")
            LabeledContent("Figma node", value: "63877:294676")
                .font(.caption)
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                TUIIllustrationScreen(
                    title: title,
                    subtitle: subtitle,
                    showPlaceholder: showPlaceholder,
                    closeTitle: "Закрыть",
                    primaryTitle: "Main action",
                    secondaryTitle: "Secondary action",
                    primaryAction: { actionCount += 1 },
                    secondaryAction: { actionCount += 1 }
                )
            }
            .presentationDetents([.large])
        }
    }
}

private struct TUIChipGroupPlayground: View {
    @State private var size: TUIChipSize = .small
    @State private var scrollable = true
    @State private var selectedIndex: Int?
    @State private var tapCount = 0

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "115603:32334").first { variant in
            variant.properties["System"] == "iOS"
                && variant.properties["Scrollable"] == (scrollable ? "on" : "off")
                && variant.properties["Size"] == (size == .small ? "S" : "M")
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIChipGroup(size: size, scrollable: scrollable) { chipSize in
                ForEach(0..<(scrollable ? 9 : (size == .small ? 9 : 8)), id: \.self) { index in
                    TUIChip("Label", size: chipSize, appearance: selectedIndex == index ? .accent : .neutral) {
                        selectedIndex = index
                        tapCount += 1
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(TUIColor.named("Background/Base"), in: RoundedRectangle(cornerRadius: 16))
            Picker("Размер", selection: $size) {
                Text("S").tag(TUIChipSize.small)
                Text("M").tag(TUIChipSize.medium)
            }
            .pickerStyle(.segmented)
            Toggle("Горизонтальная прокрутка", isOn: $scrollable)
            LabeledContent("Нажатий", value: "\(tapCount)")
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
        }
    }
}

private struct TUIChipPlayground: View {
    @State private var selectedID = "44231:309990"
    @State private var label = "Label"
    @State private var showsBadge = false
    @State private var tapCount = 0

    private var variants: [TUIComponentVariantReference] {
        TUILibraryCatalog.shared.variants(for: "42638:295990").filter(\.isIOS)
    }

    private var selectedVariant: TUIComponentVariantReference? {
        variants.first { $0.id == selectedID }
    }

    private func variantLabel(_ variant: TUIComponentVariantReference) -> String {
        let p = variant.properties
        let size = p["size"] == "small" ? "S" : "M"
        let appearance = p["appearance"] ?? "neutral"
        let leading = p["left content"] ?? "none"
        let trailing = p["right content"] ?? "none"
        let state = p["skeleton"] == "on" ? " · skeleton" : (p["is-disable"] == "on" ? " · disabled" : "")
        return "\(size) · \(appearance) · \(leading)/\(trailing)\(state)"
    }

    var body: some View {
        VStack(spacing: 18) {
            if let variant = selectedVariant,
               let size = TUIChipSize(rawValue: variant.properties["size"] ?? ""),
               let appearance = TUIChipAppearance(rawValue: variant.properties["appearance"] ?? ""),
               let leading = TUIChipLeadingContent(rawValue: variant.properties["left content"] ?? ""),
               let trailing = TUIChipTrailingContent(rawValue: variant.properties["right content"] ?? "") {
                TUIChip(
                    label,
                    size: size,
                    appearance: appearance,
                    leadingContent: leading,
                    trailingContent: trailing,
                    disabled: variant.properties["is-disable"] == "on",
                    skeleton: variant.properties["skeleton"] == "on",
                    badge: showsBadge ? "1" : nil
                ) {
                    tapCount += 1
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(TUIColor.named("Background/Base"), in: RoundedRectangle(cornerRadius: 16))
            }
            Picker("Вариант Figma", selection: $selectedID) {
                ForEach(variants) { variant in
                    Text(variantLabel(variant))
                        .tag(variant.id)
                }
            }
            .pickerStyle(.navigationLink)
            TextField("Название чипа", text: $label)
            Toggle("Бейдж", isOn: $showsBadge)
            LabeledContent("Нажатий", value: "\(tapCount)")
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
        }
    }
}

private struct TUIButtonVerticalPlayground: View {
    @State private var selectedState: TUIButtonVerticalState = .normal
    @State private var skeleton = false
    @State private var tapCount = 0

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "41691:305320").first { variant in
            variant.properties["System"] == "iOS"
                && variant.properties["State"] == (skeleton ? "Normal" : selectedState.rawValue.capitalized)
                && variant.properties["Skeleton"] == (skeleton ? "on" : "off")
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIButtonVertical("Label", state: selectedState, skeleton: skeleton) {
                tapCount += 1
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(TUIColor.named("Background/Base"), in: RoundedRectangle(cornerRadius: 16))
            Picker("Состояние", selection: $selectedState) {
                ForEach(TUIButtonVerticalState.allCases, id: \.self) { state in
                    Text(state.rawValue.capitalized).tag(state)
                }
            }
            .pickerStyle(.segmented)
            Toggle("Скелетон", isOn: $skeleton)
            LabeledContent("Нажатий", value: "\(tapCount)")
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
        }
    }
}

private struct TUINotificationMiddlePlayground: View {
    @State private var showsText = true
    @State private var text = "Text"

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "39739:293413").first { variant in
            variant.properties["system"] == "iOS" && variant.properties["text"] == (showsText ? "on" : "off")
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUINotificationMiddle(text: showsText ? text : nil)
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .background(TUIColor.named("Background/Base"), in: RoundedRectangle(cornerRadius: 16))
            Toggle("Показать текст", isOn: $showsText)
            if showsText {
                TextField("Текст уведомления", text: $text)
            }
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
        }
    }
}

private struct TUIBadgedContentPlayground: View {
    @State private var badge: TUIBadgedContentBadge = .topPlusBottom
    @State private var showsExampleContent = false

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "25745:690323").first { variant in
            variant.properties["System"] == "iOS" && variant.properties["Badge"] == badge.rawValue
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIBadgedContent(badge: badge) {
                Group {
                    if showsExampleContent {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(TUIColor.named("Background/Neutral 2"))
                            .overlay(Text("Контент").font(.subheadline))
                    } else {
                        Color.clear
                    }
                }
                .frame(width: 128, height: 128)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
            Picker("Badge", selection: $badge) {
                ForEach(TUIBadgedContentBadge.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            Toggle("Показать пример контента", isOn: $showsExampleContent)
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
        }
    }
}

private struct TUISystemSearchFieldPlayground: View {
    @Binding var placement: TUISystemSearchFieldPlacement
    @Binding var text: String
    @Binding var focused: Bool
    @State private var showingPreview = false

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "91657:37703").first { variant in
            variant.properties["type"] == placement.rawValue &&
            variant.properties["filled"] == (text.isEmpty ? "off" : "on") &&
            variant.properties["state"] == (focused ? "focus" : "normal")
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Выберите положение, заполнение и фокус, затем откройте нативный предпросмотр.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Picker("Тип", selection: $placement) {
                Text("Inline").tag(TUISystemSearchFieldPlacement.inline)
                Text("Floating").tag(TUISystemSearchFieldPlacement.floating)
            }
            .pickerStyle(.segmented)
            Toggle("Заполнено", isOn: Binding(
                get: { !text.isEmpty },
                set: { text = $0 ? "Запрос" : "" }
            ))
            Toggle("Фокус", isOn: $focused)
            Button("Открыть нативный предпросмотр") { showingPreview = true }
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showingPreview) {
            TUISystemSearchFieldPreview(text: $text, placement: placement, startsFocused: focused)
        }
    }
}

private struct TUISystemSearchFieldPreview: View {
    @Binding var text: String
    let placement: TUISystemSearchFieldPlacement
    let startsFocused: Bool
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Text("Нативное поле поиска iOS 26. Нажмите на поле и введите запрос.")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Поиск")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") { dismiss() }
                }
            }
            .tuiSystemSearchField(text: $text, placement: placement)
            .searchFocused($isFocused)
            .onAppear { isFocused = startsFocused }
        }
    }
}

private struct TUIListPlayground: View {
    let componentID: String
    @State private var size: TUIListSize = .large
    @State private var count = 3
    @State private var text = "Текст пункта списка, который может переноситься на следующую строку"

    private var isNumbered: Bool { ["79180:42849", "79180:42880"].contains(componentID) }
    private var isSingleItem: Bool { ["53190:295267", "79180:42849"].contains(componentID) }
    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: componentID).first { variant in
            let figmaSize = variant.properties["Size"] ?? variant.properties["size"]
            return figmaSize == size.rawValue || (figmaSize == "Body S" && size == .small)
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Group {
                if isSingleItem {
                    TUIListItem(text, size: size, marker: isNumbered ? .number("1.") : .bullet)
                } else {
                    TUIList(
                        Array(repeating: text, count: count),
                        size: size,
                        style: isNumbered ? .numbered() : .bulleted
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))

            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id).font(.caption)
            }
            Picker("Размер", selection: $size) {
                ForEach(TUIListSize.allCases, id: \.self) { option in
                    Text(option == .small && !isSingleItem ? "Body S" : option.rawValue).tag(option)
                }
            }
            TextField("Текст", text: $text, axis: .vertical)
            if !isSingleItem {
                Stepper("Пунктов: \(count)", value: $count, in: 1...6)
            }
        }
    }
}

private struct TUISystemControlsPlayground: View {
    let componentID: String
    @State private var isOn = true
    @State private var isEnabled = true
    @State private var isPresented = false
    @State private var isDark = false
    @State private var selectedAction = ""
    @State private var actionSheetTitle = "A short description of the actions goes here."
    @State private var showsActionSheetTitle = true
    @State private var alertTitle = "Title"
    @State private var alertMessage = "Body Text"
    @State private var hasThirdAction = false

    private var actions: [TUISystemMenuAction] {
        let defaults = (1...5).map { index in
            TUISystemMenuAction(id: "default-\(index)", title: "Default Action") {
                selectedAction = "Default Action \(index)"
            }
        }
        return defaults + [
            TUISystemMenuAction(id: "destructive", title: "Destructive Action", role: .destructive) { selectedAction = "Destructive Action" },
            TUISystemMenuAction(id: "disabled", title: "Disabled Action", isEnabled: false) {}
        ]
    }

    private var contextActions: [TUISystemMenuAction] {
        (1...6).map { index in
            TUISystemMenuAction(id: "context-\(index)", title: "Label") {
                selectedAction = "Label \(index)"
            }
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            Group {
                switch componentID {
                case "9940:39560":
                    TUISystemSwitch("Системный переключатель", isOn: $isOn, isEnabled: isEnabled)
                        .frame(maxWidth: .infinity)
                case "9151:1662":
                    Button("Открыть шторку действий") { isPresented = true }
                        .tuiSystemActionSheet(
                            isPresented: $isPresented,
                            title: actionSheetTitle,
                            showsTitle: showsActionSheetTitle,
                            actions: actions
                        )
                case "24689:584469":
                    Button("Открыть системный alert") { isPresented = true }
                        .tuiSystemAlert(
                            isPresented: $isPresented,
                            title: alertTitle,
                            message: alertMessage,
                            actions: hasThirdAction ? actions.prefix(3).map { $0 } : actions.prefix(2).map { $0 }
                        )
                case "53362:296599":
                    Text("Нажмите и удерживайте")
                        .padding(20)
                        .background(TUIColor.named("Background/Neutral 1"), in: RoundedRectangle(cornerRadius: 12))
                        .tuiSystemContextMenu(actions: contextActions)
                default:
                    TUISystemShareLink("Открыть системное меню «Поделиться»", url: URL(string: "https://www.tbank.ru/")!)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 100)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))

            if componentID == "53362:296599" {
                Menu("Открыть меню нажатием") {
                    ForEach(contextActions) { action in
                        Button(action.title, action: action.handler)
                    }
                }
            }
            if componentID == "9940:39560" {
                Toggle("Доступен", isOn: $isEnabled)
                LabeledContent("Состояние", value: isOn ? "Включён" : "Выключен")
            } else if componentID == "9151:1662" {
                Toggle("Показывать заголовок", isOn: $showsActionSheetTitle)
                TextField("Текст шторки", text: $actionSheetTitle, axis: .vertical)
            } else if componentID == "24689:584469" {
                Toggle("Три действия", isOn: $hasThirdAction)
                Toggle("Тёмная тема", isOn: $isDark)
                TextField("Заголовок", text: $alertTitle)
                TextField("Описание", text: $alertMessage)
            } else if componentID == "53362:296599" || componentID == "44720:304564" {
                Toggle("Тёмная тема", isOn: $isDark)
            }
            if !selectedAction.isEmpty {
                LabeledContent("Выбрано", value: selectedAction)
            }
            Text("Системный вид и анимация зависят от установленной версии iOS.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

private struct TUISubscriptionBadgePlayground: View {
    @State private var size: TUISubscriptionBadgeSize = .xLarge

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "87688:44061").first { variant in
            variant.properties["size"] == size.figmaName
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUISubscriptionBadge(size: size)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id).font(.caption)
            }
            Picker("Размер", selection: $size) {
                ForEach(TUISubscriptionBadgeSize.allCases, id: \.self) { option in
                    Text("\(option.figmaName) · \(option.rawValue) pt").tag(option)
                }
            }
        }
    }
}

private struct TUIBulletPlayground: View {
    @State private var type: TUIBulletType = .primary

    var body: some View {
        VStack(spacing: 24) {
            TUIBullet(type: type)
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            Picker("Тип", selection: $type) {
                ForEach(TUIBulletType.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
        }
    }
}

private struct TUILoaderPlayground: View {
    @State private var size: TUILoaderSize = .x24

    var body: some View {
        VStack(spacing: 24) {
            TUILoader(size: size)
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            Picker("Размер", selection: $size) {
                ForEach(TUILoaderSize.allCases, id: \.self) { value in
                    Text("\(value.rawValue) × \(value.rawValue)").tag(value)
                }
            }
        }
    }
}

private struct TUILinkPlayground: View {
    @State private var title = "Link"
    @State private var mode: TUILinkMode = .default
    @State private var size: TUILinkSize = .large
    @State private var showsLeadingIcon = true
    @State private var showsTrailingIcon = true
    @State private var tapCount = 0

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "55278:70443").first { variant in
            variant.properties["mode"] == mode.rawValue
                && variant.properties["size"] == size.rawValue
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUILink(
                title,
                mode: mode,
                size: size,
                showsLeadingIcon: showsLeadingIcon,
                showsTrailingIcon: showsTrailingIcon
            ) {
                tapCount += 1
            }
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(mode == .textPrimaryOnDark ? Color.black : Color.white,
                        in: RoundedRectangle(cornerRadius: 16))

            LabeledContent("Нажатий", value: "\(tapCount)")
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
            TextField("Текст", text: $title)
            Picker("Цвет", selection: $mode) {
                ForEach(TUILinkMode.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Picker("Размер", selection: $size) {
                ForEach(TUILinkSize.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Toggle("Иконка слева", isOn: $showsLeadingIcon)
            Toggle("Иконка справа", isOn: $showsTrailingIcon)
        }
    }
}

private struct TUIProgressCirclePlayground: View {
    @State private var mode: TUIProgressCircleMode = .closed
    @State private var size: TUIProgressCircleSize = .x80
    @State private var preset: TUIProgressCirclePreset = .none
    @State private var thickness = 6
    @State private var skeleton = false
    @State private var progress = TUIProgressCircleMode.closed.figmaDefaultProgress
    @State private var label = "100%"

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "25942:708453").first { variant in
            variant.properties["circleMode"] == mode.rawValue
                && variant.properties["Size"] == String(size.rawValue)
                && variant.properties["Preset"] == preset.rawValue
                && variant.properties["Thickness"] == String(thickness)
                && variant.properties["Skeleton"] == (skeleton ? "on" : "off")
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIProgressCircle(
                progress: progress,
                mode: mode,
                size: size,
                preset: preset,
                thickness: CGFloat(thickness),
                skeleton: skeleton,
                label: label
            )
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))

            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            } else {
                Text("Этой комбинации свойств нет в Figma")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Picker("Режим", selection: $mode) {
                ForEach(TUIProgressCircleMode.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .onChange(of: mode) { _, newMode in
                progress = newMode.figmaDefaultProgress
            }
            Picker("Размер", selection: $size) {
                ForEach(TUIProgressCircleSize.allCases, id: \.self) { value in
                    Text("\(value.rawValue) × \(value.rawValue)").tag(value)
                }
            }
            Picker("Содержимое", selection: $preset) {
                ForEach(TUIProgressCirclePreset.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Picker("Толщина", selection: $thickness) {
                ForEach([2, 4, 6, 8, 12], id: \.self) { value in
                    Text("\(value) pt").tag(value)
                }
            }
            Toggle("Скелетон", isOn: $skeleton)
            if preset == .text && !skeleton {
                TextField("Надпись", text: $label)
            }
            if !skeleton {
                Slider(value: $progress, in: 0...1) {
                    Text("Прогресс")
                }
            }
        }
    }
}

private struct TUIRatingPlayground: View {
    @State private var value = 3
    @State private var showsSparkles = true

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "10467:91596").first { variant in
            variant.properties["quantity"] == String(value)
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIRating(value: $value, showsSparkles: showsSparkles)
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            LabeledContent("Оценка", value: "\(value) из 5")
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
            Toggle("Искры при выборе", isOn: $showsSparkles)
            Text("Нажмите на звезду или проведите пальцем по шкале")
                .font(.caption)
                .foregroundStyle(.secondary)
            Button("Сбросить оценку") { value = 0 }
        }
    }
}

private struct TUISkeletonPlayground: View {
    @State private var keyframe: TUISkeletonKeyframe = .first

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "37840:45833").first { variant in
            variant.properties["keyframe"] == keyframe.rawValue
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUISkeleton(keyframe: keyframe)
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
            Picker("Кадр", selection: $keyframe) {
                ForEach(TUISkeletonKeyframe.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
        }
    }
}

private struct TUINotificationBadgePlayground: View {
    @State private var size: TUINotificationBadgeSize = .medium
    @State private var text = "1"

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "25738:689227").first { variant in
            variant.properties["size"] == size.rawValue
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUINotificationBadge(text, size: size)
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
            Picker("Размер", selection: $size) {
                ForEach(TUINotificationBadgeSize.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            if size != .small {
                TextField("Количество", text: $text)
                    .keyboardType(.numberPad)
            }
        }
    }
}

private struct TUISystemCheckboxPlayground: View {
    @State private var state: TUISystemCheckboxState = .selected

    var body: some View {
        VStack(spacing: 18) {
            TUISystemCheckbox(state: $state)
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            Text("Нажмите на чекбокс, чтобы изменить состояние")
                .font(.caption)
                .foregroundStyle(.secondary)
            Picker("Состояние", selection: $state) {
                ForEach(TUISystemCheckboxState.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
        }
    }
}

private struct TUISystemRadioButtonPlayground: View {
    @State private var state: TUISystemRadioButtonState = .selected

    var body: some View {
        VStack(spacing: 18) {
            TUISystemRadioButton(state: $state)
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            Text("Нажатие выбирает радиокнопку")
                .font(.caption)
                .foregroundStyle(.secondary)
            Picker("Состояние", selection: $state) {
                ForEach(TUISystemRadioButtonState.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
        }
    }
}

private struct TUIButtonPlayground: View {
    @State private var title = "Label"
    @State private var appearance: TUIButtonAppearance = .primary
    @State private var size: TUIButtonSize = .large
    @State private var state: TUIButtonState = .normal
    @State private var skeleton = false
    @State private var showsIcon = false
    @State private var showsLabel = true
    @State private var tapCount = 0

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "41658:296906").first { variant in
            let properties = variant.properties
            return properties["appearance"] == appearance.rawValue
                && properties["size"] == size.rawValue
                && properties["state"] == state.rawValue
                && properties["skeleton"] == (skeleton ? "on" : "off")
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIButton(
                title,
                appearance: appearance,
                size: size,
                state: state,
                skeleton: skeleton,
                showsIcon: showsIcon,
                showsLabel: showsLabel
            ) {
                tapCount += 1
            }
            .frame(maxWidth: size == .small ? nil : .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            LabeledContent("Нажатий", value: "\(tapCount)")
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
            TextField("Текст", text: $title)
            Picker("Оформление", selection: $appearance) {
                ForEach(TUIButtonAppearance.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Picker("Размер", selection: $size) {
                ForEach(TUIButtonSize.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Picker("Состояние", selection: $state) {
                ForEach(TUIButtonState.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Toggle("Иконка", isOn: $showsIcon)
            Toggle("Текст", isOn: $showsLabel)
            Toggle("Skeleton", isOn: $skeleton)
                .disabled(appearance != .primary || state != .normal)
        }
        .onChange(of: appearance) { _, newValue in
            if newValue != .primary { skeleton = false }
        }
        .onChange(of: state) { _, newValue in
            if newValue != .normal { skeleton = false }
        }
    }
}
