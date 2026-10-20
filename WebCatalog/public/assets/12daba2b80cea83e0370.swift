import SwiftUI

/// Custom-content row from TUI Mobile. The caller owns every child item's visuals and interaction.
public struct TUIRowCustom<Content: View>: View {
    public let spacing: CGFloat
    private let content: Content

    public init(
        spacing: CGFloat = TUISpacing.x3,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        TUIClippedRowLayout(spacing: spacing) {
            content
        }
        .padding(.horizontal, TUISpacing.x4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
    }
}

private struct TUIClippedRowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let idealWidth = sizes.reduce(0) { $0 + $1.width } + spacing * CGFloat(max(0, sizes.count - 1))
        let height = sizes.map(\.height).max() ?? 0
        return CGSize(width: proposal.width ?? idealWidth, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var x = bounds.minX
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            subview.place(
                at: CGPoint(x: x, y: bounds.minY),
                proposal: ProposedViewSize(size)
            )
            x += size.width + spacing
        }
    }
}
