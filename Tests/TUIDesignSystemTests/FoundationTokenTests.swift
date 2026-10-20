import Foundation
import SwiftUI
import UIKit
import XCTest
@testable import TUIDesignSystem

/// Checks the bundled Figma snapshot and its runtime consumers. These checks
/// do not establish freshness of the snapshot or visual font acceptance.
final class FoundationTokenTests: XCTestCase {
    func testEveryImportedModeResolvesToItsDeclaredTypeWithoutAliasLeakage() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "figma-foundations", withExtension: "json"))
        let root = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any])
        let collections = try XCTUnwrap(root["collections"] as? [[String: Any]])
        let catalog = TUITokenCatalog.shared
        var checked = 0
        var variableIDs: Set<String> = []
        for collection in collections {
            let name = try XCTUnwrap(collection["name"] as? String)
            let modes = try XCTUnwrap(collection["modes"] as? [[String: Any]])
            let variables = try XCTUnwrap(collection["variables"] as? [[String: Any]])
            XCTAssertEqual(catalog.variableNames(in: name).count, variables.count)
            for variable in variables {
                let id = try XCTUnwrap(variable["id"] as? String)
                XCTAssertTrue(variableIDs.insert(id).inserted, "Duplicate variable: \(id)")
                let token = try XCTUnwrap(variable["name"] as? String)
                let type = try XCTUnwrap(variable["resolvedType"] as? String)
                for mode in modes {
                    let modeName = try XCTUnwrap(mode["name"] as? String)
                    let value = try XCTUnwrap(catalog.value(named: token, collection: name, mode: modeName),
                                             "Unresolved \(name)/\(token) in \(modeName)")
                    let message = "\(name)/\(token) in \(modeName)"
                    switch type {
                    case "COLOR":
                        let rgba = try XCTUnwrap(value as? [String: Any], message)
                        for channel in ["r", "g", "b", "a"] {
                            let number = try XCTUnwrap(rgba[channel] as? NSNumber, message)
                            XCTAssertTrue((0...1).contains(number.doubleValue), message)
                        }
                    case "FLOAT", "TIMING":
                        XCTAssertTrue(try XCTUnwrap(value as? NSNumber, message).doubleValue.isFinite, message)
                    case "STRING":
                        XCTAssertNotNil(value as? String, message)
                    case "EASING":
                        let easing = try XCTUnwrap(value as? [String: Any], message)
                        XCTAssertEqual(easing["type"] as? String, "CUSTOM_CUBIC_BEZIER", message)
                        let points = try XCTUnwrap(easing["easingFunctionCubicBezier"] as? [String: Any], message)
                        for coordinate in ["x1", "y1", "x2", "y2"] {
                            XCTAssertTrue(try XCTUnwrap(points[coordinate] as? NSNumber, message).doubleValue.isFinite, message)
                        }
                    default: XCTFail("Unhandled Figma type \(type): \(message)")
                    }
                    checked += 1
                }
            }
        }
        XCTAssertEqual(variableIDs.count, 957)
        XCTAssertEqual(checked, 1_957)
    }

    func testPublicTypographyMetricsHaveSourceValuesForEveryField() throws {
        let catalog = TUITokenCatalog.shared
        for role in TUITypographyRole.allCases {
            let prefix = role.rawValue + "/"
            let metrics = role.metrics
            XCTAssertEqual(metrics.family, try XCTUnwrap(catalog.value(
                named: prefix + "Font Family", collection: "Platform", mode: "iOS") as? String))
            for (field, actual) in [("Font Size", metrics.size), ("Font Weight", metrics.weight),
                                    ("Line Height", metrics.lineHeight)] {
                let expected = try XCTUnwrap(catalog.number(named: prefix + field, collection: "Platform", mode: "iOS"))
                XCTAssertEqual(Double(actual), expected, accuracy: 0.00001, role.rawValue + "/" + field)
            }
            let tracking = try XCTUnwrap(
                catalog.number(named: prefix + "Letter Spacing*", collection: "Platform", mode: "iOS")
                    ?? catalog.number(named: prefix + "Letter Spacing", collection: "Platform", mode: "iOS"))
            XCTAssertEqual(Double(metrics.letterSpacing), tracking, accuracy: 0.00001, role.rawValue)
        }
        // Independent source values catch wrong mode selection and hidden fallbacks.
        XCTAssertEqual(TUITypographyRole.bodyLarge.metrics.size, 17)
        XCTAssertEqual(TUITypographyRole.bodyLarge.metrics.lineHeight, 24)
        XCTAssertEqual(TUITypographyRole.bodyLarge.metrics.letterSpacing, -0.43, accuracy: 0.00001)
        XCTAssertEqual(TUITypographyRole.bodyMediumBold.metrics.weight, 600)
    }

    @MainActor func testNativeColorsPreserveDayNightAliasesAndTransparency() throws {
        let samples: [(Color, UIUserInterfaceStyle, [CGFloat])] = [
            (TUIColor.textPrimary, .light, [0.2, 0.2, 0.2, 1]),
            (TUIColor.textPrimary, .dark, [246 / 255, 247 / 255, 248 / 255, 1]),
            (TUIColor.backgroundPrimary, .light, [1, 1, 1, 1]),
            (TUIColor.backgroundPrimary, .dark, [0, 0, 0, 1]),
            (TUIColor.backgroundNeutral, .light, [0, 16 / 255, 36 / 255, 0.03]),
            (TUIColor.backgroundNeutral, .dark, [1, 1, 1, 0.1])
        ]
        for (source, style, expected) in samples {
            let color = UIColor(source).resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            XCTAssertTrue(color.getRed(&r, green: &g, blue: &b, alpha: &a))
            for (actual, channel) in zip([r, g, b, a], expected) {
                XCTAssertEqual(actual, channel, accuracy: 0.00001)
            }
        }
    }

    func testMotionDurationsAndNativeCurvesPreserveImportedTiming() throws {
        for (duration, expected) in [(TUIMotionDuration.fastest, 0.075), (.fast, 0.15),
                                     (.moderate, 0.3), (.slow, 0.5), (.slowest, 0.7)] {
            XCTAssertEqual(duration.seconds, expected, accuracy: 0.00001)
        }
        // Independent source values from the current Animation guide,
        // Foundations 18708:974 (retrieved 2026-10-08).
        let curves: [(TUIMotionCurve, [Double])] = [
            (.productiveEntrance, [0, 0, 0.4, 0.9]),
            (.productiveExit, [0.2, 0, 1, 1]),
            (.productiveStandard, [0.2, 0, 0.4, 0.9]),
            (.expressiveEntrance, [0.35, 1.3, 0.25, 1]),
            (.expressiveExit, [0.4, 0, 1, 1]),
            (.expressiveStandard, [0.4, 0.1, 0.2, 1])
        ]
        for (curve, expected) in curves {
            let value = try XCTUnwrap(TUITokenCatalog.shared.value(
                named: "Animation/Curve/" + curve.rawValue, collection: "Primitive") as? [String: Any])
            let points = try XCTUnwrap(value["easingFunctionCubicBezier"] as? [String: NSNumber])
            let x1 = try XCTUnwrap(points["x1"]).doubleValue
            let y1 = try XCTUnwrap(points["y1"]).doubleValue
            let x2 = try XCTUnwrap(points["x2"]).doubleValue
            let y2 = try XCTUnwrap(points["y2"]).doubleValue
            for (actual, coordinate) in zip([x1, y1, x2, y2], expected) {
                XCTAssertEqual(actual, coordinate, accuracy: 0.00001, curve.rawValue)
            }
            // Sample the cubic parametrically, independently of UnitCurve's inversion.
            for step in 1..<20 {
                let t = Double(step) / 20, u = 1 - t
                let x = 3 * u * u * t * x1 + 3 * u * t * t * x2 + t * t * t
                let y = 3 * u * u * t * y1 + 3 * u * t * t * y2 + t * t * t
                XCTAssertEqual(curve.unitCurve.value(at: x), y, accuracy: 0.002, curve.rawValue)
            }
        }
    }

    @MainActor func testAllDocumentedIOSShadowsResolveDayAndDisappearAtNight() {
        // Figma Desktop definitions, Foundations 2872:5946; alpha values
        // retain the imported floating values rather than rounded hex bytes.
        let rows: [(Color, CGFloat, CGFloat, CGFloat)] = [
            (TUIShadow.smallColor, TUIShadow.smallBlur(theme: .day), TUIShadow.smallYOffset(theme: .day), 0.10),
            (TUIShadow.mediumColor, TUIShadow.mediumBlur(theme: .day), TUIShadow.mediumYOffset(theme: .day), 0.12),
            (TUIShadow.popupColor, TUIShadow.popupBlur(theme: .day), TUIShadow.popupYOffset(theme: .day), 0.14)
        ]
        for (row, expected) in zip(rows, [(CGFloat(20), CGFloat(5)), (34, 6), (40, 10)]) {
            XCTAssertEqual(row.1, expected.0)
            XCTAssertEqual(row.2, expected.1)
            let day = UIColor(row.0).resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            let night = UIColor(row.0).resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
            XCTAssertEqual(day.cgColor.alpha, row.3, accuracy: 0.00001)
            XCTAssertEqual(night.cgColor.alpha, 0, accuracy: 0.00001)
        }
        XCTAssertEqual(TUIShadow.smallBlur(theme: .night), 0)
        XCTAssertEqual(TUIShadow.smallYOffset(theme: .night), 0)
        XCTAssertEqual(TUIShadow.mediumBlur(theme: .night), 0)
        XCTAssertEqual(TUIShadow.mediumYOffset(theme: .night), 0)
        XCTAssertEqual(TUIShadow.popupBlur(theme: .night), 0)
        XCTAssertEqual(TUIShadow.popupYOffset(theme: .night), 0)
    }
}
