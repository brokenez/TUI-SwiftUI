import SwiftUI
import UIKit

public enum TUINotificationBadgeSize: String, CaseIterable, Sendable {
    case small
    case medium
    case large

    public var figmaNodeID: String {
        switch self {
        case .small: "25738:689221"
        case .medium: "25738:689224"
        case .large: "25738:689222"
        }
    }
}

/// Notification badge from TUI Mobile; `small` is the textless 6-point dot.
/// The parent owns accessibility: announce the actual count on its label/value,
/// including when the visible badge reads "99+". The badge is not a focus stop.
public struct TUINotificationBadge: View {
    public static let figmaComponentSetID = "25738:689227"
    public let text: String
    public let size: TUINotificationBadgeSize
    @Environment(\.dynamicTypeSize) private var typeSize

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
                    .accessibilityHidden(true)
            } else {
                let role: TUITypographyRole = size == .large ? .bodyMedium : .uiSmall
                TUINotificationBadgeLayout(size: size) {
                    Text(text)
                        .font(Font(scaledFont(role: role)))
                        .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                        .lineLimit(1)
                        .fixedSize()
                        .accessibilityHidden(true)
                }
                .background(TUIColor.named("Component/Badge Notification"), in: Capsule())
            }
        }
        .accessibilityHidden(true)
    }

    private func scaledFont(role: TUITypographyRole) -> UIFont {
        let category: UIContentSizeCategory
        switch min(typeSize, .accessibility1) {
        case .xSmall: category = .extraSmall
        case .small: category = .small
        case .medium: category = .medium
        case .large: category = .large
        case .xLarge: category = .extraLarge
        case .xxLarge: category = .extraExtraLarge
        case .xxxLarge: category = .extraExtraExtraLarge
        default: category = .accessibilityMedium
        }
        return UIFontMetrics(forTextStyle: role.textStyle.uiKitTextStyle)
            .scaledFont(for: role.metrics.nativeFont(at: role.metrics.size),
                        compatibleWith: UITraitCollection(preferredContentSizeCategory: category))
    }
}

private struct TUINotificationBadgeLayout: Layout {
    let size: TUINotificationBadgeSize

    private func geometry(_ subview: LayoutSubview) -> CGSize {
        let label = subview.sizeThatFits(.unspecified)
        let minimum: CGFloat = size == .large ? TUISpacing.x6 : 18
        let height = max(minimum, ceil(label.height) + 2)
        // The current structure table specifies 23% / 22%. Preserve the source
        // variants' exact base insets; enlarged insets round to a whole point.
        let inset: CGFloat = height == minimum ? (size == .large ? 5.5 : TUISpacing.x1)
            : (height * (size == .large ? 0.23 : 0.22)).rounded()
        return CGSize(width: max(height, label.width + 2 * inset), height: height)
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        geometry(subviews[0])
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // Medium's source has top 0.5 / bottom 1.5 at its minimum height.
        let offset: CGFloat = size == .medium && bounds.height == 18 ? -0.5 : 0
        subviews[0].place(at: CGPoint(x: bounds.midX, y: bounds.midY + offset), anchor: .center,
                          proposal: .unspecified)
    }
}
