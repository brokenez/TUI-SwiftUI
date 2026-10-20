import XCTest

final class SystemMotionUITests: XCTestCase {
    @MainActor
    func testExistingSkeletonRouteRetainsLiveCoreAndTextAfterNewProbeRoute() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-skeleton-motion-probe"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Live"].waitForExistence(timeout: 10))
        let active = try samples(app, prefix: "textfield-host-route-regression")
        XCTAssertGreaterThan((active.max() ?? 0) - (active.min() ?? 0), 3)
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "skeleton-existing-route-after-textfield-probe"
        tree.lifetime = .keepAlways
        add(tree)
    }

    @MainActor
    func testSkeletonAccessibilitySemanticsInNativeApplication() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-skeleton-motion-probe"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Live"].waitForExistence(timeout: 10))
        // Decorative placeholders must not become controls or unnamed
        // elements requiring a screen-reader description.
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "skeleton-native-accessibility-audit-tree"
        tree.lifetime = .keepAlways
        add(tree)
        let report = XCTAttachment(string: "Native XCTest audits: elementDetection, sufficientElementDescription, trait. No issues filtered. VoiceOver audio was not recorded.")
        report.name = "skeleton-native-accessibility-audit-scope"
        report.lifetime = .keepAlways
        add(report)
    }

    @MainActor
    func testSkeletonRespectsSystemReduceMotionAndResumesAfterBackground() throws {
        let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settings.launch()
        let accessibility = settings.buttons["com.apple.settings.accessibility"]
        XCTAssertTrue(accessibility.waitForExistence(timeout: 10))
        accessibility.tap()
        let motion = settings.buttons["MOTION_TITLE"]
        XCTAssertTrue(motion.waitForExistence(timeout: 10))
        motion.tap()
        let toggle = settings.switches["REDUCE_MOTION"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 10))
        // Settings exposes the row as a Switch and nests the actual UISwitch.
        // Tapping the row's centre hits its label and does not change the setting.
        // Querying nested switches is unstable after Settings adds the
        // cross-fade row. The observed UISwitch centre is at 91% of this
        // identified row's width; target its switch side, not the label.
        func tapSystemSwitch() {
            toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.91, dy: 0.5)).tap()
        }
        let originalValue = toggle.value as? String
        defer {
            settings.activate()
            _ = settings.wait(for: .runningForeground, timeout: 10)
            if (toggle.value as? String) != originalValue { tapSystemSwitch() }
            if let originalValue {
                _ = XCTWaiter.wait(for: [XCTNSPredicateExpectation(
                    predicate: NSPredicate(format: "value == %@", originalValue), object: toggle)], timeout: 5)
            }
        }
        if (toggle.value as? String) == "1" { tapSystemSwitch() }

        let app = XCUIApplication()
        app.launchArguments = ["--tui-skeleton-motion-probe"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Reduce Motion: off"].waitForExistence(timeout: 10))
        let active = try samples(app, prefix: "active")
        XCTAssertGreaterThan((active.max() ?? 0) - (active.min() ?? 0), 3)

        settings.activate()
        XCTAssertTrue(settings.wait(for: .runningForeground, timeout: 10))
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 10))
        if (toggle.value as? String) != "1" { tapSystemSwitch() }
        let isOn = NSPredicate(format: "value == %@", "1")
        XCTAssertTrue(toggle.waitForExistence(timeout: 5))
        let changed = XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: isOn, object: toggle)], timeout: 5) == .completed
        XCTAssertTrue(changed, "The actual system switch must turn on before checking the component")
        let settingsTree = XCTAttachment(string: settings.debugDescription)
        settingsTree.name = "system-reduce-motion-enabled-settings"
        settingsTree.lifetime = .keepAlways
        add(settingsTree)
        guard changed else { return }
        app.activate()
        let enabled = app.staticTexts["Reduce Motion: on"].waitForExistence(timeout: 10)
        let enabledTree = XCTAttachment(string: app.debugDescription)
        enabledTree.name = "system-reduce-motion-enabled-application"
        enabledTree.lifetime = .keepAlways
        add(enabledTree)
        XCTAssertTrue(enabled, "SwiftUI must observe the real system setting after foregrounding")
        guard enabled else { return }
        let reduced = try samples(app, prefix: "system-reduce-motion")
        XCTAssertEqual(Set(reduced).count, 1, "Real system Reduce Motion must freeze the production skeleton")

        settings.activate()
        XCTAssertTrue(settings.wait(for: .runningForeground, timeout: 10))
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 10))
        if (toggle.value as? String) == "1" { tapSystemSwitch() }
        let isOff = NSPredicate(format: "value == %@", "0")
        let disabled = XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: isOff, object: toggle)], timeout: 5) == .completed
        XCTAssertTrue(disabled, "The actual system switch must turn off before checking resumption")
        let disabledSettings = XCTAttachment(string: settings.debugDescription)
        disabledSettings.name = "system-reduce-motion-disabled-settings"
        disabledSettings.lifetime = .keepAlways
        add(disabledSettings)
        guard disabled else { return }
        app.activate()
        let observedOff = app.staticTexts["Reduce Motion: off"].waitForExistence(timeout: 10)
        XCTAssertTrue(observedOff)
        guard observedOff else { return }
        let resumed = try samples(app, prefix: "resumed-after-background")
        XCTAssertGreaterThan((resumed.max() ?? 0) - (resumed.min() ?? 0), 3)
        app.terminate()
        app.launch()
        XCTAssertTrue(app.staticTexts["Reduce Motion: off"].waitForExistence(timeout: 10))
        let relaunched = try samples(app, prefix: "reappearance")
        XCTAssertGreaterThan((relaunched.max() ?? 0) - (relaunched.min() ?? 0), 3)
        let measurements = XCTAttachment(string: "active=\(active)\nreduced=\(reduced)\nresumed=\(resumed)\nreappeared=\(relaunched)")
        measurements.name = "skeleton-real-system-motion-measurements"
        measurements.lifetime = .keepAlways
        add(measurements)
        let tree = XCTAttachment(string: app.debugDescription)
        tree.name = "skeleton-native-accessibility-tree"
        tree.lifetime = .keepAlways
        add(tree)
    }

    @MainActor
    private func samples(_ app: XCUIApplication, prefix: String) throws -> [Int] {
        let label = app.staticTexts["Live"]
        XCTAssertTrue(label.waitForExistence(timeout: 5))
        var values: [Int] = []
        var textValues: [Int] = []
        for index in 0..<8 {
            let screenshot = app.screenshot()
            let image = screenshot.image
            let cg = try XCTUnwrap(image.cgImage)
            let scale = CGFloat(cg.width) / app.frame.width
            // The QA scene places the 40x40 core 16 pt below its Live label.
            let rect = CGRect(x: (label.frame.midX - 20) * scale,
                y: (label.frame.maxY + 16) * scale, width: 40 * scale, height: 40 * scale).integral
            let crop = try XCTUnwrap(cg.cropping(to: rect))
            var pixel = [UInt8](repeating: 0, count: 4)
            let context = try XCTUnwrap(CGContext(data: &pixel, width: 1, height: 1,
                bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
            let center = try XCTUnwrap(crop.cropping(to: CGRect(x: crop.width / 2, y: crop.height / 2, width: 1, height: 1)))
            context.draw(center, in: CGRect(x: 0, y: 0, width: 1, height: 1))
            values.append(Int(pixel[0]))
            let attachment = XCTAttachment(data: try XCTUnwrap(UIImage(cgImage: crop).pngData()), uniformTypeIdentifier: "public.png")
            attachment.name = "skeleton-\(prefix)-\(index)"
            attachment.lifetime = .keepAlways
            add(attachment)

            // Heading Large: after the core (40), gap (16), inset (6),
            // the visible text skeleton bar is 92x24, not its 92x36 layout.
            let textRect = CGRect(x: (label.frame.midX - 46) * scale,
                y: (label.frame.maxY + 16 + 40 + 16 + 6) * scale,
                width: 92 * scale, height: 24 * scale).integral
            let textCrop = try XCTUnwrap(cg.cropping(to: textRect))
            textValues.append(try centreRed(textCrop))
            let textAttachment = XCTAttachment(data: try XCTUnwrap(UIImage(cgImage: textCrop).pngData()), uniformTypeIdentifier: "public.png")
            textAttachment.name = "skeleton-text-\(prefix)-\(index)"
            textAttachment.lifetime = .keepAlways
            add(textAttachment)
        }
        if prefix == "system-reduce-motion" {
            XCTAssertEqual(Set(textValues).count, 1, "The production text skeleton must also freeze")
        } else {
            XCTAssertGreaterThan((textValues.max() ?? 0) - (textValues.min() ?? 0), 3,
                "The production text skeleton must animate in \(prefix)")
        }
        let textMeasurements = XCTAttachment(string: "text=\(textValues)")
        textMeasurements.name = "skeleton-text-\(prefix)-measurements"
        textMeasurements.lifetime = .keepAlways
        add(textMeasurements)
        return values
    }

    private func centreRed(_ crop: CGImage) throws -> Int {
        var pixel = [UInt8](repeating: 0, count: 4)
        let context = try XCTUnwrap(CGContext(data: &pixel, width: 1, height: 1,
            bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        let center = try XCTUnwrap(crop.cropping(to: CGRect(x: crop.width / 2, y: crop.height / 2, width: 1, height: 1)))
        context.draw(center, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        return Int(pixel[0])
    }
}
