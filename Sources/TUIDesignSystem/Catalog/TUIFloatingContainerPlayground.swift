import SwiftUI

struct TUIFloatingContainerPlayground: View {
    var body: some View {
        NavigationLink("Открыть интерактивный экран") {
            TUIFloatingContainerDemoScreen()
        }
        .accessibilityIdentifier("floatingContainerDemo")
    }
}

private struct TUIFloatingContainerDemoScreen: View {
    @State private var preset: TUIFloatingContainer<Text>.Preset = .twoActions
    @State private var elevated = false
    @State private var fade = false
    @State private var presented = true
    @State private var dark = false
    @State private var state: TUIButtonState = .normal
    @State private var primaryCount = 0
    @State private var secondaryCount = 0
    @State private var alternatePrimary = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                Picker("Контент", selection: $preset) {
                    Text("Одна").tag(TUIFloatingContainer<Text>.Preset.action)
                    Text("Две").tag(TUIFloatingContainer<Text>.Preset.twoActions)
                    Text("Лигал").tag(TUIFloatingContainer<Text>.Preset.actionLegal)
                    Text("Свой").tag(TUIFloatingContainer<Text>.Preset.customContent)
                }.pickerStyle(.segmented).accessibilityIdentifier("floatingPreset")
                if preset == .twoActions || preset == .actionLegal {
                    Toggle("Elevation 1", isOn: $elevated).accessibilityIdentifier("floatingElevation")
                } else if preset == .action {
                    Toggle("Градиент", isOn: $fade).accessibilityIdentifier("floatingFade")
                }
                Toggle("Показать действия", isOn: $presented).accessibilityIdentifier("floatingVisibility")
                Button("Сменить основную кнопку") { alternatePrimary.toggle() }
                    .accessibilityIdentifier("floatingReplacePrimary")
                Picker("Состояние кнопки", selection: $state) {
                    Text("Normal").tag(TUIButtonState.normal)
                    Text("Loading").tag(TUIButtonState.loading)
                    Text("Disabled").tag(TUIButtonState.disabled)
                }.pickerStyle(.segmented).accessibilityIdentifier("floatingButtonState")
                Text("Основное: \(primaryCount), дополнительное: \(secondaryCount)")
                    .tuiTypography(.bodyMedium).accessibilityIdentifier("floatingTapCounts")
                Text("Действия остаются внизу при прокрутке. Скрытие и появление запускают анимацию из спецификации.")
                    .tuiTypography(.bodyLarge)
                ForEach(1...12, id: \.self) { index in
                    Text("Контент экрана · \(index)")
                        .tuiTypography(.bodyLarge)
                        .frame(maxWidth: .infinity, minHeight: TUIControlSize.large, alignment: .leading)
                }
                Text("Конец контента").tuiTypography(.bodyMedium)
                    .accessibilityIdentifier("floatingScrollEnd")
            }
            .padding(.horizontal, TUISpacing.x4)
            .padding(.top, TUISpacing.x4)
        }
        .background(elevated ? TUIColor.backgroundSecondary : TUIColor.backgroundPrimary)
        .tuiFloatingContainer(isPresented: presented,
            replacementID: preset == .customContent ? "custom" : "actions") { container }
        .navigationTitle("Floating Container")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(dark ? "Night" : "Day") { dark.toggle() }
                    .accessibilityIdentifier("floatingTheme")
            }
        }
        .preferredColorScheme(dark ? .dark : .light)
    }

    private var primary: TUIButton {
        TUIButton(alternatePrimary ? "Подтвердить" : "Продолжить", state: state) { primaryCount += 1 }
    }
    private var secondary: TUIButton {
        TUIButton("Отмена", appearance: .flat) { secondaryCount += 1 }
    }
    private var container: some View {
        TUIFloatingContainerDemoActions(preset: preset, elevated: elevated,
            fade: fade, primary: primary, secondary: secondary,
            customAction: { primaryCount += 1 })
    }
}

private struct TUIFloatingContainerDemoActions: View {
    let preset: TUIFloatingContainer<Text>.Preset
    let elevated: Bool
    let fade: Bool
    let primary: TUIButton
    let secondary: TUIButton
    let customAction: () -> Void
    var body: some View {
        if preset == .customContent {
            TUIFloatingContainer {
                HStack(spacing: TUISpacing.x4) {
                    Text("1 000 ₽").tuiTypography(.bodyLarge)
                    TUIButton("Оплатить", size: .small, action: customAction)
                }
                .frame(maxWidth: .infinity, minHeight: TUIControlSize.large)
            }
        } else {
            TUIFloatingContainer(primary: primary,
                secondary: preset == .twoActions ? secondary : nil,
                legalText: preset == .actionLegal ? "Продолжая, вы соглашаетесь с условиями обслуживания" : nil,
                background: preset == .action ? .off : elevated ? .elevation1 : .base,
                showsFade: fade)
        }
    }
}
