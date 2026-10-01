import SwiftUI

public enum TUILinkMode: String, CaseIterable, Sendable {
    case `default`
    case textPrimary = "text-primary"
    case textSecondary = "text-secondary"
    case textPrimaryOnLight = "text-primary-on-light"
    case textPrimaryOnDark = "text-primary-on-dark"

    var foreground: Color {
        switch self {
        case .default: TUIColor.named("Text/Action", fallback: 0x428BF9)
        case .textPrimary: TUIColor.named("Text/Primary", fallback: 0x333333)
        case .textSecondary: TUIColor.named("Text/Secondary", fallback: 0x9299A2)
        case .textPrimaryOnLight: TUIColor.named("Text/Primary On Light", fallback: 0x333333)
        case .textPrimaryOnDark: TUIColor.named("Text/Primary On Dark", fallback: 0xFFFFFF)
        }
    }
}

public enum TUILinkSize: String, CaseIterable, Sendable {
    case large
    case medium
    case small

    var typography: TUITypographyRole {
        switch self {
        case .large: .uiLarge
        case .medium: .uiMedium
        case .small: .uiSmall
        }
    }

    var height: CGFloat {
        switch self {
        case .large: 20
        case .medium: 18
        case .small: 16
        }
    }

    var spacing: CGFloat { self == .small ? 4 : 6 }
}

/// Interactive TUI link matching the 15 iOS size and color variants in Figma.
public struct TUILink: View {
    public let title: String
    public let mode: TUILinkMode
    public let size: TUILinkSize
    public let showsLeadingIcon: Bool
    public let showsTrailingIcon: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        mode: TUILinkMode = .default,
        size: TUILinkSize = .large,
        showsLeadingIcon: Bool = true,
        showsTrailingIcon: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.mode = mode
        self.size = size
        self.showsLeadingIcon = showsLeadingIcon
        self.showsTrailingIcon = showsTrailingIcon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: size.spacing) {
                if showsLeadingIcon {
                    Image("tui-link-arrow-right-circle", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .accessibilityHidden(true)
                }
                Text(title)
                    .tuiTypography(size.typography)
                    .underline(mode != .default)
                    .fixedSize(horizontal: true, vertical: false)
                if showsTrailingIcon {
                    Image("tui-link-chevron-down", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .accessibilityHidden(true)
                }
            }
            .foregroundStyle(mode.foreground)
            .frame(height: size.height)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
