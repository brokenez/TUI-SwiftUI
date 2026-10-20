import SwiftUI
import UIKit

/// Medium card from Figma set 11335:41574. State and routes belong to the app.
public struct TUICardMedium: View {
    public enum Content: String, CaseIterable, Sendable {
        case text
        case avatar = "text+avatar"
        case avatarStack = "text+avatar-stack"
        case badge = "text+badge"
        case icon = "text+icon"
    }

    public enum TextPosition: String, CaseIterable, Sendable { case top, bottom }
    public enum Background: String, CaseIterable, Sendable {
        case fill
        case imagePlaceholder = "image-placeholder"
    }

    /// Exactly the 21 applicable source variants, including the sole skeleton.
    public enum Variant: String, CaseIterable, Sendable {
        case textBottomImage, textBottomSkeleton, textBottomFill, textTopImage, textTopFill
        case avatarBottomImage, avatarBottomFill, avatarTopImage, avatarTopFill
        case stackBottomImage, stackBottomFill, stackTopImage, stackTopFill
        case badgeBottomImage, badgeBottomFill, badgeTopImage, badgeTopFill
        case iconBottomImage, iconBottomFill, iconTopImage, iconTopFill

        public var figmaNodeID: String {
            switch self {
            case .textBottomImage: "11335:41575"
            case .textBottomSkeleton: "11335:41578"
            case .textBottomFill: "11335:41579"
            case .textTopImage: "11335:41586"
            case .textTopFill: "11335:41589"
            case .avatarBottomImage: "11335:41596"
            case .avatarBottomFill: "11335:41604"
            case .avatarTopImage: "11335:41626"
            case .avatarTopFill: "11335:41631"
            case .stackBottomImage: "11335:41644"
            case .stackBottomFill: "11335:41649"
            case .stackTopImage: "11335:41662"
            case .stackTopFill: "11335:41667"
            case .badgeBottomImage: "11335:41680"
            case .badgeBottomFill: "11335:41685"
            case .badgeTopImage: "11335:41698"
            case .badgeTopFill: "11335:41703"
            case .iconBottomImage: "11335:41716"
            case .iconBottomFill: "11335:41721"
            case .iconTopImage: "11335:41734"
            case .iconTopFill: "11335:41739"
            }
        }

        public var content: Content {
            switch self {
            case .avatarBottomImage, .avatarBottomFill, .avatarTopImage, .avatarTopFill: .avatar
            case .stackBottomImage, .stackBottomFill, .stackTopImage, .stackTopFill: .avatarStack
            case .badgeBottomImage, .badgeBottomFill, .badgeTopImage, .badgeTopFill: .badge
            case .iconBottomImage, .iconBottomFill, .iconTopImage, .iconTopFill: .icon
            default: .text
            }
        }

        public var textPosition: TextPosition {
            switch self {
            case .textTopImage, .textTopFill, .avatarTopImage, .avatarTopFill,
                 .stackTopImage, .stackTopFill, .badgeTopImage, .badgeTopFill,
                 .iconTopImage, .iconTopFill: .top
            default: .bottom
            }
        }

        public var background: Background {
            switch self {
            case .textBottomFill, .textTopFill, .avatarBottomFill, .avatarTopFill,
                 .stackBottomFill, .stackTopFill, .badgeBottomFill, .badgeTopFill,
                 .iconBottomFill, .iconTopFill: .fill
            default: .imagePlaceholder
            }
        }

        public var isSkeleton: Bool { self == .textBottomSkeleton }
        /// The old source badge is larger in this single variant.
        public var badgeHeight: CGFloat { self == .badgeBottomImage ? 24 : 20 }
        public var supportsNotification: Bool { content == .avatar && textPosition == .bottom }
    }

    public struct TextStyle {
        public var role: TUITypographyRole?
        public var font: UIFont?
        public var lineHeight: CGFloat?
        public var tracking: CGFloat?
        public var color: Color
        public var maximumLines: Int?

        public init(role: TUITypographyRole? = nil, font: UIFont? = nil,
                    lineHeight: CGFloat? = nil, tracking: CGFloat? = nil,
                    color: Color = TUIColor.textPrimary, maximumLines: Int? = nil) {
            precondition(maximumLines == nil || maximumLines! > 0)
            self.role = role
            self.font = font
            self.lineHeight = lineHeight
            self.tracking = tracking
            self.color = color
            self.maximumLines = maximumLines
        }
    }

    public struct Style {
        public var width: CGFloat
        public var height: CGFloat
        public var padding: CGFloat
        public var gap: CGFloat
        public var radius: CGFloat
        public var title: TextStyle
        public var subtitle: TextStyle

        public init(width: CGFloat = 140, height: CGFloat = 140,
                    padding: CGFloat = TUISpacing.x3, gap: CGFloat = TUISpacing.x3,
                    radius: CGFloat = TUIRadius.medium,
                    title: TextStyle = TextStyle(), subtitle: TextStyle = TextStyle()) {
            precondition(width > 0 && height > 0 && padding >= 0 && gap >= 0 && radius >= 0)
            self.width = width
            self.height = height
            self.padding = padding
            self.gap = gap
            self.radius = radius
            self.title = title
            self.subtitle = subtitle
        }
    }

    public static let figmaComponentSetID = "11335:41574"
    public var variant: Variant
    public var title: String
    public var subtitle: String
    public var showsNotification: Bool
    public var notificationText: String
    public var badgeText: String
    public var isSelected: Bool
    public var isEnabled: Bool
    public var isSkeletonAnimating: Bool
    public var style: Style
    public var accessibilityLabel: String?
    public var accessibilityValue: String?
    public var accessibilityHint: String?
    private var action: (() -> Void)?
    private var customBackground: AnyView?
    private var customAccessory: AnyView?
    @Environment(\.dynamicTypeSize) private var typeSize

    public init(_ title: String = "Title", subtitle: String = "Subtitle",
                variant: Variant = .textBottomImage, showsNotification: Bool = true,
                notificationText: String = "1", badgeText: String = "10%",
                isSelected: Bool = false, isEnabled: Bool = true,
                isSkeletonAnimating: Bool = true, style: Style = Style(),
                accessibilityLabel: String? = nil, accessibilityValue: String? = nil,
                accessibilityHint: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.variant = variant
        self.showsNotification = showsNotification
        self.notificationText = notificationText
        self.badgeText = badgeText
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.isSkeletonAnimating = isSkeletonAnimating
        self.style = style
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValue = accessibilityValue
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    /// Source `image` instance-swap: illustrations, photos or gradients.
    public func cardBackground<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.customBackground = AnyView(content())
        return copy
    }

    /// The inner component has layout priority; its semantics belong to the card.
    public func accessory<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        var copy = self
        copy.customAccessory = AnyView(content())
        return copy
    }

    public var figmaNodeID: String { variant.figmaNodeID }
    var showsAccessory: Bool { customAccessory != nil || variant.content != .text }
    var combinedLabel: String { accessibilityLabel ?? [title, subtitle].filter { !$0.isEmpty }.joined(separator: ", ") }
    var combinedValue: String {
        if let accessibilityValue { return accessibilityValue }
        // A custom slot replaces the original accessory; its meaning cannot be
        // inferred from the original variant. The consumer supplies its value.
        if customAccessory != nil { return "" }
        if variant.supportsNotification && showsNotification { return "Уведомлений: " + notificationText }
        if variant.content == .badge { return "Pro, " + badgeText }
        return ""
    }

    public var body: some View {
        Group {
            if variant.isSkeleton {
                TUISkeleton(width: dimensions.width, height: dimensions.height, isAnimating: isSkeletonAnimating)
                    .clipShape(RoundedRectangle(cornerRadius: style.radius, style: .circular))
                    .accessibilityHidden(true)
            } else if let action {
                Button(action: action) { surface }
                    .buttonStyle(TUICardMediumPressStyle())
                    .disabled(!isEnabled)
            } else {
                surface
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        .accessibilityIdentifier(figmaNodeID)
        .accessibilityAddTraits(isSelected && !variant.isSkeleton ? .isSelected : [])
    }

    private var dimensions: CGSize {
        let scale = TUICardMediumFontMetrics.dimensionScale(typeSize)
        return CGSize(width: style.width * scale, height: style.height * scale)
    }

    private var surface: some View {
        VStack(alignment: .leading, spacing: showsAccessory ? max(style.gap, style.padding) : 0) {
            if variant.textPosition == .top { textContent }
            if showsAccessory {
                accessoryContent
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            if variant.textPosition == .bottom { textContent }
        }
        .padding(.horizontal, style.padding)
        .padding(.top, variant.textPosition == .top ? max(0, style.padding - TUISpacing.x0_5) : style.padding)
        .padding(.bottom, variant.textPosition == .bottom ? max(0, style.padding - TUISpacing.x0_5) : style.padding)
        .frame(width: dimensions.width, height: dimensions.height)
        .background { backgroundContent.allowsHitTesting(false).accessibilityHidden(true) }
        .clipShape(RoundedRectangle(cornerRadius: style.radius, style: .circular))
        .contentShape(RoundedRectangle(cornerRadius: style.radius, style: .circular))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(combinedLabel)
        .accessibilityValue(combinedValue)
        .accessibilityHint(accessibilityHint ?? "")
    }

    private var textContent: some View {
        TUICardMediumTextStack(title: title, subtitle: subtitle, titleStyle: style.title,
                               subtitleStyle: style.subtitle, position: variant.textPosition,
                               size: typeSize)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
    }

    @ViewBuilder private var backgroundContent: some View {
        if let customBackground { customBackground }
        else if variant.background == .fill { TUIColor.named("Background/Neutral 1 Opaque") }
        else {
            Color.white
                .overlay {
                    Canvas { context, size in
                        let tile = context.resolve(Image("tui-card-medium-checker", bundle: .module))
                        let side: CGFloat = 25.47487163543701
                        context.opacity = 0.4
                        for y in stride(from: CGFloat.zero, to: size.height, by: side) {
                            for x in stride(from: CGFloat.zero, to: size.width, by: side) {
                                context.draw(tile, in: CGRect(x: x, y: y, width: side, height: side))
                            }
                        }
                    }
                }
        }
    }

    @ViewBuilder private var accessoryContent: some View {
        if let customAccessory { customAccessory }
        else {
            switch variant.content {
            case .text: EmptyView()
            case .avatar:
                HStack(alignment: .top, spacing: TUISpacing.x1) {
                    ZStack {
                        Circle().fill(TUIColor.named("Background/Accent 2"))
                        Color.white.mask(TUIOriginalSVGMask(resource: "tui-card-medium-star"))
                            .frame(width: 34, height: 34)
                    }
                    .frame(width: TUIControlSize.large, height: TUIControlSize.large)
                    Spacer(minLength: 0)
                    if variant.supportsNotification && showsNotification {
                        TUINotificationBadge(notificationText, size: .medium)
                    }
                }
            case .avatarStack: TUICardMediumSourceAvatarStack()
            case .badge:
                TUICardMediumProBadge(text: badgeText, height: variant.badgeHeight, size: typeSize)
            case .icon:
                TUIColor.named("Background/Accent 2")
                    .mask(TUIOriginalSVGMask(resource: "tui-card-medium-note-plus"))
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct TUICardMediumPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    // Explicit legacy specification; no current Foundation duration equals 100 ms.
    static let duration = 0.1
    static let pressedScale: CGFloat = 0.95

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(reduceMotion ? 1 : configuration.isPressed ? Self.pressedScale : 1)
            .animation(reduceMotion ? nil : Animation.timingCurve(TUIMotionCurve.productiveStandard.unitCurve, duration: Self.duration),
                       value: configuration.isPressed)
    }
}

private struct TUICardMediumSourceAvatarStack: View {
    private let names = ["starbucks", "dodo", "goods"]
    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(names.indices, id: \.self) { index in
                Image("tui-card-medium-" + names[index], bundle: .module)
                    .resizable().scaledToFill()
                    .frame(width: 40, height: 40).clipShape(Circle())
                    .mask(alignment: .topLeading) {
                        if index == 0 { Color.white }
                        else {
                            TUIOriginalSVGMask(resource: "tui-card-medium-stack-mask")
                                .frame(width: 32.5006, height: 40).offset(x: 7.5)
                        }
                    }
                    .offset(x: CGFloat(index) * 28)
            }
        }
        .frame(width: 96, height: 40, alignment: .topLeading)
    }
}

private struct TUICardMediumProBadge: View {
    let text: String
    let height: CGFloat
    let size: DynamicTypeSize
    var body: some View {
        let large = height == 24
        let metrics = TUICardMediumFontMetrics.make(style: .init(), title: false, size: size, bold: true)
        HStack(spacing: 0) {
            Image("tui-card-medium-pro-dot", bundle: .module)
                .resizable().frame(width: large ? 14 : 12, height: large ? 14 : 12)
            TUICardMediumLabel(value: text, metrics: metrics, color: TUIColor.named("Text/Primary On Light"), lines: 1)
                .frame(minWidth: 8)
                .padding(.horizontal, large ? TUISpacing.x1 : TUISpacing.x0_5)
                // Preserve asymmetric source LabelCont insets, not a centered
                // label: 3.5/4.5 at 24 pt and 1.5/2.5 at 20 pt.
                .padding(.top, large ? 3.5 : 1.5)
                .padding(.bottom, large ? 4.5 : 2.5)
        }
        .padding(.leading, large ? 5 : TUISpacing.x1)
        .padding(.trailing, TUISpacing.x1)
        .frame(height: max(height, metrics.lineHeight + (large ? 8 : 4)))
        .background(TUIColor.named("Brand/Pro"), in: Capsule())
    }
}
