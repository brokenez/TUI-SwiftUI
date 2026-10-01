import SwiftUI

public enum TUIButtonAppearance: String, CaseIterable, Sendable {
    case primary
    case accent
    case primaryDestructive = "primary-destructive"
    case primaryGrayscale = "primary-grayscale"
    case secondary
    case secondaryDestructive = "secondary-destructive"
    case secondaryGrayscale = "secondary-grayscale"
    case flat
    case flatDestructive = "flat-destructive"
    case flatGrayscale = "flat-grayscale"
    case glass
    case floating
}

public enum TUIButtonSize: String, CaseIterable, Sendable {
    case large
    case medium
    case small
}

public enum TUIButtonState: String, CaseIterable, Sendable {
    case normal
    case pressed
    case loading
    case disabled
}

/// A TUI button whose visual states are backed by the iOS variants in Figma.
public struct TUIButton: View {
    static var importedVariantCount: Int { TUIButtonStyleCatalog.shared.count }

    public let title: String
    public let appearance: TUIButtonAppearance
    public let size: TUIButtonSize
    public let state: TUIButtonState
    public let skeleton: Bool
    public let showsIcon: Bool
    public let showsLabel: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        appearance: TUIButtonAppearance = .primary,
        size: TUIButtonSize = .large,
        state: TUIButtonState = .normal,
        skeleton: Bool = false,
        showsIcon: Bool = false,
        showsLabel: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.appearance = appearance
        self.size = size
        self.state = state
        self.skeleton = skeleton
        self.showsIcon = showsIcon
        self.showsLabel = showsLabel
        self.action = action
    }

    public var body: some View {
        Button(title, action: action)
            .buttonStyle(
                TUIButtonFigmaStyle(
                    appearance: appearance,
                    size: size,
                    state: state,
                    skeleton: skeleton,
                    showsIcon: showsIcon,
                    showsLabel: showsLabel
                )
            )
            .disabled(state == .disabled || state == .loading || skeleton)
    }
}

private struct TUIButtonFigmaStyle: ButtonStyle {
    let appearance: TUIButtonAppearance
    let size: TUIButtonSize
    let state: TUIButtonState
    let skeleton: Bool
    let showsIcon: Bool
    let showsLabel: Bool

    func makeBody(configuration: Configuration) -> some View {
        let displayedState: TUIButtonState = state == .normal && configuration.isPressed && !skeleton
            ? .pressed
            : state
        let style = TUIButtonStyleCatalog.shared.style(
            appearance: appearance,
            size: size,
            state: displayedState,
            skeleton: skeleton
        )
        let normalStyle = TUIButtonStyleCatalog.shared.style(
            appearance: appearance,
            size: size,
            state: .normal,
            skeleton: false
        )
        let textPaint = style?.text?.fill ?? normalStyle?.text?.fill
        let textColor = textPaint?.swiftUIColor ?? Color.primary
        let background = style?.fill?.swiftUIColor ?? .clear
        let radius = style?.radius ?? size.radius
        let dropShadow = style?.effects?.first(where: { $0.type == "DROP_SHADOW" })

        HStack(spacing: 0) {
            if displayedState == .loading {
                TUIButtonLoadingGlyph(color: normalStyle?.text?.fill?.swiftUIColor ?? .primary)
                    .frame(width: size.loadingSize, height: size.loadingSize)
            } else {
                if showsIcon {
                    Image(size == .small ? "tui-button-star-small" : "tui-button-star", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(textColor)
                        .frame(width: size.iconSize, height: size.iconSize)
                        .accessibilityHidden(true)
                }
                if showsLabel {
                    configuration.label
                        .font(.system(size: style?.text?.fontSize ?? size.fontSize, weight: size == .small ? .semibold : .regular))
                        .tracking(style?.text?.tracking ?? size.tracking)
                        .foregroundStyle(textColor)
                        .padding(.horizontal, size.labelHorizontalPadding)
                        .padding(.vertical, size.labelVerticalPadding)
                        .opacity(skeleton ? 0 : 1)
                }
            }
        }
        .opacity(skeleton ? 0 : 1)
        .frame(maxWidth: size == .small ? nil : .infinity)
        .frame(height: style?.height ?? size.height)
        .background {
            if appearance == .glass {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.ultraThinMaterial)
            }
            RoundedRectangle(cornerRadius: radius)
                .fill(background)
        }
        .clipShape(RoundedRectangle(cornerRadius: radius))
        .shadow(
            color: dropShadow?.color?.swiftUIColor ?? .clear,
            radius: dropShadow?.radius ?? 0,
            x: dropShadow?.offset?.x ?? 0,
            y: dropShadow?.offset?.y ?? 0
        )
        .overlay {
            if skeleton {
                RoundedRectangle(cornerRadius: 12)
                    .fill(TUIColor.named("Service/Skeleton", fallback: 0xF7F7F7))
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: radius))
    }
}

private struct TUIButtonLoadingGlyph: View {
    let color: Color
    @State private var rotating = false

    var body: some View {
        Image("tui-button-loader", bundle: .module)
            .renderingMode(.template)
            .resizable()
            .foregroundStyle(color)
            .rotationEffect(.degrees(rotating ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotating)
            .onAppear { rotating = true }
            .accessibilityLabel("Загрузка")
    }
}

private extension TUIButtonSize {
    var height: CGFloat {
        switch self {
        case .large: 56
        case .medium: 44
        case .small: 30
        }
    }

    var radius: CGFloat {
        switch self {
        case .large: 16
        case .medium: 12
        case .small: 100
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .large: 17
        case .medium: 15
        case .small: 13
        }
    }

    var tracking: CGFloat {
        switch self {
        case .large: -0.41
        case .medium: -0.24
        case .small: -0.08
        }
    }

    var iconSize: CGFloat { self == .small ? 16 : 24 }
    var loadingSize: CGFloat { self == .small ? 16 : 24 }
    var labelHorizontalPadding: CGFloat { self == .small ? 4 : 8 }

    var labelVerticalPadding: CGFloat {
        switch self {
        case .large: 2
        case .medium: 3
        case .small: 4
        }
    }
}

private struct TUIButtonStylePayload: Decodable {
    let styles: [TUIButtonStyleReference]
}

private struct TUIButtonStyleReference: Decodable {
    let id: String
    let properties: [String: String]
    let height: CGFloat
    let radius: CGFloat
    let fill: TUIButtonPaint?
    let text: TUIButtonText?
    let effects: [TUIButtonEffect]?
}

private struct TUIButtonText: Decodable {
    let fontSize: CGFloat
    let tracking: CGFloat
    let fill: TUIButtonPaint?
}

private struct TUIButtonPaint: Decodable {
    let opacity: Double?
    let color: TUIButtonRGBA?

    var swiftUIColor: Color {
        color?.swiftUIColor.opacity(opacity ?? 1) ?? .clear
    }
}

private struct TUIButtonRGBA: Decodable {
    let r: Double
    let g: Double
    let b: Double
    let a: Double?

    var swiftUIColor: Color {
        Color(.sRGB, red: r, green: g, blue: b, opacity: a ?? 1)
    }
}

private struct TUIButtonEffect: Decodable {
    let type: String
    let offset: TUIButtonOffset?
    let radius: CGFloat?
    let color: TUIButtonRGBA?
}

private struct TUIButtonOffset: Decodable {
    let x: CGFloat
    let y: CGFloat
}

private final class TUIButtonStyleCatalog: @unchecked Sendable {
    static let shared = TUIButtonStyleCatalog()
    private let styles: [String: TUIButtonStyleReference]

    var count: Int { styles.count }

    private init() {
        let url = Bundle.module.url(forResource: "figma-button-styles", withExtension: "json", subdirectory: "Metadata")
            ?? Bundle.module.url(forResource: "figma-button-styles", withExtension: "json")
        let payload = url.flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? JSONDecoder().decode(TUIButtonStylePayload.self, from: $0) }
        let entries = payload?.styles ?? []
        styles = Dictionary(uniqueKeysWithValues: entries.map { entry in
            (Self.key(entry.properties), entry)
        })
    }

    func style(
        appearance: TUIButtonAppearance,
        size: TUIButtonSize,
        state: TUIButtonState,
        skeleton: Bool
    ) -> TUIButtonStyleReference? {
        let properties = [
            "system": "ios",
            "appearance": appearance.rawValue,
            "size": size.rawValue,
            "state": state.rawValue,
            "skeleton": skeleton ? "on" : "off"
        ]
        return styles[Self.key(properties)]
    }

    private static func key(_ properties: [String: String]) -> String {
        ["system", "size", "appearance", "state", "skeleton"]
            .map { properties[$0] ?? "" }
            .joined(separator: "|")
    }
}
