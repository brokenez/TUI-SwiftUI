import XCTest
import UIKit

final class TextfieldUITests: XCTestCase {
    @MainActor func testCenteredTextfieldSupportsRealInputInBothThemes() throws {
        let app = try openTextfield()
        func reveal(_ element: XCUIElement, scrollingUp: Bool) {
            for _ in 0..<10 where !element.isHittable {
                if scrollingUp { app.swipeUp() } else { app.swipeDown() }
            }
            XCTAssertTrue(element.waitForExistence(timeout: 3))
            XCTAssertTrue(element.isHittable)
        }

        let alignment = app.descendants(matching: .any)["textfieldAlignmentPicker"].firstMatch
        reveal(alignment, scrollingUp: true)
        alignment.tap()
        let centerButton = app.buttons["По центру"].firstMatch
        let center = centerButton.waitForExistence(timeout: 2) ? centerButton : app.staticTexts["По центру"].firstMatch
        XCTAssertTrue(center.waitForExistence(timeout: 3)); center.tap()
        // Automatic Form pickers can push a native choice list; menu pickers
        // dismiss themselves. Return only when that actual navigation page exists.
        let choicePage = app.navigationBars["Выравнивание текста"]
        if choicePage.exists { choicePage.buttons.firstMatch.tap() }

        for label in ["Label", "Очистка", "Loader"] {
            let toggle = app.switches[label].firstMatch
            reveal(toggle, scrollingUp: false)
            let control = toggle.switches.firstMatch.exists ? toggle.switches.firstMatch : toggle
            XCTAssertEqual(control.value as? String, "0", "Center demo must start in the source-supported configuration")
        }
        XCTAssertFalse(app.buttons["textfieldStartAction"].exists)
        XCTAssertFalse(app.buttons["textfieldEndAction"].exists)
        XCTAssertFalse(app.buttons["tuiTextfieldClear"].exists)

        let input = app.textFields["tuiTextfieldInput"]
        let status = app.staticTexts["textfieldStateValue"]
        let done = app.buttons["textfieldDone"]
        for (theme, value) in [("Day", "12345"), ("Night", "67890")] {
            if theme == "Night" {
                let themeButton = app.buttons["textfieldTheme"]
                reveal(themeButton, scrollingUp: true); themeButton.tap()
                XCTAssertEqual(themeButton.label, "Night")
            }
            reveal(input, scrollingUp: false)
            input.tap()
            XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 3))
            let previous = try XCTUnwrap(input.value as? String)
            input.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: previous.count) + value)
            XCTAssertEqual(input.value as? String, value)
            XCTAssertTrue(status.label.contains("Состояние: focus · значение: \(value)"))
            XCTAssertFalse(app.buttons["tuiTextfieldClear"].exists)
            attach(app, name: "textfield-centered-real-input-\(theme.lowercased())")
            reveal(done, scrollingUp: true); done.tap()
            XCTAssertTrue(status.label.contains("Состояние: normal · значение: \(value)"))
            XCTAssertTrue(app.keyboards.firstMatch.waitForNonExistence(timeout: 3))
        }
    }

    @MainActor func testCatalogOpensLivePublicFormAndCanChangeTheme() throws {
        let app = try openTextfield()
        let entry = app.buttons["textfieldFormDemo"].firstMatch
        for _ in 0..<3 where !entry.isHittable { app.swipeUp() }
        XCTAssertTrue(entry.waitForExistence(timeout: 3)); entry.tap()
        XCTAssertTrue(app.navigationBars["Форма Textfield"].waitForExistence(timeout: 3))
        let first = app.textFields["tuiTextfieldInput-demo-0"]
        XCTAssertTrue(first.waitForExistence(timeout: 3)); first.tap(); first.typeText("A")
        app.buttons["tuiTextfieldFormAdvance"].tap(); app.typeText("B")
        XCTAssertEqual(app.textFields["tuiTextfieldInput-demo-4"].value as? String, "B")
        XCTAssertTrue(app.keyboards.firstMatch.frame.intersects(app.frame))
        attach(app, name: "textfield-catalog-live-form-day")
        app.navigationBars.buttons["Day"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Night"].exists)
        XCTAssertEqual(app.textFields["tuiTextfieldInput-demo-4"].value as? String, "B")
        attach(app, name: "textfield-catalog-live-form-night")
    }

    @MainActor func testValidationFeedbackInActiveNativeScene() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-textfield-motion-probe"]
        app.launch()
        let start = app.buttons["textfieldMotionStart"]
        XCTAssertTrue(start.waitForExistence(timeout: 5)); start.tap()
        let result = app.staticTexts["textfieldMotionResult"]
        XCTAssertTrue(NSPredicate(format: "label == %@", "Готово")
            .evaluate(with: result) || XCTWaiter.wait(for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "label == %@", "Готово"), object: result)], timeout: 10) == .completed)
        XCTAssertFalse(app.keyboards.firstMatch.exists)
        attach(app, name: "textfield-validation-motion-probe-finished")
    }

    @MainActor func testCaptureCompleteSourceMatrixFromActiveNativeScene() throws {
        let app = try openTextfield()
        var samples: [[String: Any]] = []
        for theme in ["Day", "Night"] {
            if theme == "Night" { app.buttons["textfieldTheme"].tap() }
            app.buttons["textfieldFirstVariant"].tap()
            var observed = Set<String>()
            for _ in 0..<22 {
                let sourceText = app.staticTexts["textfieldSourceID"].label
                let id = sourceText.replacingOccurrences(of: "Figma: ", with: "")
                XCTAssertTrue(id.hasPrefix("65702:")); XCTAssertTrue(observed.insert(id).inserted)
                let preview = app.otherElements["textfieldPreview"].firstMatch
                XCTAssertTrue(preview.exists)
                let frame = preview.frame
                XCTAssertEqual(frame.width, 320, accuracy: 0.5)
                let expected: CGFloat = ["65702:51258", "65702:51406", "65702:51552", "65702:51616"].contains(id) ? 98 : 56
                XCTAssertEqual(frame.height, expected, accuracy: 0.5)
                let focused = app.staticTexts["textfieldStateValue"].label.contains("Состояние: focus")
                    || app.staticTexts["textfieldStateValue"].label.contains("Состояние: invalid-focus")
                func snapshot() throws -> (CGImage, CGFloat) {
                    let cg = try XCTUnwrap(app.screenshot().image.cgImage)
                    let scale = CGFloat(cg.width) / app.frame.width
                    // Fractional floating-point origins otherwise make CGImage
                    // expand the crop by one pixel despite an exact 98 pt frame.
                    let crop = CGRect(x: (frame.minX * scale).rounded(), y: (frame.minY * scale).rounded(),
                                      width: (frame.width * scale).rounded(), height: (frame.height * scale).rounded())
                    return (try XCTUnwrap(cg.cropping(to: crop)), scale)
                }
                var (cg, scale) = try snapshot()
                // Capture the real visible phase of the native blinking caret.
                // Never paint a cursor into a screenshot or alter native animation speed.
                for _ in 0..<8 where focused && !containsNativeCaret(cg) {
                    Thread.sleep(forTimeInterval: 0.15)
                    (cg, scale) = try snapshot()
                }
                let cursorVisible = containsNativeCaret(cg)
                XCTAssertTrue(!focused || cursorVisible, "Native focus must display a real caret: \(id)")
                let image = UIImage(cgImage: cg)
                let attachment = XCTAttachment(image: image)
                attachment.name = "textfield-source-\(id.replacingOccurrences(of: ":", with: "-"))-\(theme)-native-3x"
                attachment.lifetime = .keepAlways; add(attachment)
                samples.append(["variantID": id, "theme": theme, "frame": [frame.minX, frame.minY, frame.width, frame.height], "scale": scale,
                                "focused": focused, "cursorVisible": cursorVisible])
                app.buttons["textfieldNextVariant"].tap()
            }
            XCTAssertEqual(observed.count, 22)
        }
        let attachment = XCTAttachment(data: try JSONSerialization.data(withJSONObject: samples, options: [.prettyPrinted, .sortedKeys]),
                                       uniformTypeIdentifier: "public.json")
        attachment.name = "textfield-source-native-matrix-metadata"; attachment.lifetime = .keepAlways; add(attachment)
    }

    private func containsNativeCaret(_ image: CGImage) -> Bool {
        var pixels = [UInt8](repeating: 0, count: image.width * image.height * 4)
        let drawn = pixels.withUnsafeMutableBytes { bytes -> Bool in
            guard let context = CGContext(data: bytes.baseAddress, width: image.width, height: image.height,
                bitsPerComponent: 8, bytesPerRow: image.width * 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return false }
            context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
            return true
        }
        guard drawn else { return false }
        var bluePixels = 0
        for i in stride(from: 0, to: pixels.count, by: 4) {
            if Int(pixels[i + 2]) > Int(pixels[i]) + 40,
               Int(pixels[i + 2]) > Int(pixels[i + 1]) + 20,
               pixels[i + 3] > 200 { bluePixels += 1 }
        }
        return bluePixels >= 20
    }

    @MainActor func testActualInputClearingValidationAndSubmit() throws {
        let app = try openTextfield()
        let input = app.textFields["tuiTextfieldInput"]
        XCTAssertTrue(input.waitForExistence(timeout: 5))
        input.tap()
        let clear = app.buttons["tuiTextfieldClear"]
        XCTAssertTrue(clear.waitForExistence(timeout: 3)); clear.tap()
        XCTAssertFalse(clear.exists)
        input.typeText("Alpha")
        XCTAssertEqual(input.value as? String, "Alpha")
        app.buttons["textfieldInvalidate"].tap()
        XCTAssertTrue(app.staticTexts["textfieldStateValue"].label.contains("invalid-focus"))
        input.typeText("x")
        XCTAssertTrue(app.staticTexts["textfieldStateValue"].label.contains("focus · значение: Alphax"))
        let done = app.keyboards.buttons["Done"].exists ? app.keyboards.buttons["Done"] : app.keyboards.buttons["Готово"]
        XCTAssertTrue(done.exists); done.tap()
        XCTAssertTrue(app.staticTexts["textfieldStateValue"].label.contains("отправок: 1"))
        attach(app, name: "textfield-native-input-validation-submit")
    }

    @MainActor func testReadOnlySelectionAndDisabledDoNotOpenKeyboard() throws {
        let app = try openTextfield()
        let picker = app.buttons["textfieldStatePicker"]
        let input = app.textFields["tuiTextfieldInput"]
        input.tap()
        XCTAssertTrue(app.keyboards.firstMatch.exists)
        picker.tap(); app.buttons["read-only"].firstMatch.tap()
        // The editor was already focused before switching to read-only.
        // Native iOS selects a word with a double tap; long press in an active
        // editor can enter insertion-point placement instead of selecting it.
        input.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
            .doubleTap()
        let copy = app.menuItems.matching(NSPredicate(format: "label IN %@", ["Copy", "Копировать", "Скопировать"])).firstMatch
        let selectAll = app.menuItems.matching(NSPredicate(format: "label IN %@", ["Select All", "Выбрать всё"])).firstMatch
        if selectAll.exists { selectAll.tap() }
        XCTAssertTrue(copy.waitForExistence(timeout: 3), "Read-only must permit native selection and Copy")
        XCTAssertFalse(app.menuItems.matching(NSPredicate(format: "label IN %@", ["Cut", "Вырезать", "Paste", "Вставить", "AutoFill", "Автозаполнение", "Replace…", "Заменить…", "No Replacements Found"])).firstMatch.exists)
        XCTAssertEqual(input.value as? String, "Value")
        XCTAssertFalse(app.keyboards.firstMatch.exists)
        attach(app, name: "textfield-read-only-native-selection")
        copy.tap()
        // A subsequent paste in the editable field proves that Copy copied
        // the selected value; menu availability alone would not establish it.
        app.buttons["textfieldDone"].tap()
        input.tap(); app.buttons["tuiTextfieldClear"].tap()
        input.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5)).press(forDuration: 1)
        let paste = app.menuItems.matching(NSPredicate(format: "label IN %@", ["Paste", "Вставить"])).firstMatch
        XCTAssertTrue(paste.waitForExistence(timeout: 3)); paste.tap()
        XCTAssertEqual(input.value as? String, "Value")
        attach(app, name: "textfield-copy-paste-round-trip")
        XCTAssertTrue(app.keyboards.firstMatch.exists)
        picker.tap(); app.buttons["disabled"].firstMatch.tap()
        input.tap()
        XCTAssertEqual(input.value as? String, "Value")
        XCTAssertTrue(app.staticTexts["textfieldStateValue"].label.contains("disabled"))
        XCTAssertFalse(app.keyboards.firstMatch.exists)
        attach(app, name: "textfield-disabled")
    }

    @MainActor func testCharacterLimitInLiveNativeEditor() throws {
        let app = try openTextfield()
        let limit = app.switches["textfieldLimitToggle"]
        for _ in 0..<5 where !limit.isHittable { app.swipeUp() }
        XCTAssertTrue(limit.isHittable); limit.switches.firstMatch.tap()
        app.swipeDown(); app.swipeDown()
        let input = app.textFields["tuiTextfieldInput"]
        input.tap(); app.buttons["tuiTextfieldClear"].tap()
        input.typeText("123456789")
        XCTAssertEqual(input.value as? String, "12345")
        attach(app, name: "textfield-native-character-limit")
    }

    @MainActor func testCustomActionsAndTapOnlyRespectWholeFieldDisabled() throws {
        let app = try openTextfield()
        app.buttons["textfieldCustomActions"].tap()
        let start = app.buttons["textfieldStartAction"]
        let end = app.buttons["textfieldEndAction"]
        let hint = app.buttons["textfieldHintAction"]
        start.tap(); end.tap(); hint.tap()
        let counts = app.staticTexts["textfieldActionCounts"]
        XCTAssertEqual(counts.label, "Слева: 1 · справа: 1 · ссылка: 1 · поле: 0")
        XCTAssertFalse(app.keyboards.firstMatch.exists, "Accessory actions must not implicitly focus the input")
        XCTAssertTrue(app.staticTexts["textfieldStateValue"].label.contains("Состояние: normal"))
        let picker = app.buttons["textfieldStatePicker"]
        picker.tap(); app.buttons["disabled"].firstMatch.tap()
        XCTAssertFalse(start.isEnabled); XCTAssertFalse(hint.isEnabled)
        // Send real coordinate taps too: disabled semantics alone do not prove
        // that nested custom gestures and actions are blocked.
        start.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        hint.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertEqual(counts.label, "Слева: 1 · справа: 1 · ссылка: 1 · поле: 0")
        XCTAssertFalse(app.keyboards.firstMatch.exists)
        attach(app, name: "textfield-disabled-nested-actions")
        app.buttons["textfieldCustomActions"].tap()
        app.buttons["textfieldTapOnly"].tap()
        let input = app.textFields["tuiTextfieldInput"]
        input.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertEqual(counts.label, "Слева: 1 · справа: 1 · ссылка: 1 · поле: 1")
        XCTAssertFalse(app.keyboards.firstMatch.exists)
        input.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5)).press(forDuration: 1)
        XCTAssertFalse(app.menuItems.firstMatch.exists, "Tap-only does not offer selection or editing")
        picker.tap(); app.buttons["disabled"].firstMatch.tap()
        input.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertEqual(counts.label, "Слева: 1 · справа: 1 · ссылка: 1 · поле: 1")
        attach(app, name: "textfield-tap-only-disabled")
    }

    @MainActor func testSkeletonUsesLiveReusableAnimation() throws {
        let app = try openTextfield()
        let toggle = app.switches["textfieldSkeletonToggle"]
        for _ in 0..<5 where !toggle.isHittable { app.swipeUp() }
        XCTAssertTrue(toggle.isHittable); toggle.switches.firstMatch.tap()
        app.swipeDown(); app.swipeDown()
        let preview = app.otherElements["textfieldPreview"].firstMatch
        XCTAssertTrue(preview.exists)
        XCTAssertEqual(preview.frame.height, 56, accuracy: 0.5)
        XCTAssertFalse(app.textFields["tuiTextfieldInput"].exists)
        let frame = preview.frame
        let began = Date()
        var samples: [[String: Any]] = []
        for index in 0..<8 {
            let image = app.screenshot().image
            let cg = try XCTUnwrap(image.cgImage)
            let scale = CGFloat(cg.width) / app.frame.width
            let crop = CGRect(x: (frame.minX * scale).rounded(), y: (frame.minY * scale).rounded(),
                width: (frame.width * scale).rounded(), height: (frame.height * scale).rounded())
            let field = try XCTUnwrap(cg.cropping(to: crop))
            var rgba = [UInt8](repeating: 0, count: 4)
            let pixel = try XCTUnwrap(field.cropping(to: CGRect(x: field.width / 2, y: field.height / 2, width: 1, height: 1)))
            rgba.withUnsafeMutableBytes { bytes in
                let context = CGContext(data: bytes.baseAddress, width: 1, height: 1, bitsPerComponent: 8,
                    bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
                context.draw(pixel, in: CGRect(x: 0, y: 0, width: 1, height: 1))
            }
            samples.append(["elapsed": Date().timeIntervalSince(began), "centerRGBA": rgba])
            let attachment = XCTAttachment(image: UIImage(cgImage: field))
            attachment.name = "textfield-skeleton-live-\(index)-3x"; attachment.lifetime = .keepAlways; add(attachment)
            Thread.sleep(forTimeInterval: 0.12)
        }
        let red = samples.map { ($0["centerRGBA"] as! [UInt8])[0] }
        XCTAssertGreaterThanOrEqual(Int(red.max()!) - Int(red.min()!), 2, "Skeleton must animate in the active native scene")
        let metadata = XCTAttachment(data: try JSONSerialization.data(withJSONObject: samples, options: [.prettyPrinted]),
                                     uniformTypeIdentifier: "public.json")
        metadata.name = "textfield-skeleton-live-samples"; metadata.lifetime = .keepAlways; add(metadata)
    }

    @MainActor private func openTextfield() throws -> XCUIApplication {
        let app = XCUIApplication(); app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5)); search.tap(); search.typeText("tui-textfield")
        let entry = app.staticTexts["tui-textfield "].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        return app
    }

    @MainActor private func attach(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name; attachment.lifetime = .keepAlways; add(attachment)
    }
}
