import XCTest
import SwiftUI

final class CardMediumMotionUITests: XCTestCase {
    struct Sample: Decodable {
        var time: Double
        var card: [Double]
        var cardLayout: [Double]
        var neighbor: [Double]
    }

    @MainActor
    func testProductionCardPressAndRealSystemReduceMotion() throws {
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
        func setSystemMotion(_ value: String) -> Bool {
            settings.activate()
            XCTAssertTrue(settings.wait(for: .runningForeground, timeout: 10))
            let currentToggle = settings.switches["REDUCE_MOTION"]
            XCTAssertTrue(currentToggle.waitForExistence(timeout: 5))
            // Refresh the native Settings scene after foregrounding. Its row
            // changes when the cross-fade option is inserted; resolve the
            // nested UISwitch if available rather than retaining its old frame.
            let before = XCTAttachment(screenshot: settings.screenshot())
            before.name = "card-motion-settings-before-" + value
            before.lifetime = .keepAlways
            add(before)
            let tree = XCTAttachment(string: currentToggle.debugDescription)
            tree.name = "card-motion-settings-toggle-before-" + value
            tree.lifetime = .keepAlways
            add(tree)
            if currentToggle.value as? String != value {
                let control = currentToggle.switches.firstMatch
                if control.exists && control.isHittable {
                    control.tap()
                } else {
                    currentToggle.coordinate(withNormalizedOffset: CGVector(dx: 0.91, dy: 0.5)).tap()
                }
            }
            let changed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "value == %@", value), object: currentToggle)
            let success = XCTWaiter.wait(for: [changed], timeout: 5) == .completed
            XCTAssertTrue(success, "Actual system setting must change before dependent measurements")
            return success
        }
        defer { if let original { _ = setSystemMotion(original) } }
        guard setSystemMotion("0") else { return }
        let app = launchProbe()
        XCTAssertEqual(app.staticTexts["cardMotionSystemSetting"].label, "Reduce Motion: off")
        let report = try capture(app, name: "active")
        try assertAnimated(report)
        XCTAssertEqual(app.staticTexts["cardMotionTapCount"].label, "Нажатий: 1")
        guard setSystemMotion("1") else { return }
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: 5))
        app.activate()
        let observedOn = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label == %@", "Reduce Motion: on"),
            object: app.staticTexts["cardMotionSystemSetting"])
        XCTAssertEqual(XCTWaiter.wait(for: [observedOn], timeout: 5), .completed)
        let reduced = try capture(app, name: "system-reduce-motion")
        for sample in reduced { XCTAssertEqual(sample.card[2], 140, accuracy: 0.2) }
        try assertLayoutUnchanged(reduced)
        XCTAssertEqual(app.staticTexts["cardMotionTapCount"].label, "Нажатий: 2")
        guard setSystemMotion("0") else { return }
        app.activate()
        let observedOff = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label == %@", "Reduce Motion: off"),
            object: app.staticTexts["cardMotionSystemSetting"])
        XCTAssertEqual(XCTWaiter.wait(for: [observedOff], timeout: 5), .completed)
        let resumed = try capture(app, name: "resumed")
        try assertAnimated(resumed)
        XCTAssertEqual(app.staticTexts["cardMotionTapCount"].label, "Нажатий: 3")
    }

    private func assertAnimated(_ report: [Sample]) throws {
        let baseline = try XCTUnwrap(report.first)
        XCTAssertEqual(baseline.card[2], 140, accuracy: 0.2)
        XCTAssertEqual(report.map { $0.card[2] }.min()!, 133, accuracy: 0.2)
        XCTAssertEqual(report.last!.card[2], 140, accuracy: 0.2)
        try assertLayoutUnchanged(report)
        let pressed = try XCTUnwrap(report.firstIndex { $0.card[2] <= 133.001 })
        try assertSourceTiming(Array(report[..<pressed]), pressing: true)
        try assertSourceTiming(Array(report[pressed...]), pressing: false)
    }

    private func assertSourceTiming(_ samples: [Sample], pressing: Bool) throws {
        // Independent expected curve from the imported Figma Primitive token,
        // not the traditional Material .4/0/.2/1 curve. The measured first
        // changing frame can already be late in the transition, so its time
        // alone is not the animation duration. Invert the curve and regress
        // actual sample time against its phase to recover the full duration.
        let curve = UnitCurve.bezier(startControlPoint: UnitPoint(x: 0.2, y: 0),
                                     endControlPoint: UnitPoint(x: 0.4, y: 0.9))
        var points: [(phase: Double, time: Double)] = []
        var previousWidth = -1.0
        for sample in samples {
            let width = sample.card[2]
            let progress = (pressing ? 140 - width : width - 133) / 7
            guard progress > 0.001 && progress < 0.999 && abs(width - previousWidth) > 0.001 else { continue }
            previousWidth = width
            points.append((curve.inverse.value(at: progress), sample.time))
        }
        XCTAssertGreaterThanOrEqual(points.count, pressing ? 2 : 3, "Enough distinct native frames must be measured")
        guard points.count >= 2 else { return }
        let meanPhase = points.map(\.phase).reduce(0, +) / Double(points.count)
        let meanTime = points.map(\.time).reduce(0, +) / Double(points.count)
        let covariance = points.reduce(0) { $0 + ($1.phase - meanPhase) * ($1.time - meanTime) }
        let variance = points.reduce(0) { $0 + pow($1.phase - meanPhase, 2) }
        XCTAssertGreaterThan(variance, 0)
        let duration = covariance / variance
        let start = meanTime - duration * meanPhase
        let residual = points.map { abs($0.time - start - duration * $0.phase) }.max()!
        XCTAssertEqual(duration, 0.1, accuracy: 0.012, "Full observed transition must match the 100 ms source")
        XCTAssertLessThan(residual, 0.006, "Native frames must follow the source productive-standard curve")
        let result = XCTAttachment(string: "\(pressing ? "press" : "release"): duration=\(duration), maxResidual=\(residual), points=\(points)")
        result.name = "card-medium-source-motion-timing"
        result.lifetime = .keepAlways
        add(result)
    }

    private func assertLayoutUnchanged(_ report: [Sample]) throws {
        let baseline = try XCTUnwrap(report.first)
        for sample in report {
            // SwiftUI reparents presentation layers at transition boundaries;
            // convert(to:) can return coordinates from the outgoing tree for a
            // frame. Layout coordinates and the recorded screen independently
            // check position; presentation width measures the animated scale.
            XCTAssertEqual(sample.cardLayout[0], baseline.cardLayout[0], accuracy: 0.2)
            XCTAssertEqual(sample.cardLayout[1], baseline.cardLayout[1], accuracy: 0.2)
            for index in 0..<4 {
                XCTAssertEqual(sample.neighbor[index], baseline.neighbor[index], accuracy: 0.2)
            }
        }
    }

    @MainActor private func launchProbe() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--tui-card-medium-motion-probe"]
        app.launch()
        let entry = app.staticTexts["tui-card-medium · 21 вариант iOS"]
        XCTAssertTrue(entry.waitForExistence(timeout: 10))
        entry.tap()
        XCTAssertTrue(app.buttons["cardMotionRecord"].waitForExistence(timeout: 5))
        return app
    }

    @MainActor private func capture(_ app: XCUIApplication, name: String) throws -> [Sample] {
        app.buttons["cardMotionRecord"].tap()
        app.buttons["11335:41579"].press(forDuration: 0.7)
        let report = app.staticTexts["cardMotionReport"]
        let ready = XCTNSPredicateExpectation(predicate: NSPredicate(format: "label BEGINSWITH '['"), object: report)
        XCTAssertEqual(XCTWaiter.wait(for: [ready], timeout: 8), .completed)
        let raw = report.label
        let attachment = XCTAttachment(string: raw)
        attachment.name = "card-medium-\(name)-motion-samples"
        attachment.lifetime = .keepAlways
        add(attachment)
        return try JSONDecoder().decode([Sample].self, from: Data(raw.utf8))
    }
}
