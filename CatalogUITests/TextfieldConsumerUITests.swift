import XCTest

/// The independent consumer must be built and installed before this test.
final class TextfieldConsumerUITests: XCTestCase {
    @MainActor func testPublicPackageFormInIndependentConsumerInBothThemes() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        for theme in ["day", "night"] {
            app.launchArguments = ["--textfield-consumer"] + (theme == "night" ? ["--textfield-dark"] : [])
            app.launch()
            let submit = app.buttons["consumerTextfieldSubmit"]
            XCTAssertTrue(submit.waitForExistence(timeout: 5))
            submit.tap()
            XCTAssertTrue(app.staticTexts["Введите имя"].waitForExistence(timeout: 3))
            submit.tap() // Repeat validation without changing value or invalid state.
            XCTAssertTrue(app.staticTexts["Введите имя"].exists)
            let input = app.textFields["tuiTextfieldInput"]
            input.tap(); input.typeText("Alice")
            XCTAssertEqual(input.value as? String, "Alice")
            XCTAssertFalse(app.staticTexts["Введите имя"].exists, "Editing clears the invalid state")
            let done = app.keyboards.buttons["Done"].exists ? app.keyboards.buttons["Done"] : app.keyboards.buttons["Готово"]
            XCTAssertTrue(done.exists); done.tap()
            XCTAssertEqual(app.staticTexts["consumerTextfieldSubmittedValue"].label, "Alice")
            XCTAssertFalse(app.keyboards.firstMatch.exists)
            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "textfield-independent-consumer-\(theme)"; attachment.lifetime = .keepAlways; add(attachment)
            app.terminate()
        }
    }
}
