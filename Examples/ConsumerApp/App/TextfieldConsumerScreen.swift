import SwiftUI
import TUIDesignSystem

/// A form assembled through the public package API, with screen-owned data and validation.
struct TextfieldConsumerScreen: View {
    @State private var name = ""
    @State private var fieldState = TUITextfieldState.normal
    @State private var submittedName = ""
    @State private var validationTrigger = 0

    var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x4) {
            TUITextfield(text: $name, state: $fieldState,
                label: "Имя", placeholder: "Как к вам обращаться",
                hintText: "Укажите имя для обращения", errorText: "Введите имя",
                characterLimit: 100, validationTrigger: validationTrigger,
                returnKeyType: .done, onSubmit: submit)
            TUIButton("Продолжить", action: submit)
                .accessibilityIdentifier("consumerTextfieldSubmit")
            if !submittedName.isEmpty {
                Text(submittedName).tuiTypography(.bodyLarge)
                    .accessibilityIdentifier("consumerTextfieldSubmittedValue")
            }
            Spacer()
        }
        .padding(TUISpacing.x4)
        .navigationTitle("Имя")
    }

    private func submit() {
        if name.isEmpty {
            fieldState = .invalid
            validationTrigger += 1
        } else {
            fieldState = .normal
            submittedName = name
        }
    }
}
