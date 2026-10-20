import SwiftUI

/// Live native inspection of the public Foundation APIs; source acceptance is
/// recorded separately in Documentation/References/Foundations.
struct TUIFoundationsCatalogView: View {
    @State private var theme: TUITheme = .day

    var body: some View {
        List {
            Picker("Тема", selection: $theme) {
                Text("Day").tag(TUITheme.day)
                Text("Night").tag(TUITheme.night)
            }
            .pickerStyle(.segmented)

            NavigationLink("Цвета · 289 токенов") {
                List(colorNames, id: \.self) { name in
                    HStack(spacing: TUISpacing.x3) {
                        RoundedRectangle(cornerRadius: TUIRadius.small)
                            .fill(TUIColor.named(name))
                            .frame(width: TUIControlSize.medium, height: TUIControlSize.medium)
                            .overlay(RoundedRectangle(cornerRadius: TUIRadius.small)
                                .strokeBorder(TUIColor.separator))
                        Text(name).tuiTypography(.uiSmall)
                    }
                }
                .navigationTitle("Цвета")
                .preferredColorScheme(theme == .day ? .light : .dark)
            }
            NavigationLink("Типографика · 31 роль") {
                List(TUITypographyRole.allCases, id: \.self) { role in
                    VStack(alignment: .leading, spacing: TUISpacing.x1) {
                        Text(role.rawValue).font(.caption).foregroundStyle(.secondary)
                        Text("Зарплатный клуб · 123 ₽").tuiTypography(role)
                        Text("\(Int(role.metrics.size)) pt · \(role.metrics.weight) · системный SF Pro")
                            .font(.caption.monospaced()).foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Типографика")
                .preferredColorScheme(theme == .day ? .light : .dark)
            }
            NavigationLink("Анимация · кривые и длительности") {
                TUIFoundationMotionDemo()
                    .preferredColorScheme(theme == .day ? .light : .dark)
            }
            Section("Тени · исходные параметры Figma") {
                LabeledContent("Small", value: shadowDetails(blur: TUIShadow.smallBlur(theme: theme), y: TUIShadow.smallYOffset(theme: theme)))
                LabeledContent("Medium", value: shadowDetails(blur: TUIShadow.mediumBlur(theme: theme), y: TUIShadow.mediumYOffset(theme: theme)))
                LabeledContent("Popup", value: shadowDetails(blur: TUIShadow.popupBlur(theme: theme), y: TUIShadow.popupYOffset(theme: theme)))
                Text("Blur — значение Figma. Визуальная приёмка рендера теней ведётся отдельно.")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Section("Первоисточники") {
                Link("TUI Foundations", destination: URL(string: "https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=1-75")!)
                Link("Спецификация Typography iOS", destination: URL(string: "https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=12472-11173")!)
            }
        }
        .navigationTitle("Foundations")
        .preferredColorScheme(theme == .day ? .light : .dark)
    }

    private var colorNames: [String] {
        TUITokenCatalog.shared.variableNames(in: "Theme").filter { name in
            let value = TUITokenCatalog.shared.value(named: name, collection: "Theme", mode: "Day") as? [String: Any]
            return value?["r"] != nil
        }.sorted()
    }

    private func shadowDetails(blur: CGFloat, y: CGFloat) -> String {
        "Blur \(Int(blur)) · Y \(Int(y))"
    }
}

private struct TUIFoundationMotionDemo: View {
    @State private var curve: TUIMotionCurve = .productiveStandard
    @State private var duration: TUIMotionDuration = .moderate
    @State private var moved = false
    private let curves: [TUIMotionCurve] = [.productiveStandard, .productiveEntrance, .productiveExit,
        .expressiveStandard, .expressiveEntrance, .expressiveExit]
    private let durations: [TUIMotionDuration] = [.fastest, .fast, .moderate, .slow, .slowest]

    var body: some View {
        Form {
            Picker("Кривая", selection: $curve) {
                ForEach(curves, id: \.self) { Text($0.rawValue).tag($0) }
            }
            Picker("Длительность", selection: $duration) {
                ForEach(durations, id: \.self) { value in
                    Text("\(value.rawValue) · \(Int((value.seconds * 1000).rounded())) ms").tag(value)
                }
            }
            GeometryReader { geometry in
                Circle().fill(TUIColor.accent)
                    .frame(width: TUIControlSize.medium, height: TUIControlSize.medium)
                    .offset(x: moved ? max(0, geometry.size.width - TUIControlSize.medium) : 0)
            }
            .frame(height: TUIControlSize.large)
            Button("Воспроизвести") {
                withAnimation(curve.animation(duration: duration)) { moved.toggle() }
            }
            Text("Productive применяется для fast и fastest. Пример позволяет отдельно исследовать все исходные кривые; он не меняет системные анимации навигации и шторок.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .navigationTitle("Анимация")
    }
}

#Preview {
    NavigationStack { TUIFoundationsCatalogView() }
}
