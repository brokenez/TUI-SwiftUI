import SwiftUI

struct TUITextfieldFormPlayground: View {
    @State private var values = Array(repeating: "", count: 7)
    @State private var states: [TUITextfieldState] = [.normal, .readOnly, .disabled, .normal, .normal, .normal, .normal]
    @State private var tapCount = 0
    @State private var dark = false

    var body: some View {
        TUITextfieldForm(order: (0..<6).map { .field("demo-\($0)") } + [.boundary, .field("demo-6")]) {
            ForEach(0..<6, id: \.self) { index in
                TUITextfield(text: $values[index], state: $states[index], label: "Поле \(index + 1)",
                    placeholder: "Введите значение", hintText: index == 5 ? "Подсказка поля" : nil,
                    action: index == 3 ? { tapCount += 1 } : nil)
                    .tuiTextfieldFormID("demo-\(index)")
            }
            Text("Новая группа").tuiTypography(.bodyLarge)
            TUITextfield(text: $values[6], state: $states[6], label: "Последнее поле")
                .tuiTextfieldFormID("demo-6")
            Text("Нажатий tap-only: \(tapCount)").tuiTypography(.bodyMedium)
        }
        .navigationTitle("Форма Textfield")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { Button(dark ? "Night" : "Day") { dark.toggle() } }
        }
        .preferredColorScheme(dark ? .dark : .light)
    }
}
