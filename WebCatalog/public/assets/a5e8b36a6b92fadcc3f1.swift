import SwiftUI
import UIKit

/// Static cell content. The caller owns navigation and selection. Keep the hint
/// independent: never put a cell with its hint button inside another Button.
public struct TUICell: View {
    public enum Kind: String, CaseIterable, Sendable { case compact = "Compact", `default` = "Default", extended = "Extended" }
    public enum RightSide: String, CaseIterable, Sendable { case none = "None", text = "Text", accessory = "Accessory" }
    public enum Variant: String, CaseIterable, Sendable {
        case extendedAccessory = "126659:29407"
        case defaultText = "41569:290556", defaultNone = "41569:290638", defaultAccessory = "41569:291331"
        case defaultFlexibleText = "41637:305481", defaultFlexibleNone = "41637:305513"
        case defaultFlexibleAccessory = "41637:305526"
        case extendedText = "41637:308600", extendedNone = "41637:308632"
        case compactText = "53164:295268", compactNone = "53164:295382"
        case compactFlexibleNone = "53164:295412", compactAccessory = "53164:295425"
        case compactFlexibleAccessory = "53164:295442", compactFlexibleText = "53352:314657"
        case defaultSkeletonText = "55900:294996", defaultSkeletonNone = "55900:295013"
        case defaultSkeletonAccessory = "55900:295026"
        case compactSkeletonText = "55902:294308", compactSkeletonNone = "55902:294315"
        case compactSkeletonAccessory = "55902:294320"

        public var figmaNodeID: String { rawValue }
        public var kind: Kind {
            switch self {
            case .extendedAccessory, .extendedText, .extendedNone: .extended
            case .compactText, .compactNone, .compactFlexibleNone, .compactAccessory,
                 .compactFlexibleAccessory, .compactFlexibleText, .compactSkeletonText,
                 .compactSkeletonNone, .compactSkeletonAccessory: .compact
            default: .default
            }
        }
        public var rightSide: RightSide {
            switch self {
            case .defaultText, .defaultFlexibleText, .extendedText, .compactText,
                 .compactFlexibleText, .defaultSkeletonText, .compactSkeletonText: .text
            case .extendedAccessory, .defaultAccessory, .defaultFlexibleAccessory,
                 .compactAccessory, .compactFlexibleAccessory, .defaultSkeletonAccessory,
                 .compactSkeletonAccessory: .accessory
            default: .none
            }
        }
        public var isSkeleton: Bool {
            [.defaultSkeletonText, .defaultSkeletonNone, .defaultSkeletonAccessory,
             .compactSkeletonText, .compactSkeletonNone, .compactSkeletonAccessory].contains(self)
        }
        public var fixedHeight: Bool {
            ![.defaultFlexibleText, .defaultFlexibleNone, .defaultFlexibleAccessory,
              .compactFlexibleNone, .compactFlexibleAccessory, .compactFlexibleText].contains(self)
        }
        public var minimumHeight: CGFloat {
            kind == .compact && (!fixedHeight || isSkeleton) ? TUISpacing.x12 : TUIControlSize.large
        }
        public var figmaProperties: [String: String] {
            ["system": "iOS", "fixed-height": fixedHeight ? "on" : "off", "right-side": rightSide.rawValue,
             "type": kind.rawValue, "skeleton": isSkeleton ? "on" : "off"]
        }
    }

    public enum Field: Hashable, Sendable { case caption, title, description, value, valueDescription }
    public enum InlinePlacement: Sendable { case leading, trailing }
    public enum TextPriority: String, CaseIterable, Sendable { case left, right }
    public typealias TextStyle = TUIHeaderLarge.TextStyle
    public static let figmaComponentSetID = "41569:290555"
    public let variant: Variant
    public var title: String
    public var description: String
    public var caption: String
    public var value: String
    public var valueDescription: String
    public var showsAvatar: Bool
    public var showsCaption: Bool
    public var showsDescription: Bool
    public var showsBadge: Bool
    public var showsHint: Bool
    public var badgeCount: Int
    public var isSkeletonAnimating: Bool
    /// Source defaults: paired text stacks at AX1; accessories stay alongside.
    public var reflowsTextAtAX1 = true
    public var reflowsAccessoryAtAX1 = false
    public var removesLineLimitsAtAX1 = true
    public var textPriority: TextPriority = .right
    private var minimumTextFraction: CGFloat = 0.3
    private var customAvatar: AnyView?
    private var customAccessory: AnyView?
    private var leadingContent: [Field: AnyView] = [:]
    private var trailingContent: [Field: AnyView] = [:]
    private var textStyles: [Field: TextStyle] = [:]
    private let hintAction: (() -> Void)?
    private let hintLabel: String
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(_ title: String = "Title", description: String = "Description", caption: String = "Caption",
                value: String = "Value", valueDescription: String = "Description", variant: Variant = .defaultNone,
                showsAvatar: Bool = true, showsCaption: Bool = false, showsDescription: Bool = true,
                showsBadge: Bool = true, showsHint: Bool = true, badgeCount: Int = 1,
                hintLabel: String = "Подробнее", hintAction: (() -> Void)? = nil,
                isSkeletonAnimating: Bool = true) {
        precondition(variant.rightSide != .accessory || variant.isSkeleton || !showsHint || hintAction != nil,
                     "A visible hint requires the consumer's hintAction")
        self.title = title; self.description = description; self.caption = caption
        self.value = value; self.valueDescription = valueDescription; self.variant = variant
        self.showsAvatar = showsAvatar; self.showsCaption = showsCaption; self.showsDescription = showsDescription
        self.showsBadge = showsBadge; self.showsHint = showsHint; self.badgeCount = badgeCount
        self.hintAction = hintAction; self.hintLabel = hintLabel; self.isSkeletonAnimating = isSkeletonAnimating
    }

    public func avatar<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self; copy.customAvatar = AnyView(content()); return copy
    }
    public func accessory<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self; copy.customAccessory = AnyView(content()); return copy
    }
    /// Extended is an editor optimization. Code slots are available in every variant.
    public func inlineContent<Content: View>(_ field: Field, placement: InlinePlacement,
                                            @ViewBuilder content: () -> Content) -> Self {
        var copy = self
        if placement == .leading { copy.leadingContent[field] = AnyView(content()) }
        else { copy.trailingContent[field] = AnyView(content()) }
        return copy
    }

    /// Overrides typography and overflow of one field without replacing its semantics.
    public func textStyle(_ style: TextStyle, for field: Field) -> Self {
        if case .multilineFade(let limit) = style.overflow {
            precondition(limit > 0, "Cell line limits must be positive")
        }
        var copy = self; copy.textStyles[field] = style; return copy
    }

    /// Protects the non-prioritized text against truncation below this fraction
    /// of the complete cell width, including its avatar and horizontal insets.
    public func minimumTextWidthFraction(_ fraction: CGFloat) -> Self {
        precondition(fraction.isFinite && (0...1).contains(fraction), "Cell width fractions must be between zero and one")
        var copy = self; copy.minimumTextFraction = fraction; return copy
    }

    private var compact: Bool { variant.kind == .compact }
    private var releasesLineLimits: Bool { removesLineLimitsAtAX1 && typeSize >= .accessibility1 }
    private var limited: Bool { variant.fixedHeight && !releasesLineLimits }
    private var reflowsText: Bool { reflowsTextAtAX1 && typeSize >= .accessibility1 && variant.rightSide == .text && !variant.isSkeleton }
    private var reflowsAccessory: Bool { reflowsAccessoryAtAX1 && typeSize >= .accessibility1 && variant.rightSide == .accessory && !variant.isSkeleton }
    private var verticalPadding: CGFloat {
        compact && variant.minimumHeight == TUISpacing.x12 ? TUISpacing.x1 : TUISpacing.x2
    }
    private var animation: Animation? {
        reduceMotion ? nil : TUIMotionCurve.productiveStandard.animation(duration: .fast)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x2) {
            if variant.rightSide == .text && !variant.isSkeleton && !reflowsText {
                pairedTextContent
            } else { contentRow }
            if reflowsAccessory {
                accessories.frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, verticalPadding)
            }
        }
        .padding(.horizontal, TUISpacing.x4)
        .frame(maxWidth: .infinity, minHeight: variant.minimumHeight, alignment: .topLeading)
        .contentShape(Rectangle())
        .accessibilityElement(children: .contain)
        .accessibilityHidden(variant.isSkeleton)
        .accessibilityIdentifier("tuiCell-\(variant.figmaNodeID)")
        .animation(animation, value: showsCaption)
        .animation(animation, value: showsDescription)
        .animation(animation, value: showsAvatar)
        .animation(animation, value: showsHint)
    }

    private var pairedTextContent: some View {
        TUICellTextLayout(priority: textPriority, minimumFraction: minimumTextFraction,
                          minimumHeight: variant.minimumHeight, verticalPadding: verticalPadding,
                          rowSpacing: compact ? 0 : TUISpacing.x1) {
            if !compact && showsAvatar {
                avatarContent.accessibilityHidden(true)
                    .layoutValue(key: TUICellTextSlot.self, value: .avatar)
            }
            if !compact && showsCaption {
                inlineRow(.caption, text: caption, primary: false, skeletonWidth: 80, fillsWidth: true)
                    .layoutValue(key: TUICellTextSlot.self, value: .caption)
            }
            inlineRow(.title, text: title, primary: true, skeletonWidth: 160, fillsWidth: true)
                .layoutValue(key: TUICellTextSlot.self, value: .title)
            inlineRow(.value, text: value, primary: true, skeletonWidth: 44, fillsWidth: false)
                .layoutValue(key: TUICellTextSlot.self, value: .value)
            if !compact && showsDescription {
                inlineRow(.description, text: description, primary: false, skeletonWidth: 96, fillsWidth: true)
                    .layoutValue(key: TUICellTextSlot.self, value: .description)
                inlineRow(.valueDescription, text: valueDescription, primary: false, skeletonWidth: 64, fillsWidth: false)
                    .layoutValue(key: TUICellTextSlot.self, value: .valueDescription)
            }
        }
        .clipped()
        .accessibilityElement(children: .combine)
    }

    private var contentRow: some View {
        HStack(alignment: .top, spacing: TUISpacing.x4) {
            if !compact && showsAvatar {
                avatarContent.padding(.vertical, TUISpacing.x2).accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: compact && !reflowsText ? 0 : TUISpacing.x1) {
                if !compact && showsCaption { row(.caption, text: caption, value: nil, primary: false, width: variant.rightSide == .text ? 80 : 96) }
                row(.title, text: title, value: variant.rightSide == .text && !reflowsText ? value : nil, primary: true, width: 160)
                if !compact && showsDescription {
                    row(.description, text: description, value: variant.rightSide == .text && !reflowsText ? valueDescription : nil, primary: false, width: 96)
                }
                if reflowsText {
                    VStack(alignment: .leading, spacing: compact ? 0 : TUISpacing.x1) {
                        inlineRow(.value, text: value, primary: true, skeletonWidth: 44, fillsWidth: true)
                        if !compact && showsDescription {
                            inlineRow(.valueDescription, text: valueDescription, primary: false, skeletonWidth: 64, fillsWidth: true)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: variant.minimumHeight - 2 * verticalPadding, alignment: .leading)
            .padding(.top, verticalPadding)
            .padding(.bottom, reflowsAccessory ? 0 : verticalPadding)
            .accessibilityElement(children: .combine)
            if variant.rightSide == .accessory && !variant.isSkeleton && !reflowsAccessory {
                accessories.padding(.vertical, verticalPadding)
            }
        }
    }

    @ViewBuilder private var avatarContent: some View {
        if variant.isSkeleton {
            TUISkeleton(width: TUISpacing.x10, height: TUISpacing.x10, isAnimating: isSkeletonAnimating)
                .clipShape(Circle())
        } else if let customAvatar { customAvatar }
        else {
            Circle().fill(TUIColor.named("Background/Accent 2"))
                .overlay { TUIColor.named("Text/Primary On Dark").mask(TUIOriginalSVGMask(resource: "tui-header-card-star"))
                    .frame(width: TUISpacing.x6, height: TUISpacing.x6) }
                .frame(width: TUISpacing.x10, height: TUISpacing.x10)
        }
    }

    private var accessories: some View {
        HStack(spacing: TUISpacing.x4) {
            if let customAccessory { customAccessory }
            else {
                if showsBadge {
                    TUINotificationBadge(String(badgeCount), size: .large)
                        .accessibilityElement(children: .ignore).accessibilityHidden(false)
                        .accessibilityLabel("Уведомлений: \(badgeCount)")
                }
                if showsHint, let hintAction {
                    Button(action: hintAction) {
                        Circle().fill(TUIColor.named("Background/Neutral 1"))
                            .overlay { TUIColor.textSecondary.mask(TUIOriginalSVGMask(resource: "tui-header-card-tooltip"))
                                .frame(width: TUISpacing.x3, height: TUISpacing.x3) }
                            .frame(width: 22, height: 22)
                    }
                    .buttonStyle(.plain).accessibilityLabel(hintLabel)
                    .accessibilityIdentifier("tuiCellHint")
                }
            }
        }
        .frame(minHeight: reflowsAccessory ? 0 : variant.minimumHeight - 2 * verticalPadding)
        .fixedSize(horizontal: true, vertical: true)
    }

    private func row(_ field: Field, text: String, value: String?, primary: Bool, width: CGFloat) -> some View {
        HStack(alignment: .top, spacing: TUISpacing.x2) {
            inlineRow(field, text: text, primary: primary, skeletonWidth: width, fillsWidth: true)
            if let value {
                inlineRow(field == .title ? .value : .valueDescription, text: value, primary: primary,
                          skeletonWidth: primary ? (compact ? 47 : 44) : 64, fillsWidth: false)
                    .fixedSize(horizontal: true, vertical: true)
            }
        }
        .clipped()
    }

    @ViewBuilder private func inlineRow(_ field: Field, text: String, primary: Bool,
                                        skeletonWidth: CGFloat, fillsWidth: Bool) -> some View {
        if variant.isSkeleton {
            TUISkeletonText(textStyle: primary ? .bodyLarge : .uiSmall,
                            width: skeletonWidth, isAnimating: isSkeletonAnimating)
                .frame(maxWidth: fillsWidth ? .infinity : nil, alignment: .leading)
        } else {
            TUIHeaderInlineLayout(gap: TUISpacing.x1, fillsLabel: fillsWidth,
                centered: false, firstLineHeight: primary ? 20 : 16, slotAlignment: .center) {
                if let content = leadingContent[field] {
                    content.layoutValue(key: TUIHeaderInlineRole.self, value: .prefix)
                }
                label(text, primary: primary, field: field)
                    .layoutValue(key: TUIHeaderInlineRole.self, value: .label)
                if let content = trailingContent[field] {
                    content.layoutValue(key: TUIHeaderInlineRole.self, value: .suffix)
                }
            }
            .frame(maxWidth: fillsWidth ? .infinity : nil, alignment: .leading)
        }
    }

    private func label(_ text: String, primary: Bool, field: Field) -> some View {
        let style = textStyles[field]
        let role: TUITypographyRole = primary ? .bodyLarge : .uiSmall
        let base: UIFont
        if let supplied = style?.font { base = supplied }
        else if let metrics = style?.role?.metrics {
            base = metrics.nativeFont(at: metrics.size)
        } else { base = TUIFigmaTextFont.regular(size: role.metrics.size) }
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
        let font = UIFontMetrics(forTextStyle: style?.role?.textStyle.uiKitTextStyle ?? (primary ? .body : .footnote))
            .scaledFont(for: base, compatibleWith: UITraitCollection(preferredContentSizeCategory: category))
        let height = (style?.lineHeight ?? style?.role?.metrics.lineHeight ?? (primary ? 20.0 : 16.0)) * font.pointSize / base.pointSize
        let tracking: CGFloat = style?.tracking ?? (style?.role != nil || style?.font != nil ? 0 : primary ? -0.41 : -0.08)
        let color = style?.color ?? (primary ? TUIColor.textPrimary : TUIColor.textSecondary)
        // The source UI S baseline is 13 inside its 16-point line box. Rounding
        // the legacy font's fractional ascender puts it one point too high.
        let customMetrics = style?.role != nil || style?.font != nil || style?.lineHeight != nil
        let baseline = customMetrics ? (height - font.lineHeight) / 2 + font.ascender
            : (primary ? 16.0 : 13.0) * font.pointSize / base.pointSize
        let metrics = TUIHeaderFontMetrics(font: font, lineHeight: height.rounded(),
            firstBaseline: baseline.rounded(), tracking: tracking, color: color)
        let fades = limited && field != .caption && variant.kind != .extended
        let overflow = releasesLineLimits ? TUIHeaderLarge.TextOverflow.multiline
            : style?.overflow ?? (fades ? .singleLineFade : .multiline)
        return TUIHeaderText(value: AttributedString(text), metrics: metrics, color: color, tracking: tracking,
            overflow: overflow, centered: false)
            .textCase(style?.role?.isUppercase == true ? .uppercase : nil)
            .id(text).transition(.opacity).animation(animation, value: text)
    }
}

private enum TUICellTextItem { case avatar, caption, title, value, description, valueDescription }
private struct TUICellTextSlot: LayoutValueKey { static let defaultValue = TUICellTextItem.title }

/// Measures the actual avatar and the full cell in one native layout pass.
/// Each text pair keeps its own natural widths, as in Figma's TitleCont and DescriptionCont.
private struct TUICellTextLayout: Layout {
    let priority: TUICell.TextPriority
    let minimumFraction: CGFloat
    let minimumHeight: CGFloat
    let verticalPadding: CGFloat
    let rowSpacing: CGFloat

    private func geometry(width proposedWidth: CGFloat?, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let natural = subviews.map { $0.sizeThatFits(.unspecified) }
        func index(_ role: TUICellTextItem) -> Int? { subviews.firstIndex { $0[TUICellTextSlot.self] == role } }
        let avatar = index(.avatar)
        let start = avatar.map { natural[$0].width + TUISpacing.x4 } ?? 0
        let pairs: [(TUICellTextItem, TUICellTextItem?)] = [(.caption, nil), (.title, .value), (.description, .valueDescription)]
        let intrinsic = pairs.compactMap { left, right -> CGFloat? in
            guard let a = index(left) else { return nil }
            return natural[a].width + (right.flatMap(index).map { natural[$0].width + TUISpacing.x2 } ?? 0)
        }.max() ?? 0
        let width = proposedWidth.flatMap { $0.isFinite ? max(0, $0) : nil } ?? start + intrinsic
        let textWidth = max(0, width - start)
        let protectedWidth = (width + 2 * TUISpacing.x4) * minimumFraction
        var frames = [CGRect](repeating: .zero, count: subviews.count)
        var textHeight: CGFloat = 0
        var rowCount = 0
        for (left, right) in pairs {
            guard let a = index(left) else { continue }
            if rowCount > 0 { textHeight += rowSpacing }
            var leftWidth = textWidth
            var rightWidth: CGFloat = 0
            let b = right.flatMap(index)
            if let b {
                let available = max(0, textWidth - TUISpacing.x2)
                if priority == .right {
                    let floor = min(natural[a].width, protectedWidth, available)
                    rightWidth = min(natural[b].width, available - floor)
                    leftWidth = available - rightWidth
                } else {
                    let floor = min(natural[b].width, protectedWidth, available)
                    leftWidth = min(natural[a].width, available - floor)
                    rightWidth = available - leftWidth
                }
            }
            let leftSize = subviews[a].sizeThatFits(ProposedViewSize(width: leftWidth, height: nil))
            frames[a] = CGRect(origin: CGPoint(x: start, y: textHeight), size: leftSize)
            var rowHeight = leftSize.height
            if let b {
                let rightSize = subviews[b].sizeThatFits(ProposedViewSize(width: min(natural[b].width, rightWidth), height: nil))
                frames[b] = CGRect(origin: CGPoint(x: width - rightSize.width, y: textHeight), size: rightSize)
                rowHeight = max(rowHeight, rightSize.height)
            }
            textHeight += rowHeight
            rowCount += 1
        }
        let height = max(minimumHeight, textHeight + 2 * verticalPadding,
                         avatar.map { natural[$0].height + 2 * TUISpacing.x2 } ?? 0)
        for i in subviews.indices where i != avatar { frames[i].origin.y += (height - textHeight) / 2 }
        if let avatar { frames[avatar] = CGRect(origin: CGPoint(x: 0, y: TUISpacing.x2), size: natural[avatar]) }
        return (CGSize(width: width, height: height), frames)
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        geometry(width: proposal.width, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let frames = geometry(width: bounds.width, subviews: subviews).frames
        for i in subviews.indices {
            subviews[i].place(at: CGPoint(x: bounds.minX + frames[i].minX, y: bounds.minY + frames[i].minY),
                              proposal: ProposedViewSize(frames[i].size))
        }
    }
}
