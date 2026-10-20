import XCTest

final class ButtonInteractionUITests: XCTestCase {
    @MainActor
    func testSkeletonUsesInheritedPulseInEverySizeAndTheme() throws {
        for theme in ["day", "night"] {
            for size in ["large", "medium", "small"] {
                let app = launch(["--skeleton", "--theme", theme, "--size", size])
                let button = component(app)
                XCTAssertFalse(button.isEnabled)
                let frame = button.frame
                XCTAssertEqual(frame.height, size == "large" ? 56 : size == "medium" ? 44 : 30, accuracy: 0.5)
                var values: [Int] = []
                for index in 0..<8 {
                    let image = try XCTUnwrap(app.screenshot().image.cgImage)
                    let scale = CGFloat(image.width) / app.frame.width
                    let crop = try XCTUnwrap(image.cropping(to: CGRect(
                        x: frame.minX * scale, y: frame.minY * scale,
                        width: frame.width * scale, height: frame.height * scale).integral))
                    let center = try XCTUnwrap(crop.cropping(to: CGRect(
                        x: crop.width / 2, y: crop.height / 2, width: 1, height: 1)))
                    var pixel = [UInt8](repeating: 0, count: 4)
                    let context = try XCTUnwrap(CGContext(data: &pixel, width: 1, height: 1,
                        bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(),
                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
                    context.draw(center, in: CGRect(x: 0, y: 0, width: 1, height: 1))
                    values.append(Int(pixel[0]))
                    let attachment = XCTAttachment(image: UIImage(cgImage: crop))
                    attachment.name = "button-skeleton-\(size)-\(theme)-live-\(index)"
                    attachment.lifetime = .keepAlways
                    add(attachment)
                    XCTAssertEqual(button.frame, frame, "Pulse must not move or resize the actual Button")
                }
                XCTAssertGreaterThanOrEqual((values.max() ?? 0) - (values.min() ?? 0), theme == "night" ? 8 : 3,
                    "Inherited Skeleton must animate, rather than remain a static fill")
                for value in values {
                    XCTAssertTrue((theme == "night" ? 12...27 : 246...252).contains(value),
                        "Only the source opacity range and theme token may be used")
                }
                let measurements = XCTAttachment(string: "size=\(size), theme=\(theme), centerRed=\(values)")
                measurements.name = "button-skeleton-\(size)-\(theme)-live-measurements"
                measurements.lifetime = .keepAlways
                add(measurements)
                button.tap()
                XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "0")
            }
        }
    }

    @MainActor
    func testCatalogMediumHugFillAndLoadingRetainActualContainer() {
        let app = XCUIApplication()
        app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap(); search.typeText("tui-button")
        let entry = app.staticTexts["tui-button"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        let sizes = app.buttons["buttonSizePicker"]
        XCTAssertTrue(sizes.waitForExistence(timeout: 5)); sizes.tap()
        app.buttons["medium"].firstMatch.tap()
        let component = app.buttons["buttonPlaygroundComponent"]
        XCTAssertTrue(component.waitForExistence(timeout: 5))
        let fillWidth = component.frame.width
        let widths = app.segmentedControls["buttonMediumWidthPicker"]
        XCTAssertTrue(widths.waitForExistence(timeout: 5))
        widths.buttons["По содержимому"].tap()
        let hugWidth = component.frame.width
        XCTAssertLessThan(hugWidth, fillWidth)
        XCTAssertEqual(component.frame.height, 44, accuracy: 0.5)
        component.tap()
        attach(app, name: "button-medium-hug-live-catalog")
        app.buttons["buttonStatePicker"].tap()
        app.buttons["loading"].firstMatch.tap()
        XCTAssertEqual(component.frame.width, hugWidth, accuracy: 0.5)
        attach(app, name: "button-medium-hug-loading-live-catalog")
        widths.buttons["На всю ширину"].tap()
        XCTAssertEqual(component.frame.width, fillWidth, accuracy: 0.5)
        attach(app, name: "button-medium-fill-loading-live-catalog")
    }

    @MainActor
    func testCustomizedContainerUsesActualWidthAndPreservesLoadingActionGuard() {
        for size in ["large", "medium", "small"] {
            let app = launch(["--customized", "--load-on-tap", "--size", size])
            let button = component(app)
            XCTAssertEqual(button.frame.width, 240, accuracy: 0.5)
            XCTAssertEqual(button.frame.height, size == "large" ? 56 : size == "medium" ? 44 : 30, accuracy: 0.5)
            button.tap()
            XCTAssertEqual(button.label, "Идет загрузка")
            XCTAssertTrue(button.isEnabled)
            button.tap()
            XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "1")
            app.buttons["buttonProbeFinishLoading"].tap()
            XCTAssertEqual(button.label, "Отправить документ")
            XCTAssertEqual(button.frame.width, 240, accuracy: 0.5)
            attach(app, name: "button-customized-\(size)-native")
        }
    }
    @MainActor
    func testNormalAndPressedExecuteNativeAction() {
        for state in ["normal", "pressed"] {
            let app = launch(["--state", state])
            let button = component(app)
            XCTAssertTrue(button.isEnabled)
            XCTAssertEqual(button.label, "Отправить документ")
            button.tap()
            XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "1")
            button.tap()
            XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "2")
            attach(app, name: "button-\(state)-native-action")
        }
    }

    @MainActor
    func testLoadingHasSourceLabelAndEnabledTraitButSuppressesAction() {
        let app = launch(["--state", "loading"])
        let button = component(app)
        XCTAssertTrue(button.isEnabled, "Loading must not add the unavailable trait")
        XCTAssertEqual(button.label, "Идет загрузка")
        XCTAssertEqual(button.value as? String ?? "", "")
        button.tap()
        XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "0")
        attach(app, name: "button-loading-enabled-speech-action-blocked")
        app.buttons["buttonProbeFinishLoading"].tap()
        XCTAssertEqual(button.label, "Отправить документ")
        button.tap()
        XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "1")
    }

    @MainActor
    func testDisabledAndSkeletonSuppressNativeAction() {
        for arguments in [["--state", "disabled"], ["--skeleton"]] {
            let app = launch(arguments)
            let button = component(app)
            XCTAssertFalse(button.isEnabled)
            XCTAssertEqual(button.label, "Отправить документ")
            button.tap()
            XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "0")
            attach(app, name: arguments.contains("--skeleton") ? "button-skeleton" : "button-disabled")
        }
    }

    @MainActor
    func testLoadingTransitionKeepsIdentitySizeAndRestoresActionInBothThemes() {
        for theme in ["day", "night"] {
            for size in ["large", "medium", "small"] {
                let app = launch(["--load-on-tap", "--theme", theme, "--size", size])
                let button = component(app)
                let originalFrame = button.frame
                button.tap()
                XCTAssertEqual(button.label, "Идет загрузка")
                XCTAssertTrue(button.isEnabled)
                XCTAssertEqual(app.staticTexts["buttonProbeState"].label, "loading")
                XCTAssertEqual(button.frame.width, originalFrame.width, accuracy: 0.5)
                XCTAssertEqual(button.frame.height, originalFrame.height, accuracy: 0.5)
                button.tap()
                XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "1")
                attach(app, name: "button-\(size)-\(theme)-loading-transition")
                app.buttons["buttonProbeFinishLoading"].tap()
                XCTAssertEqual(button.label, "Отправить документ")
                XCTAssertEqual(button.frame.width, originalFrame.width, accuracy: 0.5)
                XCTAssertEqual(button.frame.height, originalFrame.height, accuracy: 0.5)
                button.tap()
                XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "2")
            }
        }
    }

    @MainActor
    func testCancelledNativePressDoesNotTriggerAction() {
        let app = launch(["--size", "small"])
        let button = component(app)
        let center = button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        center.press(forDuration: 0.3, thenDragTo: center.withOffset(CGVector(dx: 160, dy: 0)))
        XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "0")
        button.tap()
        XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "1")
        attach(app, name: "button-native-cancelled-press")
    }

    @MainActor
    func testIconOnlyKeepsMeaningfulLabelAndNativeButtonTrait() {
        let app = launch(["--icon-only"])
        let button = component(app)
        XCTAssertEqual(button.label, "Добавить документ")
        XCTAssertEqual(button.frame.width, 56, accuracy: 0.5)
        XCTAssertEqual(button.frame.height, 56, accuracy: 0.5)
        button.tap()
        XCTAssertEqual(app.staticTexts["buttonProbeTapCount"].label, "1")
        attach(app, name: "button-icon-only-meaningful-label")
    }

    @MainActor
    private func launch(_ arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-button-interaction-probe"] + arguments
        app.launch()
        return app
    }

    @MainActor
    private func component(_ app: XCUIApplication) -> XCUIElement {
        let button = app.buttons["buttonProbeComponent"]
        XCTAssertTrue(button.waitForExistence(timeout: 10))
        return button
    }

    @MainActor
    private func attach(_ app: XCUIApplication, name: String) {
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = name
        screenshot.lifetime = .keepAlways
        add(screenshot)
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = name + "-accessibility-tree"
        tree.lifetime = .keepAlways
        add(tree)
    }
}
