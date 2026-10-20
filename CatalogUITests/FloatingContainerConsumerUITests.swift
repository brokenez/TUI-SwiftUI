import XCTest

final class FloatingContainerConsumerUITests: XCTestCase {
    @MainActor func testIndependentConsumerCanRunPackageActionsInBothThemes() {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        for theme in ["Day", "Night"] {
            app.launchArguments = ["--floating-container-consumer"] + (theme == "Night" ? ["--floating-dark"] : [])
            app.launch()
            let primary = app.buttons["Продолжить"].firstMatch
            XCTAssertTrue(primary.waitForExistence(timeout: 5)); primary.tap()
            XCTAssertEqual(app.staticTexts["consumerFloatingResult"].label, "Продолжение подтверждено")
            app.buttons["Отмена"].tap()
            XCTAssertEqual(app.staticTexts["consumerFloatingResult"].label, "Ожидаем подтверждение")
            app.switches["consumerFloatingVisibility"].tap()
            XCTAssertTrue(primary.waitForNonExistence(timeout: 3))
            app.switches["consumerFloatingVisibility"].tap()
            XCTAssertTrue(primary.waitForExistence(timeout: 3))
            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "floating-independent-consumer-\(theme)"
            attachment.lifetime = .keepAlways; add(attachment)
            app.terminate()
        }
    }
}
