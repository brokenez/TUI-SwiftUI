import XCTest

/// Exercises the separately installed app, which imports only the package's
/// public product. Navigation, state and sheets belong to that application.
final class CardMediumConsumerUITests: XCTestCase {
    @MainActor
    func testIndependentCardOwnsSelectionAndPresentsNativeSheet() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launch()
        let entry = app.buttons["Card Medium из пакета"]
        XCTAssertTrue(entry.waitForExistence(timeout: 10))
        entry.tap()

        let benefit = app.buttons.matching(NSPredicate(format: "label == %@", "Преимущество, Подробнее")).firstMatch
        XCTAssertTrue(benefit.waitForExistence(timeout: 5))
        XCTAssertEqual(benefit.value as? String, "Pro, 10%")
        XCTAssertFalse(benefit.isSelected)
        XCTAssertEqual(benefit.frame.width, 140, accuracy: 0.5)
        XCTAssertEqual(benefit.frame.height, 140, accuracy: 0.5)
        XCTAssertTrue(app.otherElements["Компании, Три партнёра"].exists)
        XCTAssertFalse(app.buttons["Компании, Три партнёра"].exists,
                       "A card without a consumer action must remain static")
        keep(XCTAttachment(screenshot: app.screenshot()), name: "card-medium-independent-initial")

        benefit.tap()
        dismissSheet(in: app)
        XCTAssertTrue(app.staticTexts["Преимущество выбрано"].waitForExistence(timeout: 5))
        XCTAssertTrue(benefit.isSelected)
        benefit.tap()
        dismissSheet(in: app)
        XCTAssertTrue(app.staticTexts["Нажмите на карточку"].waitForExistence(timeout: 5))
        XCTAssertFalse(benefit.isSelected)

        let notification = app.buttons["Уведомление, Новое сообщение"]
        XCTAssertTrue(notification.exists && notification.isHittable)
        XCTAssertEqual(notification.value as? String, "Одно новое сообщение")
        notification.tap()
        dismissSheet(in: app)
        XCTAssertFalse(benefit.isSelected, "The second action must not mutate the benefit's state")
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        keep(XCTAttachment(screenshot: app.screenshot()), name: "card-medium-independent-after-actions")
        keep(XCTAttachment(string: app.debugDescription), name: "card-medium-independent-accessibility-tree")
    }

    @MainActor
    private func dismissSheet(in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["Действие карточки обработано приложением"].waitForExistence(timeout: 5))
        keep(XCTAttachment(screenshot: app.screenshot()), name: "card-medium-independent-native-sheet")
        app.buttons["Готово"].tap()
        XCTAssertTrue(app.navigationBars["Card Medium из пакета"].waitForExistence(timeout: 5))
    }

    private func keep(_ attachment: XCTAttachment, name: String) {
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
