import SwiftUI

public enum TUINotificationBadgeSize: String, CaseIterable, Sendable {
    case small
    case medium
    case large
}

/// Notification badge from TUI Mobile; `small` is the textless 6-point dot.
public struct TUINotificationBadge: View {
    public let text: String
    public let size: TUINotificationBadgeSize

    public init(_ text: String = "1", size: TUINotificationBadgeSize = .medium) {
        self.text = text
        self.size = size
    }

    public var body: some View {
        Group {
            if size == .small {
                Circle()
                    .fill(TUIColor.named("Component/Badge Notification"))
                    .frame(width: 6, height: 6)
            } else {
                Text(text)
                    .tuiTypography(size == .large ? .bodyMedium : .uiSmall)
                    .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                    .padding(.horizontal, size == .large ? 5.5 : 4)
                    .frame(minWidth: size == .large ? 24 : 18)
                    .frame(height: size == .large ? 24 : 18)
                    .background(TUIColor.named("Component/Badge Notification"), in: Capsule())
            }
        }
        .accessibilityLabel(size == .small ? "Новое уведомление" : "Уведомлений: \(text)")
    }
}
