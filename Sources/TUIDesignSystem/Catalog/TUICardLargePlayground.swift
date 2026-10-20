import SwiftUI

struct TUICardLargePlayground: View {
    @State private var variant: TUICardLarge.Variant = .customWithFooter
    @State private var childPresses = 0
    @State private var cardPresses = 0
    @State private var usesSingleAction = false
    @State private var pinsFooter = false
    @State private var enlargedText = false

    var body: some View {
        Group {
            Text("Header, Header Subheader и Cell собраны из компонентов пакета. Остальные пресеты показывают слоты для проверки контейнера; полный перенос и визуальная приёмка ещё не завершены.")
                .font(.footnote).foregroundStyle(.secondary)
            Picker("Вариант контейнера", selection: $variant) {
                ForEach(TUICardLarge.Variant.allCases, id: \.self) { value in
                    Text("\(value.preset.rawValue)\(value.isFlat ? " · Flat" : "")\(value.hasFooter ? " · Footer" : "")\(value.isSkeleton ? " · Skeleton" : "")")
                        .tag(value)
                }
            }
            .pickerStyle(.menu)
            .accessibilityIdentifier("cardLargeVariant")
            Toggle("Одно действие всей карточки", isOn: $usesSingleAction)
                .accessibilityIdentifier("cardLargeSingleAction")
            Toggle("Подвал внизу при минимальной высоте", isOn: $pinsFooter)
                .accessibilityIdentifier("cardLargePinFooter")
            Toggle("Увеличенный текст", isOn: $enlargedText)
                .accessibilityIdentifier("cardLargeEnlargedText")
            Group {
                if variant.isSkeleton {
                    TUICardLarge(isSkeletonAnimating: false)
                } else if usesSingleAction {
                    Button { cardPresses += 1 } label: { card(interactive: false) }
                        .buttonStyle(TUICardLargeButtonStyle())
                        .accessibilityIdentifier("cardLargeWholeAction")
                } else {
                    card(interactive: true)
                }
            }
            .environment(\.dynamicTypeSize, enlargedText ? .accessibility1 : .large)
            Text("Действий внутри: \(childPresses)").accessibilityIdentifier("cardLargeChildCount")
            Text("Открытий карточки: \(cardPresses)").accessibilityIdentifier("cardLargeWholeCount")
            Text("Figma: \(variant.figmaNodeID)").font(.caption.monospaced())
        }
    }

    private func card(interactive: Bool) -> some View {
        TUICardLarge(variant: variant,
                    style: .init(minimumHeight: pinsFooter ? 280 : nil,
                                 footerPlacement: pinsFooter ? .bottom : .afterContent)) {
            if [.header, .headerSubheader].contains(variant.preset) {
                TUIHeaderCard(variant: .avatar, showsSubheader: variant.preset == .headerSubheader)
            } else if ![.cell, .cellClose, .cellButton].contains(variant.preset) {
                Text("Сборка карточки").tuiTypography(.headingMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, TUISpacing.x4).padding(.horizontal, TUISpacing.x5)
                    .padding(.bottom, TUISpacing.x3)
            }
        } content: {
            if variant.preset == .cell {
                TUICell()
            } else if ![.header, .headerSubheader].contains(variant.preset) {
                VStack(alignment: .leading, spacing: TUISpacing.x1) {
                    Text("Контент приложения").tuiTypography(.bodyMedium)
                    if interactive {
                        Button("Действие внутри") { childPresses += 1 }
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("cardLargeChildAction")
                    }
                }
                .padding(.horizontal, TUISpacing.x4)
            }
        } footer: {
            if variant.hasFooter {
                if interactive {
                    TUIButton("Действие в подвале", appearance: .secondary, size: .medium) { childPresses += 1 }
                        .accessibilityIdentifier("cardLargeFooterAction")
                } else {
                    Text("Открыть карточку").tuiTypography(.bodyMedium)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
