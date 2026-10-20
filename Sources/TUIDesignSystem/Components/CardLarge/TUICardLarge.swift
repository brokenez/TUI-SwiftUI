import SwiftUI

/// Card container from Figma 42587:291989. Header and cell slots include their
/// own component padding; this container adds only the card's outer insets.
/// Keep actions inside this static container. For a single action, place a
/// non-interactive card label in a native Button with TUICardLargeButtonStyle.
public struct TUICardLarge: View {
    public enum Preset: String, CaseIterable, Sendable {
        case cell = "Cell", cellList = "Cell List", custom = "Custom", header = "Header"
        case headerSubheader = "Header Subheader", small = "Small", cellClose = "Cell + Close"
        case map = "Map", cellButton = "Cell + Button", scrollCard = "Scroll card"
    }

    /// The actual source matrix, rather than every possible property combination.
    public enum Variant: String, CaseIterable, Sendable {
        case scrollCardWithFooter = "16782:41985", scrollCard = "16785:42812"
        case custom = "42587:291990", customWithFooter = "42587:291998"
        case cellListWithFooter = "42587:292047", cell = "42587:292058"
        case cellList = "42587:292066", headerSubheader = "42587:292099"
        case headerSubheaderWithFooter = "42587:292105", small = "42587:292244"
        case header = "44231:308359", customFlat = "44231:312813"
        case customFlatWithFooter = "44231:312821", cellListFlatWithFooter = "44231:312857"
        case cellFlat = "44231:312868", cellListFlat = "44231:312872"
        case headerSubheaderFlat = "44231:312881", headerFlat = "44231:312885"
        case headerSubheaderFlatWithFooter = "44231:312889", smallFlat = "44231:312977"
        case cellClose = "46739:304459", map = "50523:298748"
        case headerSubheaderSkeleton = "56027:299894", cellButton = "65635:312455"

        public var figmaNodeID: String { rawValue }
        public var preset: Preset {
            switch self {
            case .scrollCard, .scrollCardWithFooter: .scrollCard
            case .custom, .customWithFooter, .customFlat, .customFlatWithFooter: .custom
            case .cellList, .cellListWithFooter, .cellListFlat, .cellListFlatWithFooter: .cellList
            case .cell, .cellFlat: .cell
            case .header, .headerFlat: .header
            case .headerSubheader, .headerSubheaderWithFooter, .headerSubheaderFlat,
                 .headerSubheaderFlatWithFooter, .headerSubheaderSkeleton: .headerSubheader
            case .small, .smallFlat: .small
            case .cellClose: .cellClose
            case .map: .map
            case .cellButton: .cellButton
            }
        }
        public var isFlat: Bool {
            switch self {
            case .customFlat, .customFlatWithFooter, .cellListFlatWithFooter, .cellFlat,
                 .cellListFlat, .headerSubheaderFlat, .headerFlat,
                 .headerSubheaderFlatWithFooter, .smallFlat: true
            default: false
            }
        }
        public var hasFooter: Bool {
            switch self {
            case .scrollCardWithFooter, .customWithFooter, .cellListWithFooter,
                 .headerSubheaderWithFooter, .customFlatWithFooter, .cellListFlatWithFooter,
                 .headerSubheaderFlatWithFooter, .cellButton: true
            default: false
            }
        }
        public var isSkeleton: Bool { self == .headerSubheaderSkeleton }
        public var figmaProperties: [String: String] {
            ["Systеm": "iOS", "Preset": preset.rawValue, "Flat": isFlat ? "True" : "False",
             "Footer": hasFooter ? "True" : "False", "Skeleton": isSkeleton ? "True" : "False"]
        }
    }

    public enum FooterPlacement: String, CaseIterable, Sendable { case afterContent, bottom }

    /// Optional height is a minimum, so larger text can grow instead of clipping.
    public struct Style {
        public var screenPadding: CGFloat?
        public var radius: CGFloat
        public var minimumHeight: CGFloat?
        public var showsShadow: Bool
        public var footerPlacement: FooterPlacement

        public init(screenPadding: CGFloat? = nil, radius: CGFloat = TUIRadius.xLarge,
                    minimumHeight: CGFloat? = nil, showsShadow: Bool = true,
                    footerPlacement: FooterPlacement = .afterContent) {
            precondition((screenPadding ?? 0) >= 0 && radius >= 0 && (minimumHeight ?? 0) >= 0)
            self.screenPadding = screenPadding
            self.radius = radius
            self.minimumHeight = minimumHeight
            self.showsShadow = showsShadow
            self.footerPlacement = footerPlacement
        }
    }

    public static let figmaComponentSetID = "42587:291989"
    public var variant: Variant
    public var style: Style
    public var isSkeletonAnimating: Bool
    private let header: AnyView?
    private let content: AnyView?
    private let footer: AnyView?
    @Environment(\.colorScheme) private var colorScheme

    public init<H: View, C: View, F: View>(variant: Variant = .customWithFooter,
        style: Style = Style(), @ViewBuilder header: () -> H,
        @ViewBuilder content: () -> C, @ViewBuilder footer: () -> F) {
        self.variant = variant
        self.style = style
        isSkeletonAnimating = true
        self.header = H.self == EmptyView.self ? nil : AnyView(header())
        self.content = C.self == EmptyView.self ? nil : AnyView(content())
        self.footer = F.self == EmptyView.self ? nil : AnyView(footer())
    }

    public init<H: View, C: View>(variant: Variant = .custom, style: Style = Style(),
        @ViewBuilder header: () -> H, @ViewBuilder content: () -> C) {
        self.init(variant: variant, style: style, header: header, content: content, footer: { EmptyView() })
    }

    public init(variant: Variant = .headerSubheaderSkeleton, style: Style = Style(),
                isSkeletonAnimating: Bool = true) {
        precondition(variant.isSkeleton, "A non-skeleton card requires its real content slots")
        self.variant = variant
        self.style = style
        self.isSkeletonAnimating = isSkeletonAnimating
        header = nil
        content = nil
        footer = nil
    }

    public var body: some View {
        Group {
            if variant.isSkeleton {
                GeometryReader { geometry in
                    TUISkeleton(width: geometry.size.width, height: geometry.size.height,
                                isAnimating: isSkeletonAnimating)
                }
                .frame(height: style.minimumHeight ?? 84)
                .clipShape(RoundedRectangle(cornerRadius: style.radius, style: .circular))
                .accessibilityHidden(true)
            } else {
                surface
            }
        }
        .padding(.horizontal, style.screenPadding ?? (variant.preset == .small ? 0 : TUISpacing.x4))
    }

    private var surface: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header {
                header
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, !variant.hasFooter &&
                             [.header, .headerSubheader].contains(variant.preset) ? TUISpacing.x1 : 0)
            }
            if let content {
                content
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(contentInsets)
            }
            if let footer, variant.hasFooter {
                if style.footerPlacement == .bottom && style.minimumHeight != nil {
                    Spacer(minLength: 0)
                }
                footer
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, TUISpacing.x5)
                    .padding(.bottom, TUISpacing.x5)
            }
        }
        .padding(.vertical, [.cell, .cellClose].contains(variant.preset) ? TUISpacing.x3 : 0)
        .frame(maxWidth: .infinity, minHeight: style.minimumHeight, alignment: .topLeading)
        .background(variant.isFlat ? TUIColor.named("Background/Neutral 1 On Base")
                                  : TUIColor.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: style.radius, style: .circular))
        .compositingGroup()
        // Convert Figma blur to the half-radius verified in native captures.
        // Composite first so the shadow belongs to the card, not its children.
        .shadow(color: shadowEnabled ? TUIColor.named("Hide from publishing/Shadow/Medium/Color") : .clear,
                radius: shadowNumber("Blur") / 2, x: 0, y: shadowNumber("Y-axis"))
    }

    private var contentInsets: EdgeInsets {
        switch variant.preset {
        case .cell: EdgeInsets(top: 0, leading: TUISpacing.x1, bottom: 0, trailing: TUISpacing.x1)
        case .cellClose: EdgeInsets(top: 0, leading: TUISpacing.x1, bottom: 0, trailing: TUISpacing.x4)
        case .cellButton: EdgeInsets(top: TUISpacing.x3, leading: TUISpacing.x1,
                                     bottom: TUISpacing.x3, trailing: TUISpacing.x1)
        case .cellList: EdgeInsets(top: 0, leading: TUISpacing.x1,
                                   bottom: TUISpacing.x3, trailing: TUISpacing.x1)
        case .custom, .small: EdgeInsets(top: 0, leading: TUISpacing.x1,
                                        bottom: TUISpacing.x5, trailing: TUISpacing.x1)
        case .map: EdgeInsets(top: TUISpacing.x1, leading: TUISpacing.x5,
                              bottom: TUISpacing.x5, trailing: TUISpacing.x5)
        case .scrollCard: EdgeInsets(top: 0, leading: 0, bottom: TUISpacing.x5, trailing: 0)
        case .header, .headerSubheader: EdgeInsets()
        }
    }

    private var shadowEnabled: Bool { !variant.isFlat && style.showsShadow }
    private func shadowNumber(_ suffix: String) -> CGFloat {
        guard shadowEnabled else { return 0 }
        return CGFloat(TUITokenCatalog.shared.number(named: "Hide from publishing/Shadow/Medium/\(suffix)",
            collection: "Theme", mode: colorScheme == .dark ? "Night" : "Day") ?? 0)
    }
}

/// Native Button owns activation, cancellation on scrolling and accessibility.
/// Use only for a non-interactive card label; put separate child actions in a
/// static TUICardLarge instead. Never nest native buttons inside a button label.
public struct TUICardLargeButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.95 : 1)
            .animation(reduceMotion ? nil : TUIMotionCurve.productiveStandard.animation(duration: .fast),
                       value: configuration.isPressed)
    }
}
