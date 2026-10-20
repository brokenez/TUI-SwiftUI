import SwiftUI
import UIKit

/// Legacy large screen heading. Figma set 42565:305012, iOS 26/shared variants.
/// Navigation, actions and state are supplied by the consuming application.
public struct TUIHeaderLarge: View {
    public enum Variant: String, CaseIterable, Sendable {
        case descriptionLeading
        case descriptionLeadingSkeleton
        case descriptionCentered
        case descriptionCenteredSkeleton
        case subheaderLeading
        case subheaderLeadingExtended
        case subheaderLeadingSkeleton
        case subheaderCentered
        case subheaderCenteredSkeleton
        case descriptionLeadingExtended

        public var figmaNodeID: String {
            switch self {
            case .descriptionLeading: "42565:305013"
            case .descriptionLeadingSkeleton: "17714:51940"
            case .descriptionCentered: "547:151714"
            case .descriptionCenteredSkeleton: "17714:51950"
            case .subheaderLeading: "42565:305051"
            case .subheaderLeadingExtended: "18083:44942"
            case .subheaderLeadingSkeleton: "17714:51980"
            case .subheaderCentered: "547:151734"
            case .subheaderCenteredSkeleton: "17714:51990"
            case .descriptionLeadingExtended: "18083:44906"
            }
        }

        public var showsDescription: Bool {
            switch self {
            case .descriptionLeading, .descriptionLeadingSkeleton, .descriptionCentered,
                 .descriptionCenteredSkeleton, .descriptionLeadingExtended: true
            default: false
            }
        }

        public var isCentered: Bool {
            switch self {
            case .descriptionCentered, .descriptionCenteredSkeleton,
                 .subheaderCentered, .subheaderCenteredSkeleton: true
            default: false
            }
        }

        public var isSkeleton: Bool {
            switch self {
            case .descriptionLeadingSkeleton, .descriptionCenteredSkeleton,
                 .subheaderLeadingSkeleton, .subheaderCenteredSkeleton: true
            default: false
            }
        }

        public var isExtended: Bool {
            self == .descriptionLeadingExtended || self == .subheaderLeadingExtended
        }
    }

    public enum TextOverflow: Hashable, Sendable {
        case multiline
        case singleLineFade
        /// A positive number of visible lines; only the last line fades.
        case multilineFade(lineLimit: Int)
    }

    /// Nil role preserves the exact legacy SF Pro face from this component set.
    /// A role selects current Foundation typography for documented customization.
    public struct TextStyle {
        public var role: TUITypographyRole?
        /// For explicit Figma font overrides without a Foundation role.
        public var font: UIFont?
        public var lineHeight: CGFloat?
        public var color: Color?
        public var tracking: CGFloat?
        public var overflow: TextOverflow

        public init(role: TUITypographyRole? = nil, font: UIFont? = nil, lineHeight: CGFloat? = nil, color: Color? = nil,
                    tracking: CGFloat? = nil, overflow: TextOverflow = .multiline) {
            self.role = role
            self.font = font
            self.lineHeight = lineHeight
            self.color = color
            self.tracking = tracking
            self.overflow = overflow
        }
    }

    public enum AccessoryAlignment: String, CaseIterable, Sendable {
        case firstLineCenter, firstBaseline, top, center, bottom

        var vertical: VerticalAlignment {
            switch self {
            case .firstLineCenter: .tuiHeaderFirstLineCenter
            case .firstBaseline: .firstTextBaseline
            case .top: .top
            case .center: .center
            case .bottom: .bottom
            }
        }
    }

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    public var variant: Variant
    public var title: AttributedString
    public var subheader: AttributedString
    public var description: AttributedString
    public var showsSubheader: Bool
    public var showsIcon: Bool
    public var isSkeletonAnimating: Bool
    public var titleStyle = TextStyle()
    public var subheaderStyle = TextStyle()
    public var descriptionStyle = TextStyle()
    public var insets = EdgeInsets(top: TUISpacing.x2, leading: TUISpacing.x4,
                                  bottom: TUISpacing.x6, trailing: TUISpacing.x4)
    public var accessoryAlignment: AccessoryAlignment = .firstLineCenter
    /// Source extended placeholders center against the entire text block.
    public var titleSlotAlignment: AccessoryAlignment = .center
    public var secondarySlotAlignment: AccessoryAlignment = .center
    /// Opt-in specification behavior: place accessory below text at AX1.
    public var reflowsAccessoryAtAX1 = false

    private var accessoryContent: AnyView?
    private var titleContent: AnyView?
    private var secondaryContent: AnyView?
    private var inlineTitle: Text?
    private var inlineSecondary: Text?
    private var titlePrefix: AnyView?
    private var titleSuffix: AnyView?
    private var secondaryPrefix: AnyView?
    private var secondarySuffix: AnyView?

    public init(_ title: String = "Header", subheader: String = "Subheader",
                description: String = "Description", variant: Variant = .subheaderLeading,
                showsSubheader: Bool = true, showsIcon: Bool = false,
                isSkeletonAnimating: Bool = true) {
        self.init(title: AttributedString(title), subheader: AttributedString(subheader),
                  description: AttributedString(description), variant: variant,
                  showsSubheader: showsSubheader, showsIcon: showsIcon,
                  isSkeletonAnimating: isSkeletonAnimating)
    }

    /// AttributedString retains links, language and inline text attributes.
    public init(title: AttributedString, subheader: AttributedString = AttributedString("Subheader"),
                description: AttributedString = AttributedString("Description"),
                variant: Variant = .subheaderLeading, showsSubheader: Bool = true,
                showsIcon: Bool = false, isSkeletonAnimating: Bool = true) {
        self.title = title
        self.subheader = subheader
        self.description = description
        self.variant = variant
        self.showsSubheader = showsSubheader
        self.showsIcon = showsIcon
        self.isSkeletonAnimating = isSkeletonAnimating
    }

    public func accessory<Content: View>(alignment: AccessoryAlignment = .firstLineCenter,
                                         reflowsAtAX1: Bool = false,
                                         @ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.accessoryContent = AnyView(content())
        copy.accessoryAlignment = alignment
        copy.reflowsAccessoryAtAX1 = reflowsAtAX1
        return copy
    }

    public func textStyles(title: TextStyle = TextStyle(), subheader: TextStyle = TextStyle(),
                           description: TextStyle = TextStyle()) -> Self {
        var copy = self
        copy.titleStyle = title
        copy.subheaderStyle = subheader
        copy.descriptionStyle = description
        return copy
    }

    public func contentInsets(_ insets: EdgeInsets) -> Self {
        var copy = self
        copy.insets = insets
        return copy
    }

    /// Supply text composition for inline symbols, sensitive text or other spec slots.
    /// Custom content owns its semantics and typography; skeleton still replaces it.
    public func titleContent<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.titleContent = AnyView(content())
        copy.inlineTitle = nil
        return copy
    }

    public func secondaryContent<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.secondaryContent = AnyView(content())
        copy.inlineSecondary = nil
        return copy
    }

    /// Native text composition keeps an inline image in the text flow, including
    /// wraps and fades, while inheriting the Header's exact typography.
    public func titleInlineText(_ text: Text) -> Self {
        var copy = self
        copy.inlineTitle = text
        copy.titleContent = nil
        return copy
    }

    public func secondaryInlineText(_ text: Text) -> Self {
        var copy = self
        copy.inlineSecondary = text
        copy.secondaryContent = nil
        return copy
    }

    public func textSlotAlignments(title: AccessoryAlignment = .center,
                                   secondary: AccessoryAlignment = .center) -> Self {
        var copy = self
        copy.titleSlotAlignment = title
        copy.secondarySlotAlignment = secondary
        return copy
    }

    public func titleLeading<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.titlePrefix = AnyView(content())
        return copy
    }

    public func titleTrailing<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.titleSuffix = AnyView(content())
        return copy
    }

    public func secondaryLeading<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.secondaryPrefix = AnyView(content())
        return copy
    }

    public func secondaryTrailing<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.secondarySuffix = AnyView(content())
        return copy
    }

    public var figmaNodeID: String { variant.figmaNodeID }

    private var alignment: Alignment { variant.isCentered ? .center : .leading }
    private var stackAlignment: HorizontalAlignment { variant.isCentered ? .center : .leading }
    private var hasAccessory: Bool { accessoryContent != nil || showsIcon }
    private var shouldReflow: Bool { reflowsAccessoryAtAX1 && dynamicTypeSize >= .accessibility1 }

    public var body: some View {
        VStack(alignment: stackAlignment, spacing: TUISpacing.x4) {
            if hasAccessory && shouldReflow {
                VStack(alignment: stackAlignment, spacing: TUISpacing.x2) {
                    VStack(alignment: stackAlignment, spacing: TUISpacing.x4) {
                        heading
                        if variant.showsDescription { secondary(isDescription: true) }
                    }
                    accessoryView
                }
                .frame(maxWidth: .infinity, alignment: alignment)
            } else {
                // Legacy subheader HeaderCont has gap 0; description and custom
                // mobile accessories use 16. Hidden accessories reserve no space.
                HStack(alignment: accessoryAlignment.vertical,
                       spacing: variant.showsDescription || accessoryContent != nil ? TUISpacing.x4 : TUISpacing.x0) {
                    heading
                    if hasAccessory { accessoryView }
                }
                if variant.showsDescription { secondary(isDescription: true) }
            }
        }
        .padding(insets)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }

    private var heading: some View {
        let firstLineCenter = titleMetrics.lineHeight / 2
        let firstBaseline = titleMetrics.firstBaseline
        return VStack(alignment: stackAlignment, spacing: TUISpacing.x4) {
            titleRow
            if !variant.showsDescription && showsSubheader { secondary(isDescription: false) }
        }
        .frame(maxWidth: .infinity, alignment: alignment)
        .alignmentGuide(.tuiHeaderFirstLineCenter) { dimensions in
            dimensions[.firstTextBaseline] - firstBaseline + firstLineCenter
        }
        .accessibilityElement(children: .combine)
        .contentShape(.accessibility, Rectangle())
        .accessibilityAddTraits(variant.isSkeleton ? [] : .isHeader)
        .accessibilityHidden(variant.isSkeleton)
    }

    @ViewBuilder private var titleRow: some View {
        if variant.isSkeleton {
            TUISkeletonText(textStyle: .headingLarge, width: 130, isAnimating: isSkeletonAnimating)
                .frame(maxWidth: .infinity, alignment: alignment)
        } else {
            textRow(title, style: titleStyle, metrics: titleMetrics, custom: titleContent,
                    inline: inlineTitle, prefix: titlePrefix, suffix: titleSuffix,
                    slotAlignment: titleSlotAlignment)
        }
    }

    @ViewBuilder private func secondary(isDescription: Bool) -> some View {
        if variant.isSkeleton {
            let textStyle: TUISkeletonText.TextStyle = isDescription && variant.isCentered ? .bodyLarge : .bodyMedium
            TUISkeletonText(textStyle: textStyle,
                            width: isDescription || variant.isCentered ? 185 : 130,
                            isAnimating: isSkeletonAnimating)
                .frame(height: isDescription ? 20 : 18)
                .frame(maxWidth: .infinity, alignment: alignment)
                .accessibilityHidden(true)
        } else {
            textRow(isDescription ? description : subheader,
                    style: isDescription ? descriptionStyle : subheaderStyle,
                    metrics: secondaryMetrics(isDescription: isDescription), custom: secondaryContent,
                    inline: inlineSecondary, prefix: secondaryPrefix, suffix: secondarySuffix,
                    slotAlignment: secondarySlotAlignment)
        }
    }

    @ViewBuilder private var accessoryView: some View {
        if let accessoryContent {
            accessoryContent
                .fixedSize(horizontal: true, vertical: true)
        } else {
            Circle()
                .fill(TUIColor.named("Background/Accent 2"))
                .overlay {
                    Image("tui-header-large-star", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                        .padding(7.2) // Source avatar: 20% inset in a 36 pt circle.
                }
                .frame(width: 36, height: 36)
                .accessibilityHidden(true)
        }
    }

    private func textRow(_ value: AttributedString, style: TextStyle, metrics: TUIHeaderFontMetrics,
                         custom: AnyView?, inline: Text?, prefix: AnyView?, suffix: AnyView?,
                         slotAlignment: AccessoryAlignment) -> some View {
        let placeholder = AnyView(Circle().fill(TUIColor.named("Background/Neutral 1 On Light"))
            .frame(width: TUISpacing.x4, height: TUISpacing.x4).accessibilityHidden(true))
        let leading = prefix ?? (variant.isExtended ? placeholder : nil)
        let trailing = suffix ?? (variant.isExtended ? placeholder : nil)
        return TUIHeaderInlineLayout(gap: 10, fillsLabel: suffix == nil,
                                    centered: variant.isCentered, firstLineHeight: metrics.lineHeight,
                                    slotAlignment: slotAlignment) {
            if let leading { leading.layoutValue(key: TUIHeaderInlineRole.self, value: .prefix) }
            Group {
                if let custom { custom }
                else {
                    TUIHeaderText(value: value, metrics: metrics, color: style.color ?? metrics.color,
                                  tracking: style.tracking ?? metrics.tracking, overflow: style.overflow,
                                  centered: variant.isCentered, inlineText: inline)
                        .textCase(style.role?.isUppercase == true ? .uppercase : nil)
                }
            }
            .layoutValue(key: TUIHeaderInlineRole.self, value: .label)
            if let trailing { trailing.layoutValue(key: TUIHeaderInlineRole.self, value: .suffix) }
        }
    }

    private var titleMetrics: TUIHeaderFontMetrics {
        .make(style: titleStyle, title: true, description: false, size: dynamicTypeSize)
    }

    private func secondaryMetrics(isDescription: Bool) -> TUIHeaderFontMetrics {
        .make(style: isDescription ? descriptionStyle : subheaderStyle,
              title: false, description: isDescription, size: dynamicTypeSize)
    }
}

struct TUIHeaderFontMetrics {
    let font: UIFont
    let lineHeight: CGFloat
    let firstBaseline: CGFloat
    let tracking: CGFloat
    let color: Color

    static func make(style: TUIHeaderLarge.TextStyle, title: Bool, description: Bool,
                     size: DynamicTypeSize) -> Self {
        let category: UIContentSizeCategory
        switch min(size, .accessibility1) {
        case .xSmall: category = .extraSmall
        case .small: category = .small
        case .medium: category = .medium
        case .large: category = .large
        case .xLarge: category = .extraLarge
        case .xxLarge: category = .extraExtraLarge
        case .xxxLarge: category = .extraExtraExtraLarge
        default: category = .accessibilityMedium
        }
        let base: UIFont
        let tracking: CGFloat
        let baseHeight: CGFloat
        if let supplied = style.font {
            base = supplied
            tracking = 0
            baseHeight = style.lineHeight ?? supplied.lineHeight.rounded()
        } else if let role = style.role {
            let metrics = role.metrics
            base = metrics.nativeFont(at: metrics.size)
            tracking = 0
            baseHeight = style.lineHeight ?? metrics.lineHeight
        } else {
            // Legacy styles differ from current Foundation heading/body roles.
            base = title ? TUIFigmaTextFont.displayBold(size: 30)
                : TUIFigmaTextFont.regular(size: description ? 17 : 15)
            tracking = title ? 0.36 : description ? -0.41 : -0.24
            baseHeight = style.lineHeight ?? (title ? 36 : description ? 20 : 18)
        }
        let scaled = UIFontMetrics(forTextStyle: style.role?.textStyle.uiKitTextStyle ?? (title ? .title1 : description ? .body : .subheadline))
            .scaledFont(for: base, compatibleWith: UITraitCollection(preferredContentSizeCategory: category))
        let scale = scaled.pointSize / base.pointSize
        let lineHeight = (baseHeight * scale).rounded()
        // Outlined source: title baseline 29 inside 36, Body L 16 inside 20.
        // Figma legacy AUTO rounds ascent, rather than centering fractional leading.
        let baseline = style.role == nil && style.lineHeight == nil ? scaled.ascender.rounded()
            : (lineHeight - scaled.lineHeight) / 2 + scaled.ascender
        return Self(font: scaled, lineHeight: lineHeight, firstBaseline: baseline, tracking: style.tracking ?? tracking,
                    color: title || description ? TUIColor.textPrimary : TUIColor.textSecondary)
    }
}

struct TUIHeaderText: View {
    let value: AttributedString
    let metrics: TUIHeaderFontMetrics
    let color: Color
    let tracking: CGFloat
    let overflow: TUIHeaderLarge.TextOverflow
    let centered: Bool
    var inlineText: Text? = nil
    var usesIntrinsicWidth: Bool = false
    var masksSensitiveText: Bool = false
    @Environment(\.openURL) private var openURL
    @State private var linkHitMap = TUIHeaderLinkHitMap()

    private var knownLinks: [TUIHeaderTextLink] { inlineText == nil ? value.tuiHeaderLinks : [] }

    private var styledText: some View {
        (inlineText ?? (knownLinks.isEmpty ? Text(value) : value.tuiHeaderAnnotatedText))
            .font(Font(metrics.font))
            // Figma letter-spacing maps to the Core Text kern advance.
            .kerning(tracking)
            .foregroundStyle(color)
            .multilineTextAlignment(centered ? .center : .leading)
            .lineSpacing(metrics.lineHeight - metrics.font.lineHeight)
    }

    @ViewBuilder private var text: some View {
        if masksSensitiveText { styledText.textRenderer(TUISensitiveTextRenderer()) }
        else { styledText }
    }

    private var multilineText: some View {
        TUIHeaderTextLayout(fontLineHeight: metrics.font.lineHeight, lineHeight: metrics.lineHeight,
                            firstBaseline: metrics.firstBaseline, centered: centered) {
            text.fixedSize(horizontal: false, vertical: true)
        }
    }

    private var fade: some View {
        LinearGradient(stops: [.init(color: .white, location: 0),
                               .init(color: .white, location: 0.85065),
                               .init(color: .clear, location: 1)],
                       startPoint: .leading, endPoint: .trailing)
    }

    private func limitedMultiline(_ lineLimit: Int) -> some View {
        precondition(lineLimit > 0, "Header multiline fade needs a positive lineLimit")
        return ViewThatFits(in: .vertical) {
            multilineText.fixedSize(horizontal: false, vertical: true)
            TUIHeaderTextLayout(fontLineHeight: metrics.font.lineHeight, lineHeight: metrics.lineHeight,
                                firstBaseline: metrics.firstBaseline, centered: centered,
                                maximumLines: lineLimit) {
                text.textRenderer(TUIHeaderFadeTextRenderer(lineLimit: lineLimit,
                    firstBaseline: metrics.firstBaseline, lineHeight: metrics.lineHeight,
                    centered: centered, linkHitMap: knownLinks.isEmpty ? nil : linkHitMap))
                    .fixedSize(horizontal: false, vertical: true)
                    .allowsHitTesting(knownLinks.isEmpty)
                    .accessibilityHidden(!knownLinks.isEmpty)
            }
            .clipped()
            .mask {
                VStack(spacing: 0) {
                    if lineLimit > 1 { Color.white.frame(height: metrics.lineHeight * CGFloat(lineLimit - 1)) }
                    fade.frame(height: metrics.lineHeight)
                }
            }
            .overlay {
                if !knownLinks.isEmpty {
                    Color.clear.contentShape(Rectangle())
                        .gesture(SpatialTapGesture().onEnded { event in
                            if let url = linkHitMap.url(at: event.location) { openURL(url) }
                        })
                        .accessibilityHidden(true)
                }
            }
        }
        .frame(maxHeight: metrics.lineHeight * CGFloat(lineLimit))
        .contentShape(.accessibility, Rectangle())
    }

    var body: some View {
        Group {
            switch overflow {
            case .multiline:
                multilineText
            case .multilineFade(let lineLimit):
                limitedMultiline(lineLimit)
            case .singleLineFade:
                TUIHeaderSingleLineIntrinsicLayout(enabled: usesIntrinsicWidth) {
                    text.fixedSize().hidden().accessibilityHidden(true)
                    ViewThatFits(in: .horizontal) {
                        TUIHeaderTextLayout(fontLineHeight: metrics.font.lineHeight, lineHeight: metrics.lineHeight,
                                            firstBaseline: metrics.firstBaseline, centered: centered) { text.fixedSize() }
                            .fixedSize()
                        GeometryReader { proxy in
                            TUIHeaderTextLayout(fontLineHeight: metrics.font.lineHeight, lineHeight: metrics.lineHeight,
                                                firstBaseline: metrics.firstBaseline, centered: centered) { text.fixedSize() }
                                .frame(width: proxy.size.width, height: metrics.lineHeight)
                                .clipped()
                                .mask(fade)
                        }
                        .frame(height: metrics.lineHeight)
                        .contentShape(.accessibility, Rectangle())
                    }
                }
            }
        }
        .modifier(TUIHeaderLinkedTextAccessibility(links: knownLinks, label: String(value.characters)))
    }
}

/// ViewThatFits' GeometryReader fallback has no intrinsic width. Measure the
/// native label first so content-sized controls only fade after a constraint.
private struct TUIHeaderSingleLineIntrinsicLayout: Layout {
    let enabled: Bool

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard enabled else { return subviews[1].sizeThatFits(proposal) }
        let natural = subviews[0].sizeThatFits(.unspecified)
        let width = min(proposal.width ?? natural.width.rounded(.up), natural.width.rounded(.up))
        let size = subviews[1].sizeThatFits(ProposedViewSize(width: width, height: proposal.height))
        return CGSize(width: width, height: size.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews[1].place(at: bounds.origin, proposal: ProposedViewSize(bounds.size))
    }
}

/// Continue soft-wrapped native glyphs along the last visible baseline. Native
/// lineLimit would reserve space for an ellipsis, unlike Figma's continuous fade.
/// CharacterIndex restarts for an explicit paragraph in the iOS 26 text layout;
/// do not carry a new paragraph into the visible line.
private struct TUIHeaderFadeTextRenderer: TextRenderer {
    let lineLimit: Int
    let firstBaseline: CGFloat
    let lineHeight: CGFloat
    let centered: Bool
    let linkHitMap: TUIHeaderLinkHitMap?

    func sizeThatFits(proposal: ProposedViewSize, text: TextProxy) -> CGSize {
        let size = text.sizeThatFits(proposal)
        linkHitMap?.measure(proposal: proposal, size: size)
        return size
    }

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        var regions: [TUIHeaderLinkHitMap.Region] = []
        func record(_ line: Text.Layout.Line, dx: CGFloat = 0, dy: CGFloat = 0) {
            for run in line {
                if let link = run[TUIHeaderInlineLinkAttribute.self] {
                    regions.append(.init(rect: run.typographicBounds.rect.offsetBy(dx: dx, dy: dy), url: link.url))
                }
            }
        }
        defer {
            linkHitMap?.update(regions, baselineOffset: firstBaseline - (layout.first?.origin.y ?? firstBaseline),
                               centered: centered, height: lineHeight * CGFloat(lineLimit))
        }
        guard layout.count > lineLimit else {
            for line in layout { context.draw(line); record(line) }
            return
        }
        for index in 0..<lineLimit { context.draw(layout[index]); record(layout[index]) }
        let last = layout[lineLimit - 1]
        var previousIndex = last.flatMap { $0.characterIndices }.max()
        var x = last.origin.x + last.typographicBounds.width
        let baseline = last.origin.y
        let visibleEnvelope = layout.map { $0.typographicBounds.rect.maxX }.max() ?? x
        for index in lineLimit..<layout.count {
            let line = layout[index]
            guard let previousCharacter = previousIndex,
                  let firstIndex = line.flatMap({ $0.characterIndices }).min(),
                  firstIndex > previousCharacter else { break }
            var continuation = context
            continuation.translateBy(x: x - line.origin.x, y: baseline - line.origin.y)
            continuation.draw(line)
            record(line, dx: x - line.origin.x, dy: baseline - line.origin.y)
            x += line.typographicBounds.width
            previousIndex = line.flatMap { $0.characterIndices }.max()
            if x >= visibleEnvelope { break }
        }
    }

}

/// Snap legacy AUTO text line boxes, retaining the native Text baseline and links.
private struct TUIHeaderTextLayout: Layout {
    let fontLineHeight: CGFloat
    let lineHeight: CGFloat
    let firstBaseline: CGFloat
    let centered: Bool
    var maximumLines: Int? = nil

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = subviews[0].sizeThatFits(ProposedViewSize(width: proposal.width, height: nil))
        let lines = max(1, ((size.height - fontLineHeight) / max(1, lineHeight)).rounded() + 1)
        let visibleLines = maximumLines.map { min(lines, CGFloat($0)) } ?? lines
        return CGSize(width: proposal.width ?? size.width, height: visibleLines * lineHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let dimensions = subviews[0].dimensions(in: ProposedViewSize(width: bounds.width, height: nil))
        subviews[0].place(at: CGPoint(x: bounds.minX + (centered ? (bounds.width - dimensions.width) / 2 : 0),
                                     y: bounds.minY + firstBaseline - dimensions[.firstTextBaseline]),
                          proposal: ProposedViewSize(width: bounds.width, height: nil))
    }

    func explicitAlignment(of guide: VerticalAlignment, in bounds: CGRect,
                           proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGFloat? {
        guard guide == .firstTextBaseline else { return nil }
        return firstBaseline
    }
}

enum TUIHeaderInlineItem { case label, prefix, suffix }
struct TUIHeaderInlineRole: LayoutValueKey { static let defaultValue = TUIHeaderInlineItem.label }

/// A suffix hugs a short label and stays visible at the trailing edge on overflow.
/// Default extended slots use Figma's fill-width label geometry instead.
struct TUIHeaderInlineLayout: Layout {
    let gap: CGFloat
    let fillsLabel: Bool
    let centered: Bool
    let firstLineHeight: CGFloat
    let slotAlignment: TUIHeaderLarge.AccessoryAlignment

    private func anchors(_ subviews: Subviews, measured: [CGSize]) -> [CGFloat] {
        subviews.enumerated().map { index, view in
            switch slotAlignment {
            case .top: 0
            case .center: measured[index].height / 2
            case .bottom: measured[index].height
            case .firstLineCenter:
                view[TUIHeaderInlineRole.self] == .label ? firstLineHeight / 2 : measured[index].height / 2
            case .firstBaseline:
                view.dimensions(in: ProposedViewSize(measured[index]))[.firstTextBaseline]
            }
        }
    }

    private func sizes(_ subviews: Subviews, width: CGFloat?) -> [CGSize] {
        let reserved = subviews.filter { $0[TUIHeaderInlineRole.self] != .label }
            .reduce(CGFloat(0)) { $0 + $1.sizeThatFits(.unspecified).width }
            + CGFloat(max(0, subviews.count - 1)) * gap
        return subviews.map { view in
            if view[TUIHeaderInlineRole.self] != .label { return view.sizeThatFits(.unspecified) }
            let intrinsic = view.sizeThatFits(.unspecified)
            let available = width.map { max(0, $0 - reserved) }
            return view.sizeThatFits(ProposedViewSize(width: fillsLabel ? available
                : available.map { min(intrinsic.width, $0) }, height: nil))
        }
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let measured = sizes(subviews, width: proposal.width)
        let alignmentAnchors = anchors(subviews, measured: measured)
        let above = alignmentAnchors.max() ?? 0
        let below = measured.enumerated().map { $0.element.height - alignmentAnchors[$0.offset] }.max() ?? 0
        return CGSize(width: proposal.width ?? measured.reduce(0) { $0 + $1.width }
                      + CGFloat(max(0, subviews.count - 1)) * gap,
                      height: above + below)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let measured = sizes(subviews, width: bounds.width)
        let alignmentAnchors = anchors(subviews, measured: measured)
        let above = alignmentAnchors.max() ?? 0
        let total = measured.reduce(0) { $0 + $1.width } + CGFloat(max(0, subviews.count - 1)) * gap
        var x = bounds.minX + (centered ? (bounds.width - total) / 2 : 0)
        for (index, view) in subviews.enumerated() {
            let size = measured[index]
            let y = bounds.minY + above - alignmentAnchors[index]
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + gap
        }
    }

    func explicitAlignment(of guide: VerticalAlignment, in bounds: CGRect,
                           proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGFloat? {
        guard guide == .firstTextBaseline, let label = subviews.first(where: { $0[TUIHeaderInlineRole.self] == .label })
        else { return nil }
        let measured = sizes(subviews, width: bounds.width)
        let index = subviews.firstIndex(where: { $0[TUIHeaderInlineRole.self] == .label })!
        let alignmentAnchors = anchors(subviews, measured: measured)
        return (alignmentAnchors.max() ?? 0) - alignmentAnchors[index]
            + label.dimensions(in: ProposedViewSize(measured[index]))[guide]
    }
}

private enum TUIHeaderFirstLineCenter: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat { context.height / 2 }
}
extension VerticalAlignment {
    static let tuiHeaderFirstLineCenter = VerticalAlignment(TUIHeaderFirstLineCenter.self)
}
