import SwiftUI
import TUIDesignSystem

struct TextfieldFormConsumerScreen: View {
    @State private var values = Array(repeating: "", count: 10)
    @State private var states: [TUITextfieldState] = [.normal, .readOnly, .disabled, .normal] + Array(repeating: .normal, count: 6)
    @State private var tapCount = 0
    @State private var fieldFrames: [Int: CGRect] = [:]

    private let order: [TUITextfieldFormItem] = (0..<9).map { .field("field-\($0)") } + [.boundary, .field("field-9")]

    var body: some View {
        TUITextfieldForm(order: order) {
            Text("Профиль").tuiTypography(.bodyLarge)
                .accessibilityIdentifier("consumerFormHeading")
            ForEach(0..<9, id: \.self) { index in field(index) }
            Text("Другая группа").tuiTypography(.bodyLarge)
                .accessibilityIdentifier("consumerFormBoundary")
            field(9)
            Text("Нажатий: \(tapCount)").tuiTypography(.bodyMedium)
                .accessibilityIdentifier("consumerFormTapCount")
        }
        .navigationTitle("Форма из пакета")
        .toolbar {
            if CommandLine.arguments.contains("--textfield-form-state-probe") {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сменить состояние") { states[0] = states[0] == .readOnly ? .disabled : .readOnly }
                        .accessibilityIdentifier("consumerFormChangeState")
                }
            }
        }
    }

    private func field(_ index: Int) -> some View {
        TUITextfield(text: $values[index], state: $states[index], label: "Поле \(index + 1)",
            placeholder: "Введите значение", hintText: index == 8 ? "Подсказка последнего поля группы" : nil,
            action: index == 3 ? { tapCount += 1 } : nil)
            .tuiTextfieldFormID("field-\(index)")
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("consumerFormField-\(index)")
            // QA metadata: a container's AX frame can omit the hint's empty
            // bottom padding. Preserve that frame and expose actual SwiftUI
            // layout separately, without drawing or replacing the component.
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .global) } action: { fieldFrames[index] = $0 }
            .accessibilityValue(frameDescription(index))
    }

    private func frameDescription(_ index: Int) -> String {
        guard let frame = fieldFrames[index], let data = try? JSONEncoder().encode(
            [frame.minX, frame.minY, frame.width, frame.height]) else { return "Layout not measured" }
        return String(decoding: data, as: UTF8.self)
    }
}
