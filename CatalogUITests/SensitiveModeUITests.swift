import XCTest

final class SensitiveModeUITests: XCTestCase {
    @MainActor func testLiveCatalogMasksTextWithoutBlockingActions() {
        let app = XCUIApplication()
        app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 10))
        search.tap(); search.typeText("tui-sensitive-mode")
        let entry = app.staticTexts["tui-sensitive-mode"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        if app.keyboards.firstMatch.exists {
            app.swipeDown()
        }
        // Native List exposes the entire row as the Canvas AX frame. Actual
        // source-frame dimensions are asserted in package rendering tests.
        for (size, sourceID) in [("Body L", "46866:304516"), ("Body M", "46866:304595"),
                                  ("UI S", "46866:304647"), ("UI XS", "46866:304698"),
                                  ("Font Size5", "47079:304877")] {
            app.buttons["sensitiveFontSizePicker"].tap()
            app.buttons[size].firstMatch.tap()
            XCTAssertTrue(app.staticTexts["sensitiveSelectedNode"].label.contains(sourceID))
        }
        let component = app.buttons["sensitiveDemoButton"]
        XCTAssertTrue(component.waitForExistence(timeout: 5))
        let before = component.frame
        component.tap()
        XCTAssertEqual(app.staticTexts["sensitiveButtonCount"].label, "Нажатий: 1")
        let toggle = app.switches["sensitiveHiddenToggle"]
        XCTAssertTrue(toggle.exists)
        XCTAssertEqual(toggle.value as? String, "1")
        toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.93, dy: 0.5)).tap()
        XCTAssertEqual(toggle.value as? String, "0")
        XCTAssertEqual(component.frame.size, before.size)
        attach(app, name: "sensitive-live-catalog-visible-before-second-tap")
        component.tap()
        XCTAssertEqual(app.staticTexts["sensitiveButtonCount"].label, "Нажатий: 2")
        attach(app, name: "sensitive-live-catalog-show-hide-actions")
    }

    @MainActor func testIndependentConsumerPreservesMaskedLinkButtonAndWholeComponentActions() {
        for theme in ["day", "night"] {
            let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
            app.launchArguments = ["--sensitive-mode-consumer"] + (theme == "night" ? ["--sensitive-dark"] : [])
            app.launch()
            let component = app.buttons["consumerSensitiveButton"]
            XCTAssertTrue(component.waitForExistence(timeout: 10))
            let toggle = app.switches["consumerSensitiveToggle"]
            for (index, size) in ["large", "medium", "small"].enumerated() {
                app.segmentedControls["consumerSensitiveSize"].buttons[size].tap()
                let frame = component.frame
                XCTAssertEqual(frame.width, 280, accuracy: 0.5)
                XCTAssertEqual(frame.height, size == "large" ? 56 : size == "medium" ? 44 : 30, accuracy: 0.5)
                component.tap()
                XCTAssertEqual(app.staticTexts["consumerSensitiveButtonCount"].label, String(index * 2 + 1))
                attach(app, name: "sensitive-consumer-\(size)-\(theme)-hidden")
                XCTAssertEqual(toggle.value as? String, "1")
                toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.93, dy: 0.5)).tap()
                XCTAssertEqual(toggle.value as? String, "0")
                XCTAssertEqual(component.frame, frame)
                component.tap()
                XCTAssertEqual(app.staticTexts["consumerSensitiveButtonCount"].label, String(index * 2 + 2))
                toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.93, dy: 0.5)).tap()
                XCTAssertEqual(toggle.value as? String, "1")
            }
            let link = app.descendants(matching: .any).matching(identifier: "consumerSensitiveLink").firstMatch
            XCTAssertTrue(link.exists)
            // Tap both the visible prefix and the mask over the amount.
            link.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.5)).tap()
            XCTAssertEqual(app.staticTexts["consumerSensitiveLinkCount"].label, "1")
            link.coordinate(withNormalizedOffset: CGVector(dx: 0.85, dy: 0.5)).tap()
            XCTAssertEqual(app.staticTexts["consumerSensitiveLinkCount"].label, "2")
            let wholeComponent = app.buttons["consumerSensitiveWholeComponent"]
            XCTAssertTrue(wholeComponent.exists)
            wholeComponent.tap()
            XCTAssertEqual(app.staticTexts["consumerSensitiveButtonCount"].label, "7")
            attach(app, name: "sensitive-consumer-\(theme)-masked-link-and-whole-component")
        }
    }

    @MainActor private func attach(_ app: XCUIApplication, name: String) {
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}
