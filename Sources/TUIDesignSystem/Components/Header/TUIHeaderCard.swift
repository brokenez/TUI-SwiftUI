import SwiftUI
import UIKit

/// Card heading, Figma set 44217:298609. The Switch accessory uses native iOS 26.
/// Consumer slots replace the editor's instance-swap placeholders.
public struct TUIHeaderCard: View {
    public enum Variant: String, CaseIterable, Sendable {
        case skeleton = "17714:53773"
        case extendedSkeleton = "17714:53869"
        case avatar = "44217:298678"
        case button = "44217:299480"
        case buttonLink = "44217:299616"
        case `switch` = "44217:299699"
        case none = "44217:299799"
        case extendedAvatar = "59830:293851"
        case extended = "59830:293951"

        public var figmaNodeID: String { rawValue }
        public var isSkeleton: Bool { self == .skeleton || self == .extendedSkeleton }
        public var isExtended: Bool { [.extendedSkeleton, .extendedAvatar, .extended].contains(self) }
        public var accessoryName: String {
            switch self {
            case .avatar, .extendedAvatar: "Avatar"
            case .button: "Button"
            case .buttonLink: "Button Link"
            case .switch: "Switch"
            default: "None"
            }
        }
        public var figmaProperties: [String: String] {
            ["System": "iOS", "Accessory": accessoryName,
             "Extended": isExtended ? "On" : "Off", "skeleton": isSkeleton ? "on" : "off"]
        }
    }

    public typealias TextStyle = TUIHeaderLarge.TextStyle
    public typealias TextOverflow = TUIHeaderLarge.TextOverflow
    public typealias AccessoryAlignment = TUIHeaderLarge.AccessoryAlignment
    public let variant: Variant
    public var title: AttributedString
    public var subheader: AttributedString
    public var description: AttributedString
    public var caption: String
    public var showsSubheader: Bool
    public var showsDescription: Bool
    public var showsCaption: Bool
    public var isSkeletonAnimating: Bool
    public var badgeCount: Int?
    public var badgeAccessibilityValue: String?
    public var accessoryAlignment: AccessoryAlignment = .top
    public var reflowsAccessoryAtAX1 = false
    private var titleStyle = TextStyle()
    private var subheaderStyle = TextStyle()
    private var descriptionStyle = TextStyle()
    private var customAccessory: AnyView?
    private var subheaderPrefix: AnyView?
    private var subheaderSuffix: AnyView?
    private let actionTitle: String
    private let accessoryAction: (() -> Void)?
    private let switchValue: Binding<Bool>?
    private let isEnabled: Bool
    private var hintAction: (() -> Void)?
    private var hintLabel = "Подробнее"
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    public init(_ title: String = "Header", subheader: String = "Subheader",
                description: String = "Description", caption: String = "Caption",
                variant: Variant = .avatar, showsSubheader: Bool = true,
                showsDescription: Bool = false, showsCaption: Bool = true,
                badgeCount: Int? = nil, badgeAccessibilityValue: String? = nil,
                actionTitle: String = "Label", accessoryAction: (() -> Void)? = nil,
                isOn: Binding<Bool>? = nil, isEnabled: Bool = true,
                isSkeletonAnimating: Bool = true) {
        self.init(title: AttributedString(title), subheader: AttributedString(subheader),
                  description: AttributedString(description), caption: caption, variant: variant,
                  showsSubheader: showsSubheader, showsDescription: showsDescription, showsCaption: showsCaption,
                  badgeCount: badgeCount, badgeAccessibilityValue: badgeAccessibilityValue,
                  actionTitle: actionTitle, accessoryAction: accessoryAction,
                  isOn: isOn, isEnabled: isEnabled, isSkeletonAnimating: isSkeletonAnimating)
    }

    public init(title: AttributedString, subheader: AttributedString = AttributedString("Subheader"),
                description: AttributedString = AttributedString("Description"), caption: String = "Caption",
                variant: Variant = .avatar, showsSubheader: Bool = true,
                showsDescription: Bool = false, showsCaption: Bool = true,
                badgeCount: Int? = nil, badgeAccessibilityValue: String? = nil,
                actionTitle: String = "Label", accessoryAction: (() -> Void)? = nil,
                isOn: Binding<Bool>? = nil, isEnabled: Bool = true,
                isSkeletonAnimating: Bool = true) {
        precondition(![.button, .buttonLink].contains(variant) || accessoryAction != nil,
                     "Button variants require the consumer's accessoryAction")
        precondition(variant != .switch || isOn != nil, "Switch requires a writable isOn binding")
        self.title = title; self.subheader = subheader; self.description = description
        self.caption = caption; self.variant = variant; self.showsSubheader = showsSubheader
        self.showsDescription = showsDescription; self.showsCaption = showsCaption
        self.badgeCount = badgeCount; self.badgeAccessibilityValue = badgeAccessibilityValue
        self.actionTitle = actionTitle; self.accessoryAction = accessoryAction
        self.switchValue = isOn; self.isEnabled = isEnabled; self.isSkeletonAnimating = isSkeletonAnimating
    }

    public func textStyles(title: TextStyle = .init(), subheader: TextStyle = .init(),
                           description: TextStyle = .init()) -> Self {
        var copy = self
        copy.titleStyle = title; copy.subheaderStyle = subheader; copy.descriptionStyle = description
        return copy
    }

    /// Owns its semantics. Pass `.none` or `.extended` to omit a built-in accessory.
    public func accessory<Content: View>(alignment: AccessoryAlignment = .top,
                                         reflowsAtAX1: Bool = false,
                                         @ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.customAccessory = AnyView(content()); copy.accessoryAlignment = alignment
        copy.reflowsAccessoryAtAX1 = reflowsAtAX1
        return copy
    }

    public func subheaderLeading<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self; copy.subheaderPrefix = AnyView(content()); return copy
    }
    public func subheaderTrailing<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self; copy.subheaderSuffix = AnyView(content()); return copy
    }

    /// A visible tooltip also becomes a named action of the heading for VoiceOver.
    public func hint(_ label: String, action: @escaping () -> Void) -> Self {
        var copy = self; copy.hintLabel = label; copy.hintAction = action; return copy
    }

    public var figmaNodeID: String { variant.figmaNodeID }
    private var hasAccessory: Bool {
        !variant.isSkeleton && (customAccessory != nil || variant.accessoryName != "None"
                               || badgeCount != nil || hintAction != nil)
    }
    private var rightInset: CGFloat {
        variant.isSkeleton || ["Avatar", "Button", "Switch"].contains(variant.accessoryName)
            ? TUISpacing.x4 : TUISpacing.x5
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: TUISpacing.x2) {
            if hasAccessory && reflowsAccessoryAtAX1 && dynamicTypeSize >= .accessibility1 {
                heading
                accessories
            } else {
                HStack(alignment: accessoryAlignment.vertical, spacing: TUISpacing.x4) {
                    heading
                        .frame(maxHeight: .infinity, alignment: .leading)
                    if hasAccessory { accessories }
                }
            }
            if showsDescription && !variant.isSkeleton {
                label(description, style: descriptionStyle, kind: .description)
            }
        }
        .padding(.top, TUISpacing.x4).padding(.bottom, TUISpacing.x3)
        .padding(.leading, TUISpacing.x5).padding(.trailing, rightInset)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        .accessibilityHidden(variant.isSkeleton)
    }

    private var heading: some View {
        let firstLineCenter = (variant.isExtended && showsCaption ? TUISpacing.x3 + TUISpacing.x2 : 0)
            + metrics(.title).lineHeight / 2
        return VStack(alignment: .leading, spacing: TUISpacing.x2) {
            if variant.isExtended && showsCaption {
                Group {
                    if variant.isSkeleton {
                        TUISkeleton(width: 130, height: TUISpacing.x3, isAnimating: isSkeletonAnimating)
                    } else {
                        label(AttributedString(caption.uppercased()), style: .init(overflow: .singleLineFade), kind: .caption)
                    }
                }
                .frame(height: TUISpacing.x3, alignment: .top)
            }
            if variant.isSkeleton {
                TUISkeletonText(textStyle: .headingMedium, width: 92, isAnimating: isSkeletonAnimating)
            } else { label(title, style: titleStyle, kind: .title) }
            if showsSubheader {
                Group {
                    if variant.isSkeleton {
                        TUISkeletonText(textStyle: .bodyLarge, width: 130, isAnimating: isSkeletonAnimating)
                            .frame(height: 18)
                    } else {
                        TUIHeaderInlineLayout(gap: TUISpacing.x2, fillsLabel: subheaderSuffix == nil,
                                              centered: false, firstLineHeight: metrics(.subheader).lineHeight,
                                              slotAlignment: .center) {
                            if let subheaderPrefix {
                                subheaderPrefix.layoutValue(key: TUIHeaderInlineRole.self, value: .prefix)
                            }
                            label(subheader, style: subheaderStyle, kind: .subheader)
                                .layoutValue(key: TUIHeaderInlineRole.self, value: .label)
                            if let subheaderSuffix {
                                subheaderSuffix.layoutValue(key: TUIHeaderInlineRole.self, value: .suffix)
                            }
                        }
                    }
                }
                .padding(.bottom, TUISpacing.x0_5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .alignmentGuide(.tuiHeaderFirstLineCenter) { _ in firstLineCenter }
        .accessibilityElement(children: .combine)
        .contentShape(.accessibility, Rectangle())
        .accessibilityAddTraits(.isHeader)
        .accessibilityValue(badgeAccessibilityValue ?? badgeCount.map { String($0) } ?? "")
        .accessibilityActions {
            if let hintAction { Button(hintLabel, action: hintAction) }
        }
    }

    private var accessories: some View {
        HStack(spacing: TUISpacing.x4) {
            if let badgeCount {
                TUINotificationBadge(badgeCount > 99 ? "99+" : String(badgeCount), size: .large).accessibilityHidden(true)
            }
            if let hintAction {
                Button(action: hintAction) {
                    Circle().fill(TUIColor.named("Background/Neutral 1"))
                        .overlay { TUIColor.textSecondary.mask(TUIOriginalSVGMask(resource: "tui-header-card-tooltip"))
                            .frame(width: 12, height: 12) }
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(.plain).accessibilityHidden(true)
            }
            if let customAccessory { customAccessory }
            else {
                switch variant {
                case .avatar, .extendedAvatar:
                    Circle().fill(TUIColor.named("Background/Accent 2"))
                        .overlay { TUIColor.named("Text/Primary On Dark")
                            .mask(TUIOriginalSVGMask(resource: "tui-header-card-star"))
                            .frame(width: TUISpacing.x6, height: TUISpacing.x6) }
                        .frame(width: TUISpacing.x10, height: TUISpacing.x10)
                        .accessibilityHidden(true)
                case .button:
                    if let accessoryAction {
                        TUIButton(actionTitle, size: .small, state: isEnabled ? .normal : .disabled,
                                  action: accessoryAction)
                    }
                case .buttonLink:
                    if let accessoryAction {
                        Button(action: accessoryAction) {
                            label(AttributedString(actionTitle), style: .init(color: TUIColor.action,
                                  overflow: .singleLineFade), kind: .description)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .buttonStyle(.plain).disabled(!isEnabled).padding(.top, TUISpacing.x0_5)
                    }
                case .switch:
                    if let switchValue {
                        TUISystemSwitch(String(title.characters), isOn: switchValue, isEnabled: isEnabled)
                    }
                default: EmptyView()
                }
            }
        }
        .fixedSize(horizontal: true, vertical: true)
    }

    private func label(_ value: AttributedString, style: TextStyle, kind: TUIHeaderCardTextKind) -> some View {
        let m = TUIHeaderCardFontMetrics.make(kind: kind, style: style, size: dynamicTypeSize)
        return TUIHeaderText(value: value, metrics: m, color: style.color ?? m.color,
                             tracking: style.tracking ?? m.tracking, overflow: style.overflow, centered: false)
            .textCase(style.role?.isUppercase == true ? .uppercase : nil)
    }
    private func metrics(_ kind: TUIHeaderCardTextKind) -> TUIHeaderFontMetrics {
        TUIHeaderCardFontMetrics.make(kind: kind, style: .init(), size: dynamicTypeSize)
    }
}

enum TUIHeaderCardTextKind { case title, subheader, description, caption }
enum TUIHeaderCardFontMetrics {
    static func make(kind: TUIHeaderCardTextKind, style: TUIHeaderLarge.TextStyle,
                     size: DynamicTypeSize) -> TUIHeaderFontMetrics {
        let base: UIFont
        let height: CGFloat
        let tracking: CGFloat
        switch kind {
        case .title: base = TUIFigmaTextFont.displayBold(size: 20); height = 24; tracking = 0.38
        case .subheader: base = TUIFigmaTextFont.regular(size: 15); height = 18; tracking = -0.24
        case .description: base = TUIFigmaTextFont.regular(size: 17); height = 20; tracking = -0.41
        // The source's legacy Medium face is not bundled. Visual acceptance is
        // pending; this uses the platform face instead of adding unlicensed fonts.
        case .caption: base = .systemFont(ofSize: 13, weight: .medium); height = 16; tracking = 0
        }
        var exact = style
        if style.role == nil && style.font == nil { exact.font = base }
        exact.lineHeight = style.lineHeight ?? (style.role?.metrics.lineHeight ?? height)
        let m = TUIHeaderFontMetrics.make(style: exact, title: kind == .title,
                                        description: kind == .description, size: size)
        return .init(font: m.font, lineHeight: m.lineHeight,
                     firstBaseline: style.role == nil && style.lineHeight == nil ? m.font.ascender.rounded() : m.firstBaseline,
                     tracking: style.tracking ?? (style.role != nil || style.font != nil ? 0 : tracking),
                     color: style.color ?? (kind == .subheader || kind == .caption ? TUIColor.textSecondary : TUIColor.textPrimary))
    }
}
