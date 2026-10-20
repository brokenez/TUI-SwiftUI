import SwiftUI
import UIKit
import TUIDesignSystem

/// Independent consumer: no copies of component code or resource files.
struct HeaderConsumerScreen: View {
    enum Mode: String, CaseIterable {
        case standard, ax1, ax1Reflow, ax5Reflow, descriptionAX1Reflow, fade, skeleton, inlineSymbol, multilineFade, baselineLink, multilineLinkedFade, linkedBlocks
    }

    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var systemReduceMotion = UIAccessibility.isReduceMotionEnabled
    @State private var selected = false
    @State private var linkCount = 0
    @State private var linkTargets: [String] = []
    @State private var accessibilityReport = ""
    @State private var accessibilityActionResult = ""
    @State private var mode: Mode

    init() {
        let prefix = "--header-mode="
        let argument = ProcessInfo.processInfo.arguments.first { $0.hasPrefix(prefix) }
        _mode = State(initialValue: argument.flatMap { Mode(rawValue: String($0.dropFirst(prefix.count))) } ?? .standard)
    }

    private var typeSize: DynamicTypeSize {
        switch mode {
        case .ax1, .ax1Reflow, .descriptionAX1Reflow: .accessibility1
        case .ax5Reflow: .accessibility5
        default: .large
        }
    }

    private var linkedTitle: AttributedString {
        var result = AttributedString("Настройки уведомлений")
        result.link = URL(string: "https://go.tcsbank.ru/tui-header-specs")
        result.foregroundColor = TUIColor.action
        return result
    }

    private var partialLinkedTitle: AttributedString {
        var result = AttributedString("Длинный заголовок, очень длинный, на три строки, с иконкой в конце и дополнительным текстом")
        if let range = result.range(of: "конце") {
            result[range].link = URL(string: "https://go.tcsbank.ru/tui-header-specs")
            result[range].foregroundColor = TUIColor.action
        }
        return result
    }

    private func linkedBlock(_ text: String, link: String, target: String) -> AttributedString {
        var result = AttributedString(text)
        if let range = result.range(of: link) {
            result[range].link = URL(string: "https://go.tcsbank.ru/tui-header-specs?block=" + target)
            result[range].foregroundColor = TUIColor.action
        }
        return result
    }

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            Text("Header live")
                .accessibilityIdentifier("headerLiveAnchor")
            Group {
                if mode == .skeleton {
                    TUIHeaderLarge(variant: .subheaderLeadingSkeleton)
                } else if mode == .fade {
                    TUIHeaderLarge("Очень длинный заголовок, который не помещается в одну строку",
                                   showsSubheader: false)
                        .textStyles(title: .init(overflow: .singleLineFade))
                        .titleTrailing {
                            Text("42").tuiTypography(.bodyMedium)
                                .accessibilityIdentifier("headerSuffix")
                        }
                } else if mode == .multilineFade {
                    TUIHeaderLarge("Длинный заголовок, очень длинный, на три строки, с иконкой в конце и дополнительным текстом", showsSubheader: false)
                        .textStyles(title: .init(overflow: .multilineFade(lineLimit: 3)))
                } else if mode == .multilineLinkedFade {
                    TUIHeaderLarge(title: partialLinkedTitle, showsSubheader: false)
                        .textStyles(title: .init(overflow: .multilineFade(lineLimit: 3)))
                } else if mode == .linkedBlocks {
                    VStack(spacing: TUISpacing.x4) {
                        TUIHeaderLarge(title: linkedBlock("Настройки уведомлений", link: "уведомлений", target: "title"),
                            subheader: linkedBlock("Получать новости и важные сообщения сервиса", link: "новости", target: "subheader"))
                        TUIHeaderLarge(title: AttributedString("Описание условий"),
                            description: linkedBlock("Подробнее об условиях сервиса", link: "Подробнее", target: "description"),
                            variant: .descriptionLeading)
                    }
                } else if mode == .baselineLink {
                    TUIHeaderLarge("Настройки\nуведомлений", subheader: "Получать новости сервиса")
                        .accessory(alignment: .firstBaseline) {
                            TUILink("Все", showsLeadingIcon: false, showsTrailingIcon: false) { linkCount += 1 }
                        }
                } else if mode == .inlineSymbol {
                    TUIHeaderLarge(showsSubheader: false)
                        .titleInlineText(Text("Заголовок, который занимает несколько строк \(Image(systemName: "star.fill"))"))
                } else {
                    TUIHeaderLarge(title: linkedTitle,
                                   subheader: AttributedString("Получать новости и важные сообщения сервиса"),
                                   description: AttributedString("Получать новости и важные сообщения сервиса"),
                                   variant: mode == .descriptionAX1Reflow ? .descriptionLeading : .subheaderLeading)
                        .accessory(reflowsAtAX1: mode == .ax1Reflow || mode == .ax5Reflow || mode == .descriptionAX1Reflow) {
                            Toggle("Получать уведомления", isOn: $selected)
                                .labelsHidden()
                                .accessibilityLabel("Получать уведомления")
                        }
                }
            }
            .frame(width: 375)
            .environment(\.dynamicTypeSize, typeSize)
            .environment(\.openURL, OpenURLAction { url in
                linkCount += 1
                linkTargets.append(url.absoluteString)
                return .handled
            })
            if mode != .linkedBlocks { Text("Выбрано: \(selected ? "да" : "нет")") }
            Text("Ссылок: \(linkCount)")
            if mode == .linkedBlocks {
                Text(linkTargets.joined(separator: "\n")).lineLimit(1)
                    .accessibilityIdentifier("headerLinkTargets")
            }
            if mode != .linkedBlocks {
                Text("Reduce Motion: \(reduceMotion ? "on" : "off")")
                Text("System Reduce Motion: \(systemReduceMotion ? "on" : "off")")
                Text("Scene: \(String(describing: scenePhase))")
            }
            if ProcessInfo.processInfo.arguments.contains("--header-ax-probe") {
              VStack(spacing: TUISpacing.x1) {
                Button("Снять AX") { accessibilityReport = HeaderAccessibilityProbe.snapshot() }
                    .accessibilityIdentifier("headerAXSnapshot")
                Button("Выполнить AX ссылку") {
                    let label = mode == .multilineLinkedFade ? "конце" : "Настройки уведомлений"
                    accessibilityActionResult = HeaderAccessibilityProbe.performLinkAction(label: label) ? "AX action: success" : "AX action: unavailable"
                }
                .accessibilityIdentifier("headerAXPerformLink")
                Text(accessibilityReport).font(.caption).lineLimit(1)
                    .accessibilityIdentifier("headerAXSnapshotPayload")
                Text(accessibilityActionResult).accessibilityIdentifier("headerAXActionResult")
                if mode == .linkedBlocks {
                    ForEach(["уведомлений", "новости", "Подробнее"], id: \.self) { label in
                        Button(label) {
                            accessibilityActionResult = HeaderAccessibilityProbe.performLinkAction(label: label) ? "AX action: success" : "AX action: unavailable"
                        }
                        .accessibilityIdentifier("headerAXAction-" + label)
                    }
                }
              }
            }
            Picker("Режим проверки", selection: $mode) {
                ForEach(Mode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .accessibilityIdentifier("headerConsumerMode")
            Spacer(minLength: 0)
        }
        .padding(.top, TUISpacing.x4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(TUIColor.textPrimary)
        .background(TUIColor.backgroundPrimary)
        .environment(\.colorScheme, mode == .skeleton ? .dark : .light)
        .navigationTitle("Header · отдельный проект")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification)) { _ in
            systemReduceMotion = UIAccessibility.isReduceMotionEnabled
        }
        .onChange(of: scenePhase) { _, _ in
            systemReduceMotion = UIAccessibility.isReduceMotionEnabled
        }
    }
}
