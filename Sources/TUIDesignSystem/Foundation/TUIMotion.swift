import SwiftUI

public enum TUIMotionDuration: String, Sendable {
    case fastest, fast, moderate, slow, slowest

    public var seconds: Double {
        TUITokenCatalog.shared.number(
            named: "Animation/Duration/\(rawValue)",
            collection: "Primitive"
        ) ?? 0
    }
}

public enum TUIMotionCurve: String, Sendable {
    case productiveEntrance = "productive-entrance"
    case productiveExit = "productive-exit"
    case productiveStandard = "productive-standard"
    case expressiveEntrance = "expressive-entrance"
    case expressiveExit = "expressive-exit"
    case expressiveStandard = "expressive-standard"

    var unitCurve: UnitCurve {
        guard
            let value = TUITokenCatalog.shared.value(
                named: "Animation/Curve/\(rawValue)", collection: "Primitive"
            ) as? [String: Any],
            let points = value["easingFunctionCubicBezier"] as? [String: Any],
            let x1 = (points["x1"] as? NSNumber)?.doubleValue,
            let y1 = (points["y1"] as? NSNumber)?.doubleValue,
            let x2 = (points["x2"] as? NSNumber)?.doubleValue,
            let y2 = (points["y2"] as? NSNumber)?.doubleValue
        else { return .linear }
        return .bezier(startControlPoint: UnitPoint(x: x1, y: y1),
                       endControlPoint: UnitPoint(x: x2, y: y2))
    }

    public func animation(duration: TUIMotionDuration) -> Animation {
        guard
            let value = TUITokenCatalog.shared.value(
                named: "Animation/Curve/\(rawValue)",
                collection: "Primitive"
            ) as? [String: Any],
            let points = value["easingFunctionCubicBezier"] as? [String: Any],
            let x1 = (points["x1"] as? NSNumber)?.doubleValue,
            let y1 = (points["y1"] as? NSNumber)?.doubleValue,
            let x2 = (points["x2"] as? NSNumber)?.doubleValue,
            let y2 = (points["y2"] as? NSNumber)?.doubleValue
        else { return .linear(duration: duration.seconds) }
        return .timingCurve(x1, y1, x2, y2, duration: duration.seconds)
    }
}
