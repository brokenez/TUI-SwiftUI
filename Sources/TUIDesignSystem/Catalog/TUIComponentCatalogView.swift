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
            }
            Section("Coverage") {
                LabeledContent("Status", value: ["41658:296906", "10312:84", "28036:523553", "53309:296335", "9999:26"].contains(component.id) ? "In progress" : "Catalogued")
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
