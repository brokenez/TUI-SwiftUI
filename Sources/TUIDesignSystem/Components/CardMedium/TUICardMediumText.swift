import SwiftUI
import UIKit

struct TUICardMediumFontMetrics {
    let font: UIFont
    let lineHeight: CGFloat
    let baseline: CGFloat
    let tracking: CGFloat

    static func category(_ size: DynamicTypeSize) -> UIContentSizeCategory {
        switch min(size, .accessibility1) {
        case .xSmall: .extraSmall
        case .small: .small
        case .medium: .medium
        case .large: .large
        case .xLarge: .extraLarge
        case .xxLarge: .extraExtraLarge
        case .xxxLarge: .extraExtraExtraLarge
        default: .accessibilityMedium
        }
    }

    static func dimensionScale(_ size: DynamicTypeSize) -> CGFloat {
        let base = UIFont.systemFont(ofSize: TUITypographyRole.uiMediumBold.metrics.size)
        return UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: base,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: category(size))).pointSize / base.pointSize
    }

    static func make(style: TUICardMedium.TextStyle, title: Bool, size: DynamicTypeSize, bold: Bool = false) -> Self {
        let role = style.role ?? (title ? .uiMediumBold : bold ? .uiSmallBold : .uiSmall)
        let metrics = role.metrics
        // Public system face only. Its difference from the old Figma font is an
        // open visual acceptance item, not silently compensated in the consumer.
        let base = style.font ?? metrics.nativeFont(at: metrics.size)
        let scaled = UIFontMetrics(forTextStyle: style.role?.textStyle.uiKitTextStyle ?? (title ? .subheadline : .footnote)).scaledFont(for: base,
            compatibleWith: UITraitCollection(preferredContentSizeCategory: category(size)))
        let baseHeight = style.lineHeight ?? (style.font != nil ? base.lineHeight.rounded()
            : style.role != nil ? metrics.lineHeight : title ? 18 : 16)
        let height = (baseHeight * scaled.pointSize / base.pointSize).rounded()
        let baseline = style.font == nil && style.role == nil && style.lineHeight == nil
            ? scaled.ascender.rounded() : (height - scaled.lineHeight) / 2 + scaled.ascender
        return Self(font: scaled, lineHeight: height, baseline: baseline,
                    tracking: style.tracking ?? (style.role != nil || style.font != nil ? 0 : title ? -0.24 : -0.08))
    }

    func lines(for value: String, width: CGFloat, maximum: Int?) -> Int {
        guard !value.isEmpty, width > 0 else { return 0 }
        let attributed = NSAttributedString(string: value, attributes: [.font: font, .kern: tracking])
        let height = attributed.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        let natural = max(1, Int(ceil(height / font.lineHeight)))
        return maximum.map { min(natural, $0) } ?? natural
    }
}

struct TUICardMediumTextStack: View {
    let title: String
    let subtitle: String
    let titleStyle: TUICardMedium.TextStyle
    let subtitleStyle: TUICardMedium.TextStyle
    let position: TUICardMedium.TextPosition
    let size: DynamicTypeSize

    private var displayTitle: String { titleStyle.role?.isUppercase == true ? title.uppercased() : title }
    private var displaySubtitle: String { subtitleStyle.role?.isUppercase == true ? subtitle.uppercased() : subtitle }

    var body: some View {
        let titleMetrics = TUICardMediumFontMetrics.make(style: titleStyle, title: true, size: size)
        let subtitleMetrics = TUICardMediumFontMetrics.make(style: subtitleStyle, title: false, size: size)
        GeometryReader { proxy in
            let lines = fittingLines(width: proxy.size.width, height: proxy.size.height,
                                     titleMetrics: titleMetrics, subtitleMetrics: subtitleMetrics)
            VStack(alignment: .leading, spacing: lines.title > 0 && lines.subtitle > 0 ? TUISpacing.x1 : 0) {
                if lines.title > 0 {
                    TUICardMediumLabel(value: displayTitle, metrics: titleMetrics, color: titleStyle.color, lines: lines.title)
                }
                if lines.subtitle > 0 {
                    TUICardMediumLabel(value: displaySubtitle, metrics: subtitleMetrics, color: subtitleStyle.color, lines: lines.subtitle)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,
                   alignment: position == .top ? .topLeading : .bottomLeading)
        }
    }

    private func fittingLines(width: CGFloat, height: CGFloat, titleMetrics: TUICardMediumFontMetrics,
                              subtitleMetrics: TUICardMediumFontMetrics) -> (title: Int, subtitle: Int) {
        var titleLines = titleMetrics.lines(for: displayTitle, width: width, maximum: titleStyle.maximumLines)
        var subtitleLines = subtitleMetrics.lines(for: displaySubtitle, width: width, maximum: subtitleStyle.maximumLines)
        // Keep both labels when possible; additional title lines have priority.
        while CGFloat(titleLines) * titleMetrics.lineHeight + CGFloat(subtitleLines) * subtitleMetrics.lineHeight
                + (titleLines > 0 && subtitleLines > 0 ? TUISpacing.x1 : 0) > height {
            if subtitleLines > 1 { subtitleLines -= 1 }
            else if titleLines > 1 { titleLines -= 1 }
            else if subtitleLines > 0 { subtitleLines = 0 }
            else if titleLines > 0 { titleLines = 0 }
            else { break }
        }
        return (titleLines, subtitleLines)
    }
}

struct TUICardMediumLabel: View {
    let value: String
    let metrics: TUICardMediumFontMetrics
    let color: Color
    let lines: Int

    var body: some View {
        ViewThatFits(in: .vertical) {
            label(limited: false)
            label(limited: true)
                .mask {
                    VStack(spacing: 0) {
                        if lines > 1 { Color.white.frame(height: metrics.lineHeight * CGFloat(lines - 1)) }
                        LinearGradient(stops: [.init(color: .white, location: 0),
                                               .init(color: .white, location: 0.85065),
                                               .init(color: .clear, location: 1)],
                                       startPoint: .leading, endPoint: .trailing)
                            .frame(height: metrics.lineHeight)
                    }
                }
        }
        .frame(maxHeight: metrics.lineHeight * CGFloat(lines))
        .clipped()
        .accessibilityLabel(value)
    }

    private func label(limited: Bool) -> some View {
        TUICardMediumLabelLayout(metrics: metrics, maximumLines: limited ? lines : nil) {
            Text(value)
                .font(Font(metrics.font)).kerning(metrics.tracking).foregroundStyle(color)
                .lineSpacing(metrics.lineHeight - metrics.font.lineHeight)
                .textRenderer(TUICardMediumFadeRenderer(maximumLines: limited ? lines : nil))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct TUICardMediumLabelLayout: Layout {
    let metrics: TUICardMediumFontMetrics
    let maximumLines: Int?

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let natural = subviews[0].sizeThatFits(ProposedViewSize(width: proposal.width, height: nil))
        let count = max(1, ((natural.height - metrics.font.lineHeight) / max(1, metrics.lineHeight)).rounded() + 1)
        return CGSize(width: min(proposal.width ?? natural.width, natural.width),
                      height: min(count, maximumLines.map(CGFloat.init) ?? count) * metrics.lineHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let proposed = ProposedViewSize(width: bounds.width, height: nil)
        let measured = subviews[0].dimensions(in: proposed)
        subviews[0].place(at: CGPoint(x: bounds.minX, y: bounds.minY + metrics.baseline - measured[.firstTextBaseline]),
                          proposal: proposed)
    }
}

/// Continue a soft wrap into the faded last line; preserve explicit paragraphs.
private struct TUICardMediumFadeRenderer: TextRenderer {
    let maximumLines: Int?
    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        guard let maximumLines, layout.count > maximumLines else {
            for line in layout { context.draw(line) }
            return
        }
        for index in 0..<maximumLines { context.draw(layout[index]) }
        let last = layout[maximumLines - 1]
        var previousIndex = last.flatMap { $0.characterIndices }.max()
        var x = last.origin.x + last.typographicBounds.width
        let envelope = layout.map { $0.typographicBounds.rect.maxX }.max() ?? x
        for index in maximumLines..<layout.count {
            let line = layout[index]
            guard let previous = previousIndex,
                  let first = line.flatMap({ $0.characterIndices }).min(), first > previous else { break }
            var continuation = context
            continuation.translateBy(x: x - line.origin.x, y: last.origin.y - line.origin.y)
            continuation.draw(line)
            x += line.typographicBounds.width
            previousIndex = line.flatMap { $0.characterIndices }.max()
            if x >= envelope { break }
        }
    }
}
