import SwiftUI

/// A row of chips that either scrolls horizontally or wraps at the available width.
public struct TUIChipGroup<Content: View>: View {
    public let size: TUIChipSize
    public let scrollable: Bool
    @ViewBuilder public let content: (TUIChipSize) -> Content

    public init(
        size: TUIChipSize = .small,
        scrollable: Bool = true,
        @ViewBuilder content: @escaping (TUIChipSize) -> Content
    ) {
        self.size = size
        self.scrollable = scrollable
        self.content = content
    }

    public var body: some View {
        Group {
            if scrollable {
                ScrollView(.horizontal) {
                    HStack(spacing: TUISpacing.x2) { content(size) }
                        .padding(.horizontal, TUISpacing.x4)
                }
                .scrollIndicators(.hidden)
            } else {
                TUIChipFlowLayout(spacing: TUISpacing.x2) { content(size) }
                    .padding(.horizontal, TUISpacing.x4)
            }
        }
        .padding(.vertical, TUISpacing.x2)
    }
}

private struct TUIChipFlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widest: CGFloat = 0
        for subview in subviews {
            let item = subview.sizeThatFits(.unspecified)
            if x > 0 && x + spacing + item.width > maxWidth {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            if x > 0 { x += spacing }
            x += item.width
            widest = max(widest, x)
            rowHeight = max(rowHeight, item.height)
        }
        return CGSize(width: proposal.width ?? widest, height: y + rowHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for subview in subviews {
            let item = subview.sizeThatFits(.unspecified)
            if x > 0 && x + spacing + item.width > bounds.width {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            if x > 0 { x += spacing }
            subview.place(at: CGPoint(x: bounds.minX + x, y: bounds.minY + y), proposal: .unspecified)
            x += item.width
            rowHeight = max(rowHeight, item.height)
        }
    }
}
