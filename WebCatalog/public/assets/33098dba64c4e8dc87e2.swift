import SwiftUI

public enum TUIChipSize: String, CaseIterable, Sendable {
    case small
    case medium

    public var height: CGFloat { self == .small ? 30 : 36 }
    var horizontalPadding: CGFloat { self == .small ? 7 : 10 }
    var verticalPadding: CGFloat { self == .small ? 7 : 10 }
    var labelMinimumWidth: CGFloat { self == .small ? 57 : 63 }

    func minimumWidth(leading: TUIChipLeadingContent, trailing: TUIChipTrailingContent) -> CGFloat {
        var width = labelMinimumWidth
        switch leading {
        case .none: break
        case .icon: width += 16
        case .image: width += self == .small ? 20 : 16
        }
        if trailing != .none { width += 16 }
        if self == .medium, leading == .image, trailing != .none { width += 4 }
        return width
    }
}

public enum TUIChipAppearance: String, CaseIterable, Sendable {
    case neutral
    case floating
    case accent
}

public enum TUIChipLeadingContent: String, CaseIterable, Sendable {
    case none
    case icon
    case image
}

public enum TUIChipTrailingContent: String, CaseIterable, Sendable {
    case none
    case close
    case dropdown
}

/// A compact, tappable TUI chip. The documented iOS combinations are selectable in the catalog.
public struct TUIChip: View {
    public let title: String
    public let size: TUIChipSize
    public let appearance: TUIChipAppearance
    public let leadingContent: TUIChipLeadingContent
    public let trailingContent: TUIChipTrailingContent
    public let disabled: Bool
    public let skeleton: Bool
    public let badge: String?
    public let image: Image?
    private let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    public init(
        _ title: String,
        size: TUIChipSize = .small,
        appearance: TUIChipAppearance = .neutral,
        leadingContent: TUIChipLeadingContent = .none,
        trailingContent: TUIChipTrailingContent = .none,
        disabled: Bool = false,
        skeleton: Bool = false,
        badge: String? = nil,
        image: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.appearance = appearance
        self.leadingContent = leadingContent
        self.trailingContent = trailingContent
        self.disabled = disabled
        self.skeleton = skeleton
        self.badge = badge
        self.image = image
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            content
        }
        .buttonStyle(.plain)
        .disabled(disabled || skeleton)
        .accessibilityLabel(title)
    }

    private var content: some View {
        HStack(spacing: 0) {
            if leadingContent == .icon {
                Image("tui-chip-plus", bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(foreground)
                    .frame(width: 16, height: 16)
            } else if leadingContent == .image {
                Group {
                    if let image {
                        image.resizable().scaledToFill()
                    } else {
                        Circle().fill(appearance == .accent ? Color.white.opacity(0.1) : Color.black.opacity(0.03))
                    }
                }
                .frame(width: 24, height: 24)
                .clipShape(Circle())
            }

            Text(title)
                .tuiTypography(.uiSmallBold)
                .foregroundStyle(foreground)
                .lineLimit(1)
                .fixedSize()
                .padding(.horizontal, 4)

            if let badge {
                Text(badge)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(-0.1)
                    .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                    .padding(.horizontal, 4)
                    .frame(minWidth: 16, minHeight: 16)
                    .background(TUIColor.named("Background/Neutral 4"), in: Capsule())
                    .padding(.trailing, 2)
            }

            if trailingContent != .none {
                Image(trailingContent == .close ? "tui-chip-cross" : "tui-chip-dropdown", bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(foreground)
                    .frame(width: 16, height: 16)
            }
        }
        .padding(.leading, leadingContent == .image ? size.horizontalPadding - 4 : size.horizontalPadding)
        .padding(.trailing, size == .medium && leadingContent == .image && trailingContent == .none
            ? size.horizontalPadding - 4
            : size.horizontalPadding)
        .frame(height: size.height)
        .frame(minWidth: size.minimumWidth(leading: leadingContent, trailing: trailingContent))
        .background(background, in: Capsule())
        .overlay {
            if skeleton {
                Capsule().fill(TUIColor.named("Service/Skeleton"))
            }
        }
        .shadow(
            color: appearance == .floating && !skeleton ? TUIShadow.smallColor : .clear,
            radius: appearance == .floating ? TUIShadow.smallBlur(theme: theme) / 2 : 0,
            x: 0,
            y: appearance == .floating ? TUIShadow.smallYOffset(theme: theme) : 0
        )
        .accessibilityElement(children: .combine)
    }

    private var theme: TUITheme { colorScheme == .dark ? .night : .day }

    private var foreground: Color {
        if disabled { return TUIColor.named("Text/Tertiary") }
        return TUIColor.named(appearance == .accent ? "Text/Primary On Dark" : "Text/Primary")
    }

    private var background: Color {
        if skeleton { return .clear }
        switch appearance {
        case .neutral: return TUIColor.named("Background/Neutral 1")
        case .floating: return TUIColor.named("Background/Elevation 1")
        case .accent: return TUIColor.named("Background/Accent 2")
        }
    }
}
