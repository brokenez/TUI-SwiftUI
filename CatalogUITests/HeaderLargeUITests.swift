import XCTest

final class HeaderLargeUITests: XCTestCase {
    @MainActor
    func testRealCatalogAccessoryReceivesTapsAndTitleLinkReceivesOpenURL() throws {
        let app = XCUIApplication()
        app.launch()
        let entry = app.staticTexts["tui-header [large] · 10 вариантов iOS"]
        XCTAssertTrue(entry.waitForExistence(timeout: 10))
        entry.tap()
        let customAccessory = app.switches["headerCustomAccessory"]
        scrollTo(customAccessory, in: app)
        customAccessory.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
        let titleLink = app.switches["headerTitleLink"]
        scrollTo(titleLink, in: app)
        titleLink.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
        let selection = app.switches["Выбрать раздел"]
        scrollTo(selection, in: app, up: false)
        XCTAssertEqual(selection.value as? String, "0")
        selection.tap()
        XCTAssertEqual(selection.value as? String, "1")
        selection.tap()
        XCTAssertEqual(selection.value as? String, "0")
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "header-native-accessibility-tree-with-link-and-toggle"
        tree.lifetime = .keepAlways
        add(tree)
        let title = app.links["Header"]
        XCTAssertTrue(title.exists, "Attributed title must preserve a native link")
        title.tap()
        XCTAssertTrue(app.alerts["Ссылка сработала"].waitForExistence(timeout: 5))
        app.alerts["Ссылка сработала"].buttons["Закрыть"].tap()
        let subheader = app.links["Subheader"]
        XCTAssertTrue(subheader.exists, "Combined heading must retain the subheader link")
        subheader.tap()
        XCTAssertTrue(app.alerts["Ссылка сработала"].waitForExistence(timeout: 5))
        app.alerts["Ссылка сработала"].buttons["Закрыть"].tap()
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        let picker = app.buttons["headerVariantPicker"]
        scrollTo(picker, in: app)
        picker.tap()
        let descriptionVariant = app.buttons["descriptionLeading"]
        XCTAssertTrue(descriptionVariant.waitForExistence(timeout: 5))
        XCTAssertTrue(descriptionVariant.isHittable)
        descriptionVariant.coordinate(withNormalizedOffset: CGVector(dx: 0.7, dy: 0.5)).press(forDuration: 0.1)
        let changed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label CONTAINS %@", "descriptionLeading"), object: picker)
        XCTAssertEqual(XCTWaiter.wait(for: [changed], timeout: 5), .completed,
                       "Verify real picker selection before looking for the description link")
        let description = app.links["Description"]
        scrollTo(description, in: app, up: false)
        description.tap()
        XCTAssertTrue(app.alerts["Ссылка сработала"].waitForExistence(timeout: 5))
        app.alerts["Ссылка сработала"].buttons["Закрыть"].tap()
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "header-native-linked-title-and-interactive-accessory"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    @MainActor
    private func scrollTo(_ element: XCUIElement, in app: XCUIApplication, up: Bool = true) {
        for _ in 0..<8 {
            if element.exists && element.isHittable { return }
            if up { app.swipeUp() } else { app.swipeDown() }
        }
        XCTAssertTrue(element.exists && element.isHittable, "Control must be reachable in the real catalog")
    }
}
