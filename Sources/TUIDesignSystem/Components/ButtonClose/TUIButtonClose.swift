import SwiftUI

/// Close action from the eight iOS variants of `tui-button [close]`.
public struct TUIButtonClose: View {
    public enum Size: String, CaseIterable, Sendable {
        case small
        case xSmall = "x-small"
        public var diameter: CGFloat { self == .small ? 30 : 24 }
    }

    public enum Environment: String, CaseIterable, Sendable {
        case onBase = "on-base"
        case onLight = "on-light"
        case onDark = "on-dark"
    }

    @SwiftUI.Environment(\.dynamicTypeSize) private var dynamicTypeSize
    public let size: Size
    public let environment: Environment
    public let theme: TUITheme
    public let accessibilityLabel: String
    private let action: () -> Void

    public init(
        size: Size = .small,
        environment: Environment = .onBase,
        theme: TUITheme = .day,
        accessibilityLabel: String = "Закрыть",
        action: @escaping () -> Void
    ) {
        self.size = size
        self.environment = environment
        self.theme = theme
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var figmaNodeID: String {
        switch (environment, theme, size) {
        case (.onBase, .day, .small): "30258:432918"
        case (.onBase, .night, .small): "38487:470419"
        case (.onBase, .day, .xSmall): "38502:471895"
        case (.onBase, .night, .xSmall): "38502:471897"
        case (.onLight, _, .small): "30258:432950"
        case (.onLight, _, .xSmall): "38502:471901"
        case (.onDark, _, .small): "30263:433024"
        case (.onDark, _, .xSmall): "38502:471899"
        }
    }

    private var colorScheme: ColorScheme {
        switch environment {
        case .onBase: theme == .day ? .light : .dark
        case .onLight: .light
        case .onDark: .dark
        }
    }

    private var fill: Color {
        switch environment {
        case .onBase: TUIColor.named("Background/Neutral 1 Opaque", fallback: 0xF6F7F8)
        case .onLight: TUIColor.named("Background/Overlay Glass On Light", fallback: 0x000000)
        case .onDark: TUIColor.named("Background/Overlay Glass On Dark", fallback: 0xFFFFFF)
        }
    }

    private var pressedFill: Color {
        switch environment {
        case .onBase: TUIColor.named("State/Background/Neutral 1 Pressed")
        case .onLight: TUIColor.named("State/Background/Overlay Glass On Light Pressed")
        case .onDark: TUIColor.named("State/Background/Overlay Glass On Dark Pressed")
        }
    }

    private var foreground: Color {
        if environment != .onBase { return TUIColor.named("Text/Primary On Dark", fallback: 0xFFFFFF) }
        if theme == .night {
            // This legacy Figma layer explicitly uses #F6F7F8.
            return Color(red: 246.0 / 255, green: 247.0 / 255, blue: 248.0 / 255)
        }
        return TUIColor.textSecondary
    }

    public var body: some View {
        let iconSize: CGFloat = TUISpacing.x4 * (dynamicTypeSize.isAccessibilitySize ? 1.25 : 1)
        // The specification retains the 7/4 pt inset around the enlarged AX1 glyph.
        // Consequently the circle grows by 4 pt, and remains capped above AX1.
        let diameter = size.diameter + iconSize - TUISpacing.x4
        Button(action: action) {
            Image("tui-button-close-cross", bundle: .module)
                .renderingMode(.template)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(foreground)
                .frame(width: diameter, height: diameter)
                .contentShape(Circle())
        }
        .buttonStyle(TUIButtonCloseStyle(
            normalFill: fill,
            pressedFill: pressedFill,
            usesMaterial: environment != .onBase
        ))
        .environment(\.colorScheme, colorScheme)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier("tuiButtonClose-\(figmaNodeID)")
    }
}

private struct TUIButtonCloseStyle: ButtonStyle {
    let normalFill: Color
    let pressedFill: Color
    let usesMaterial: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label.background {
            if usesMaterial {
                Circle().fill(.ultraThinMaterial)
                    .overlay { Circle().fill(configuration.isPressed ? pressedFill : normalFill) }
            } else {
                Circle().fill(configuration.isPressed ? pressedFill : normalFill)
            }
        }
    }
}
