import SwiftUI
import XCTest
import TUIDesignSystem


struct NameForm: View {
    @State private var name = ""
    @State private var fieldState = TUITextfieldState.normal
    @State private var submittedName = ""
    @State private var validationTrigger = 0

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: TUISpacing.x4) {
                TUITextfield(
                    text: $name,
                    state: $fieldState,
                    label: "Имя",
                    placeholder: "Как к вам обращаться",
                    hintText: "Укажите имя для обращения",
                    errorText: "Введите имя",
                    characterLimit: 100,
                    validationTrigger: validationTrigger,
                    returnKeyType: .done,
                    onSubmit: submit
                )
                TUIButton("Продолжить", action: submit)
                if !submittedName.isEmpty {
                    Text(submittedName).tuiTypography(.bodyLarge)
                }
                Spacer()
            }
            .padding(TUISpacing.x4)
            .navigationTitle("Имя")
        }
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

final class TextfieldAssemblyExampleTests: XCTestCase {
    @MainActor func testDocumentedFormUsesPublicPackageAPI() {
        _ = NameForm().body
    }
    @MainActor func testDocumentedGroupedFormUsesPublicPackageAPI() {
        _ = ProfileForm().body
    }
}

struct ProfileForm: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var city = ""
    @State private var firstState = TUITextfieldState.normal
    @State private var lastState = TUITextfieldState.normal
    @State private var cityState = TUITextfieldState.normal

    var body: some View {
        NavigationStack {
            TUITextfieldForm(order: [.field("first"), .field("last"), .boundary, .field("city")]) {
                TUITextfield(text: $firstName, state: $firstState, label: "Имя")
                    .tuiTextfieldFormID("first")
                TUITextfield(text: $lastName, state: $lastState, label: "Фамилия",
                             hintText: "Как указано в документах")
                    .tuiTextfieldFormID("last")
                Text("Адрес").tuiTypography(.bodyLarge)
                TUITextfield(text: $city, state: $cityState, label: "Город")
                    .tuiTextfieldFormID("city")
            }
            .navigationTitle("Профиль")
        }
    }
}
