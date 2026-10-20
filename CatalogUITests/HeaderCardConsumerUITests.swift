import XCTest

final class HeaderCardConsumerUITests: XCTestCase {
    @MainActor func testIndependentMatrixAndButtonActions() throws {
        let app = consumer()
        for id in ["17714:53773", "17714:53869", "44217:298678", "44217:299480", "44217:299616",
                   "44217:299699", "44217:299799", "59830:293851", "59830:293951"] {
            select(id, in: app)
            XCTAssertEqual(app.staticTexts["consumerHeaderCardNode"].label, "Figma: " + id)
            if ["17714:53773", "17714:53869"].contains(id) {
                XCTAssertFalse(app.staticTexts["Подробнее об условиях сервиса"].exists)
            } else {
                let preview = app.descendants(matching: .any)["consumerHeaderCard"].firstMatch
                XCTAssertEqual(preview.frame.width, 375, accuracy: 0.5)
            }
        }
        for (index, id) in ["44217:299480", "44217:299616"].enumerated() {
            select(id, in: app)
            let action = app.buttons["Открыть условия"].firstMatch
            reveal(action, in: app, down: true); action.tap()
            dismissSheet(in: app)
            XCTAssertEqual(app.staticTexts["consumerHeaderCardPresses"].label, "Кнопка: \(index + 1)")
            XCTAssertEqual(app.staticTexts["consumerHeaderCardHints"].label, "Подсказки: 0")
        }
        let enabled = app.switches["consumerHeaderCardEnabled"]
        reveal(enabled, in: app); toggle(enabled)
        let disabled = app.buttons["Открыть условия"].firstMatch
        reveal(disabled, in: app, down: true)
        XCTAssertFalse(disabled.isEnabled)
        keep(XCTAttachment(screenshot: app.screenshot()), "header-card-consumer-disabled-link")
    }

    @MainActor func testNativeSwitchUsesBindingAndPreservesIndependentActions() throws {
        let app = consumer(variant: "44217:299699")
        let control = app.switches["Настройки уведомлений"].firstMatch
        XCTAssertTrue(control.waitForExistence(timeout: 5))
        XCTAssertEqual(control.value as? String, "0")
        toggle(control)
        XCTAssertEqual(control.value as? String, "1")
        XCTAssertEqual(app.staticTexts["consumerHeaderCardState"].label, "Переключатель: включён")
        XCTAssertEqual(app.staticTexts["consumerHeaderCardPresses"].label, "Кнопка: 0")
        let enabled = app.switches["consumerHeaderCardEnabled"]
        reveal(enabled, in: app); toggle(enabled)
        reveal(control, in: app, down: true)
        XCTAssertFalse(control.isEnabled)
        XCTAssertEqual(control.value as? String, "1")
        keep(XCTAttachment(screenshot: app.screenshot()), "header-card-consumer-native-switch")
        keep(XCTAttachment(string: app.debugDescription), "header-card-consumer-switch-tree")
    }

    @MainActor func testHeadingLinksBadgeCaptionAndHintRemainAccessible() throws {
        let app = consumer(variant: "59830:293951", probe: true)
        let snapshot = app.buttons["consumerHeaderCardAXSnapshot"]
        reveal(snapshot, in: app); snapshot.tap()
        let data = try XCTUnwrap(app.staticTexts["consumerHeaderCardAXPayload"].label.data(using: .utf8))
        keep(XCTAttachment(data: data, uniformTypeIdentifier: "public.json"), "header-card-consumer-ax-snapshot")
        let rows = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [[String: Any]])
        let heading = try XCTUnwrap(rows.first {
            ($0["isHeader"] as? Bool) == true && ($0["isElement"] as? Bool) == true &&
            ($0["label"] as? String)?.contains("Настройки уведомлений") == true
        })
        XCTAssertTrue((heading["label"] as? String)?.contains("ПОДПИСКА") == true)
        XCTAssertTrue((heading["label"] as? String)?.contains("Получать новости") == true)
        let actions = try XCTUnwrap(heading["actions"] as? [String])
        for name in ["Открыть ссылку: уведомлений", "Открыть ссылку: новости", "Подробнее об уведомлениях"] {
            XCTAssertTrue(actions.contains(name), "Missing heading action: " + name)
        }
        let description = try XCTUnwrap(rows.first {
            ($0["isElement"] as? Bool) == true && ($0["label"] as? String) == "Подробнее об условиях сервиса"
        })
        XCTAssertEqual(description["actions"] as? [String], ["Открыть ссылку: Подробнее"])
        for (index, word) in ["уведомлений", "новости", "Подробнее"].enumerated() {
            let action = app.buttons["consumerHeaderCardAX-" + word]
            reveal(action, in: app); action.tap()
            XCTAssertEqual(app.staticTexts["consumerHeaderCardAXResult"].label, "AX action: success")
            XCTAssertEqual(app.staticTexts["consumerHeaderCardLinks"].label, "Ссылок: \(index + 1)")
        }
        XCTAssertEqual(app.staticTexts["consumerHeaderCardTargets"].label,
                       "tui-consumer://header-card/title, tui-consumer://header-card/subheader, tui-consumer://header-card/description")
        let hint = app.buttons["consumerHeaderCardAX-Подробнее об уведомлениях"]
        reveal(hint, in: app); hint.tap()
        dismissSheet(in: app)
        XCTAssertEqual(app.staticTexts["consumerHeaderCardHints"].label, "Подсказки: 1")
        XCTAssertEqual(app.staticTexts["consumerHeaderCardPresses"].label, "Кнопка: 0")
        keep(XCTAttachment(string: app.debugDescription), "header-card-consumer-complete-content-tree")
    }

    @MainActor private func consumer(variant: String? = nil, probe: Bool = false) -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-card-consumer"]
        if let variant { app.launchArguments.append("--header-card-variant=" + variant) }
        if probe { app.launchArguments.append("--header-card-ax-probe") }
        app.launch()
        XCTAssertTrue(app.navigationBars["Header Card из пакета"].waitForExistence(timeout: 10))
        return app
    }
    @MainActor private func select(_ id: String, in app: XCUIApplication) {
        let picker = app.buttons["consumerHeaderCardVariant"]
        reveal(picker, in: app); picker.tap()
        let item = app.buttons[id].firstMatch
        XCTAssertTrue(item.waitForExistence(timeout: 5)); item.tap()
    }
    @MainActor private func reveal(_ element: XCUIElement, in app: XCUIApplication, down: Bool = false) {
        for _ in 0..<6 {
            if element.exists && element.isHittable { return }
            if down { app.swipeDown() } else { app.swipeUp() }
        }
        XCTAssertTrue(element.exists && element.isHittable)
    }
    @MainActor private func toggle(_ element: XCUIElement) {
        if element.switches.firstMatch.exists { element.switches.firstMatch.tap() } else { element.tap() }
    }
    @MainActor private func dismissSheet(in app: XCUIApplication) {
        XCTAssertTrue(app.staticTexts["Действие Header Card обработано приложением"].waitForExistence(timeout: 5))
        keep(XCTAttachment(screenshot: app.screenshot()), "header-card-consumer-native-sheet")
        app.buttons["Готово"].tap()
        XCTAssertTrue(app.navigationBars["Header Card из пакета"].waitForExistence(timeout: 5))
    }
    private func keep(_ attachment: XCTAttachment, _ name: String) {
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
