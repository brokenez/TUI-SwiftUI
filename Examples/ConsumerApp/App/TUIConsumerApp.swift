import SwiftUI
import TUIDesignSystem

@main
struct TUIConsumerApp: App {
    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.arguments.contains("--sensitive-mode-consumer") {
                NavigationStack { SensitiveModeConsumerScreen() }
                    .preferredColorScheme(ProcessInfo.processInfo.arguments.contains("--sensitive-dark") ? .dark : .light)
            } else if ProcessInfo.processInfo.arguments.contains("--floating-container-consumer") {
                NavigationStack { FloatingContainerConsumerScreen() }
                    .preferredColorScheme(ProcessInfo.processInfo.arguments.contains("--floating-dark") ? .dark : .light)
            } else if ProcessInfo.processInfo.arguments.contains("--textfield-form-consumer") {
                NavigationStack { TextfieldFormConsumerScreen() }
                    .preferredColorScheme(ProcessInfo.processInfo.arguments.contains("--textfield-dark") ? .dark : .light)
            } else if ProcessInfo.processInfo.arguments.contains("--textfield-consumer") {
                NavigationStack { TextfieldConsumerScreen() }
                    .preferredColorScheme(ProcessInfo.processInfo.arguments.contains("--textfield-dark") ? .dark : .light)
            } else {
                NavigationStack {
                    if ProcessInfo.processInfo.arguments.contains("--header-card-consumer") {
                        HeaderCardConsumerScreen()
                    } else if ProcessInfo.processInfo.arguments.contains("--header-consumer") {
                        HeaderConsumerScreen()
                    } else { ConsumerScreen() }
                }
            }
        }
    }
}

struct ConsumerScreen: View {
    @State private var isFavorite = false
    @State private var showsShare = false

    var body: some View {
        List {
            Section {
                NavigationLink("Button из пакета") { ButtonConsumerScreen() }
                NavigationLink("Sensitive Mode из пакета") { SensitiveModeConsumerScreen() }
                NavigationLink("Loader из пакета") { LoaderConsumerScreen() }
                NavigationLink("Textfield из пакета") { TextfieldConsumerScreen() }
                NavigationLink("Форма Textfield из пакета") { TextfieldFormConsumerScreen() }
                NavigationLink("Floating Container из пакета") { FloatingContainerConsumerScreen() }
                NavigationLink("Header Large из пакета") { HeaderConsumerScreen() }
                NavigationLink("Card Medium из пакета") { CardMediumConsumerScreen() }
                NavigationLink("Header Card из пакета") { HeaderCardConsumerScreen() }
            }
            Section("Компоненты из подключённого пакета") {
                HStack(spacing: TUISpacing.x4) {
                    TUIButtonLike(isSelected: $isFavorite)
                    TUIButtonShare { showsShare = true }
                    Text(isFavorite ? "В избранном" : "Добавить в избранное")
                }
                .padding(.vertical, TUISpacing.x2)
            }
            Section("Источник") {
                Text("Like: 44290:299175 → 44290:299177")
                Text("Share: 44290:299204")
                Text("Приложение использует публичный API и ресурсы Swift Package. Исходники компонентов сюда не копируются.")
            }
        }
        .navigationTitle("TUI в другом проекте")
        .sheet(isPresented: $showsShare) {
            NavigationStack {
                List {
                    Text("Действие Share дошло до приложения-потребителя")
                }
                .navigationTitle("Поделиться")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Готово") { showsShare = false }
                    }
                }
            }
        }
    }
}
