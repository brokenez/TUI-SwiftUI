import XCTest

final class FloatingContainerUITests: XCTestCase {
    @MainActor func testPrimaryReplacementAndSupplementChangesKeepConsumerActions() throws {
        let app = try openDemo()
        app.buttons["floatingReplacePrimary"].tap()
        let replaced = app.buttons["Подтвердить"].firstMatch
        XCTAssertTrue(replaced.waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Продолжить"].firstMatch.waitForNonExistence(timeout: 3))
        for preset in ["Лигал", "Две", "Одна", "Две"] {
            app.segmentedControls["floatingPreset"].buttons[preset].tap()
            XCTAssertTrue(replaced.isHittable); replaced.tap()
        }
        XCTAssertTrue(app.staticTexts["floatingTapCounts"].label.contains("Основное: 4"))
        app.buttons["Отмена"].firstMatch.tap()
        XCTAssertTrue(app.staticTexts["floatingTapCounts"].label.contains("дополнительное: 1"))
        app.buttons["floatingReplacePrimary"].tap()
        XCTAssertTrue(app.buttons["Продолжить"].firstMatch.waitForExistence(timeout: 3))
        XCTAssertTrue(replaced.waitForNonExistence(timeout: 3))
        attach(app, name: "floating-replacements-consumer-actions")
    }

    @MainActor func testSourcePresetsStayFixedWhileScrollingAndActionsWorkInBothThemes() throws {
        let app = try openDemo()
        let primary = app.buttons["Продолжить"].firstMatch
        let secondary = app.buttons["Отмена"].firstMatch
        XCTAssertTrue(primary.waitForExistence(timeout: 3)); XCTAssertTrue(secondary.exists)
        for theme in ["Day", "Night"] {
            if theme == "Night" { app.buttons["floatingTheme"].tap() }
            let initial = primary.frame
            XCTAssertEqual(initial.minX, 16, accuracy: 0.5)
            XCTAssertEqual(initial.width, app.frame.width - 32, accuracy: 0.5)
            XCTAssertEqual(initial.height, 56, accuracy: 0.5)
            XCTAssertEqual(secondary.frame.minY - primary.frame.maxY, 8, accuracy: 0.5)
            primary.tap(); secondary.tap()
            XCTAssertTrue(app.staticTexts["floatingTapCounts"].label.contains(theme == "Day"
                ? "Основное: 1, дополнительное: 1" : "Основное: 2, дополнительное: 2"))
            app.swipeUp(); app.swipeUp()
            XCTAssertEqual(primary.frame.minY, initial.minY, accuracy: 0.5)
            XCTAssertEqual(primary.frame.width, initial.width, accuracy: 0.5)
            let end = app.staticTexts["floatingScrollEnd"]
            for _ in 0..<3 where !end.isHittable { app.swipeUp() }
            XCTAssertTrue(end.isHittable)
            XCTAssertEqual(primary.frame.minY - end.frame.maxY, 20, accuracy: 1)
            attach(app, name: "floating-two-actions-sticky-\(theme)")
            app.swipeDown(); app.swipeDown(); app.swipeDown()
        }
        app.segmentedControls["floatingPreset"].buttons["Одна"].tap()
        XCTAssertFalse(secondary.exists)
        XCTAssertTrue(app.switches["floatingFade"].exists)
        app.switches["floatingFade"].tap()
        attach(app, name: "floating-single-fade-Night")
        app.segmentedControls["floatingPreset"].buttons["Лигал"].tap()
        XCTAssertFalse(secondary.exists)
        XCTAssertTrue(app.staticTexts["Продолжая, вы соглашаетесь с условиями обслуживания"].exists)
        attach(app, name: "floating-action-legal-Night")
        app.segmentedControls["floatingPreset"].buttons["Свой"].tap()
        let pay = app.buttons["Оплатить"]
        XCTAssertTrue(pay.exists); pay.tap()
        XCTAssertTrue(app.staticTexts["floatingTapCounts"].label.contains("Основное: 3"))
        attach(app, name: "floating-custom-content-Night")
    }

    @MainActor func testDisabledAndLoadingDoNotRunActionAndVisibilityCanBeRepeated() throws {
        let app = try openDemo()
        let primary = app.buttons["Продолжить"].firstMatch
        let states = app.segmentedControls["floatingButtonState"]
        states.buttons["Disabled"].tap()
        XCTAssertFalse(primary.isEnabled)
        states.buttons["Loading"].tap()
        let loading = app.buttons["Идет загрузка"].firstMatch
        XCTAssertTrue(loading.exists); loading.tap()
        XCTAssertTrue(app.staticTexts["floatingTapCounts"].label.contains("Основное: 0"))
        states.buttons["Normal"].tap()
        primary.tap()
        XCTAssertTrue(app.staticTexts["floatingTapCounts"].label.contains("Основное: 1"))
        for _ in 0..<2 {
            app.switches["floatingVisibility"].tap()
            XCTAssertTrue(primary.waitForNonExistence(timeout: 3))
            app.switches["floatingVisibility"].tap()
            XCTAssertTrue(primary.waitForExistence(timeout: 3)); XCTAssertTrue(primary.isHittable)
        }
        attach(app, name: "floating-visibility-after-repeat")
    }

    @MainActor private func openDemo() throws -> XCUIApplication {
        let app = XCUIApplication(); app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5)); search.tap(); search.typeText("tui-floating-container")
        let entry = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "tui-floating-container")).firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 3)); entry.tap()
        let demo = app.buttons["floatingContainerDemo"].firstMatch
        XCTAssertTrue(demo.waitForExistence(timeout: 3)); demo.tap()
        XCTAssertTrue(app.navigationBars["Floating Container"].waitForExistence(timeout: 3))
        return app
    }

    @MainActor private func attach(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
