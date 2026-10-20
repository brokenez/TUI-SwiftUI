import SwiftUI

public enum TUISystemBrowserChromeVariant: String, CaseIterable, Hashable, Sendable {
    case addressBar
    case addressBarScrolled
    case tabBar

    public var figmaNodeID: String {
        switch self {
        case .addressBar: "42221:48344"
        case .addressBarScrolled: "42221:48351"
        case .tabBar: "42221:48357"
        }
    }

    public var title: String {
        switch self {
        case .addressBar: "Address bar · Normal"
        case .addressBarScrolled: "Address bar · Scrolled"
        case .tabBar: "Tab bar"
        }
    }
}

/// Browser chrome from TUI Mobile. The containing app supplies its native status bar and home indicator.
/// Place the tab-bar variant in a bottom safe-area inset so iOS can draw its native home indicator.
public struct TUISystemBrowserChrome: View {
    public let variant: TUISystemBrowserChromeVariant
    public let tabCount: Int
    public let onBack: () -> Void
    public let onForward: () -> Void
    public let onNewTab: () -> Void
    public let onShare: () -> Void
    public let onMore: () -> Void

    public init(
        variant: TUISystemBrowserChromeVariant,
        tabCount: Int = 4,
        onBack: @escaping () -> Void = {},
        onForward: @escaping () -> Void = {},
        onNewTab: @escaping () -> Void = {},
        onShare: @escaping () -> Void = {},
        onMore: @escaping () -> Void = {}
    ) {
        self.variant = variant
        self.tabCount = tabCount
        self.onBack = onBack
        self.onForward = onForward
        self.onNewTab = onNewTab
        self.onShare = onShare
        self.onMore = onMore
    }

    public var body: some View {
        switch variant {
        case .addressBar:
            normalAddressBar
        case .addressBarScrolled:
            scrolledAddressBar
        case .tabBar:
            tabBar
        }
    }

    private var normalAddressBar: some View {
        HStack(spacing: 0) {
            ZStack {
                HStack(spacing: 7) {
                    Image("address-lock", bundle: .module)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .accessibilityHidden(true)
                    Text("tbank.ru")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(TUIColor.named("Text/Primary"))
                }
                Button(action: onShare) {
                    HStack {
                        Spacer()
                        Image("browser-share", bundle: .module)
                            .resizable()
                            .frame(width: 21, height: 21)
                            .accessibilityHidden(true)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Поделиться")
            }
            .padding(.horizontal, 13)
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background(TUIColor.named("Background/Neutral 2"), in: Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(TUIColor.named("Background/Elevation 1"))
        .overlay(alignment: .bottom) {
            Rectangle().fill(TUIColor.named("Border/Normal")).frame(height: 0.4)
        }
        .frame(width: 375)
    }

    private var scrolledAddressBar: some View {
        HStack(spacing: 6) {
            Image("address-lock-small", bundle: .module)
                .resizable()
                .frame(width: 12, height: 12)
                .accessibilityHidden(true)
            Text("tbank.ru")
                .font(.system(size: 12.857, weight: .regular))
                .foregroundStyle(TUIColor.named("Text/Primary"))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 38)
        .background(TUIColor.named("Background/Elevation 1"))
        .overlay(alignment: .bottom) {
            Rectangle().fill(TUIColor.named("Border/Normal")).frame(height: 0.5)
        }
        .frame(width: 375)
    }

    private var tabBar: some View {
        HStack {
                iconButton("browser-back", label: "Назад", action: onBack)
                Spacer(minLength: 0)
                iconButton("browser-forward", label: "Вперёд", action: onForward)
                Spacer(minLength: 0)
                iconButton("browser-new-tab", label: "Новая вкладка", action: onNewTab, size: 36, containerSize: 36)
                Spacer(minLength: 0)
                Button(action: onMore) {
                    Text("\(tabCount)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(TUIColor.named("Text/Secondary"))
                        .frame(width: 24, height: 24)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(TUIColor.named("Text/Secondary"), lineWidth: 2))
                        .frame(width: 26, height: 26)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Вкладки: \(tabCount)")
                Spacer(minLength: 0)
                iconButton("browser-more-menu", label: "Ещё", action: onMore)
        }
        .padding(.horizontal, 21)
        .frame(width: 375, height: 44)
        .background(TUIColor.named("Background/Elevation 1").ignoresSafeArea(edges: .bottom))
        .overlay(alignment: .top) {
            Rectangle().fill(TUIColor.named("Border/Normal")).frame(height: 0.5)
        }
        .clipped()
    }

    private func iconButton(
        _ asset: String,
        label: String,
        action: @escaping () -> Void,
        size: CGFloat = 26,
        containerSize: CGFloat = 36
    ) -> some View {
        Button(action: action) {
            Image(asset, bundle: .module)
                .resizable()
                .frame(width: size, height: size)
                .frame(width: containerSize, height: containerSize)
                .accessibilityHidden(true)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}
