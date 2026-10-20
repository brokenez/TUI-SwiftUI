import XCTest

/// Runs the independent app importing only the package product.
final class HeaderConsumerUITests: XCTestCase {
    private let title = "Настройки уведомлений"
    private let subtitle = "Получать новости и важные сообщения сервиса"

    @MainActor
    func testIndependentNativeInlineSymbolUsesWrappedHeading() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=inlineSymbol"]
        app.launch()
        let heading = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Заголовок, который занимает несколько строк")).firstMatch
        XCTAssertTrue(heading.waitForExistence(timeout: 10))
        XCTAssertGreaterThan(heading.frame.height, 36)
        XCTAssertLessThanOrEqual(heading.frame.maxX, app.frame.midX + 375 / 2 - 16 + 1)
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-independent-native-inline-symbol")
        keep(XCTAttachment(string: app.debugDescription), name: "header-independent-native-inline-symbol-ax-tree")
    }

    @MainActor
    func testIndependentHeaderLinksStateAndAX1Reflow() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        var geometry: [String: [String: CGFloat]] = [:]
        for mode in ["standard", "ax1", "ax1Reflow", "ax5Reflow", "descriptionAX1Reflow"] {
            app.launchArguments = ["--header-consumer", "--header-mode=" + mode]
            app.launch()
            let link = app.links[title]
            XCTAssertTrue(link.waitForExistence(timeout: 10))
            let text = app.staticTexts[subtitle]
            let toggle = app.switches["Получать уведомления"]
            XCTAssertTrue(toggle.exists && toggle.isHittable)
            if mode.hasSuffix("Reflow") {
                XCTAssertGreaterThan(toggle.frame.minY, text.frame.maxY)
                XCTAssertEqual(toggle.frame.minY - text.frame.maxY, 8, accuracy: 1)
            } else {
                XCTAssertLessThan(toggle.frame.minY, text.frame.minY)
            }
            geometry[mode] = ["titleHeight": link.frame.height,
                              "subtitleHeight": text.frame.height,
                              "accessoryY": toggle.frame.minY,
                              "gapAfterSubtitle": toggle.frame.minY - text.frame.maxY]
            toggle.tap()
            XCTAssertTrue(app.staticTexts["Выбрано: да"].waitForExistence(timeout: 5))
            toggle.tap()
            XCTAssertTrue(app.staticTexts["Выбрано: нет"].exists)
            link.tap()
            XCTAssertTrue(app.staticTexts["Ссылок: 1"].waitForExistence(timeout: 5))
            try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
            keep(XCTAttachment(screenshot: app.screenshot()), name: "header-independent-" + mode)
            keep(XCTAttachment(string: app.debugDescription), name: "header-independent-" + mode + "-ax-tree")
        }
        XCTAssertEqual(geometry["ax1Reflow"], geometry["ax5Reflow"], "AX5 must retain the specification's AX1 cap")
        let data = try JSONSerialization.data(withJSONObject: geometry, options: [.prettyPrinted, .sortedKeys])
        keep(XCTAttachment(data: data, uniformTypeIdentifier: "public.json"), name: "header-independent-native-geometry")
    }

    @MainActor
    func testBoundedFadeFocusRetainsCompleteLabelAndVisibleSuffix() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=fade"]
        app.launch()
        // The specification combines heading content for VoiceOver; SwiftUI
        // propagates the suffix identifier onto the combined parent as well.
        let suffix = app.staticTexts.matching(identifier: "headerSuffix")
            .matching(NSPredicate(format: "label == %@", "42")).firstMatch
        XCTAssertTrue(suffix.waitForExistence(timeout: 10))
        XCTAssertTrue(suffix.isHittable)
        XCTAssertLessThanOrEqual(suffix.frame.maxX, app.frame.midX + 375 / 2 - 16 + 1)
        XCTAssertGreaterThan(suffix.frame.minX, app.frame.midX + 100)
        let combined = app.staticTexts["Очень длинный заголовок, который не помещается в одну строку, 42"]
        XCTAssertTrue(combined.exists)
        XCTAssertLessThanOrEqual(combined.frame.width, 343 + 1,
                                 "Focus must follow the visible heading bounds while retaining its full label")
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-independent-fade-and-suffix")
        keep(XCTAttachment(string: app.debugDescription), name: "header-independent-fade-ax-tree")
    }

    @MainActor
    func testIndependentMultilineFadeRetainsFullLabelWithinVisibleBounds() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=multilineFade"]
        app.launch()
        let heading = app.staticTexts["Длинный заголовок, очень длинный, на три строки, с иконкой в конце и дополнительным текстом"]
        XCTAssertTrue(heading.waitForExistence(timeout: 10))
        XCTAssertLessThanOrEqual(heading.frame.width, 344)
        XCTAssertLessThanOrEqual(heading.frame.height, 109)
        XCTAssertGreaterThan(heading.frame.height, 72)
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-independent-multiline-fade")
        keep(XCTAttachment(string: app.debugDescription), name: "header-independent-multiline-fade-ax-tree")
    }

    @MainActor
    func testNativeLinksInTitleSubheaderAndDescriptionExecuteDistinctTargets() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=linkedBlocks", "--header-ax-probe"]
        app.launch()
        let snapshot = app.buttons["headerAXSnapshot"]
        XCTAssertTrue(snapshot.waitForExistence(timeout: 10))
        snapshot.tap()
        let data = try XCTUnwrap(app.staticTexts["headerAXSnapshotPayload"].label.data(using: .utf8))
        keep(XCTAttachment(data: data, uniformTypeIdentifier: "public.json"), name: "header-native-all-text-links-snapshot")
        let rows = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [[String: Any]])
        let heading = try XCTUnwrap(rows.first {
            ($0["isHeader"] as? Bool) == true && ($0["isElement"] as? Bool) == true &&
            ($0["label"] as? String)?.contains(title) == true &&
            ($0["label"] as? String)?.contains(subtitle) == true
        })
        let actions = try XCTUnwrap(heading["actions"] as? [String])
        XCTAssertEqual(actions, ["Открыть ссылку: уведомлений", "Открыть ссылку: новости"])
        let description = try XCTUnwrap(rows.first {
            ($0["label"] as? String) == "Подробнее об условиях сервиса" && ($0["isElement"] as? Bool) == true
        })
        XCTAssertEqual(description["actions"] as? [String], ["Открыть ссылку: Подробнее"])
        XCTAssertEqual(description["isHeader"] as? Bool, false)
        XCTAssertFalse(rows.contains {
            ["уведомлений", "новости", "Подробнее"].contains($0["label"] as? String ?? "") &&
            ($0["isButton"] as? Bool) != true &&
            ($0["isElement"] as? Bool) == true && ($0["actions"] as? [String])?.isEmpty == true
        }, "Embedded links must be actions of their complete text element")
        for (index, item) in [("уведомлений", "title"), ("новости", "subheader"), ("Подробнее", "description")].enumerated() {
            app.buttons["headerAXAction-" + item.0].tap()
            XCTAssertTrue(app.staticTexts["AX action: success"].waitForExistence(timeout: 5))
            XCTAssertTrue(app.staticTexts["Ссылок: \(index + 1)"].exists)
            XCTAssertTrue(app.staticTexts["headerLinkTargets"].label.contains("?block=" + item.1))
        }
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-native-all-text-links-after-actions")
        keep(XCTAttachment(string: app.debugDescription), name: "header-native-all-text-links-after-actions-tree")
    }

    @MainActor
    func testNativeStandardHeadingUsesAdditionalLinkAction() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=standard", "--header-ax-probe"]
        app.launch()
        let snapshot = app.buttons["headerAXSnapshot"]
        XCTAssertTrue(snapshot.waitForExistence(timeout: 10))
        snapshot.tap()
        let payload = app.staticTexts["headerAXSnapshotPayload"]
        let data = try XCTUnwrap(payload.label.data(using: .utf8))
        keep(XCTAttachment(data: data, uniformTypeIdentifier: "public.json"), name: "header-native-standard-links-snapshot")
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-native-standard-links")
        let rows = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [[String: Any]])
        let heading = try XCTUnwrap(rows.first {
            ($0["isHeader"] as? Bool) == true && ($0["isElement"] as? Bool) == true &&
            ($0["label"] as? String)?.contains(title) == true &&
            ($0["label"] as? String)?.contains(subtitle) == true
        }, "Title and subheader must form one accessible heading")
        let actions = try XCTUnwrap(heading["actions"] as? [String])
        XCTAssertTrue(actions.contains { $0.contains(title) }, "Embedded URL must be available as an additional heading action")
        app.buttons["headerAXPerformLink"].tap()
        XCTAssertTrue(app.staticTexts["AX action: success"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ссылок: 1"].exists)
    }

    @MainActor
    func testNativeAdditionalLinkActionRetainsFullHeadingAndExecutes() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=multilineLinkedFade", "--header-ax-probe"]
        app.launch()
        let snapshot = app.buttons["headerAXSnapshot"]
        XCTAssertTrue(snapshot.waitForExistence(timeout: 10))
        snapshot.tap()
        let payload = app.staticTexts["headerAXSnapshotPayload"]
        XCTAssertTrue(payload.waitForExistence(timeout: 5))
        let data = try XCTUnwrap(payload.label.data(using: .utf8))
        keep(XCTAttachment(data: data, uniformTypeIdentifier: "public.json"), name: "header-native-custom-action-snapshot")
        let rows = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [[String: Any]])
        XCTAssertFalse(rows.contains {
            ($0["label"] as? String) == "конце" && ($0["isElement"] as? Bool) == true
        }, "The UIKit accessibility tree must expose the embedded link as an action, not an invisible separate focus element")
        let heading = try XCTUnwrap(rows.first {
            ($0["isHeader"] as? Bool) == true &&
            ($0["actions"] as? [String])?.contains("Открыть ссылку: конце") == true
        })
        XCTAssertEqual(heading["label"] as? String, "Длинный заголовок, очень длинный, на три строки, с иконкой в конце и дополнительным текстом")
        let frame = try XCTUnwrap(heading["frame"] as? [String: Double])
        XCTAssertLessThanOrEqual(try XCTUnwrap(frame["width"]), 344)
        XCTAssertLessThanOrEqual(try XCTUnwrap(frame["height"]), 109)
        app.buttons["headerAXPerformLink"].tap()
        XCTAssertTrue(app.staticTexts["AX action: success"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ссылок: 1"].exists)
        keep(XCTAttachment(string: app.debugDescription), name: "header-native-custom-action-after-execution-ax-tree")
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-native-custom-action-after-execution")
    }

    @MainActor
    func testPartialLinkInContinuedFadeRespondsAtVisibleGlyphs() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=multilineLinkedFade"]
        app.launch()
        let anchor = app.staticTexts["headerLiveAnchor"]
        XCTAssertTrue(anchor.waitForExistence(timeout: 10))
        let heading = app.staticTexts.matching(NSPredicate(format: "label == %@", "Длинный заголовок, очень длинный, на три строки, с иконкой в конце и дополнительным текстом")).firstMatch
        XCTAssertTrue(heading.waitForExistence(timeout: 5))
        // XCTest uses UIKit's separate automation tree, which may retain native
        // Text's raw link metadata. VoiceOver focus is checked through public
        // UIKit accessibility elements in the additional-action test above.
        keep(XCTAttachment(string: app.debugDescription), name: "header-partial-fade-link-before-tap-ax-tree")
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-partial-fade-link-before-tap")
        let x = app.frame.midX - 375 / 2 + 16 + 300
        let y = anchor.frame.maxY + 16 + 8 + 72 + 18
        app.coordinate(withNormalizedOffset: .zero).withOffset(CGVector(dx: x, dy: y)).tap()
        XCTAssertTrue(app.staticTexts["Ссылок: 1"].waitForExistence(timeout: 5),
                      "The visible continued word must keep its native link hit region")
        heading.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.2)).tap()
        XCTAssertTrue(app.staticTexts["Ссылок: 1"].exists,
                      "Ordinary heading glyphs must not become a link")
        keep(XCTAttachment(string: app.debugDescription), name: "header-partial-fade-link-after-tap-ax-tree")
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-partial-fade-link-after-tap")
    }

    @MainActor
    func testIndependentBaselineLinkAccessoryExecutesConsumerAction() throws {
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=baselineLink"]
        app.launch()
        let link = app.buttons["Все"]
        XCTAssertTrue(link.waitForExistence(timeout: 10))
        XCTAssertTrue(link.isHittable)
        link.tap()
        XCTAssertTrue(app.staticTexts["Ссылок: 1"].waitForExistence(timeout: 5))
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        keep(XCTAttachment(screenshot: app.screenshot()), name: "header-independent-baseline-link")
        keep(XCTAttachment(string: app.debugDescription), name: "header-independent-baseline-link-ax-tree")
    }

    @MainActor
    func testIndependentHeaderSkeletonUsesRealSystemMotionSetting() throws {
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
        let original = toggle.value as? String
        func setMotion(_ value: String) {
            XCTAssertTrue(settings.wait(for: .runningForeground, timeout: 10))
            if toggle.value as? String != value {
                toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.91, dy: 0.5)).tap()
            }
            let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "value == %@", value), object: toggle)
            XCTAssertEqual(XCTWaiter.wait(for: [expectation], timeout: 5), .completed)
        }
        defer {
            settings.activate()
            if let original { setMotion(original) }
        }
        setMotion("0")
        let app = XCUIApplication(bundleIdentifier: "local.TUIConsumer")
        app.launchArguments = ["--header-consumer", "--header-mode=skeleton"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Reduce Motion: off"].waitForExistence(timeout: 10))
        try motionSamples(app, phase: "active", mustAnimate: true)
        settings.activate()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 10))
        setMotion("1")
        app.activate()
        XCTAssertTrue(app.staticTexts["Reduce Motion: on"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["System Reduce Motion: on"].exists)
        try motionSamples(app, phase: "reduced", mustAnimate: false)
        try app.performAccessibilityAudit(for: [.elementDetection, .sufficientElementDescription, .trait])
        XCTAssertFalse(app.links[title].exists)
        XCTAssertFalse(app.staticTexts["Header"].exists)
        keep(XCTAttachment(string: app.debugDescription), name: "header-independent-skeleton-ax-tree")
        settings.activate()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 10))
        setMotion("0")
        app.activate()
        XCTAssertTrue(app.staticTexts["Reduce Motion: off"].waitForExistence(timeout: 10))
        try motionSamples(app, phase: "resumed", mustAnimate: true)
        app.terminate()
        app.launch()
        XCTAssertTrue(app.staticTexts["Reduce Motion: off"].waitForExistence(timeout: 10))
        try motionSamples(app, phase: "reappeared", mustAnimate: true)
    }

    @MainActor
    private func motionSamples(_ app: XCUIApplication, phase: String, mustAnimate: Bool) throws {
        let anchor = app.staticTexts["headerLiveAnchor"]
        XCTAssertTrue(anchor.waitForExistence(timeout: 10))
        var samples: [[Int]] = [[], []]
        for index in 0..<8 {
            let cg = try XCTUnwrap(app.screenshot().image.cgImage)
            let scale = CGFloat(cg.width) / app.frame.width
            let x = app.frame.midX - 375 / 2 + 16
            let top = anchor.frame.maxY + 16 + 8
            let rects = [CGRect(x: x, y: top + 6, width: 130, height: 24),
                         CGRect(x: x, y: top + 36 + 16 + 3, width: 130, height: 12)]
            for (part, rect) in rects.enumerated() {
                let scaled = CGRect(x: rect.minX * scale, y: rect.minY * scale,
                                    width: rect.width * scale, height: rect.height * scale).integral
                let crop = try XCTUnwrap(cg.cropping(to: scaled))
                samples[part].append(try centerRed(crop))
                let data = try XCTUnwrap(UIImage(cgImage: crop).pngData())
                keep(XCTAttachment(data: data, uniformTypeIdentifier: "public.png"),
                     name: "header-motion-\(phase)-\(part)-\(index)")
            }
        }
        for values in samples {
            if mustAnimate { XCTAssertGreaterThan((values.max() ?? 0) - (values.min() ?? 0), 3) }
            else { XCTAssertEqual(Set(values).count, 1) }
        }
        keep(XCTAttachment(string: "title=\(samples[0])\nsubheader=\(samples[1])"), name: "header-motion-" + phase + "-values")
    }

    private func centerRed(_ crop: CGImage) throws -> Int {
        var pixel = [UInt8](repeating: 0, count: 4)
        let context = try XCTUnwrap(CGContext(data: &pixel, width: 1, height: 1,
            bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
        let center = try XCTUnwrap(crop.cropping(to: CGRect(x: crop.width / 2, y: crop.height / 2, width: 1, height: 1)))
        context.draw(center, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        return Int(pixel[0])
    }

    private func keep(_ attachment: XCTAttachment, name: String) {
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
