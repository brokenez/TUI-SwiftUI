import SwiftUI

struct TUICardMediumPlayground: View {
    @Environment(\.dynamicTypeSize) private var systemTypeSize
    @State private var variant = TUICardMedium.Variant.textBottomImage
    @State private var title = "Title"
    @State private var subtitle = "Subtitle"
    @State private var badgeText = "10%"
    @State private var notificationText = "1"
    @State private var showsNotification = true
    @State private var isEnabled = true
    @State private var isSelected = false
    @State private var animates = true
    @State private var count = 0
    @State private var theme = TUITheme.day
    @State private var typeSize: DynamicTypeSize?
    @State private var titleLines = 2
    @State private var subtitleLines = 2
    @State private var customBackground = false
    @State private var customAccessory = false
    @State private var width = 140.0
    @State private var height = 140.0

    private var card: TUICardMedium {
        let card = TUICardMedium(title, subtitle: subtitle, variant: variant,
            showsNotification: showsNotification, notificationText: notificationText,
            badgeText: badgeText, isSelected: isSelected, isEnabled: isEnabled,
            isSkeletonAnimating: animates,
            style: .init(width: width, height: height,
                         title: .init(maximumLines: titleLines), subtitle: .init(maximumLines: subtitleLines))) {
                count += 1
                isSelected.toggle()
            }
        let background = customBackground ? card.cardBackground {
            LinearGradient(colors: [TUIColor.backgroundPrimary, TUIColor.accent], startPoint: .top, endPoint: .bottom)
        } : card
        return customAccessory ? background.accessory {
            TUISkeleton(width: 40, height: 40, isAnimating: false)
        } : background
    }

    var body: some View {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--tui-card-medium-motion-probe") {
            TUICardMediumMotionProbe()
        } else {
            controls
        }
        #else
        controls
        #endif
    }

    private var controls: some View {
        Group {
            VStack(spacing: TUISpacing.x4) {
                card
                    .environment(\.dynamicTypeSize, typeSize ?? systemTypeSize)
                    .environment(\.colorScheme, theme == .day ? .light : .dark)
                Text("Нажатий: \(count)")
                    .accessibilityIdentifier("cardMediumTapCount")
                Text(isSelected ? "Выбрано" : "Не выбрано")
                    .accessibilityIdentifier("cardMediumSelection")
            }
            .accessibilityElement(children: .contain)
            Picker("Вариант Figma", selection: $variant) {
                ForEach(TUICardMedium.Variant.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.menu)
            .accessibilityIdentifier("cardMediumVariantPicker")
            TextField("Заголовок", text: $title)
            TextField("Подпись", text: $subtitle)
            TextField("Pro-бейдж", text: $badgeText)
            TextField("Уведомлений", text: $notificationText)
            Toggle("Показывать уведомление", isOn: $showsNotification)
            Toggle("Действие доступно", isOn: $isEnabled)
                .accessibilityIdentifier("cardMediumEnabled")
            Toggle("Выбрано", isOn: $isSelected)
            Toggle("Анимация skeleton", isOn: $animates)
            Toggle("Свой фон", isOn: $customBackground)
            Toggle("Свой вложенный компонент", isOn: $customAccessory)
            Stepper("Строк заголовка: \(titleLines)", value: $titleLines, in: 1...6)
            Stepper("Строк подписи: \(subtitleLines)", value: $subtitleLines, in: 1...6)
            LabeledContent("Ширина", value: "\(Int(width)) pt")
            Slider(value: $width, in: 92...240, step: 1)
            LabeledContent("Высота", value: "\(Int(height)) pt")
            Slider(value: $height, in: 92...240, step: 1)
            Picker("Размер текста", selection: $typeSize) {
                Text("Системный").tag(nil as DynamicTypeSize?)
                Text("Стандартный").tag(DynamicTypeSize.large as DynamicTypeSize?)
                Text("AX1").tag(DynamicTypeSize.accessibility1 as DynamicTypeSize?)
                Text("AX5 → ограничение AX1").tag(DynamicTypeSize.accessibility5 as DynamicTypeSize?)
            }
            .pickerStyle(.menu)
            .accessibilityIdentifier("cardMediumDynamicType")
            Picker("Тема", selection: $theme) {
                ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            LabeledContent("Figma node", value: variant.figmaNodeID)
            NavigationLink("Все 21 варианта") {
                ScrollView {
                    LazyVStack(spacing: TUISpacing.x4) {
                        ForEach(TUICardMedium.Variant.allCases, id: \.self) { variant in
                            TUICardMedium(variant: variant, isSkeletonAnimating: false) { count += 1 }
                            Text(variant.rawValue).font(.caption)
                            Text(variant.figmaNodeID).font(.caption.monospaced())
                        }
                    }
                    .padding()
                }
                .navigationTitle("Card Medium")
            }
        }
    }
}
