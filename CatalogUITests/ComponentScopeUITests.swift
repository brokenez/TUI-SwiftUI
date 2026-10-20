import XCTest

final class ComponentScopeUITests: XCTestCase {
    @MainActor func testSystemSetsAreOmittedAndCustomTextfieldRemainsAccessible() {
        let app = XCUIApplication()
        app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap()
        search.typeText("system-")
        let systemEntries = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "system-"))
        XCTAssertEqual(systemEntries.count, 0)
        let excluded = XCTAttachment(screenshot: app.screenshot())
        excluded.name = "excluded-system-search"
        excluded.lifetime = .keepAlways
        add(excluded)

        search.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 7))
        search.typeText("tui-textfield")
        let customEntry = app.staticTexts["tui-textfield "].firstMatch
        XCTAssertTrue(customEntry.waitForExistence(timeout: 5))
        customEntry.tap()
        XCTAssertTrue(app.textFields["tuiTextfieldInput"].waitForExistence(timeout: 5))
        let custom = XCTAttachment(screenshot: app.screenshot())
        custom.name = "custom-textfield-retained"
        custom.lifetime = .keepAlways
        add(custom)
    }
}
