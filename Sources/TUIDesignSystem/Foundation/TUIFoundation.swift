import SwiftUI
import UIKit

public enum TUIPlatform: String, CaseIterable, Sendable {
    case iOS = "iOS"
    case android = "Android"
    case desktop = "Desktop"
}

public enum TUITheme: String, CaseIterable, Sendable {
    case day = "Day"
    case night = "Night"
}

public enum TUIControlState: String, CaseIterable, Sendable {
    case normal = "Normal"
    case pressed = "Pressed"
    case loading = "Loading"
    case disabled = "Disabled"
    case focus = "Focus (Desktop)"
}

public enum TUIColor {
    public static let backgroundPrimary = dynamicToken("Background/Base", fallbackLight: 0xFFFFFF, fallbackDark: 0x000000)
    public static let backgroundSecondary = dynamicToken("Background/Elevation 1", fallbackLight: 0xF5F5F6, fallbackDark: 0x1C1C1E)
    public static let backgroundNeutral = dynamicToken("Background/Neutral 1", fallbackLight: 0xF1F1F1, fallbackDark: 0x2C2C2E)
    public static let textPrimary = dynamicToken("Text/Primary", fallbackLight: 0x1B1F3B, fallbackDark: 0xFFFFFF)
    public static let textSecondary = dynamicToken("Text/Secondary", fallbackLight: 0x6D6D72, fallbackDark: 0xA1A1A6)
    public static let action = dynamicToken("Text/Action", fallbackLight: 0x126DF7, fallbackDark: 0x4DA3FF)
    public static let accent = dynamicToken("Background/Accent 1", fallbackLight: 0xFFDD2D, fallbackDark: 0xFFDD2D)
    public static let negative = dynamicToken("Text/Negative", fallbackLight: 0xE31C1C, fallbackDark: 0xFF6B6B)
    public static let positive = dynamicToken("Text/Positive", fallbackLight: 0x12B886, fallbackDark: 0x41D6A3)
    public static let separator = Color(uiColor: .separator)

    public static func named(_ name: String, fallback: UInt = 0x808080) -> Color {
        dynamicToken(name, fallbackLight: fallback, fallbackDark: fallback)
    }

    private static func dynamicToken(_ name: String, fallbackLight: UInt, fallbackDark: UInt) -> Color {
        Color(uiColor: UIColor { traits in
            let mode = traits.userInterfaceStyle == .dark ? TUITheme.night.rawValue : TUITheme.day.rawValue
            if let value = TUITokenCatalog.shared.value(named: name, collection: "Theme", mode: mode),
               let color = UIColor.tuiColor(from: value) {
                return color
            }
            return UIColor.tuiHex(traits.userInterfaceStyle == .dark ? fallbackDark : fallbackLight)
        })
    }
}

public enum TUISpacing {
    public static let x0: CGFloat = 0
    public static let x1: CGFloat = 4
    public static let x2: CGFloat = 8
    public static let x3: CGFloat = 12
    public static let x4: CGFloat = 16
    public static let x5: CGFloat = 20
    public static let x6: CGFloat = 24
    public static let x8: CGFloat = 32
    public static let x10: CGFloat = 40
    public static let x12: CGFloat = 48
    public static let x16: CGFloat = 64
}

public enum TUIRadius {
    public static let xSmall: CGFloat = 4
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let xLarge: CGFloat = 24
    public static let round: CGFloat = 1_000
}

public enum TUIControlSize {
    public static let small: CGFloat = 32
    public static let medium: CGFloat = 44
    public static let large: CGFloat = 56
}

private extension UIColor {
    static func tuiColor(from value: Any) -> UIColor? {
        guard
            let rgba = value as? [String: Any],
            let red = (rgba["r"] as? NSNumber)?.doubleValue,
            let green = (rgba["g"] as? NSNumber)?.doubleValue,
            let blue = (rgba["b"] as? NSNumber)?.doubleValue
        else { return nil }
        let alpha = (rgba["a"] as? NSNumber)?.doubleValue ?? 1
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func tuiHex(_ value: UInt) -> UIColor {
        UIColor(
            red: CGFloat((value >> 16) & 0xFF) / 255,
            green: CGFloat((value >> 8) & 0xFF) / 255,
            blue: CGFloat(value & 0xFF) / 255,
            alpha: 1
        )
    }
}
