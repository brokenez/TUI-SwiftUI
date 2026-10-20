import XCTest

final class SocialButtonUITests: XCTestCase {
    @MainActor
    func testShareNativeActionAndCustomAccessibilityLabel() {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-social-button-probe", "--kind", "share", "--label", "Отправить документ"]
        app.launch()
        let button = app.buttons["tuiButtonShare-44290:299204"]
        XCTAssertTrue(button.waitForExistence(timeout: 10))
        XCTAssertEqual(button.label, "Отправить документ")
        XCTAssertEqual(button.frame.width, 44, accuracy: 0.5)
        XCTAssertEqual(button.frame.height, 44, accuracy: 0.5)
        button.tap()
        XCTAssertEqual(app.staticTexts["socialProbeTapCount"].label, "1")
        button.tap()
        XCTAssertEqual(app.staticTexts["socialProbeTapCount"].label, "2")
        assertVisibleGlyph(app, button: button, red: false)
        attach(app, name: "share-native-action-custom-label")
    }

    @MainActor
    func testLikeNativeSelectionAndSelectedTrait() {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-social-button-probe", "--kind", "like"]
        app.launch()
        let unselected = app.buttons["tuiButtonLike-44290:299175"]
        XCTAssertTrue(unselected.waitForExistence(timeout: 10))
        XCTAssertEqual(unselected.label, "В избранное")
        XCTAssertFalse(unselected.isSelected)
        unselected.tap()
        let selected = app.buttons["tuiButtonLike-44290:299177"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        XCTAssertTrue(selected.isSelected)
        XCTAssertEqual(app.staticTexts["socialProbeSelection"].label, "on")
        XCTAssertEqual(app.staticTexts["socialProbeTapCount"].label, "1")
        assertVisibleGlyph(app, button: selected, red: true)
        attach(app, name: "like-selected-native-trait")
        selected.tap()
        XCTAssertTrue(unselected.waitForExistence(timeout: 5))
        XCTAssertFalse(unselected.isSelected)
        XCTAssertEqual(app.staticTexts["socialProbeSelection"].label, "off")
        XCTAssertEqual(app.staticTexts["socialProbeTapCount"].label, "2")
        assertVisibleGlyph(app, button: unselected, red: false)
        attach(app, name: "like-deselected-native-trait")
    }

    @MainActor
    func testEveryNativeStateAndThemeProducesRenderingEvidence() throws {
        let appearances = ["secondary", "glass-on-light", "glass-on-dark"]
        for kind in ["share", "like"] {
            for appearance in appearances {
                for state in ["normal", "pressed"] {
                    for selected in kind == "like" ? ["off", "on"] : ["off"] {
                        for theme in ["day", "night"] {
                            let app = XCUIApplication()
                            app.launchArguments = ["--tui-social-button-probe", "--kind", kind,
                                "--appearance", appearance, "--state", state,
                                "--selected", selected, "--theme", theme]
                            app.launch()
                            let prefix = kind == "like" ? "tuiButtonLike-" : "tuiButtonShare-"
                            let button = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", prefix)).firstMatch
                            XCTAssertTrue(button.waitForExistence(timeout: 10))
                            XCTAssertEqual(button.frame.width, 44, accuracy: 0.5)
                            XCTAssertEqual(button.frame.height, 44, accuracy: 0.5)
                            let nodeID = String(button.identifier.dropFirst(prefix.count))
                            let image = try crop(app, button: button)
                            let attachment = XCTAttachment(data: try XCTUnwrap(image.pngData()),
                                uniformTypeIdentifier: "public.png")
                            attachment.name = "ios-\(nodeID.replacingOccurrences(of: ":", with: "-"))-\(theme)-3x"
                            attachment.lifetime = .keepAlways
                            add(attachment)
                        }
                    }
                }
            }
        }
    }

    @MainActor
    func testNativeAX1AndAX5RemainFiftyPoints() {
        for kind in ["share", "like"] {
            for typeSize in ["XXXL", "AX1", "AX5"] {
                let app = XCUIApplication()
                app.launchArguments = ["--tui-social-button-probe", "--kind", kind, "--type-size", typeSize]
                app.launch()
                let prefix = kind == "like" ? "tuiButtonLike-" : "tuiButtonShare-"
                let button = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", prefix)).firstMatch
                XCTAssertTrue(button.waitForExistence(timeout: 10))
                let expected: CGFloat = typeSize == "XXXL" ? 44 : 50
                XCTAssertEqual(button.frame.width, expected, accuracy: 0.5)
                XCTAssertEqual(button.frame.height, expected, accuracy: 0.5)
                attach(app, name: "\(kind)-native-\(typeSize)")
            }
        }
    }

    @MainActor
    func testNativePressCancellationDoesNotTriggerAction() {
        for kind in ["share", "like"] {
            let app = XCUIApplication()
            app.launchArguments = ["--tui-social-button-probe", "--kind", kind]
            app.launch()
            let prefix = kind == "like" ? "tuiButtonLike-" : "tuiButtonShare-"
            let button = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", prefix)).firstMatch
            XCTAssertTrue(button.waitForExistence(timeout: 10))
            let center = button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            let outside = center.withOffset(CGVector(dx: 120, dy: 0))
            center.press(forDuration: 0.3, thenDragTo: outside)
            XCTAssertEqual(app.staticTexts["socialProbeTapCount"].label, "0")
            XCTAssertEqual(app.staticTexts["socialProbeSelection"].label, "off")
            attach(app, name: "\(kind)-cancelled-press")
            button.tap()
            XCTAssertEqual(app.staticTexts["socialProbeTapCount"].label, "1")
        }
    }

    @MainActor
    func testGlassOnExactSpecificationBackdropProducesEvidence() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-social-button-probe", "--spec-dark-backdrop"]
        app.launch()
        for node in ["26951:46960", "26951:46984", "26951:46966", "26951:46990"] {
            let button = app.buttons["tuiButtonLike-" + node]
            XCTAssertTrue(button.waitForExistence(timeout: 10))
            XCTAssertEqual(button.frame.width, 44, accuracy: 0.5)
            let attachment = XCTAttachment(data: try XCTUnwrap(crop(app, button: button).pngData()),
                uniformTypeIdentifier: "public.png")
            attachment.name = "spec-backdrop-" + node.replacingOccurrences(of: ":", with: "-") + "-3x"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
        attach(app, name: "exact-specification-backdrop")
    }

    @MainActor
    private func crop(_ app: XCUIApplication, button: XCUIElement) throws -> UIImage {
        let screenshot = app.screenshot().image
        let cg = try XCTUnwrap(screenshot.cgImage)
        let scale = CGFloat(cg.width) / app.frame.width
        let rect = CGRect(x: button.frame.minX * scale, y: button.frame.minY * scale,
            width: button.frame.width * scale, height: button.frame.height * scale).integral
        return UIImage(cgImage: try XCTUnwrap(cg.cropping(to: rect)))
    }

    @MainActor
    private func assertVisibleGlyph(_ app: XCUIApplication, button: XCUIElement, red: Bool) {
        do {
            let cg = try XCTUnwrap(crop(app, button: button).cgImage)
            var pixels = [UInt8](repeating: 0, count: cg.width * cg.height * 4)
            let context = try XCTUnwrap(CGContext(data: &pixels, width: cg.width, height: cg.height,
                bitsPerComponent: 8, bytesPerRow: cg.width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
            context.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
            var colored = 0
            for i in stride(from: 0, to: pixels.count, by: 4) {
                let r = Int(pixels[i]), g = Int(pixels[i + 1]), b = Int(pixels[i + 2])
                if red ? (r > g + 40 && r > b + 40) : (b > r + 40 && b > g + 20) { colored += 1 }
            }
            XCTAssertGreaterThan(colored, 100,
                "Exported icon must render visibly; a native Button without its glyph is not accepted")
        } catch { XCTFail("Cannot inspect rendered glyph: \(error)") }
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
