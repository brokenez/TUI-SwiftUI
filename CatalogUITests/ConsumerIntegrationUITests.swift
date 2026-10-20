import XCTest

/// The consumer must already be installed on the destination Simulator.
/// It imports the library as a package; this runner does not inject component code.
final class ConsumerIntegrationUITests: XCTestCase {
    @MainActor
    func testIndependentConsumerRetainsLoaderForMinimumVisibleDuration() {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launch()
        let entry = app.buttons["Loader из пакета"]
        XCTAssertTrue(entry.waitForExistence(timeout: 10)); entry.tap()
        let start = app.buttons["consumerLoaderStart"]
        XCTAssertTrue(start.waitForExistence(timeout: 5))
        for expectedCount in [1, 2] {
            start.tap()
            let measured = app.staticTexts["consumerLoaderVisibleSeconds"]
            XCTAssertTrue(measured.waitForExistence(timeout: 5))
            let seconds = Double(measured.label.replacingOccurrences(of: ",", with: "."))
            XCTAssertNotNil(seconds)
            XCTAssertGreaterThanOrEqual(seconds ?? 0, 0.500)
            XCTAssertEqual(app.staticTexts["consumerLoaderCompleted"].label, String(expectedCount))
            XCTAssertEqual(start.label, "Загрузить данные")
        }
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "independent-consumer-loader-minimum-visible-duration"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    @MainActor
    func testIndependentConsumerUsesButtonCustomizationAndPackageResources() {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launch()
        let entry = app.buttons["Button из пакета"]
        XCTAssertTrue(entry.waitForExistence(timeout: 10))
        entry.tap()
        let component = app.buttons["consumerButtonComponent"]
        XCTAssertTrue(component.waitForExistence(timeout: 10))
        for (index, size) in ["large", "medium", "small"].enumerated() {
            app.segmentedControls["consumerButtonSize"].buttons[size].tap()
            XCTAssertEqual(component.frame.width, 280, accuracy: 0.5)
            XCTAssertEqual(component.frame.height, size == "large" ? 56 : size == "medium" ? 44 : 30, accuracy: 0.5)
            XCTAssertEqual(component.label, "Отправить документ")
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "independent-consumer-custom-button-\(size)"
            screenshot.lifetime = .keepAlways
            add(screenshot)
            component.tap()
            XCTAssertEqual(component.label, "Идет загрузка")
            XCTAssertTrue(component.isEnabled)
            XCTAssertEqual(app.staticTexts["consumerButtonTapCount"].label, "Нажатий, \(index + 1)")
            component.tap()
            XCTAssertEqual(app.staticTexts["consumerButtonTapCount"].label, "Нажатий, \(index + 1)")
            app.buttons["consumerButtonFinishLoading"].tap()
            XCTAssertEqual(component.label, "Отправить документ")
        }
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "independent-consumer-custom-button-accessibility-tree"
        tree.lifetime = .keepAlways
        add(tree)
    }
    @MainActor
    func testIndependentConsumerOwnsSelectionAndReceivesShareAction() {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launch()
        let favorite = app.buttons["tuiButtonLike-44290:299175"]
        XCTAssertTrue(favorite.waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Добавить в избранное"].exists)
        favorite.tap()
        let selected = app.buttons["tuiButtonLike-44290:299177"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertTrue(selected.isSelected)
        XCTAssertTrue(app.staticTexts["В избранном"].exists)
        selected.tap()
        XCTAssertTrue(favorite.waitForExistence(timeout: 5))
        XCTAssertFalse(favorite.isSelected)
        app.buttons["tuiButtonShare-44290:299204"].tap()
        XCTAssertTrue(app.staticTexts["Действие Share дошло до приложения-потребителя"].waitForExistence(timeout: 5))
        let sheet = XCTAttachment(screenshot: app.screenshot())
        sheet.name = "independent-consumer-share-native-sheet"
        sheet.lifetime = .keepAlways
        add(sheet)
        app.buttons["Готово"].tap()
        XCTAssertTrue(favorite.waitForExistence(timeout: 5))
        let rendered = XCTAttachment(screenshot: app.screenshot())
        rendered.name = "independent-consumer-component-resources"
        rendered.lifetime = .keepAlways
        add(rendered)
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "independent-consumer-native-accessibility-tree"
        tree.lifetime = .keepAlways
        add(tree)
    }
}
