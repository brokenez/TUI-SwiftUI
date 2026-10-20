import SwiftUI
import TUIDesignSystem

/// Independent consumer: the screen owns state and actions; all component
/// rendering and resources come from the public Swift Package.
struct FloatingContainerConsumerScreen: View {
    @State private var didContinue = false
    @State private var isPresented = true
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                Text("Проверьте данные").tuiTypography(.headingMedium)
                Text("Счёт для зачисления: текущий счёт").tuiTypography(.bodyLarge)
                Toggle("Показать действия", isOn: $isPresented)
                    .accessibilityIdentifier("consumerFloatingVisibility")
                Text(didContinue ? "Продолжение подтверждено" : "Ожидаем подтверждение")
                    .tuiTypography(.bodyMedium).accessibilityIdentifier("consumerFloatingResult")
                ForEach(1...10, id: \.self) { index in
                    Text("Пункт условий \(index)").tuiTypography(.bodyLarge)
                        .frame(maxWidth: .infinity, minHeight: TUIControlSize.large, alignment: .leading)
                }
            }.padding(.horizontal, TUISpacing.x4).padding(.top, TUISpacing.x4)
        }
        .tuiFloatingContainer(isPresented: isPresented) {
            TUIFloatingContainer(primary: TUIButton("Продолжить") { didContinue = true },
                secondary: TUIButton("Отмена", appearance: .flat) { didContinue = false })
        }
        .background(TUIColor.backgroundPrimary)
        .navigationTitle("Действия из пакета")
    }
}
