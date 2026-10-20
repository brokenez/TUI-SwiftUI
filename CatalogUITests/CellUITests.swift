import XCTest

final class CellUITests: XCTestCase {
    @MainActor func testHintUsesConsumerStateAndVariantsAreSelectable() throws {
        let app = XCUIApplication(); app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5)); search.tap(); search.typeText("tui-cell")
        let entry = app.staticTexts["tui-cell"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        let hint = app.buttons["tuiCellHint"]
        scrollTo(hint, in: app); hint.tap(); hint.tap()
        let count = app.staticTexts["cellHintCount"]
        scrollTo(count, in: app); XCTAssertEqual(count.label, "Нажатий на подсказку: 2")
        let picker = app.buttons["cellVariantPicker"]
        scrollTo(picker, in: app, up: false); picker.tap()
        let option = app.buttons["Compact · None · flexible"].firstMatch
        XCTAssertTrue(option.waitForExistence(timeout: 5)); option.tap()
        XCTAssertFalse(hint.exists)
        XCTAssertEqual(count.label, "Нажатий на подсказку: 2")
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "cell-native-hint-and-compact-variant"; screenshot.lifetime = .keepAlways; add(screenshot)
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "cell-native-accessibility-tree"; tree.lifetime = .keepAlways; add(tree)
    }
    @MainActor func testInlineBadgeIsLiveInNonExtendedVariant() throws {
        let app = XCUIApplication(); app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5)); search.tap(); search.typeText("tui-cell")
        let entry = app.staticTexts["tui-cell"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        let picker = app.buttons["cellVariantPicker"]
        scrollTo(picker, in: app); picker.tap()
        let option = app.buttons["Default · None · fixed"].firstMatch
        XCTAssertTrue(option.waitForExistence(timeout: 5)); option.tap()
        let toggle = app.switches["cellInlineToggle"]
        scrollTo(toggle, in: app)
        XCTAssertEqual(toggle.value as? String, "0")
        toggle.switches.firstMatch.tap()
        XCTAssertEqual(toggle.value as? String, "1")
        let badge = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label CONTAINS %@", "Дополнительный бейдж: 2")).firstMatch
        scrollTo(badge, in: app, up: false)
        XCTAssertTrue(badge.exists)
        XCTAssertTrue(app.descendants(matching: .any).matching(identifier: "tuiCell-41569:290638").firstMatch.exists)
        XCTAssertFalse(app.buttons["tuiCellHint"].exists)
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "cell-default-non-extended-live-inline-badge"; screenshot.lifetime = .keepAlways; add(screenshot)
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "cell-non-extended-inline-badge-accessibility-tree"; tree.lifetime = .keepAlways; add(tree)
    }
    @MainActor private func scrollTo(_ element: XCUIElement, in app: XCUIApplication, up: Bool = true) {
        for _ in 0..<8 {
            if element.exists && element.isHittable { return }
            if up { app.swipeUp() } else { app.swipeDown() }
        }
        XCTAssertTrue(element.exists && element.isHittable)
    }
}
