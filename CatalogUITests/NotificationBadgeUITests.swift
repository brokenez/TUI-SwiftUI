import XCTest

final class NotificationBadgeUITests: XCTestCase {
    @MainActor func testActualBadgeVariantsScalingAndParentOwnedAccessibility() throws {
        let app = XCUIApplication()
        app.launch()
        let entry = app.staticTexts["tui-badge notification · 3 размера iOS"]
        scrollTo(entry, in: app)
        entry.tap()
        let parent = app.buttons["notificationBadgeParent"]
        XCTAssertTrue(parent.waitForExistence(timeout: 5))
        XCTAssertEqual(parent.label, "Уведомления")
        XCTAssertEqual(parent.value as? String, "Обновлений: 1")
        parent.tap()
        XCTAssertEqual(app.staticTexts["notificationBadgePresses"].label, "Открытий: 1")

        replace(app.textFields["notificationBadgeText"], with: "99+", in: app)
        replace(app.textFields["notificationBadgeActualCount"], with: "124", in: app)
        scrollTo(parent, in: app, up: false)
        XCTAssertEqual(parent.value as? String, "Обновлений: 124")
        // XCTest's visual snapshot can include rendered descendants even when
        // SwiftUI hides their accessibility. Do not equate existence in that
        // snapshot with a VoiceOver focus stop; focus needs a separate audit.
        XCTAssertEqual(parent.label, "Уведомления")

        for size in ["large", "small", "medium"] {
            select(size, picker: app.buttons["notificationBadgeSize"], in: app)
            scrollTo(parent, in: app, up: false)
            XCTAssertEqual(parent.value as? String, size == "small" ? "" : "Обновлений: 124")
            keep(app, name: "notification-badge-native-\(size)-99plus")
        }

        select("AX1", picker: app.buttons["notificationBadgeDynamicType"], in: app)
        scrollTo(parent, in: app, up: false)
        let ax1Height = parent.frame.height
        keep(app, name: "notification-badge-native-AX1")
        select("AX5 → ограничение AX1", picker: app.buttons["notificationBadgeDynamicType"], in: app)
        scrollTo(parent, in: app, up: false)
        // The surrounding native button text may scale further; the package
        // render test measures the badge itself and verifies the exact cap.
        XCTAssertGreaterThanOrEqual(parent.frame.height, ax1Height)
        XCTAssertEqual(parent.value as? String, "Обновлений: 124")
        parent.tap()
        XCTAssertEqual(app.staticTexts["notificationBadgePresses"].label, "Открытий: 2")
        keep(app, name: "notification-badge-native-AX5")
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "notification-badge-parent-accessibility-tree"
        tree.lifetime = .keepAlways
        add(tree)
        try app.performAccessibilityAudit(for: [.sufficientElementDescription, .trait])
    }

    @MainActor private func select(_ option: String, picker: XCUIElement, in app: XCUIApplication) {
        scrollTo(picker, in: app)
        picker.tap()
        let item = app.buttons[option]
        XCTAssertTrue(item.waitForExistence(timeout: 3))
        item.tap()
    }

    @MainActor private func replace(_ field: XCUIElement, with value: String, in app: XCUIApplication) {
        scrollTo(field, in: app)
        field.tap()
        let previous = field.value as? String ?? ""
        field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: previous.count) + value)
    }

    @MainActor private func scrollTo(_ element: XCUIElement, in app: XCUIApplication, up: Bool = true) {
        for _ in 0..<10 {
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
