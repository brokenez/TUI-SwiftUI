import XCTest
import UIKit

final class LoaderUITests: XCTestCase {
    @MainActor
    func testCaptureTwoNativeLoaderCyclesWithTimestamps() async throws {
        let app = try openLoader()
        let toggle = app.switches["loaderAnimationToggle"]
        toggle.switches.firstMatch.tap()
        app.buttons["loaderSizePicker"].tap()
        app.buttons["40 × 40"].firstMatch.tap()
        let loader = app.descendants(matching: .any).matching(identifier: "43680:292637").firstMatch
        XCTAssertTrue(loader.waitForExistence(timeout: 5))
        let frame = loader.frame
        XCTAssertEqual(frame.width, 40, accuracy: 0.5)
        XCTAssertEqual(frame.height, 40, accuracy: 0.5)
        toggle.switches.firstMatch.tap()
        let clock = ContinuousClock()
        let started = clock.now
        var times: [[String: Double]] = []
        while started.duration(to: clock.now) < .milliseconds(8500) {
            let before = seconds(started.duration(to: clock.now))
            let screenshot = app.screenshot()
            let after = seconds(started.duration(to: clock.now))
            let pixels = try croppedLoader(screenshot, frame: frame, appFrame: app.frame)
            let attachment = XCTAttachment(data: pixels, uniformTypeIdentifier: "public.png")
            attachment.name = String(format: "loader-native-timeline-frame-%03d", times.count)
            attachment.lifetime = .keepAlways
            add(attachment)
            times.append(["index": Double(times.count), "beforeScreenshot": before, "afterScreenshot": after])
            try await Task.sleep(for: .milliseconds(50))
        }
        XCTAssertGreaterThan(times.count, 12, "Capture actual scene frames across two full cycles")
        let metadata: [String: Any] = ["durationSeconds": seconds(started.duration(to: clock.now)),
            "sourceVariantID": "43680:292637", "frameInPoints": [frame.minX, frame.minY, frame.width, frame.height],
            "appFrameInPoints": [app.frame.width, app.frame.height], "samples": times]
        let data = try JSONSerialization.data(withJSONObject: metadata, options: [.prettyPrinted, .sortedKeys])
        let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "public.json")
        attachment.name = "loader-native-timeline-timestamps"
        attachment.lifetime = .keepAlways
        add(attachment)
        toggle.switches.firstMatch.tap()
    }

    private func seconds(_ duration: Duration) -> Double {
        let parts = duration.components
        return Double(parts.seconds) + Double(parts.attoseconds) / 1e18
    }

    @MainActor
    func testLiveLoaderMotionAndSourceVariantSelection() async throws {
        let app = try openLoader()
        let toggle = app.switches["loaderAnimationToggle"]
        XCTAssertTrue(toggle.isHittable); toggle.switches.firstMatch.tap()
        let loader = app.descendants(matching: .any).matching(identifier: "42819:293395").firstMatch
        XCTAssertTrue(loader.waitForExistence(timeout: 5))
        XCTAssertEqual(loader.frame.width, 24, accuracy: 0.5)
        let sourceFrame = loader.frame
        toggle.switches.firstMatch.tap()
        try await Task.sleep(for: .milliseconds(400))
        let original = app.screenshot()
        let initialPixels = try croppedLoader(original, frame: sourceFrame, appFrame: app.frame)
        let initial = XCTAttachment(screenshot: original)
        initial.name = "loader-active-scene-frame-0"; initial.lifetime = .keepAlways; add(initial)
        // A screenshot comparison detects the actual scene timeline advancing, not only the time function.
        var changed = false
        for _ in 0..<6 {
            try await Task.sleep(for: .milliseconds(400))
            if try croppedLoader(app.screenshot(), frame: sourceFrame, appFrame: app.frame) != initialPixels {
                changed = true; break
            }
        }
        XCTAssertTrue(changed, "The actual loader pixels must change in an active scene")
        attach(app, name: "loader-active-scene-frame-changed")
        XCTAssertTrue(toggle.isHittable); toggle.switches.firstMatch.tap()
        XCTAssertEqual(toggle.value as? String, "0")
        let picker = app.buttons["loaderSizePicker"]
        for (size, node) in [(12, "42819:293394"), (16, "42678:293418"), (32, "42977:286792"), (40, "43680:292637")] {
            picker.tap()
            let option = app.buttons["\(size) × \(size)"].firstMatch
            XCTAssertTrue(option.waitForExistence(timeout: 3)); option.tap()
            let selected = app.descendants(matching: .any).matching(identifier: node).firstMatch
            XCTAssertTrue(selected.waitForExistence(timeout: 3))
            XCTAssertEqual(selected.frame.width, CGFloat(size), accuracy: 0.5)
            XCTAssertEqual(selected.frame.height, CGFloat(size), accuracy: 0.5)
            attach(app, name: "loader-source-size-\(size)")
        }
    }

    @MainActor
    func testCustomDiameterColorAndThicknessUseNativeControls() throws {
        let app = try openLoader()
        app.switches["loaderAnimationToggle"].switches.firstMatch.tap()
        let picker = app.buttons["loaderColorPicker"]
        XCTAssertTrue(picker.isHittable); picker.tap()
        app.buttons["Action"].firstMatch.tap()
        let toggle = app.switches["loaderCustomSizeToggle"]
        toggle.switches.firstMatch.tap()
        let stepper = app.steppers["loaderDiameterStepper"]
        XCTAssertTrue(stepper.waitForExistence(timeout: 3))
        stepper.buttons["loaderDiameterStepper-Increment"].tap()
        let loader = app.descendants(matching: .any).matching(identifier: "42819:293395").firstMatch
        XCTAssertEqual(loader.frame.width, 30, accuracy: 0.5)
        let thickness = app.switches["loaderCustomThicknessToggle"]
        thickness.switches.firstMatch.tap()
        let thicknessStepper = app.steppers["loaderThicknessStepper"]
        XCTAssertTrue(thicknessStepper.waitForExistence(timeout: 3))
        thicknessStepper.buttons["loaderThicknessStepper-Increment"].tap()
        XCTAssertTrue(app.staticTexts["Толщина: 3,5"].exists || app.staticTexts["Толщина: 3.5"].exists)
        attach(app, name: "loader-custom-native-controls")
    }

    @MainActor private func openLoader() throws -> XCUIApplication {
        let app = XCUIApplication(); app.launch()
        let search = app.searchFields.firstMatch
        XCTAssertTrue(search.waitForExistence(timeout: 5)); search.tap(); search.typeText("tui-loader")
        let entry = app.staticTexts["tui-loader"].firstMatch
        XCTAssertTrue(entry.waitForExistence(timeout: 5)); entry.tap()
        return app
    }

    @MainActor private func attach(_ app: XCUIApplication, name: String) {
        let image = XCTAttachment(screenshot: app.screenshot())
        image.name = name; image.lifetime = .keepAlways; add(image)
    }

    @MainActor private func croppedLoader(_ screenshot: XCUIScreenshot, frame: CGRect, appFrame: CGRect) throws -> Data {
        let cg = try XCTUnwrap(screenshot.image.cgImage)
        let scale = CGFloat(cg.width) / appFrame.width
        let rect = CGRect(x: (frame.minX - appFrame.minX) * scale,
                          y: (frame.minY - appFrame.minY) * scale,
                          width: frame.width * scale, height: frame.height * scale)
        return try XCTUnwrap(UIImage(cgImage: try XCTUnwrap(cg.cropping(to: rect))).pngData())
    }
}
