import XCTest

final class CardLargeUITests: XCTestCase {
    @MainActor func testChildActionsAndSingleCardActionStayIndependent() throws {
        let app = XCUIApplication()
        app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("tui-card-large")
        let entry = app.staticTexts["tui-card-large"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5))
        entry.tap()
        let child = app.buttons["cardLargeChildAction"]
        scrollTo(child, in: app)
        child.tap()
        let childCount = app.staticTexts["cardLargeChildCount"]
        scrollTo(childCount, in: app)
        XCTAssertEqual(childCount.label, "Действий внутри: 1")
        XCTAssertEqual(app.staticTexts["cardLargeWholeCount"].label, "Открытий карточки: 0")
        let footer = app.buttons["cardLargeFooterAction"]
        scrollTo(footer, in: app, up: false)
        footer.tap()
        scrollTo(childCount, in: app)
        XCTAssertEqual(childCount.label, "Действий внутри: 2")
        XCTAssertEqual(app.staticTexts["cardLargeWholeCount"].label, "Открытий карточки: 0")
        keep(app, name: "card-large-container-native-child-actions")

        let toggle = app.switches["cardLargeSingleAction"]
        scrollTo(toggle, in: app, up: false)
        // The labelled Toggle exposes its actual UISwitch as a descendant.
        let control = toggle.switches.firstMatch
        XCTAssertTrue(control.exists)
        control.tap()
        XCTAssertEqual(toggle.value as? String, "1")
        let whole = app.buttons["cardLargeWholeAction"]
        scrollTo(whole, in: app)
        XCTAssertFalse(child.exists)
        XCTAssertFalse(footer.exists)
        whole.tap()
        scrollTo(childCount, in: app)
        XCTAssertEqual(childCount.label, "Действий внутри: 2")
        XCTAssertEqual(app.staticTexts["cardLargeWholeCount"].label, "Открытий карточки: 1")
        keep(app, name: "card-large-container-native-single-action")
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "card-large-container-native-tree"
        tree.lifetime = .keepAlways
        add(tree)
    }

    @MainActor func testCellPresetsShowTheRealPublicCell() throws {
        let app = XCUIApplication(); app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5)); search.tap(); search.typeText("tui-card-large")
        let entry = app.staticTexts["tui-card-large"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        let picker = app.buttons["cardLargeVariant"]
        for optionName in ["Cell", "Cell · Flat"] {
            scrollTo(picker, in: app, up: false); picker.tap()
            let option = app.buttons[optionName].firstMatch
            scrollTo(option, in: app); option.tap()
            let cell = app.descendants(matching: .any).matching(identifier: "tuiCell-41569:290638").firstMatch
            scrollTo(cell, in: app)
            XCTAssertTrue(cell.exists)
            XCTAssertTrue(app.descendants(matching: .any).matching(NSPredicate(format: "label == %@", "Title, Description")).firstMatch.exists)
            XCTAssertFalse(app.staticTexts["Контент приложения"].exists)
            XCTAssertFalse(app.buttons["cardLargeChildAction"].exists)
            keep(app, name: optionName == "Cell" ? "card-large-real-cell" : "card-large-real-cell-flat")
        }
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "card-large-cell-native-tree"; tree.lifetime = .keepAlways; add(tree)
    }

    @MainActor private func scrollTo(_ element: XCUIElement, in app: XCUIApplication, up: Bool = true) {
        for _ in 0..<8 {
            if element.exists && element.isHittable { return }
            if up { app.swipeUp() } else { app.swipeDown() }
        }
        XCTAssertTrue(element.exists && element.isHittable)
    }
    @MainActor private func keep(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
