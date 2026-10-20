import XCTest
import UIKit

final class HeaderCardUITests: XCTestCase {
    @MainActor func testButtonLinkAndNativeSwitchUseConsumerState() throws {
        let app = XCUIApplication()
        app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap(); search.typeText("tui-header [card]")
        let entry = app.staticTexts["tui-header [card]"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        select("Button · Standard", in: app)
        scrollTo(app.buttons["Label"].firstMatch, in: app, up: false)
        app.buttons["Label"].firstMatch.tap()
        XCTAssertEqual(app.staticTexts["headerCardActionCount"].label, "Кнопка: 1")
        select("Button Link · Standard", in: app)
        scrollTo(app.buttons["Label"].firstMatch, in: app, up: false)
        app.buttons["Label"].firstMatch.tap()
        XCTAssertEqual(app.staticTexts["headerCardActionCount"].label, "Кнопка: 2")
        select("Switch · Standard", in: app)
        let toggle = app.switches["Header"].firstMatch
        scrollTo(toggle, in: app, up: false)
        XCTAssertEqual(toggle.value as? String, "0")
        let preview = app.descendants(matching: .any)["headerCardPreview"].firstMatch
        XCTAssertEqual(preview.frame.width, 375, accuracy: 0.5)
        XCTAssertEqual(preview.frame.height, 80, accuracy: 0.5)
        let control = toggle.switches.firstMatch
        if control.exists { control.tap() } else { toggle.tap() }
        XCTAssertEqual(toggle.value as? String, "1")
        XCTAssertEqual(app.staticTexts["headerCardSwitchState"].label, "Переключатель: включён")
        XCTAssertEqual(app.staticTexts["headerCardActionCount"].label, "Кнопка: 2")
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = "header-card-native-switch-and-actions"; shot.lifetime = .keepAlways; add(shot)
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "header-card-native-accessibility-tree"; tree.lifetime = .keepAlways; add(tree)
        // Restore the source's off state before taking the second-theme render.
        if control.exists { control.tap() } else { toggle.tap() }
        let night = app.buttons["Night"].firstMatch
        scrollTo(night, in: app); night.tap()
        scrollTo(preview, in: app, up: false)
        XCTAssertEqual(toggle.value as? String, "0")
        XCTAssertEqual(preview.frame.height, 80, accuracy: 0.5)
    }
    @MainActor func testNativeSwitchRendersOnAnUnclipped375PointHost() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-header-card-snapshot-probe"]
        app.launch()
        let preview = app.descendants(matching: .any)["headerCardSnapshot"].firstMatch
        XCTAssertTrue(preview.waitForExistence(timeout: 5))
        for theme in ["day", "night"] {
            if theme == "night" {
                app.buttons["headerCardSnapshotTheme"].tap()
                XCTAssertEqual(app.staticTexts["headerCardSnapshotThemeValue"].label, "Night")
            }
            XCTAssertEqual(app.switches["Header"].firstMatch.value as? String, "0")
            XCTAssertEqual(preview.frame.width, 375, accuracy: 0.5)
            XCTAssertEqual(preview.frame.height, 80, accuracy: 0.5)
            let screenshot = app.screenshot().image
            let scale = screenshot.scale
            let box = CGRect(x: (preview.frame.minX * scale).rounded(),
                             y: (preview.frame.minY * scale).rounded(),
                             width: 375 * scale, height: 80 * scale)
            let cropped = try XCTUnwrap(screenshot.cgImage?.cropping(to: box))
            let native = UIImage(cgImage: cropped, scale: scale, orientation: .up)
            XCTAssertEqual(cropped.width, 1125); XCTAssertEqual(cropped.height, 240)
            let shot = XCTAttachment(image: native)
            shot.name = "header-card-44217-299699-\(theme)-3x"; shot.lifetime = .keepAlways; add(shot)
            let provenance = XCTAttachment(string: "Native screenshot crop only; no resizing or color changes. AX frame \(preview.frame); captured pixel rectangle \(box); scale \(scale).")
            provenance.name = "header-card-switch-capture-\(theme)"; provenance.lifetime = .keepAlways; add(provenance)
        }
    }
    @MainActor private func select(_ name: String, in app: XCUIApplication) {
        let picker = app.buttons["headerCardVariantPicker"]
        scrollTo(picker, in: app)
        picker.tap()
        let item = app.buttons[name].firstMatch
        XCTAssertTrue(item.waitForExistence(timeout: 5))
        item.tap()
    }
    @MainActor private func scrollTo(_ element: XCUIElement, in app: XCUIApplication, up: Bool = true) {
        for _ in 0..<8 {
            if element.exists && element.isHittable { return }
            if up { app.swipeUp() } else { app.swipeDown() }
        }
        XCTAssertTrue(element.exists && element.isHittable)
    }
}
