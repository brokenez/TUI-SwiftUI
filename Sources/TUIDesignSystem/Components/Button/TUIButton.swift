import SwiftUI
import UIKit

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
    public static let figmaComponentSetID = "41658:296906"
    static var importedVariantCount: Int { TUIButtonStyleCatalog.shared.count }

    /// The exact base variant. Instance content/customization does not change
    /// its source ID; nil means the requested combination is not in Figma.
    public var figmaNodeID: String? {
        TUIButtonStyleCatalog.shared.style(appearance: appearance, size: size, state: state, skeleton: skeleton)?.id
    }

    public let title: String
    public let appearance: TUIButtonAppearance
    public let size: TUIButtonSize
    public let state: TUIButtonState
    public let skeleton: Bool
    public let showsIcon: Bool
    public let showsLabel: Bool
    /// Figma `Icon`: replacement for the Large/Medium icon slot.
    public let icon: Image?
    /// Figma `Icon (16)`: independent replacement for the Small icon slot.
    public let smallIcon: Image?
    /// Use .original for fixed-color/multicolor artwork. This applies only
    /// to replacement images; the source default icons remain templates.
    public let iconRenderingMode: Image.TemplateRenderingMode
    /// Explicit customization allowed by the source specification. Prefer
    /// the built-in appearances and TUIColor tokens; nil preserves them.
    public let backgroundColor: Color?
    public let textColor: Color?
    public let iconColor: Color?
    public let cornerRadius: CGFloat?
    /// Explicit container width, including Small and icon-only buttons.
    /// Nil keeps the original size-dependent layout.
    public let width: CGFloat?
    /// Masks every literal occurrence inside the label, preserving the original
    /// text geometry and tap area. Nil or an empty string shows the whole label.
    public let sensitiveText: String?
    private let action: () -> Void
    @AccessibilityFocusState(for: .voiceOver) private var hasVoiceOverFocus: Bool
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled

    public init(
        _ title: String,
        appearance: TUIButtonAppearance = .primary,
        size: TUIButtonSize = .large,
        state: TUIButtonState = .normal,
        skeleton: Bool = false,
        showsIcon: Bool = false,
        showsLabel: Bool = true,
        icon: Image? = nil,
        smallIcon: Image? = nil,
        iconRenderingMode: Image.TemplateRenderingMode = .template,
        backgroundColor: Color? = nil,
        textColor: Color? = nil,
        iconColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        width: CGFloat? = nil,
        sensitiveText: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.appearance = appearance
        self.size = size
        self.state = state
        self.skeleton = skeleton
        self.showsIcon = showsIcon
        self.showsLabel = showsLabel
        self.icon = icon
        self.smallIcon = smallIcon
        self.iconRenderingMode = iconRenderingMode
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.iconColor = iconColor
        self.cornerRadius = cornerRadius
        self.width = width
        self.sensitiveText = sensitiveText
        self.action = action
    }

    public var body: some View {
        if voiceOverEnabled {
            nativeButton
                .accessibilityFocused($hasVoiceOverFocus)
                .onChange(of: state) { previous, current in
                    // Announce completion only while this button retains focus;
                    // never move VoiceOver away from another control.
                    if previous == .loading && current != .loading && hasVoiceOverFocus {
                        UIAccessibility.post(notification: .announcement, argument: title)
                    }
                }
        } else {
            // The native focus bridge is needed only for VoiceOver. Keeping it
            // out of other modes also preserves offscreen ImageRenderer output.
            nativeButton
        }
    }

    private var nativeButton: some View {
        Button(title) {
            // Loading stays a focusable, enabled accessibility button, but
            // cannot repeat the action (speech table 25085:11915–11919).
            guard state != .loading && state != .disabled && !skeleton else { return }
            action()
        }
            .buttonStyle(
                TUIButtonFigmaStyle(
                    title: title,
                    appearance: appearance,
                    size: size,
                    state: state,
                    skeleton: skeleton,
                    showsIcon: showsIcon,
                    showsLabel: showsLabel,
                    icon: size == .small ? smallIcon : icon,
                    iconRenderingMode: iconRenderingMode,
                    backgroundColorOverride: backgroundColor,
                    textColorOverride: textColor,
                    iconColorOverride: iconColor,
                    cornerRadiusOverride: cornerRadius,
                    widthOverride: width,
                    sensitiveText: sensitiveText
                )
            )
            .disabled(state == .disabled || skeleton)
            .accessibilityLabel(Text(state == .loading ? "Идет загрузка" : title))
    }
}

private struct TUIButtonFigmaStyle: ButtonStyle {
    let title: String
    let appearance: TUIButtonAppearance
    let size: TUIButtonSize
    let state: TUIButtonState
    let skeleton: Bool
    let showsIcon: Bool
    let showsLabel: Bool
    let icon: Image?
    let iconRenderingMode: Image.TemplateRenderingMode
    let backgroundColorOverride: Color?
    let textColorOverride: Color?
    let iconColorOverride: Color?
    let cornerRadiusOverride: CGFloat?
    let widthOverride: CGFloat?
    let sensitiveText: String?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorScheme) private var colorScheme

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
        let sourceTextColor = textPaint?.swiftUIColor ?? Color.primary
        let textColor = textColorOverride ?? sourceTextColor
        let iconColor = iconColorOverride ?? sourceTextColor
        let background = backgroundColorOverride ?? style?.fill?.swiftUIColor ?? .clear
        let radius = max(0, cornerRadiusOverride ?? style?.radius ?? size.radius)
        let dropShadow = style?.effects?.first(where: { $0.type == "DROP_SHADOW" })
        // Native SF Pro, per the 2026-10-20 distribution typography decision.
        let baseSize = normalStyle?.text?.fontSize ?? size.fontSize
        let baseFont = size == .small ? UIFont.systemFont(ofSize: baseSize, weight: .semibold)
            : TUIFigmaTextFont.regular(size: baseSize)
        let font = UIFontMetrics(forTextStyle: size.typographyRole.textStyle.uiKitTextStyle)
            .scaledFont(for: baseFont, compatibleWith: UITraitCollection(preferredContentSizeCategory: contentSizeCategory))
        let tracking = style?.text?.tracking ?? size.tracking
        let metrics = TUIHeaderFontMetrics(font: font, lineHeight: font.lineHeight,
                                          firstBaseline: font.ascender, tracking: tracking, color: textColor)
        // iOS guide 25085:11908 / diagram 25085:11909: one icon increase at AX1.
        let iconSize = size.iconSize * (dynamicTypeSize >= .accessibility1 ? 1.25 : 1)

        HStack(spacing: 0) {
            if showsIcon {
                Group {
                    if let icon {
                        // Corner case 130:282986: fit oversized artwork,
                        // retain smaller artwork inside the unchanged slot.
                        ViewThatFits(in: [.horizontal, .vertical]) {
                            icon.renderingMode(iconRenderingMode).fixedSize()
                            icon.renderingMode(iconRenderingMode).resizable().scaledToFit()
                        }
                        .frame(width: size.iconSize, height: size.iconSize)
                        .scaleEffect(iconSize / size.iconSize)
                        .frame(width: iconSize, height: iconSize)
                    } else {
                        Image(size == .small ? "tui-button-star-small" : "tui-button-star", bundle: .module)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: iconSize, height: iconSize)
                    }
                }
                .foregroundStyle(iconColor)
                .accessibilityHidden(true)
            }
            if showsLabel {
                TUIHeaderText(value: AttributedString(title), metrics: metrics, color: textColor,
                              tracking: tracking, overflow: .singleLineFade, centered: false,
                              inlineText: sensitiveText.map { TUISensitiveText.annotatedText(title, masking: $0, color: textColor) },
                              usesIntrinsicWidth: true,
                              masksSensitiveText: !(sensitiveText ?? "").isEmpty)
                    .padding(.horizontal, size.labelHorizontalPadding)
            }
        }
        // Keep the original label/icon in layout while loading. The source
        // guide requires the container to retain its normal size (81:48109).
        .opacity(skeleton || displayedState == .loading ? 0 : 1)
        // Construction 14133:8499: label-only totals 24/18/11 pt,
        // with icon + label the outer insets are 16/10/7 pt.
        .padding(.horizontal, showsLabel ? size.outerHorizontalPadding : max(0, (size.height - iconSize) / 2))
        .padding(.vertical, size.minimumVerticalInset)
        .frame(width: widthOverride ?? (showsIcon && !showsLabel ? size.height : nil))
        .frame(maxWidth: widthOverride != nil || size == .small || !showsLabel ? nil : .infinity)
        .frame(minHeight: style?.height ?? size.height)
        .overlay {
            if displayedState == .loading && !skeleton {
                TUIButtonLoadingGlyph(color: textColorOverride ?? normalStyle?.text?.fill?.swiftUIColor ?? .primary)
                    .frame(width: size.loadingSize, height: size.loadingSize)
                    .accessibilityHidden(true)
            }
        }
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
            color: appearance == .floating && dropShadow != nil ? TUIShadow.smallColor
                : dropShadow?.color?.swiftUIColor ?? .clear,
            radius: appearance == .floating && dropShadow != nil
                // Figma Blur 20 matches SwiftUI radius 10 in native source pairs.
                ? TUIShadow.smallBlur(theme: colorScheme == .dark ? .night : .day) / 2
                : dropShadow?.radius ?? 0,
            x: dropShadow?.offset?.x ?? 0,
            y: appearance == .floating && dropShadow != nil
                ? TUIShadow.smallYOffset(theme: colorScheme == .dark ? .night : .day)
                : dropShadow?.offset?.y ?? 0
        )
        .overlay {
            if skeleton {
                GeometryReader { geometry in
                    TUISkeleton(width: geometry.size.width, height: geometry.size.height,
                                cornerRadius: radius)
                }
                .allowsHitTesting(false)
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: radius))
    }

    private var contentSizeCategory: UIContentSizeCategory {
        switch dynamicTypeSize {
        case .xSmall: .extraSmall
        case .small: .small
        case .medium: .medium
        case .large: .large
        case .xLarge: .extraLarge
        case .xxLarge: .extraExtraLarge
        case .xxxLarge: .extraExtraExtraLarge
        case .accessibility1: .accessibilityMedium
        case .accessibility2: .accessibilityLarge
        case .accessibility3: .accessibilityExtraLarge
        case .accessibility4: .accessibilityExtraExtraLarge
        case .accessibility5: .accessibilityExtraExtraExtraLarge
        @unknown default: .large
        }
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
    var outerHorizontalPadding: CGFloat {
        switch self {
        case .large: 16
        case .medium: 10
        case .small: 7
        }
    }

    // Minimum insets annotated in the iOS scaling diagram 25085:11909.
    var minimumVerticalInset: CGFloat {
        switch self {
        case .large: 8
        case .medium: 6
        case .small: 2
        }
    }

    var typographyRole: TUITypographyRole {
        switch self {
        case .large: .uiLarge
        case .medium: .uiMedium
        case .small: .uiSmallBold
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
    let alias: String?

    var swiftUIColor: Color {
        if let alias, let name = TUIButtonStyleCatalog.shared.tokenName(for: alias) {
            // The bound Theme token already contains its mode-specific alpha.
            // Figma's resolved Day paint opacity must not multiply it again.
            return TUIColor.named(name)
        }
        return color?.swiftUIColor.opacity(opacity ?? 1) ?? .clear
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
    private let tokenNamesByKey: [String: String]

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
        let bindingsURL = Bundle.module.url(forResource: "figma-button-variable-bindings", withExtension: "json", subdirectory: "Metadata")
            ?? Bundle.module.url(forResource: "figma-button-variable-bindings", withExtension: "json")
        let bindings = bindingsURL.flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? JSONSerialization.jsonObject(with: $0) as? [String: Any] }?["variables"] as? [[String: String]] ?? []
        tokenNamesByKey = Dictionary(uniqueKeysWithValues: bindings.compactMap { value in
            guard value["collection"] == "Theme", let key = value["key"], let name = value["name"] else { return nil }
            return (key, name)
        })
    }

    func tokenName(for alias: String) -> String? {
        guard alias.hasPrefix("VariableID:") else { return nil }
        let key = alias.dropFirst("VariableID:".count).split(separator: "/").first.map(String.init)
        return key.flatMap { tokenNamesByKey[$0] }
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
