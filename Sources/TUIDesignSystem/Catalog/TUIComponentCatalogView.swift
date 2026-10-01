import SwiftUI
import Foundation

public struct TUIComponentCatalogView: View {
    private let catalog = TUILibraryCatalog.shared
    @State private var query = ""

    public init() {}

    public var body: some View {
        List {
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
            }
            Section("Coverage") {
                LabeledContent("Status", value: ["41658:296906", "10312:84", "28036:523553", "53309:296335", "9999:26", "55278:70443", "25942:708453", "10467:91596", "37840:45833", "25738:689227"].contains(component.id) ? "In progress" : "Catalogued")
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

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "10467:91596").first { variant in
            variant.properties["quantity"] == String(value)
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIRating(value: $value)
                .frame(maxWidth: .infinity)
                .frame(height: 88)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))
            LabeledContent("Оценка", value: "\(value) из 5")
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
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
