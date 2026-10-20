import SwiftUI
import Foundation

public struct TUIComponentCatalogView: View {
    private let catalog = TUILibraryCatalog.shared
    @State private var query = ""

    public init() {}

    public var body: some View {
        List {
            if query.isEmpty {
                Section("Основа библиотеки") {
                    NavigationLink("Foundations · цвета, шрифты, анимация") {
                        TUIFoundationsCatalogView()
                    }
                }
                Section("Интерактивные компоненты") {
                    if let card = catalog.components(matching: "tui-card-medium").first(where: { $0.id == "11335:41574" }) {
                        NavigationLink("tui-card-medium · 21 вариант iOS") {
                            TUIComponentReferenceView(component: card)
                        }
                    }
                    if let header = catalog.components(matching: "tui-header [large]").first(where: { $0.id == "42565:305012" }) {
                        NavigationLink("tui-header [large] · 10 вариантов iOS") {
                            TUIComponentReferenceView(component: header)
                        }
                    }
                    if let paymentLogo = catalog.components(matching: "payment-logo").first(where: { $0.id == "45931:47324" }) {
                        NavigationLink("payment-logo · 13 логотипов iOS") {
                            TUIComponentReferenceView(component: paymentLogo)
                        }
                    }
                    if let button = catalog.components(matching: "tui-button").first(where: { $0.id == "41658:296906" }) {
                        NavigationLink("tui-button · 147 вариантов") {
                            TUIComponentReferenceView(component: button)
                        }
                    }
                    if let wallet = catalog.components(matching: "tui-button [wallet]").first(where: { $0.id == "54757:286088" }) {
                        NavigationLink("tui-button [wallet] · 2 варианта iOS") {
                            TUIComponentReferenceView(component: wallet)
                        }
                    }
                    if let addCard = catalog.components(matching: "tui-button [add-card]").first(where: { $0.id == "7319:38983" }) {
                        NavigationLink("tui-button [add-card] · 6 вариантов iOS") {
                            TUIComponentReferenceView(component: addCard)
                        }
                    }
                    if let checkicon = catalog.components(matching: "tui-cell [checkicon]").first(where: { $0.id == "41637:306903" }) {
                        NavigationLink("tui-cell [checkicon] · 3 варианта iOS") {
                            TUIComponentReferenceView(component: checkicon)
                        }
                    }
                    if let close = catalog.components(matching: "tui-button [close]").first(where: { $0.id == "30258:432933" }) {
                        NavigationLink("tui-button [close] · 8 вариантов iOS") {
                            TUIComponentReferenceView(component: close)
                        }
                    }
                    if let share = catalog.components(matching: "tui-button [share]").first(where: { $0.id == "44290:299199" }) {
                        NavigationLink("tui-button [share] · 6 вариантов iOS") {
                            TUIComponentReferenceView(component: share)
                        }
                    }
                    if let like = catalog.components(matching: "tui-button [like]").first(where: { $0.id == "44290:299166" }) {
                        NavigationLink("tui-button [like] · 12 вариантов iOS") {
                            TUIComponentReferenceView(component: like)
                        }
                    }
                    if let pager = catalog.components(matching: "tui-pager").first(where: { $0.id == "34357:426019" }) {
                        NavigationLink("tui-pager · 10 вариантов iOS") {
                            TUIComponentReferenceView(component: pager)
                        }
                    }
                    if let textExpandable = catalog.components(matching: "tui-text-expandable").first(where: { $0.id == "44305:306527" }) {
                        NavigationLink("tui-text-expandable · 9 вариантов iOS") {
                            TUIComponentReferenceView(component: textExpandable)
                        }
                    }
                    if catalog.components(matching: "tui-swipe-actions").contains(where: { $0.id == "53204:296101" }) {
                        NavigationLink("tui-swipe-actions · 2 варианта iOS") {
                            TUISwipeActionsCatalogDetail()
                        }
                    }
                    if let counter = catalog.components(matching: "tui-counter").first(where: { $0.id == "16661:51922" }) {
                        NavigationLink("tui-counter · 9 вариантов iOS") {
                            TUIComponentReferenceView(component: counter)
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
                    if let skeletonText = catalog.components(matching: "tui-skeleton [text]").first(where: { $0.id == "37840:45836" }) {
                        NavigationLink("tui-skeleton [text] · 13 вариантов iOS") {
                            TUIComponentReferenceView(component: skeletonText)
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
                    if let component = catalog.components(matching: "tui-row [avatar-labelled]").first(where: { $0.id == "53606:308726" }) {
                        NavigationLink("tui-row [avatar-labelled] · 1 вариант iOS") {
                            TUIComponentReferenceView(component: component)
                        }
                    }
                    if let component = catalog.components(matching: "tui-row [card-medium]").first(where: { $0.id == "16273:42831" }) {
                        NavigationLink("tui-row [card-medium] · 2 варианта iOS") {
                            TUIComponentReferenceView(component: component)
                        }
                    }
                    if let component = catalog.components(matching: "tui-row [button-vertical]").first(where: { $0.id == "48700:323897" }) {
                        NavigationLink("tui-row [button-vertical] · 2 варианта iOS") {
                            TUIComponentReferenceView(component: component)
                        }
                    }
                }
                Section("Декоративные элементы") {
                    ForEach(["55278:70654", "55278:70659"], id: \.self) { identifier in
                        if let component = catalog.components(matching: "underline").first(where: { $0.id == identifier }) {
                            NavigationLink(component.name + " · псевдо: 2 варианта") {
                                TUIComponentReferenceView(component: component)
                            }
                        }
                    }
                }
                Section("Сетка и отступы") {
                    if let component = catalog.components(matching: "tui-spacing").first(where: { $0.id == "28406:482266" }) {
                        NavigationLink("tui-spacing · 21 вариант") {
                            TUIComponentReferenceView(component: component)
                        }
                    }
                }
                Section("Чипы") {
                    if let group = catalog.components(matching: "tui-chip-group").first(where: { $0.id == "115603:32334" }) {
                        NavigationLink("tui-chip-group · 4 варианта iOS") {
                            TUIComponentReferenceView(component: group)
                        }
                    }
                    ForEach(["44286:300575", "44286:300668", "44286:300482"], id: \.self) { identifier in
                        if let component = catalog.components(matching: "tui-chip-group").first(where: { $0.id == identifier }) {
                            NavigationLink(component.name + " · 6 вариантов iOS") {
                                TUIComponentReferenceView(component: component)
                            }
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
                    ForEach(["9940:39560", "9151:1662", "24689:584469", "53362:296599", "44720:304564", "91657:37703", "42221:48343"], id: \.self) { identifier in
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
                    LabeledContent("Исходные наборы", value: "\(catalog.components.count)")
                    LabeledContent("Наборы для переноса", value: "\(catalog.activeComponents.count)")
                    LabeledContent("Системные — вне объёма", value: "\(catalog.coverageEntries.filter { $0.status == .excluded }.count)")
                    LabeledContent("Variants", value: "3 927")
                    LabeledContent("Assets", value: "3 518")
                }
                Section("TUI Typography · iOS") {
                    ForEach(TUITypographyRole.allCases, id: \.self) { role in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(role.rawValue.split(separator: "/").suffix(2).joined(separator: " / "))
                                .tuiTypography(role)
                            Text(typographyDetails(role))
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

    private func typographyDetails(_ role: TUITypographyRole) -> String {
        let metrics = role.metrics
        return "\(metrics.family) · \(Int(metrics.size)) / \(Int(metrics.lineHeight)) · tracking Figma \(String(format: "%.2f", Double(metrics.letterSpacing))) · Dynamic Type \(role.textStyle.rawValue)"
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
            if component.id == "42587:291989" {
                Section("Живой контейнер · перенос продолжается") {
                    TUICardLargePlayground()
                }
            } else if component.id == "11335:41574" {
                Section("Живой компонент") {
                    TUICardMediumPlayground()
                }
            } else if component.id == "44217:298609" {
                Section("Живой компонент · проходит проверку") {
                    TUIHeaderCardPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "42565:305012" {
                Section("Живой компонент") {
                    TUIHeaderLargePlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "41658:296906" {
                Section("Живой компонент") {
                    TUIButtonPlayground()
                }
            } else if component.id == "46866:304541" {
                Section("Живой компонент · пиксельная маска") {
                    TUISensitiveModePlayground()
                }
            } else if component.id == "54757:286088" {
                Section("Живой компонент") {
                    TUIButtonWalletPlayground()
                }
            } else if component.id == "7319:38983" {
                Section("Живой компонент") {
                    TUIButtonAddCardPlayground()
                }
            } else if component.id == "30258:432933" {
                Section("Живой компонент") {
                    TUIButtonClosePlayground()
                }
            } else if component.id == "44290:299199" {
                Section("Живой компонент") {
                    TUISocialButtonPlayground(isLike: false)
                }
            } else if component.id == "44290:299166" {
                Section("Живой компонент") {
                    TUISocialButtonPlayground(isLike: true)
                }
            } else if component.id == "34357:426019" {
                Section("Живой компонент") {
                    TUIPagerPlayground()
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
            } else if component.id == "16661:51922" {
                Section("Живой компонент") {
                    TUICounterPlayground()
                }
            } else if component.id == "44305:306527" {
                Section("Живой компонент") {
                    TUITextExpandablePlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "9999:26" {
                Section("Живой компонент") {
                    TUILoaderPlayground()
                }
            } else if component.id == "65702:51131" {
                Section("Живой компонент") {
                    TUITextfieldPlayground()
                }
            } else if component.id == "44286:299509" {
                Section("Живой компонент") {
                    TUIFloatingContainerPlayground()
                }
            } else if component.id == "37840:45836" {
                Section("Живой компонент") {
                    TUISkeletonTextPlayground()
                }
            } else if component.id == "16273:42831" {
                Section("Живой компонент") {
                    TUIRowCardMediumPlayground()
                }
            } else if component.id == "43816:296648" {
                Section("Живой компонент") {
                    TUIBlockStatusPlayground()
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
            } else if component.id == "42221:48343" {
                Section("Живой компонент") {
                    TUISystemBrowserChromePlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "43816:296032" {
                Section("Живой компонент") {
                    TUIIllustrationScreenPlayground()
                }
            } else if component.id == "39867:46664" {
                Section("Живой компонент") {
                    TUISearchInputPlayground()
                }
            } else if component.id == "47912:303878" {
                Section("Живой компонент") {
                    TUIBlockDetailsPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "16753:52842" {
                Section("Живой компонент") {
                    TUIRowCustomPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "41569:290555" {
                Section("Живой компонент") {
                    TUICellPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "41637:306903" {
                Section("Живой компонент") {
                    TUICellCheckiconPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "48700:323897" {
                Section("Живой компонент") {
                    TUIRowButtonVerticalPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "53606:308726" {
                Section("Живой компонент") {
                    TUIRowAvatarLabelledPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if component.id == "45931:47324" {
                Section("Живой компонент") {
                    TUIPaymentLogoPlayground()
                }
            } else if ["55278:70654", "55278:70659"].contains(component.id) {
                Section("Живой компонент") {
                    TUIUnderlinePlayground(componentID: component.id)
                }
            } else if component.id == "28406:482266" {
                Section("Живой компонент") {
                    TUISpacingPlayground()
                }
            } else if component.id == "115603:32334" {
                Section("Живой компонент") {
                    TUIChipGroupPlayground()
                        .listRowInsets(EdgeInsets())
                }
            } else if ["44286:300575", "44286:300668", "44286:300482"].contains(component.id) {
                Section("Живой компонент") {
                    TUIChipGroupUseCasePlayground(componentID: component.id)
                        .listRowInsets(EdgeInsets())
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
                if let coverage = catalog.coverage(for: component.id) {
                    LabeledContent("Статус", value: coverage.status.label)
                    LabeledContent("Варианты iOS 26", value: "\(coverage.applicableVariantCount)")
                    if coverage.historicalVariantCount > 0 {
                        LabeledContent("Исторические iOS 18", value: "\(coverage.historicalVariantCount)")
                        Text("Сохранены для справки. Проверка исполнения — нативная iOS 26.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    if coverage.previousStatus == "complete", coverage.status != .complete {
                        Text("Ранее отмечен готовым; повторная приёмка ещё не завершена.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                } else {
                    Text("Данные проверки недоступны")
                }
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
            Section("Матрица iOS 26") {
                ForEach(variants.filter { !$0.isHistoricalIOS18 }) { variant in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(variant.name).font(.subheadline.weight(.semibold))
                        Text(variant.properties.keys.sorted().map { "\($0)=\(variant.properties[$0]!)" }.joined(separator: ", "))
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
            let historical = variants.filter(\.isHistoricalIOS18)
            if !historical.isEmpty {
                Section("Исторические варианты iOS 18") {
                    ForEach(historical) { variant in
                        Text(variant.name).font(.caption)
                    }
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
            .frame(width: 375, alignment: .leading)
            .background(TUIColor.named("Background/Base"), in: RoundedRectangle(cornerRadius: 16))
            Picker("Размер", selection: $size) {
                Text("S").tag(TUIChipSize.small)
                Text("M").tag(TUIChipSize.medium)
            }
            .pickerStyle(.segmented)
            Toggle("Горизонтальная прокрутка", isOn: $scrollable)
            LabeledContent("Нажатий", value: "\(tapCount)")
            if let selectedVariant {
                HStack {
                    Text("Figma node")
                    Spacer(minLength: 8)
                    Text(selectedVariant.id)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
        }
    }
}

private struct TUIChipGroupUseCasePlayground: View {
    let componentID: String
    @State private var size: TUIChipSize = .small
    @State private var scrollable = true
    @State private var alignment: TUIChipGroupAlignment = .start
    @State private var selectedIndex = 0
    @State private var visibleIndices = Set(0..<8)
    @State private var tapCount = 0

    private var kind: Kind {
        switch componentID {
        case "44286:300575": .choice
        case "44286:300668": .filter
        default: .list
        }
    }

    private var itemCount: Int {
        switch (kind, size) {
        case (.choice, .small): 9
        case (.choice, .medium): 8
        case (.filter, .small): 8
        case (.filter, .medium): 6
        case (.list, _): 9
        }
    }

    private var wrapRows: [[Int]] {
        let rowCapacity: Int
        switch (kind, size) {
        case (.choice, .small), (.list, _): rowCapacity = 5
        case (.choice, .medium): rowCapacity = 4
        case (.filter, .small): rowCapacity = 4
        case (.filter, .medium): rowCapacity = 3
        }
        let indices = kind == .filter ? visibleIndices.sorted() : Array(0..<itemCount)
        return stride(from: 0, to: indices.count, by: rowCapacity).map { start in
            Array(indices[start..<min(start + rowCapacity, indices.count)])
        }
    }

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: componentID).first { variant in
            variant.properties["System"] == "iOS"
                && variant.properties["Scrollable"] == (scrollable ? "on" : "off")
                && variant.properties["Size"] == (size == .small ? "S" : "M")
                && variant.properties["Alignment"] == (alignment == .start ? "Start" : "Center")
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            TUIChipGroup(size: size, scrollable: scrollable, alignment: alignment) { chipSize in
                if scrollable {
                    HStack(spacing: TUISpacing.x2) {
                        ForEach(0..<itemCount, id: \.self) { index in
                            chip(at: index, size: chipSize)
                        }
                    }
                } else {
                    VStack(spacing: TUISpacing.x2) {
                        ForEach(Array(wrapRows.enumerated()), id: \.offset) { _, row in
                            HStack(spacing: TUISpacing.x2) {
                                ForEach(row, id: \.self) { index in
                                    chip(at: index, size: chipSize)
                                }
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: alignment == .center ? .center : .leading
                            )
                        }
                    }
                    .frame(width: 375 - TUISpacing.x4 * 2)
                }
            }
            .frame(width: 375, alignment: .leading)
            .background(TUIColor.named("Background/Base"), in: RoundedRectangle(cornerRadius: 16))

            Picker("Размер", selection: $size) {
                Text("S").tag(TUIChipSize.small)
                Text("M").tag(TUIChipSize.medium)
            }
            .pickerStyle(.segmented)
            .onChange(of: size) { _, _ in
                if kind == .filter {
                    visibleIndices = Set(0..<itemCount)
                }
            }

            Toggle("Горизонтальная прокрутка", isOn: $scrollable)
                .onChange(of: scrollable) { _, isScrollable in
                    if isScrollable { alignment = .start }
                }

            Picker("Выравнивание", selection: $alignment) {
                Text("По началу").tag(TUIChipGroupAlignment.start)
                Text("По центру").tag(TUIChipGroupAlignment.center)
            }
            .pickerStyle(.segmented)
            .disabled(scrollable)

            if kind != .filter {
                LabeledContent(kind == .choice ? "Выборов" : "Нажатий", value: "\(tapCount)")
            } else {
                LabeledContent("Осталось фильтров", value: "\(visibleIndices.count)")
            }
            if let selectedVariant {
                HStack {
                    Text("Figma node")
                    Spacer(minLength: 8)
                    Text(selectedVariant.id)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .foregroundStyle(.secondary)
                }
                .font(.caption)
            }
        }
    }

    private enum Kind: Equatable {
        case choice
        case filter
        case list
    }

    @ViewBuilder
    private func chip(at index: Int, size: TUIChipSize) -> some View {
        switch kind {
        case .choice:
            TUIChip("Label", size: size, appearance: selectedIndex == index ? .accent : .neutral) {
                selectedIndex = index
                tapCount += 1
            }
        case .filter:
            if visibleIndices.contains(index) {
                TUIChip("Label", size: size, appearance: .accent, trailingContent: .close) {
                    visibleIndices.remove(index)
                }
            }
        case .list:
            TUIChip(index == 8 ? "Еще" : "Label", size: size) {
                tapCount += 1
            }
        }
    }
}

private struct TUIRowCustomPlayground: View {
    @State private var placeholderText = "Replace me"
    @State private var itemCount = 6

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            TUIRowCustom {
                ForEach(0..<itemCount, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: TUIRadius.small)
                        .strokeBorder(
                            TUIColor.named("Text/Secondary"),
                            style: StrokeStyle(lineWidth: 0.5, dash: [4, 3])
                        )
                        .frame(width: 100, height: 100)
                        .overlay {
                            Text(placeholderText)
                                .tuiTypography(.bodyMedium)
                                .foregroundStyle(TUIColor.named("Text/Secondary"))
                                .multilineTextAlignment(.center)
                                .frame(width: 100, height: 100)
                        }
                }
            }
            .frame(width: 375, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: TUISpacing.x3) {
                TextField("Содержимое ячейки", text: $placeholderText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Stepper("Ячеек: \(itemCount)", value: $itemCount, in: 1...6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel("Количество ячеек")
                LabeledContent("Figma node", value: "16753:52841")
                    .font(.caption)
            }
            .padding(.horizontal, TUISpacing.x4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct TUIRowAvatarLabelledPlayground: View {
    @State private var firstTitle = "Avatar label"
    @State private var firstSubtitle = "Avatar label"

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            TUIRowAvatarLabelled(labels: [(firstTitle, firstSubtitle)] + Array(repeating: ("Avatar label", "Avatar label"), count: 5))
                .frame(width: 375, height: 90, alignment: .leading)
                .clipped()
            VStack(alignment: .leading, spacing: TUISpacing.x3) {
                TextField("Подпись", text: $firstTitle)
                TextField("Вторая строка", text: $firstSubtitle)
                LabeledContent("Figma node", value: TUIRowAvatarLabelled.figmaNodeID)
                    .font(.caption)
            }
            .padding(.horizontal, TUISpacing.x4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct TUIRowButtonVerticalPlayground: View {
    @State private var quantity: TUIRowButtonVerticalQuantity = .oneToThree
    @State private var label = "Label"
    @State private var lastAction = ""

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            TUIRowButtonVertical(
                quantity: quantity,
                labels: Array(repeating: label, count: 4),
                onTap: { lastAction = "Нажата кнопка \($0 + 1)" }
            )
            VStack(alignment: .leading, spacing: TUISpacing.x3) {
                Picker("Количество", selection: $quantity) {
                    ForEach(TUIRowButtonVerticalQuantity.allCases, id: \.self) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Подпись кнопки", text: $label)
                if !lastAction.isEmpty {
                    Text(lastAction).font(.caption).foregroundStyle(.secondary)
                }
                LabeledContent("Figma node", value: quantity.figmaNodeID)
                    .font(.caption)
            }
            .padding(.horizontal, TUISpacing.x4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct TUIPaymentLogoPlayground: View {
    @State private var network: TUIPaymentLogo.Network = .mastercardMetal

    private let columns = [GridItem(.adaptive(minimum: 96), spacing: TUISpacing.x3)]

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            Picker("Логотип", selection: $network) {
                ForEach(TUIPaymentLogo.Network.allCases) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .accessibilityIdentifier("paymentLogoNetworkPicker")

            HStack {
                Spacer()
                TUIPaymentLogo(network)
                    .frame(width: 86, height: 48)
                    .background(TUIColor.named("Background/Neutral 4"), in: RoundedRectangle(cornerRadius: TUIRadius.medium))
                    .accessibilityIdentifier("paymentLogoSelectedPreview")
                Spacer()
            }

            LabeledContent("Figma node", value: network.figmaNodeID)
                .font(.caption)
                .accessibilityIdentifier("paymentLogoFigmaNode")

            LazyVGrid(columns: columns, spacing: TUISpacing.x3) {
                ForEach(TUIPaymentLogo.Network.allCases) { value in
                    Button {
                        network = value
                    } label: {
                        VStack(spacing: TUISpacing.x2) {
                            TUIPaymentLogo(value)
                            Text(value.rawValue)
                                .font(.caption2)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                                .frame(height: 28)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, TUISpacing.x3)
                        .background(TUIColor.named("Background/Neutral 4"), in: RoundedRectangle(cornerRadius: TUIRadius.medium))
                        .overlay {
                            RoundedRectangle(cornerRadius: TUIRadius.medium)
                                .strokeBorder(network == value ? TUIColor.named("Text/Action") : .clear, lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("paymentLogoOption-\(value.rawValue)")
                }
            }
        }
    }
}

private struct TUIUnderlinePlayground: View {
    let componentID: String

    @State private var pseudo = false

    private var style: TUIUnderline.Style {
        componentID == "55278:70654" ? .primary : .secondary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            Toggle("Псевдо", isOn: $pseudo)
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                Text("Текст над линией")
                    .tuiTypography(.bodyMedium)
                    .foregroundStyle(TUIColor.named("Text/Primary"))
                TUIUnderline(style: style, pseudo: pseudo)
                    .accessibilityIdentifier("underlinePreview")
            }
            LabeledContent("Figma node", value: style.figmaVariantID(pseudo: pseudo))
                .font(.caption)

            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                ForEach(TUIUnderline.Style.allCases) { exampleStyle in
                    HStack(spacing: TUISpacing.x5) {
                        Text(exampleStyle.rawValue)
                            .tuiTypography(.bodySmall)
                            .foregroundStyle(TUIColor.named("Text/Secondary"))
                            .frame(width: 80, alignment: .leading)
                        ForEach([false, true], id: \.self) { isPseudo in
                            VStack(spacing: TUISpacing.x2) {
                                TUIUnderline(style: exampleStyle, pseudo: isPseudo)
                                Text(isPseudo ? "Yes" : "No")
                                    .font(.caption2)
                                    .foregroundStyle(TUIColor.named("Text/Secondary"))
                            }
                            .frame(width: 56, alignment: .leading)
                        }
                    }
                }
            }
        }
    }
}

private struct TUISpacingPlayground: View {
    @State private var size: TUISpacingIndicator.Size = .x48
    @State private var visible = true

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            Picker("Размер", selection: $size) {
                ForEach(TUISpacingIndicator.Size.allCases) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .accessibilityIdentifier("tuiSpacingSizePicker")

            Toggle("Видимый индикатор", isOn: $visible)
                .disabled(size == .zero || size == .x2)
                .accessibilityIdentifier("tuiSpacingVisibleToggle")

            HStack {
                TUISpacingIndicator(size: size, visible: visible)
                Spacer(minLength: 0)
            }
            .frame(height: 64, alignment: .center)

            LabeledContent("Точный размер", value: "\(Int(size.points)) pt")
            LabeledContent("Figma node", value: TUISpacingIndicator(size: size, visible: visible).figmaVariantID)
            .font(.caption)
                .accessibilityIdentifier("tuiSpacingFigmaNode")
        }
        .onChange(of: size) { _, newSize in
            if newSize.figmaVariantIDs.hidden == nil {
                visible = true
            }
        }
    }
}

private struct TUIBlockDetailsPlayground: View {
    @State private var title = "TitleValue"
    @State private var titleDescription = "TitleDescription"
    @State private var amountDescription = "AmountDescription"
    @State private var comment = "Comment"
    @State private var skeleton = false
    @State private var showTitleDescription = true
    @State private var showAmount = true
    @State private var showAmountDescription = true
    @State private var showAmountDescription2 = false
    @State private var showComment = true
    @State private var showBadges = true
    @State private var showStatus = true

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "47912:303878").first {
            $0.properties["system"] == "iOS" && $0.properties["skeleton"] == (skeleton ? "on" : "off")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            TUIBlockDetails(
                titleValueText: title,
                titleDescriptionText: titleDescription,
                amountDescriptionText: amountDescription,
                commentText: comment,
                showAmount: showAmount,
                showAmountDescription: showAmountDescription,
                showAmountDescription2: showAmountDescription2,
                showBadges: showBadges,
                showComment: showComment,
                showStatus: showStatus,
                showTitleDescription: showTitleDescription,
                skeleton: skeleton
            )
            .background(TUIColor.named("Background/Base"), in: RoundedRectangle(cornerRadius: TUIRadius.large))

            TextField("Заголовок", text: $title)
            TextField("Описание заголовка", text: $titleDescription)
            TextField("Описание суммы", text: $amountDescription)
            TextField("Комментарий", text: $comment)
            Toggle("Скелетон", isOn: $skeleton)
            Toggle("Описание заголовка", isOn: $showTitleDescription)
            Toggle("Сумма", isOn: $showAmount)
            Toggle("Описание суммы", isOn: $showAmountDescription)
            Toggle("Дополнительное описание", isOn: $showAmountDescription2)
            Toggle("Комментарий", isOn: $showComment)
            Toggle("Бейдж", isOn: $showBadges)
            Toggle("Статус", isOn: $showStatus)
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
        }
    }
}

private struct TUISearchInputPlayground: View {
    @State private var state: TUISearchInput.State = .normal
    @State private var text = ""

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "39867:46664").first { variant in
            variant.properties["state"] == state.rawValue
                && variant.properties["filled"] == (text.isEmpty ? "off" : "on")
        }
    }

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            TUISearchInput(text: $text, state: state)
            Picker("Состояние", selection: $state) {
                ForEach(TUISearchInput.State.allCases, id: \.self) { value in
                    Text(value.rawValue.capitalized).tag(value)
                }
            }
            .pickerStyle(.segmented)
            Toggle("Заполненное поле", isOn: Binding(
                get: { !text.isEmpty },
                set: { text = $0 ? "Запрос" : "" }
            ))
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

private struct TUISystemBrowserChromePlayground: View {
    @State private var variant: TUISystemBrowserChromeVariant = .addressBar
    @State private var tabCount = 4
    @State private var lastAction = ""

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "42221:48343").first { $0.id == variant.figmaNodeID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            TUISystemBrowserChrome(
                variant: variant,
                tabCount: tabCount,
                onBack: { lastAction = "Назад" },
                onForward: { lastAction = "Вперёд" },
                onNewTab: { tabCount += 1; variant = .tabBar },
                onShare: { lastAction = "Поделиться" },
                onMore: { lastAction = "Показать вкладки" }
            )
            VStack(alignment: .leading, spacing: TUISpacing.x3) {
                Picker("Вид панели", selection: $variant) {
                    ForEach(TUISystemBrowserChromeVariant.allCases, id: \.self) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.menu)
                if variant == .tabBar {
                    Stepper("Вкладок: \(tabCount)", value: $tabCount, in: 1...99)
                }
                if !lastAction.isEmpty {
                    Text("Действие: \(lastAction)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let selectedVariant {
                    LabeledContent("Figma node", value: selectedVariant.id)
                        .font(.caption)
                }
            }
            .padding(.horizontal, TUISpacing.x4)
        }
    }
}

private struct TUIListPlayground: View {
    let componentID: String
    @State private var size: TUIListSize = .large
    @State private var count = 3
    @State private var text = ""

    private var isNumbered: Bool { ["79180:42849", "79180:42880"].contains(componentID) }
    private var isSingleItem: Bool { ["53190:295267", "79180:42849"].contains(componentID) }
    private var sampleText: String {
        if size == .medium {
            return "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        }
        let ending = isNumbered ? "ex. " : "ex "
        return "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip \(ending)"
    }
    private var displayedText: String { text.isEmpty ? sampleText : text }
    private var textBinding: Binding<String> {
        Binding(get: { displayedText }, set: { text = $0 })
    }
    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: componentID).first { variant in
            let system = variant.properties["System"] ?? variant.properties["system"] ?? ""
            guard system.lowercased().hasPrefix("ios") else { return false }
            let figmaSize = variant.properties["Size"] ?? variant.properties["size"]
            return figmaSize == size.rawValue || (figmaSize == "Body S" && size == .small)
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Group {
                if isSingleItem {
                    TUIListItem(displayedText, size: size, marker: isNumbered ? .number("1.") : .bullet)
                } else {
                    TUIList(
                        Array(repeating: displayedText, count: count),
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
            TextField("Текст", text: textBinding, axis: .vertical)
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
                LabeledContent("Figma node", value: TUISystemSwitchVariant.current(isOn: isOn, isEnabled: isEnabled).figmaNodeID)
            } else if componentID == "9151:1662" {
                Toggle("Показывать заголовок", isOn: $showsActionSheetTitle)
                TextField("Текст шторки", text: $actionSheetTitle, axis: .vertical)
                LabeledContent("Figma node", value: TUISystemActionSheetVariant.current.figmaNodeID)
            } else if componentID == "24689:584469" {
                Toggle("Три действия", isOn: $hasThirdAction)
                Toggle("Тёмная тема", isOn: $isDark)
                TextField("Заголовок", text: $alertTitle)
                TextField("Описание", text: $alertMessage)
            } else if componentID == "53362:296599" || componentID == "44720:304564" {
                Toggle("Тёмная тема", isOn: $isDark)
                if componentID == "53362:296599" {
                    LabeledContent("Figma node", value: TUISystemContextMenuVariant(isDarkMode: isDark).figmaNodeID)
                } else if componentID == "44720:304564" {
                    LabeledContent("Figma node", value: TUISystemShareSheetVariant(isDarkMode: isDark).figmaNodeID)
                }
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
            LabeledContent("Figma node", value: type.figmaNodeID)
                .font(.caption)
                .accessibilityIdentifier("bulletFigmaNode")
        }
    }
}

private struct TUITextExpandablePlayground: View {
    @State private var text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    @State private var size: TUITextExpandable.Size = .bodyMedium
    @State private var style: TUITextExpandable.Style = .primary
    @State private var showsMoreButton = true
    @State private var isSkeleton = false
    @State private var previewHeight: CGFloat = 106

    private var component: TUITextExpandable {
        TUITextExpandable(text, size: size, style: style, showsMoreButton: showsMoreButton, isSkeleton: isSkeleton)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x3) {
            ScrollView(.horizontal) {
                component
                    .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { previewHeight = $0 }
            }
            .scrollIndicators(.hidden)
            .frame(height: previewHeight)
            VStack(alignment: .leading, spacing: TUISpacing.x3) {
                if !isSkeleton {
                    TextField("Текст компонента", text: $text, axis: .vertical)
                        .lineLimit(2...5)
                    Picker("Размер", selection: $size) {
                        ForEach(TUITextExpandable.Size.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    Picker("Стиль", selection: $style) {
                        ForEach(TUITextExpandable.Style.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    Toggle("Кнопка «еще»", isOn: $showsMoreButton)
                } else {
                    Picker("Размер", selection: $size) {
                        ForEach(TUITextExpandable.Size.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                }
                Toggle("Скелетон", isOn: $isSkeleton)
                LabeledContent("Figma node", value: component.figmaNodeID ?? "Нет такой комбинации")
                    .font(.caption)
                    .accessibilityIdentifier("textExpandableFigmaNode")
            }
            .padding(.horizontal, TUISpacing.x4)
        }
        .padding(.vertical, TUISpacing.x2)
        .onChange(of: isSkeleton) { _, enabled in
            if enabled { style = .primary }
        }
    }
}

private struct TUISwipeActionsCatalogDetail: View {
    @State private var contents: TUISwipeContents = .cell
    @State private var actionCount = 2
    @State private var lastAction = "Свайпните строку влево"

    private var actions: [TUISwipeAction] {
        let options: [(String, String)] = [("Избранное", "star.fill"), ("Поделиться", "square.and.arrow.up"), ("Удалить", "trash")]
        return options.prefix(actionCount).enumerated().map { index, item in
            TUISwipeAction(item.0, systemImage: item.1, role: index == 2 ? .destructive : nil) {
                lastAction = item.0
            }
        }
    }

    var body: some View {
        List {
            Section("Живой компонент · iOS свайп") {
                HStack(spacing: TUISpacing.x3) {
                        Image(systemName: contents == .cell ? "person.crop.circle.fill" : "creditcard.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(TUIColor.action)
                        VStack(alignment: .leading, spacing: TUISpacing.x1) {
                            Text(contents == .cell ? "Название ячейки" : "Основная карта")
                                .tuiTypography(contents == .cell ? .bodyMedium : .bodyMediumBold)
                                .foregroundStyle(TUIColor.textPrimary)
                            Text(contents == .cell ? "Описание" : "•• 1234 · T‑Bank Black")
                                .tuiTypography(.bodySmall)
                                .foregroundStyle(TUIColor.textSecondary)
                        }
                        Spacer(minLength: 0)
                }
                .padding(.horizontal, TUISpacing.x4)
                .frame(maxWidth: .infinity, minHeight: contents == .cell ? 56 : 80, alignment: .leading)
                .background(TUIColor.backgroundPrimary)
                .contentShape(Rectangle())
                .tuiSwipeActions(actions)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            Section("Вариант Figma") {
            Picker("Содержимое", selection: $contents) {
                    ForEach(TUISwipeContents.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Picker("Число действий", selection: $actionCount) {
                ForEach(1...3, id: \.self) { Text("\($0)").tag($0) }
            }
            LabeledContent("Figma node", value: contents.figmaNodeID)
                .font(.caption)
                .accessibilityIdentifier("swipeActionsFigmaNode")
            }
            Section("Проверка действия") {
                Text(lastAction)
                    .font(.caption)
                    .accessibilityIdentifier("swipeActionsLastAction")
            }
            Section("Платформа") {
                LabeledContent("Поддерживаемые iOS-варианты", value: "2 · Cell и Card")
                LabeledContent("Исходная спецификация", value: "tui-swipe-actions")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("tui-swipe-actions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TUICounterPlayground: View {
    @State private var value = 2
    @State private var size: TUICounter.Size = .large
    @State private var preset: TUICounter.Preset = .primary

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            HStack {
                Spacer(minLength: 0)
                TUICounter(value: $value, size: size, preset: preset)
                Spacer(minLength: 0)
            }
            .padding(.vertical, TUISpacing.x4)
            Picker("Размер", selection: $size) {
                ForEach(TUICounter.Size.allCases, id: \.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            Picker("Вариант", selection: $preset) {
                ForEach(TUICounter.Preset.allCases, id: \.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            Stepper("Значение: \(value) шт", value: $value)
            LabeledContent("Figma node", value: TUICounter(value: $value, size: size, preset: preset).figmaNodeID)
                .font(.caption)
                .accessibilityIdentifier("counterFigmaNode")
        }
    }
}

private struct TUILoaderPlayground: View {
    @State private var size: TUILoaderSize = .x24
    @State private var customSize = false
    @State private var diameter: Double = 28
    @State private var customThickness = false
    @State private var thickness: Double = 3
    @State private var color = "Исходный"
    @State private var isAnimating = true

    private var selectedColor: Color? {
        switch color {
        case "Action": TUIColor.action
        case "Text Primary": TUIColor.textPrimary
        case "Negative": TUIColor.negative
        default: nil
        }
    }

    var body: some View {
        VStack(spacing: TUISpacing.x6) {
            TUILoader(size: size, color: selectedColor,
                      diameter: customSize ? CGFloat(diameter) : nil,
                      lineWidth: customThickness ? CGFloat(thickness) : nil,
                      isAnimating: isAnimating)
                .frame(maxWidth: .infinity)
                .frame(height: TUISpacing.x16 + TUISpacing.x6)
                .background(TUIColor.backgroundPrimary, in: RoundedRectangle(cornerRadius: TUIRadius.large))
            Picker("Размер", selection: $size) {
                ForEach(TUILoaderSize.allCases, id: \.self) { value in
                    Text("\(value.rawValue) × \(value.rawValue)").tag(value)
                }
            }
            .accessibilityIdentifier("loaderSizePicker")
            Picker("Цвет", selection: $color) {
                ForEach(["Исходный", "Action", "Text Primary", "Negative"], id: \.self) { Text($0).tag($0) }
            }
            .accessibilityIdentifier("loaderColorPicker")
            Toggle("Анимация", isOn: $isAnimating).accessibilityIdentifier("loaderAnimationToggle")
            Toggle("Произвольный размер", isOn: $customSize).accessibilityIdentifier("loaderCustomSizeToggle")
            if customSize {
                Stepper("Диаметр: \(Int(diameter))", value: $diameter, in: 12...80, step: 2)
                    .accessibilityIdentifier("loaderDiameterStepper")
            }
            Toggle("Произвольная толщина", isOn: $customThickness).accessibilityIdentifier("loaderCustomThicknessToggle")
            if customThickness {
                Stepper("Толщина: \(thickness.formatted())", value: $thickness, in: 1.5...12, step: 0.5)
                    .accessibilityIdentifier("loaderThicknessStepper")
            }
            LabeledContent("Figma variant", value: size.figmaNodeID)
            Text("Линия: 2 с рост + 2 с уменьшение. Вращение: оборот за 2 с. Остановка показывает исходную позу.")
                .font(.caption).foregroundStyle(TUIColor.textSecondary)
        }
    }
}

private struct TUIRowCardMediumPlayground: View {
    @State private var preset: TUIRowCardMediumPreset = .x140
    @State private var title = "Title"
    @State private var subtitle = "Subtitle"

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            TUIRowCardMedium(
                preset: preset,
                titles: Array(repeating: title, count: 5),
                subtitles: Array(repeating: subtitle, count: 5)
            )
            .frame(height: preset.dimension)

            Picker("Размер карточки", selection: $preset) {
                ForEach(TUIRowCardMediumPreset.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            TextField("Заголовок", text: $title)
            if preset == .x140 {
                TextField("Подзаголовок", text: $subtitle)
            }
            LabeledContent("Figma variant", value: preset.figmaNodeID)
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
    @State private var value = 0
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
                .background(TUIColor.named("Background/Neutral 1 Opaque"), in: RoundedRectangle(cornerRadius: 16))
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
    @State private var theme = TUITheme.day
    @State private var width = 40.0
    @State private var height = 40.0
    @State private var isAnimating = true

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "37840:45833").first { variant in
            variant.properties["keyframe"] == keyframe.rawValue
        }
    }

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            TUISkeleton(keyframe: keyframe, width: width, height: height, isAnimating: isAnimating)
                .frame(maxWidth: .infinity)
                .frame(height: max(88, height + TUISpacing.x8))
                .background(TUIColor.backgroundPrimary, in: RoundedRectangle(cornerRadius: TUIRadius.large))
                .environment(\.colorScheme, theme == .day ? .light : .dark)
            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id)
                    .font(.caption)
            }
            Toggle("Анимация", isOn: $isAnimating)
            Picker("Начальный кадр", selection: $keyframe) {
                ForEach(TUISkeletonKeyframe.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            Stepper("Ширина: \(Int(width)) pt", value: $width, in: 0...280, step: 4)
            Stepper("Высота: \(Int(height)) pt", value: $height, in: 0...120, step: 4)
            Picker("Тема", selection: $theme) {
                ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            NavigationLink("Оба кадра · Day и Night") {
                TUISkeletonVariantMatrix()
            }
        }
    }
}

private struct TUISkeletonVariantMatrix: View {
    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            HStack(spacing: TUISpacing.x4) {
                Text("Кадр").frame(width: 72, alignment: .leading)
                Text("Day").frame(width: 88)
                Text("Night").frame(width: 88)
            }
            ForEach(TUISkeletonKeyframe.allCases, id: \.self) { keyframe in
                HStack(spacing: TUISpacing.x4) {
                    Text(keyframe.rawValue).frame(width: 72, alignment: .leading)
                    ForEach(TUITheme.allCases, id: \.self) { theme in
                        TUISkeleton(keyframe: keyframe, isAnimating: false)
                            .frame(width: 88, height: 72)
                            .background(TUIColor.backgroundPrimary)
                            .environment(\.colorScheme, theme == .day ? .light : .dark)
                    }
                }
            }
            Spacer()
        }
        .padding(TUISpacing.x4)
        .navigationTitle("Skeleton · матрица")
        .navigationBarTitleDisplayMode(.inline)
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
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Checkbox")
                .accessibilityValue("Выбрано", isEnabled: state == .selected || state == .selectedDisabled)
                .accessibilityAddTraits(state == .disabled || state == .selectedDisabled ? [] : .isButton)
                .accessibilityAction {
                    guard state != .disabled && state != .selectedDisabled else { return }
                    state = state == .normal || state == .indeterminate ? .selected : .normal
                }
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
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Radio button")
                .accessibilityValue("Выбрано", isEnabled: state == .selected || state == .selectedDisabled)
                .accessibilityAddTraits(state == .disabled || state == .selectedDisabled ? [] : .isButton)
                .accessibilityAction {
                    guard state != .disabled && state != .selectedDisabled else { return }
                    state = .selected
                }
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
    @State private var iconResource = "Исходная"
    @State private var smallIconResource = "Исходная"
    @State private var backgroundToken = "Исходный"
    @State private var textToken = "Исходный"
    @State private var iconToken = "Исходный"
    @State private var isRound = false
    @State private var hasFixedWidth = false
    @State private var fixedWidth = 240.0
    @State private var mediumFitsContent = false
    @State private var sensitiveText = ""

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
                showsLabel: showsLabel,
                icon: iconResource == "Исходная" ? nil : Image(iconResource, bundle: TUIResources.bundle),
                smallIcon: smallIconResource == "Исходная" ? nil : Image(smallIconResource, bundle: TUIResources.bundle),
                backgroundColor: overrideColor(backgroundToken),
                textColor: overrideColor(textToken),
                iconColor: overrideColor(iconToken),
                cornerRadius: isRound && size != .small ? TUIRadius.round : nil,
                width: hasFixedWidth ? fixedWidth : nil,
                sensitiveText: sensitiveText.isEmpty ? nil : sensitiveText
            ) {
                tapCount += 1
            }
            .fixedSize(horizontal: size == .medium && mediumFitsContent && !hasFixedWidth, vertical: false)
            .accessibilityIdentifier("buttonPlaygroundComponent")
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
            TextField("Скрываемая часть текста", text: $sensitiveText)
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
            .accessibilityIdentifier("buttonSizePicker")
            if size == .medium {
                Picker("Ширина Medium", selection: $mediumFitsContent) {
                    Text("На всю ширину").tag(false)
                    Text("По содержимому").tag(true)
                }
                .pickerStyle(.segmented)
                .disabled(hasFixedWidth)
                .accessibilityIdentifier("buttonMediumWidthPicker")
            }
            Picker("Состояние", selection: $state) {
                ForEach(TUIButtonState.allCases, id: \.self) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .accessibilityIdentifier("buttonStatePicker")
            Toggle("Иконка", isOn: $showsIcon)
            Toggle("Текст", isOn: $showsLabel)
            Toggle("Skeleton", isOn: $skeleton)
                .disabled(appearance != .primary || state != .normal)
            DisclosureGroup("Кастомизация по спецификации") {
                Text("Сначала выберите готовое оформление. Изменение цветов — исключение, предусмотренное спецификацией.")
                    .font(.caption).foregroundStyle(.secondary)
                Picker("Иконка Large/Medium", selection: $iconResource) {
                    Text("Исходная").tag("Исходная")
                    Text("Стрелка в круге").tag("tui-link-arrow-right-circle")
                    Text("Закрыть").tag("tui-button-close-cross")
                }
                Picker("Иконка Small", selection: $smallIconResource) {
                    Text("Исходная").tag("Исходная")
                    Text("Стрелка в круге").tag("tui-link-arrow-right-circle")
                    Text("Закрыть").tag("tui-button-close-cross")
                }
                Picker("Фон", selection: $backgroundToken) {
                    ForEach(["Исходный", "Background/Neutral 1", "Background/Accent 1", "Background/Accent 2"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
                Picker("Текст", selection: $textToken) {
                    ForEach(["Исходный", "Text/Action", "Text/Primary", "Text/Negative"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
                Picker("Цвет иконки", selection: $iconToken) {
                    ForEach(["Исходный", "Text/Action", "Text/Primary", "Status/Positive"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
                Toggle("Круглая форма Large/Medium", isOn: $isRound).disabled(size == .small)
                Toggle("Задать ширину", isOn: $hasFixedWidth)
                if hasFixedWidth {
                    Slider(value: $fixedWidth, in: 120...330, step: 1)
                    LabeledContent("Ширина", value: "\(Int(fixedWidth)) pt")
                }
            }
        }
        .onChange(of: appearance) { _, newValue in
            if newValue != .primary { skeleton = false }
        }
        .onChange(of: state) { _, newValue in
            if newValue != .normal { skeleton = false }
        }
    }

    private func overrideColor(_ token: String) -> Color? {
        token == "Исходный" ? nil : TUIColor.named(token)
    }
}

private struct TUISocialButtonPlayground: View {
    let isLike: Bool
    @State private var appearance = TUISocialButtonAppearance.secondary
    @State private var state = TUISocialButtonState.normal
    @State private var selected = false
    @State private var theme = TUITheme.day
    @State private var typeSize = DynamicTypeSize.large
    @State private var label = ""
    @State private var taps = 0

    private var nodeID: String {
        if isLike {
            TUIButtonLike(isSelected: .constant(selected), appearance: appearance, state: state).figmaNodeID
        } else {
            TUIButtonShare(appearance: appearance, state: state) {}.figmaNodeID
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            Group {
                if isLike {
                    TUIButtonLike(isSelected: $selected, appearance: appearance, state: state,
                        accessibilityLabel: label.isEmpty ? "В избранное" : label) { taps += 1 }
                } else {
                    TUIButtonShare(appearance: appearance, state: state,
                        accessibilityLabel: label.isEmpty ? "Поделиться" : label) { taps += 1 }
                }
            }
            .dynamicTypeSize(typeSize)
            .padding(TUISpacing.x8)
            .frame(maxWidth: .infinity)
            .background(appearance == .glassOnDark || theme == .night ? Color.black : .white)
            .environment(\.colorScheme, theme == .day ? .light : .dark)
            .clipShape(RoundedRectangle(cornerRadius: TUIRadius.large))
            Picker("Оформление", selection: $appearance) {
                ForEach(TUISocialButtonAppearance.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            Picker("Состояние для сравнения", selection: $state) {
                ForEach(TUISocialButtonState.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            if isLike { Toggle("Выбрано", isOn: $selected) }
            Picker("Тема", selection: $theme) {
                ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            Picker("Dynamic Type", selection: $typeSize) {
                Text("Default").tag(DynamicTypeSize.large)
                Text("XXXL").tag(DynamicTypeSize.xxxLarge)
                Text("AX1").tag(DynamicTypeSize.accessibility1)
                Text("AX5").tag(DynamicTypeSize.accessibility5)
            }
            TextField("Озвучка кнопки", text: $label)
            LabeledContent("Нажатий", value: String(taps))
            LabeledContent("Figma node", value: nodeID).font(.caption)
            NavigationLink("Все состояния · Day и Night") {
                TUISocialButtonVariantMatrix(isLike: isLike)
            }
        }
    }
}

private struct TUISocialButtonVariantMatrix: View {
    let isLike: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: TUISpacing.x4) {
                ForEach(TUISocialButtonAppearance.allCases, id: \.self) { appearance in
                    ForEach(TUISocialButtonState.allCases, id: \.self) { state in
                        ForEach(isLike ? [false, true] : [false], id: \.self) { selected in
                            VStack(alignment: .leading, spacing: TUISpacing.x2) {
                                Text("\(appearance.rawValue) · \(state.rawValue)\(isLike ? (selected ? " · on" : " · off") : "")")
                                    .font(.caption)
                                HStack(spacing: TUISpacing.x4) {
                                    ForEach(TUITheme.allCases, id: \.self) { theme in
                                        VStack(spacing: TUISpacing.x2) {
                                            Text(theme.rawValue).font(.caption)
                                            Group {
                                                if isLike {
                                                    TUIButtonLike(isSelected: .constant(selected),
                                                        appearance: appearance, state: state)
                                                } else {
                                                    TUIButtonShare(appearance: appearance, state: state) {}
                                                }
                                            }
                                            .padding(TUISpacing.x5)
                                            .background(appearance == .glassOnDark || theme == .night ? Color.black : .white)
                                            .environment(\.colorScheme, theme == .day ? .light : .dark)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding(TUISpacing.x4)
        }
        .navigationTitle(isLike ? "Like · матрица" : "Share · матрица")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TUIButtonClosePlayground: View {
    @State private var size = TUIButtonClose.Size.small
    @State private var environment = TUIButtonClose.Environment.onBase
    @State private var theme = TUITheme.day
    @State private var typeSize = DynamicTypeSize.large
    @State private var label = "Закрыть"
    @State private var taps = 0

    private var component: TUIButtonClose {
        TUIButtonClose(size: size, environment: environment, theme: theme,
                       accessibilityLabel: label) { taps += 1 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            component
                .dynamicTypeSize(typeSize)
                .padding(TUISpacing.x8)
                .frame(maxWidth: .infinity)
                .background(environment == .onDark || (environment == .onBase && theme == .night) ? Color.black : .white)
                .clipShape(RoundedRectangle(cornerRadius: TUIRadius.large))
            Picker("Размер", selection: $size) {
                ForEach(TUIButtonClose.Size.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            Picker("Фон", selection: $environment) {
                ForEach(TUIButtonClose.Environment.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            if environment == .onBase {
                Picker("Theme", selection: $theme) {
                    Text("light").tag(TUITheme.day)
                    Text("dark").tag(TUITheme.night)
                }
            }
            Picker("Dynamic Type", selection: $typeSize) {
                Text("Default").tag(DynamicTypeSize.large)
                Text("AX1").tag(DynamicTypeSize.accessibility1)
                Text("AX5").tag(DynamicTypeSize.accessibility5)
            }
            TextField("Озвучка кнопки", text: $label)
            LabeledContent("Нажатий", value: String(taps))
                .accessibilityIdentifier("closeButtonTapCount")
            LabeledContent("Figma node", value: component.figmaNodeID)
                .font(.caption)
                .accessibilityIdentifier("closeButtonFigmaNode")
        }
        .padding(.vertical, TUISpacing.x2)
    }
}

private struct TUIButtonWalletPlayground: View {
    @State private var prefix = "Добавить в "
    @State private var tapCount = 0
    @State private var previewTypeSize = DynamicTypeSize.large

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            VStack(spacing: TUISpacing.x4) {
                TUIButtonWallet(size: .large, prefix: prefix) { tapCount += 1 }
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier("walletLargeButton")
                LabeledContent("Figma node · L", value: TUIButtonWallet.Size.large.figmaNodeID)
                    .font(.caption)
                TUIButtonWallet(size: .medium, prefix: prefix) { tapCount += 1 }
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier("walletMediumButton")
                LabeledContent("Figma node · M", value: TUIButtonWallet.Size.medium.figmaNodeID)
                    .font(.caption)
            }
            .dynamicTypeSize(previewTypeSize)
            Picker("Размер текста", selection: $previewTypeSize) {
                Text("Default").tag(DynamicTypeSize.large)
                Text("AX1").tag(DynamicTypeSize.accessibility1)
                Text("AX5").tag(DynamicTypeSize.accessibility5)
            }
            .accessibilityIdentifier("walletDynamicType")
            TextField("Подпись перед Apple Wallet", text: $prefix)
                .accessibilityIdentifier("walletButtonPrefix")
            Text("Нажатий: \(tapCount)")
                .font(.caption)
                .accessibilityIdentifier("walletButtonTapCount")
        }
        .padding(.vertical, TUISpacing.x2)
    }
}

private struct TUIBlockStatusPlayground: View {
    @State private var type: TUIBlockStatusType = .fullscreen
    @State private var isDark = false
    @State private var showsButton = true
    @State private var showsSecondaryButton = false
    @State private var showsImage = true
    @State private var showsTitle = true
    @State private var showsText = true
    @State private var title = "Title"
    @State private var text = "Text"
    @State private var lastAction = ""

    private var selectedVariant: TUIComponentVariantReference? {
        TUILibraryCatalog.shared.variants(for: "43816:296648").first { variant in
            let system = variant.properties["System"] ?? variant.properties["system"] ?? ""
            let typeValue = variant.properties["Type"] ?? variant.properties["type"]
            let buttonValue = variant.properties["Button"] ?? variant.properties["button"]
            return system.lowercased() == "ios"
                && typeValue == type.rawValue
                && buttonValue == (showsButton ? "on" : "off")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            TUIBlockStatus(
                type: type,
                title: title,
                text: text,
                showsButton: showsButton,
                showsSecondaryButton: showsSecondaryButton,
                showsImage: showsImage,
                showsTitle: showsTitle,
                showsText: showsText,
                primaryAction: { lastAction = "Primary action" },
                secondaryAction: { lastAction = "Secondary action" }
            )
            .frame(maxWidth: .infinity)

            if let selectedVariant {
                LabeledContent("Figma node", value: selectedVariant.id).font(.caption)
            }
            Picker("Вариант", selection: $type) {
                ForEach(TUIBlockStatusType.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            Toggle("Тёмная тема", isOn: $isDark)
            Toggle("Кнопка", isOn: $showsButton)
            Toggle("Вторая кнопка", isOn: $showsSecondaryButton)
            Toggle("Иллюстрация", isOn: $showsImage)
            Toggle("Заголовок", isOn: $showsTitle)
            Toggle("Описание", isOn: $showsText)
            TextField("Заголовок", text: $title)
            TextField("Описание", text: $text, axis: .vertical)
            if !lastAction.isEmpty {
                Text("Нажата: \(lastAction)").font(.caption).foregroundStyle(.secondary)
            }
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

private struct TUIPagerPlayground: View {
    @State private var size = TUIPager.Size.small
    @State private var pages = 8
    @State private var selection = 0
    @State private var theme = TUITheme.day

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            TabView(selection: $selection) {
                ForEach(0..<pages, id: \.self) { page in
                    Text("Страница \(page + 1)")
                        .tuiTypography(.bodyLarge)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(TUIColor.backgroundNeutral)
                        .clipShape(RoundedRectangle(cornerRadius: TUIRadius.large))
                        .padding(.horizontal, TUISpacing.x4)
                        .tag(page)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 120)
            TUIPager(pages: pages, selection: $selection, size: size)
                .frame(width: 360)
                .padding(.vertical, TUISpacing.x3)
                .background(TUIColor.backgroundPrimary)
                .environment(\.colorScheme, theme == .day ? .light : .dark)
            Text("Листайте карточки или выберите страницу ниже")
                .font(.caption)
                .foregroundStyle(.secondary)
            NavigationLink("Матрица всех 10 вариантов") {
                TUIPagerVariantMatrix()
            }
            Picker("Размер", selection: $size) {
                ForEach(TUIPager.Size.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            Stepper("Страниц: \(pages)", value: $pages, in: 2...30)
            Stepper("Страница: \(selection + 1)", value: $selection, in: 0...(pages - 1))
            Picker("Тема", selection: $theme) {
                ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            LabeledContent("Figma node", value: size.figmaNodeID(pages: pages) ?? "Нет варианта")
                .font(.caption.monospaced())
        }
        .onChange(of: pages) { _, new in selection = min(selection, new - 1) }
    }
}

private struct TUIPagerVariantMatrix: View {
    var body: some View {
        ScrollView {
            VStack(spacing: TUISpacing.x4) {
                ForEach(TUIPager.Size.allCases, id: \.self) { size in
                    VStack(spacing: TUISpacing.x3) {
                        Text(size.rawValue).font(.headline)
                        ForEach(2...6, id: \.self) { count in
                            VStack(spacing: TUISpacing.x1) {
                                Text("\(count == 6 ? "6+" : String(count)) · \(size.figmaNodeID(pages: count) ?? "")")
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                                TUIPager(pages: count, selection: .constant(0), size: size)
                                    .frame(width: 360)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, TUISpacing.x4)
            .frame(maxWidth: .infinity)
        }
        .background(TUIColor.backgroundPrimary)
        .environment(\.colorScheme, .light)
        .navigationTitle("Pager · матрица iOS")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TUISkeletonTextPlayground: View {
    @State private var isAnimating = true
    @State private var style = TUISkeletonText.TextStyle.headingLarge
    @State private var width = 92.0
    @State private var theme = TUITheme.day

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            TUISkeletonText(textStyle: style, width: width, isAnimating: isAnimating)
                .frame(maxWidth: .infinity)
                .padding(TUISpacing.x4)
                .background(TUIColor.backgroundPrimary)
                .environment(\.colorScheme, theme == .day ? .light : .dark)
            Toggle("Анимация", isOn: $isAnimating)
            Picker("Стиль текста", selection: $style) {
                ForEach(TUISkeletonText.TextStyle.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            Stepper("Ширина: \(Int(width)) pt", value: $width, in: 0...280, step: 4)
            Picker("Тема", selection: $theme) {
                ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            LabeledContent("Figma node", value: style.figmaNodeID)
                .font(.caption.monospaced())
            NavigationLink("Матрица всех 13 вариантов") {
                TUISkeletonTextVariantMatrix()
            }
        }
    }
}

private struct TUISkeletonTextVariantMatrix: View {
    var body: some View {
        ScrollView {
            VStack(spacing: TUISpacing.x4) {
                ForEach(TUISkeletonText.TextStyle.allCases, id: \.self) { style in
                    HStack(spacing: TUISpacing.x4) {
                        Text(style.rawValue)
                            .font(.caption.monospaced())
                            .frame(width: 140, alignment: .leading)
                        TUISkeletonText(textStyle: style, isAnimating: false)
                    }
                }
            }
            .padding(.vertical, TUISpacing.x4)
            .frame(maxWidth: .infinity)
        }
        .background(TUIColor.backgroundPrimary)
        .environment(\.colorScheme, .light)
        .navigationTitle("Skeleton · матрица iOS")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TUICellCheckiconPlayground: View {
    @State private var variant = TUICellCheckicon.Variant.fixedHeight
    @State private var heightMode = TUICellCheckicon.HeightMode.standard
    @State private var title = "Title"
    @State private var description = "Description"
    @State private var caption = "Caption"
    @State private var showAvatar = true
    @State private var showCaption = false
    @State private var showDescription = true
    @State private var selected = true
    @State private var expands = true
    @State private var typeSize = DynamicTypeSize.large
    @State private var count = 0

    @State private var theme = TUITheme.day
    @State private var reduceMotion = false
    @State private var customAvatar = false
    @State private var contentAlignment = TUICellCheckicon.ContentAlignment.top
    @State private var horizontalInset = TUISpacing.x4
    @State private var measuredSize = CGSize.zero

    private var layoutOptions: TUICellCheckicon.LayoutOptions {
        .init(leadingInset: horizontalInset, trailingInset: horizontalInset,
              avatarAlignment: contentAlignment, textAlignment: contentAlignment,
              accessoryAlignment: contentAlignment)
    }

    private var avatarOverride: AnyView? {
        guard customAvatar else { return nil }
        return AnyView(
            VStack(spacing: TUISpacing.x2) {
                Image("tui-cell-checkicon-star", bundle: .module).renderingMode(.template).resizable()
                    .frame(width: TUISpacing.x6, height: TUISpacing.x6)
                Text("Счёт").font(.body)
            }
            .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
            .frame(width: 300, height: 100)
            .background(TUIColor.named("Background/Accent 2"), in: RoundedRectangle(cornerRadius: TUIRadius.medium))
        )
    }

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            ScrollView(.horizontal) {
                TUICellCheckicon(title: title, description: description, caption: caption,
                                 variant: variant, heightMode: heightMode, layout: layoutOptions, showAvatar: showAvatar, showCaption: showCaption,
                                 showDescription: showDescription, showSelected: selected,
                                 expandsAtAccessibilitySize: expands, avatar: avatarOverride) {
                    selected.toggle()
                    count += 1
                }
                .frame(width: 375)
                .environment(\.dynamicTypeSize, typeSize)
                .environment(\.tuiCellCheckiconReduceMotionPreview, reduceMotion)
                .background(TUIColor.named("Background/Base"))
                .environment(\.colorScheme, theme == .night ? .dark : .light)
                .onGeometryChange(for: CGSize.self) { $0.size } action: { measuredSize = $0 }
            }
            VStack(spacing: TUISpacing.x3) {
                Text("Нажатий: \(count)")
                Text("Размер: \(Int(measuredSize.width)) × \(Int(measuredSize.height))").font(.caption.monospaced())
                Picker("Вариант", selection: $variant) {
                    Text("fixed-height on").tag(TUICellCheckicon.Variant.fixedHeight)
                    Text("fixed-height off").tag(TUICellCheckicon.Variant.flexibleHeight)
                    Text("skeleton on").tag(TUICellCheckicon.Variant.skeleton)
                }
                Picker("Режим высоты", selection: $heightMode) {
                    ForEach(TUICellCheckicon.HeightMode.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                Picker("Тема", selection: $theme) {
                    ForEach(TUITheme.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                Picker("Dynamic Type", selection: $typeSize) {
                    Text("Default").tag(DynamicTypeSize.large)
                    Text("AX1").tag(DynamicTypeSize.accessibility1)
                    Text("AX5").tag(DynamicTypeSize.accessibility5)
                }.pickerStyle(.segmented)
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                TextField("Caption", text: $caption)
                Toggle("show-avatar", isOn: $showAvatar)
                Toggle("show-caption", isOn: $showCaption)
                Toggle("show-description", isOn: $showDescription)
                Toggle("show-selected", isOn: $selected)
                Toggle("Полный текст при AX1", isOn: $expands)
                DisclosureGroup("Настройки компоновки") {
                    Toggle("Большой аватар", isOn: $customAvatar)
                    Toggle("Reduce Motion", isOn: $reduceMotion)
                    Picker("Выравнивание", selection: $contentAlignment) {
                        ForEach(TUICellCheckicon.ContentAlignment.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }
                    Stepper("Боковые отступы: \(Int(horizontalInset))", value: $horizontalInset, in: 0...40, step: 4)
                }
                LabeledContent("Figma node", value: variant.figmaNodeID).font(.caption.monospaced())
                NavigationLink("Примеры компоновки и доступности") {
                    TUICellCheckiconLayoutExamples()
                }
                NavigationLink("Матрица всех 3 вариантов") {
                    TUICellCheckiconVariantMatrix()
                }
            }.padding(.horizontal, TUISpacing.x4)
        }.padding(.vertical, TUISpacing.x4)
    }
}

private struct TUICellCheckiconLayoutExamples: View {
    private enum Example: String, CaseIterable {
        case center = "Центрирование"
        case asymmetric = "Разные отступы"
        case typography = "Типографика"
        case accessory = "Правый блок"
        case reflow = "Правый блок под текстом"
        case fixedAX = "Одна строка при AX1 / AX5"
    }
    @State private var example = Example.center
    @State private var count = 0
    private let longTitle = "Длинный заголовок ячейки, который должен полностью переноситься при увеличении шрифта"

    private var avatar: AnyView {
        AnyView(Rectangle().fill(TUIColor.named("Background/Accent 2"))
            .frame(width: 80, height: 100))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: TUISpacing.x6) {
                Picker("Пример", selection: $example) {
                    ForEach(Example.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }.padding(.horizontal, TUISpacing.x4)
                switch example {
                case .center:
                    Text("top").font(.caption)
                    TUICellCheckicon(avatar: avatar) { count += 1 }.frame(width: 375)
                    Text("center").font(.caption)
                    TUICellCheckicon(layout: .init(avatarAlignment: .center, textAlignment: .center, accessoryAlignment: .center),
                                     avatar: avatar) { count += 1 }.frame(width: 375)
                case .asymmetric:
                    Text("Слева 32, справа 8; вертикальные отступы 12").font(.caption)
                    TUICellCheckicon(layout: .init(leadingInset: TUISpacing.x8, trailingInset: TUISpacing.x2,
                                                  textVerticalInset: TUISpacing.x3, accessoryVerticalInset: TUISpacing.x3)) {
                        count += 1
                    }.frame(width: 375)
                case .typography:
                    Text("Body M Bold / Text Positive; UI S / Text Action").font(.caption)
                    TUICellCheckicon(textOptions: .init(title: .init(role: .bodyMediumBold, color: TUIColor.positive),
                                                       description: .init(role: .uiSmall, color: TUIColor.action))) {
                        count += 1
                    }.frame(width: 375)
                case .accessory:
                    Text("Замена правого содержимого").font(.caption)
                    TUICellCheckicon(accessory: AnyView(Text("42").tuiTypography(.uiSmall)
                        .foregroundStyle(TUIColor.action))) { count += 1 }.frame(width: 375)
                case .reflow:
                    Text("AX1 · перенос правого блока выключен").font(.caption)
                    TUICellCheckicon(title: longTitle) { count += 1 }
                        .frame(width: 375).environment(\.dynamicTypeSize, .accessibility1)
                    Text("AX1 · перенос правого блока включён").font(.caption)
                    TUICellCheckicon(title: longTitle, reflowsAccessoryAtAccessibilitySize: true) { count += 1 }
                        .frame(width: 375).environment(\.dynamicTypeSize, .accessibility1)
                case .fixedAX:
                    Text("AX1 · ограничения строк сохранены").font(.caption)
                    TUICellCheckicon(title: longTitle, expandsAtAccessibilitySize: false) { count += 1 }
                        .frame(width: 375).environment(\.dynamicTypeSize, .accessibility1)
                    Text("AX5 · шрифт ограничен AX1").font(.caption)
                    TUICellCheckicon(title: longTitle, expandsAtAccessibilitySize: false) { count += 1 }
                        .frame(width: 375).environment(\.dynamicTypeSize, .accessibility5)
                }
                Text("Нажатий: \(count)")
            }.padding(.vertical, TUISpacing.x4)
        }
        .background(TUIColor.backgroundPrimary)
        .navigationTitle("Checkicon · настройки")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TUICellCheckiconVariantMatrix: View {
    @State private var count = 0
    var body: some View {
        ScrollView {
            VStack(spacing: TUISpacing.x6) {
                ForEach(TUICellCheckicon.Variant.allCases, id: \.self) { variant in
                    VStack(spacing: TUISpacing.x2) {
                        Text(variant.figmaNodeID).font(.caption.monospaced())
                        TUICellCheckicon(variant: variant) { count += 1 }
                            .frame(width: 375)
                    }
                }
                Text("Нажатий: \(count)")
            }.padding(.vertical, TUISpacing.x4)
        }
        .background(TUIColor.named("Background/Base"))
        .environment(\.dynamicTypeSize, .large)
        .navigationTitle("Checkicon · матрица iOS")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TUIButtonAddCardPlayground: View {
    @State private var size = TUIButtonAddCard.Size.large
    @State private var state = TUIButtonAddCard.State.normal
    @State private var typeSize = DynamicTypeSize.large
    @State private var label = "Добавить"
    @State private var hint = "Выпустить карту или открыть счёт"
    @State private var count = 0

    var body: some View {
        VStack(spacing: TUISpacing.x4) {
            TUIButtonAddCard(size: size, state: state, accessibilityLabel: label, accessibilityHint: hint) { count += 1 }
                .environment(\.dynamicTypeSize, typeSize)
                .frame(maxWidth: .infinity, minHeight: 180)
                .background(.black, in: RoundedRectangle(cornerRadius: TUIRadius.large))
            Text("Нажатий: \(count)")
            Picker("Размер", selection: $size) {
                ForEach(TUIButtonAddCard.Size.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            Picker("Состояние", selection: $state) {
                ForEach(TUIButtonAddCard.State.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            Picker("Dynamic Type", selection: $typeSize) {
                Text("Default").tag(DynamicTypeSize.large)
                Text("AX1").tag(DynamicTypeSize.accessibility1)
                Text("AX5").tag(DynamicTypeSize.accessibility5)
            }
            .pickerStyle(.segmented)
            TextField("Описание для озвучки", text: $label)
            TextField("Подсказка", text: $hint)
            LabeledContent("Figma node", value: size.figmaNodeID(state: state))
                .font(.caption.monospaced())
            NavigationLink("Матрица всех 6 вариантов") {
                TUIButtonAddCardVariantMatrix()
            }
        }
    }
}

private struct TUIButtonAddCardVariantMatrix: View {
    @State private var count = 0
    var body: some View {
        ScrollView {
            VStack(spacing: TUISpacing.x5) {
                ForEach(TUIButtonAddCard.Size.allCases, id: \.self) { size in
                    ForEach(TUIButtonAddCard.State.allCases, id: \.self) { state in
                        VStack(spacing: TUISpacing.x2) {
                            Text("\(size.rawValue) · \(state.rawValue)")
                                .font(.caption.monospaced())
                                .foregroundStyle(.white)
                            TUIButtonAddCard(size: size, state: state) { count += 1 }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                Text("Нажатий: \(count)").foregroundStyle(.white)
            }
            .padding(.vertical, TUISpacing.x4)
            .frame(maxWidth: .infinity)
        }
        .background(.black)
        .environment(\.dynamicTypeSize, .large)
        .navigationTitle("Add card · матрица iOS")
        .navigationBarTitleDisplayMode(.inline)
    }
}
