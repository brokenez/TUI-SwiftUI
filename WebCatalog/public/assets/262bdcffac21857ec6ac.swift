import SwiftUI

public enum TUIBadgedContentBadge: String, CaseIterable, Sendable {
    case top = "top"
    case topPlusBottom = "top-plus-bottom"
    case bottom = "bottom"
    case tClient = "t-client"
    case off = "off"
}

/// Composes the notification, verification and client badges around any content.
public struct TUIBadgedContent<Content: View>: View {
    public let badge: TUIBadgedContentBadge
    @ViewBuilder public let content: Content

    public init(badge: TUIBadgedContentBadge, @ViewBuilder content: () -> Content) {
        self.badge = badge
        self.content = content()
    }

    public var body: some View {
        content
            .overlay(alignment: .topTrailing) {
                if badge == .top || badge == .topPlusBottom {
                    TUINotificationBadge("1", size: .medium)
                        .offset(x: 8, y: -8)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                switch badge {
                case .bottom, .topPlusBottom:
                    Image("tui-badged-content-check", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8.125, height: 5.625)
                        .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                        .frame(width: 16, height: 16)
                        .background(TUIColor.named("Background/Neutral 4"), in: Circle())
                        .padding(1)
                        .background(TUIColor.named("Background/Base"), in: Circle())
                        .offset(x: 8, y: 8)
                        .accessibilityLabel("Подтверждено")
                case .tClient:
                    TUIClientBadge()
                        .overlay(Circle().strokeBorder(TUIColor.named("Background/Base"), lineWidth: 2))
                        .offset(x: 4, y: 4)
                case .top, .off:
                    EmptyView()
                }
            }
    }
}
