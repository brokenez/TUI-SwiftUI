import SwiftUI

public enum TUIChipGroupAlignment: String, CaseIterable, Sendable {
    case start
    case center
}

/// A row of chips that either scrolls horizontally or wraps at the available width.
public struct TUIChipGroup<Content: View>: View {
    public let size: TUIChipSize
    public let scrollable: Bool
    public let alignment: TUIChipGroupAlignment
    @ViewBuilder public let content: (TUIChipSize) -> Content

    public init(
        size: TUIChipSize = .small,
        scrollable: Bool = true,
        alignment: TUIChipGroupAlignment = .start,
        @ViewBuilder content: @escaping (TUIChipSize) -> Content
    ) {
        self.size = size
        self.scrollable = scrollable
        self.alignment = alignment
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
                TUIChipFlowLayout(spacing: TUISpacing.x2, alignment: alignment) { content(size) }
                    .padding(.horizontal, TUISpacing.x4)
            }
        }
        .padding(.vertical, TUISpacing.x2)
    }
}

private struct TUIChipFlowLayout: Layout {
    let spacing: CGFloat
    let alignment: TUIChipGroupAlignment

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var rowHeights: [CGFloat] = []
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var widest: CGFloat = 0
        for subview in subviews {
            let item = subview.sizeThatFits(.unspecified)
            if rowWidth > 0 && rowWidth + spacing + item.width > maxWidth {
                rowHeights.append(rowHeight)
                widest = max(widest, rowWidth)
                rowWidth = 0
                rowHeight = 0
            }
            if rowWidth > 0 { rowWidth += spacing }
            rowWidth += item.width
            rowHeight = max(rowHeight, item.height)
        }
        if rowWidth > 0 {
            rowHeights.append(rowHeight)
            widest = max(widest, rowWidth)
        }
        let height = rowHeights.enumerated().reduce(CGFloat.zero) { result, row in
            result + row.element + (row.offset == rowHeights.count - 1 ? 0 : spacing)
        }
        return CGSize(width: proposal.width ?? widest, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var y: CGFloat = 0
        var rows: [[(subview: Subviews.Element, size: CGSize, x: CGFloat)]] = []
        var row: [(Subviews.Element, CGSize, CGFloat)] = []
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        for subview in subviews {
            let item = subview.sizeThatFits(.unspecified)
            if rowWidth > 0 && rowWidth + spacing + item.width > bounds.width {
                rows.append(row.map { (subview: $0.0, size: $0.1, x: $0.2) })
                rowWidth = 0
                rowHeight = 0
                row = []
            }
            if rowWidth > 0 { rowWidth += spacing }
            row.append((subview, item, rowWidth))
            rowWidth += item.width
            rowHeight = max(rowHeight, item.height)
        }
        if !row.isEmpty { rows.append(row.map { (subview: $0.0, size: $0.1, x: $0.2) }) }

        for items in rows {
            let totalWidth = items.last.map { $0.x + $0.size.width } ?? 0
            let startX = alignment == .center ? max(0, (bounds.width - totalWidth) / 2) : 0
            let height = items.map(\.size.height).max() ?? 0
            for item in items {
                item.subview.place(
                    at: CGPoint(x: bounds.minX + startX + item.x, y: bounds.minY + y),
                    proposal: .unspecified
                )
            }
            y += height + spacing
        }
    }
}
