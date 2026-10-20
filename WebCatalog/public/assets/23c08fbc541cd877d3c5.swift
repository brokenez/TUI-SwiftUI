import SwiftUI

public enum TUISubscriptionBadgeSize: Int, CaseIterable, Sendable {
    case xLarge = 28
    case large = 24
    case medium = 20
    case small = 16

    public var figmaName: String {
        switch self {
        case .xLarge: "x-large"
        case .large: "large"
        case .medium: "medium"
        case .small: "small"
        }
    }
}

/// Subscription status icon built from the original Figma vector, at its four iOS sizes.
public struct TUISubscriptionBadge: View {
    public let size: TUISubscriptionBadgeSize

    public init(size: TUISubscriptionBadgeSize = .xLarge) {
        self.size = size
    }

    public var body: some View {
        Image("tui-subscription-badge-\(size.figmaName)", bundle: .module)
            .resizable()
            .interpolation(.high)
            .frame(width: CGFloat(size.rawValue), height: CGFloat(size.rawValue))
            .accessibilityLabel("Подписка")
    }
}
