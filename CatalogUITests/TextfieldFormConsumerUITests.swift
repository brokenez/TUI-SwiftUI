import XCTest

final class TextfieldFormConsumerUITests: XCTestCase {
    @MainActor func testExternalReadOnlyAndDisabledChangesRemoveKeyboardNavigation() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--textfield-form-consumer", "--textfield-form-state-probe"]
        app.launch()
        let first = app.textFields["tuiTextfieldInput-field-0"]
        XCTAssertTrue(first.waitForExistence(timeout: 5)); first.tap(); first.typeText("A")
        XCTAssertTrue(app.buttons["tuiTextfieldFormAdvance"].exists)
        let change = app.buttons["consumerFormChangeState"]
        change.tap(); waitForDismissal(app)
        XCTAssertEqual(first.value as? String, "A")
        first.coordinate(withNormalizedOffset: CGVector(dx: 0.02, dy: 0.5)).doubleTap()
        let copy = app.menuItems.matching(NSPredicate(format: "label IN %@", ["Copy", "Копировать", "Скопировать"])).firstMatch
        XCTAssertTrue(copy.waitForExistence(timeout: 3)); XCTAssertFalse(app.keyboards.firstMatch.exists)
        copy.tap()
        change.tap(); waitForDismissal(app)
        XCTAssertFalse(first.isEnabled); XCTAssertEqual(first.value as? String, "A")
        attach(app, name: "textfield-form-external-disabled")
        app.terminate()
    }

    @MainActor func testNativeFormNavigationSkipsUnavailableFieldsScrollsAndRespectsBoundary() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        for theme in ["day", "night"] {
            app.launchArguments = ["--textfield-form-consumer"] + (theme == "night" ? ["--textfield-dark"] : [])
            app.launch()
            let first = app.textFields["tuiTextfieldInput-field-0"]
            XCTAssertTrue(first.waitForExistence(timeout: 5)); first.tap()
            XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 3))
            let advance = app.buttons["tuiTextfieldFormAdvance"]
            XCTAssertTrue(advance.waitForExistence(timeout: 3)); XCTAssertEqual(advance.label, "Дальше")
            XCTAssertLessThan(advance.frame.width, app.frame.width / 2, "Medium uses source Hug sizing")
            first.typeText("A")
            XCTAssertTrue(app.keyboards.firstMatch.frame.intersects(app.frame), "Software keyboard must be visible for viewport acceptance")
            XCTAssertEqual(keyboardTop(app) - advance.frame.maxY, 16, accuracy: 1)
            XCTAssertEqual(app.frame.maxX - advance.frame.maxX, 16, accuracy: 1)
            XCTAssertEqual(advance.frame.height, 44, accuracy: 1)
            advance.tap()
            app.typeText("B")
            XCTAssertEqual(app.textFields["tuiTextfieldInput-field-4"].value as? String, "B")
            XCTAssertTrue(app.keyboards.firstMatch.frame.intersects(app.frame), "Next must retain the visible software keyboard")
            XCTAssertEqual(app.staticTexts["consumerFormTapCount"].label, "Нажатий: 0")
            for index in 5...8 {
                advance.tap(); app.typeText("\(index)")
                XCTAssertEqual(app.textFields["tuiTextfieldInput-field-\(index)"].value as? String, "\(index)")
                XCTAssertTrue(app.keyboards.firstMatch.frame.intersects(app.frame), "Keyboard must remain visible after focusing field \(index)")
            }
            let last = app.otherElements["consumerFormField-8"].firstMatch
            XCTAssertTrue(app.staticTexts["Подсказка последнего поля группы"].exists)
            let settled = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
                guard let frame = self.measuredFrame(last) else { return false }
                return abs(advance.frame.minY - frame.maxY - 12) <= 1
            }, object: nil)
            XCTAssertEqual(XCTWaiter.wait(for: [settled], timeout: 3), .completed,
                           "Wait for the native focus/hint/scroll transition to reach its source geometry")
            let layout = try XCTUnwrap(measuredFrame(last))
            XCTAssertEqual(layout.height, 98, accuracy: 1, "56 pt field + complete 42 pt hint")
            XCTAssertLessThanOrEqual(layout.maxY, advance.frame.minY - 11,
                                     "Whole field, including hint, must fit above the floating button")
            XCTAssertEqual(advance.frame.minY - layout.maxY, 12, accuracy: 1)
            XCTAssertEqual(keyboardTop(app) - advance.frame.maxY, 16, accuracy: 1)
            XCTAssertEqual(advance.label, "Дальше", "A later group exists, but must not receive focus across a boundary")
            attach(app, name: "textfield-form-scrolled-hint-\(theme)")
            let geometry = XCTAttachment(string: "Layout: \(layout); AX: \(last.frame); button: \(advance.frame); keyboard including predictions top: \(keyboardTop(app))")
            geometry.name = "textfield-form-geometry-\(theme)"; geometry.lifetime = .keepAlways; add(geometry)
            advance.tap()
            waitForDismissal(app)
            XCTAssertFalse(advance.exists)
            let final = app.textFields["tuiTextfieldInput-field-9"]
            if !final.isHittable { app.swipeUp() }
            final.tap(); app.typeText("Z")
            XCTAssertEqual(final.value as? String, "Z")
            XCTAssertTrue(advance.waitForExistence(timeout: 3)); XCTAssertEqual(advance.label, "Готово")
            attach(app, name: "textfield-form-last-done-\(theme)")
            advance.tap()
            waitForDismissal(app)
            first.tap()
            XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 3))
            // Tap the actually visible 12 pt gap. Tapping an offscreen heading
            // would let XCTest scroll first and could dismiss the keyboard
            // before the tap, falsely passing the blank-space requirement.
            let firstLayout = try XCTUnwrap(measuredFrame(app.otherElements["consumerFormField-0"].firstMatch))
            let gapPoint = CGVector(dx: app.frame.midX, dy: firstLayout.maxY + 6)
            XCTAssertLessThan(gapPoint.dy, keyboardTop(app))
            app.coordinate(withNormalizedOffset: .zero).withOffset(gapPoint).tap()
            waitForDismissal(app)
            app.terminate()
        }
    }

    @MainActor private func waitForDismissal(_ app: XCUIApplication) {
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
            !app.keyboards.firstMatch.exists && !app.buttons["tuiTextfieldFormAdvance"].exists
        }, object: nil)
        XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 3), .completed,
                       "Native keyboard and floating action must disappear after the normal closing transition")
    }

    @MainActor private func measuredFrame(_ element: XCUIElement) -> CGRect? {
        guard let text = element.value as? String, let data = text.data(using: .utf8),
              let numbers = try? JSONDecoder().decode([CGFloat].self, from: data), numbers.count == 4 else { return nil }
        return CGRect(x: numbers[0], y: numbers[1], width: numbers[2], height: numbers[3])
    }

    @MainActor private func keyboardTop(_ app: XCUIApplication) -> CGFloat {
        // The Keyboard AX element excludes the native prediction strip.
        // Measure that observed strip, rather than inventing a 44 pt correction.
        let predictions = app.otherElements["Typing Predictions"].firstMatch
        return predictions.exists ? min(predictions.frame.minY, app.keyboards.firstMatch.frame.minY)
            : app.keyboards.firstMatch.frame.minY
    }

    @MainActor private func attach(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
