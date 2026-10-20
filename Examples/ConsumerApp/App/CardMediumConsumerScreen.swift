import SwiftUI
import TUIDesignSystem

/// External consumer: no internal imports, component copies or asset bundle.
struct CardMediumConsumerScreen: View {
    @State private var selected = false
    @State private var showsDetails = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                TUICardMedium("Преимущество", subtitle: "Подробнее", variant: .badgeBottomFill,
                              badgeText: "10%", isSelected: selected) {
                    selected.toggle()
                    showsDetails = true
                }
                Text(selected ? "Преимущество выбрано" : "Нажмите на карточку")
                TUICardMedium("Компании", subtitle: "Три партнёра", variant: .stackTopFill)
                TUICardMedium("Уведомление", subtitle: "Новое сообщение", variant: .avatarBottomFill,
                              notificationText: "1", accessibilityValue: "Одно новое сообщение") {
                    showsDetails = true
                }
            }
            .padding(TUISpacing.x4)
        }
        .navigationTitle("Card Medium из пакета")
        .sheet(isPresented: $showsDetails) {
            NavigationStack {
                Text("Действие карточки обработано приложением")
                    .padding(TUISpacing.x4)
                    .navigationTitle("Преимущество")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Готово") { showsDetails = false }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack { CardMediumConsumerScreen() }
}
