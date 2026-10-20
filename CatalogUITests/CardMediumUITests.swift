import XCTest
import UIKit

final class CardMediumUITests: XCTestCase {
    /// Run with actual simctl ui content_size settings: large, accessibility-medium,
    /// accessibility-extra-extra-extra-large. No launch argument or SwiftUI override.
    @MainActor func testSystemDynamicTypeAndAccessibleActions() throws {
        let systemCategory = UIApplication.shared.preferredContentSizeCategory
        XCTAssertTrue([UIContentSizeCategory.large, .accessibilityMedium,
                       .accessibilityExtraExtraExtraLarge].contains(systemCategory))
        // Compare real system inheritance with the previously verified package
        // renders: 420 px at Large, 644 px at AX1/AX5, both at 3x.
        // This is a regression check, not acceptance of the unresolved Figma font.
        let expectedWidth = systemCategory == .large ? 140.0 : 644.0 / 3
        let app = XCUIApplication()
        app.launch()
        let entry = app.staticTexts["tui-card-medium · 21 вариант iOS"]
        scrollTo(entry, in: app)
        entry.tap()
        let card = app.buttons["11335:41575"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        XCTAssertEqual(card.frame.width, expectedWidth, accuracy: 0.5)
        XCTAssertEqual(card.frame.height, expectedWidth, accuracy: 0.5)
        XCTAssertEqual(card.label, "Title, Subtitle")
        XCTAssertEqual(app.buttons.matching(identifier: "11335:41575").count, 1)
        card.tap()
        XCTAssertTrue(card.isSelected)
        XCTAssertEqual(app.staticTexts["cardMediumTapCount"].label, "Нажатий: 1")
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "card-medium-system-" + systemCategory.rawValue
        screenshot.lifetime = .keepAlways
        add(screenshot)
        let report = XCTAttachment(string: "System category: \(systemCategory.rawValue)\nExpected width: \(expectedWidth)\nActual frame: \(card.frame)\n" + app.debugDescription)
        report.name = "card-medium-system-geometry-and-semantics"
        report.lifetime = .keepAlways
        add(report)
    }

    @MainActor func testActualCardReceivesActionsSelectionAndDisabledState() throws {
        let app = XCUIApplication()
        app.launch()
        let entry = app.staticTexts["tui-card-medium · 21 вариант iOS"]
        XCTAssertTrue(entry.waitForExistence(timeout: 10))
        entry.tap()
        let card = app.buttons["11335:41575"]
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        XCTAssertEqual(card.frame.width, 140, accuracy: 0.5)
        XCTAssertEqual(card.frame.height, 140, accuracy: 0.5)
        card.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            .press(forDuration: 0.15, thenDragTo: card.coordinate(withNormalizedOffset: CGVector(dx: 2, dy: 0.5)))
        XCTAssertEqual(app.staticTexts["cardMediumTapCount"].label, "Нажатий: 0", "Release outside the card must cancel its action")
        card.tap()
        XCTAssertEqual(app.staticTexts["cardMediumTapCount"].label, "Нажатий: 1")
        XCTAssertTrue(card.isSelected)
        card.tap()
        XCTAssertEqual(app.staticTexts["cardMediumTapCount"].label, "Нажатий: 2")
        XCTAssertFalse(card.isSelected)
        let enabled = app.switches["cardMediumEnabled"]
        scrollTo(enabled, in: app)
        enabled.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
        scrollTo(card, in: app, up: false)
        XCTAssertFalse(card.isEnabled)
        XCTAssertEqual(app.staticTexts["cardMediumTapCount"].label, "Нажатий: 2")
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "card-medium-native-button-and-disabled-state"
        tree.lifetime = .keepAlways
        add(tree)
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
    }

    @MainActor func testVariantPickerDisplaysLegacyBadgeAvatarAndSkeleton() throws {
        let app = XCUIApplication()
        app.launch()
        let entry = app.staticTexts["tui-card-medium · 21 вариант iOS"]
        XCTAssertTrue(entry.waitForExistence(timeout: 10))
        entry.tap()
        let picker = app.buttons["cardMediumVariantPicker"]
        for (name, id) in [("badgeBottomImage", "11335:41680"),
                           ("avatarTopFill", "11335:41631"),
                           ("textBottomSkeleton", "11335:41578")] {
            scrollTo(picker, in: app, up: false)
            picker.tap()
            let option = app.buttons[name]
            // Native menus open around the selected item. Skeleton is above the
            // previously selected avatar, so its menu must scroll downward.
            scrollTo(option, in: app, up: name != "textBottomSkeleton")
            option.tap()
            let changed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label CONTAINS %@", name), object: picker)
            XCTAssertEqual(XCTWaiter.wait(for: [changed], timeout: 5), .completed)
            if name != "textBottomSkeleton" {
                let card = app.buttons[id]
                scrollTo(card, in: app, up: false)
                XCTAssertTrue(card.exists)
                card.tap()
            } else {
                XCTAssertFalse(app.buttons[id].exists, "Skeleton must expose neither an action nor the hidden source text")
            }
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "card-medium-native-" + name
            screenshot.lifetime = .keepAlways
            add(screenshot)
        }
    }

    @MainActor private func scrollTo(_ element: XCUIElement, in app: XCUIApplication, up: Bool = true) {
        for _ in 0..<8 {
            if element.exists && element.isHittable { return }
            if up { app.swipeUp() } else { app.swipeDown() }
        }
        XCTAssertTrue(element.exists && element.isHittable, "Card control must be reachable")
    }
}
