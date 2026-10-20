import SwiftUI
import UIKit

/// A selectable cell with the original iOS checkmark, optional avatar and text.
/// Selection is owned by the caller; skeleton is available only with fixed-height on.
public struct TUICellCheckicon: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.tuiCellCheckiconReduceMotionPreview) private var reduceMotionPreview
    public enum Variant: String, CaseIterable, Sendable {
        case fixedHeight, flexibleHeight, skeleton
        public var figmaNodeID: String {
            switch self {
            case .fixedHeight: "41637:306904"
            case .flexibleHeight: "41637:306919"
            case .skeleton: "55902:297311"
            }
        }
    }

    /// Modes from the mobile table in the component specification.
    public enum HeightMode: String, CaseIterable, Sendable {
        case standard = "default"
        case compact, spacious

        public var minimumHeight: CGFloat {
            switch self {
            case .standard: TUIControlSize.large
            case .compact: TUISpacing.x12
            case .spacious: 80
            }
        }
        public var verticalPadding: CGFloat {
            switch self {
            case .standard: TUISpacing.x2
            case .compact: TUISpacing.x1
            case .spacious: TUISpacing.x5
            }
        }
    }

    public enum ContentAlignment: String, CaseIterable, Sendable {
        case top, center
    }

    /// Independent horizontal insets and symmetric vertical insets are
    /// supported by the specification. Nil vertical insets use HeightMode.
    public struct LayoutOptions: Sendable {
        public var leadingInset: CGFloat
        public var trailingInset: CGFloat
        public var textVerticalInset: CGFloat?
        public var accessoryVerticalInset: CGFloat?
        public var elementSpacing: CGFloat
        public var textSpacing: CGFloat
        public var minimumTextFraction: CGFloat
        public var avatarAlignment: ContentAlignment
        public var textAlignment: ContentAlignment
        public var accessoryAlignment: ContentAlignment

        public init(
            leadingInset: CGFloat = TUISpacing.x4, trailingInset: CGFloat = TUISpacing.x4,
            textVerticalInset: CGFloat? = nil, accessoryVerticalInset: CGFloat? = nil,
            elementSpacing: CGFloat = TUISpacing.x4, textSpacing: CGFloat = TUISpacing.x1,
            minimumTextFraction: CGFloat = 0.3,
            avatarAlignment: ContentAlignment = .top, textAlignment: ContentAlignment = .top,
            accessoryAlignment: ContentAlignment = .top
        ) {
            self.leadingInset = leadingInset
            self.trailingInset = trailingInset
            self.textVerticalInset = textVerticalInset
            self.accessoryVerticalInset = accessoryVerticalInset
            self.elementSpacing = elementSpacing
            self.textSpacing = textSpacing
            self.minimumTextFraction = minimumTextFraction
            self.avatarAlignment = avatarAlignment
            self.textAlignment = textAlignment
            self.accessoryAlignment = accessoryAlignment
        }
    }

    /// Overrides use foundation typography roles; nil preserves the original
    /// legacy SF Pro Text style, including its explicit tracking.
    public struct TextStyle {
        public var role: TUITypographyRole?
        public var color: Color?
        public var tracking: CGFloat?

        public init(role: TUITypographyRole? = nil, color: Color? = nil, tracking: CGFloat? = nil) {
            self.role = role
            self.color = color
            self.tracking = tracking
        }
    }

    public struct TextOptions {
        public var title: TextStyle
        public var description: TextStyle
        public var caption: TextStyle

        public init(title: TextStyle = .init(), description: TextStyle = .init(), caption: TextStyle = .init()) {
            self.title = title
            self.description = description
            self.caption = caption
        }
    }

    public let title: String
    public let description: String
    public let caption: String
    public let variant: Variant
    public let heightMode: HeightMode
    public let layout: LayoutOptions
    public let textOptions: TextOptions
    public let reflowsAccessoryAtAccessibilitySize: Bool
    public let showAvatar: Bool
    public let showCaption: Bool
    public let showDescription: Bool
    public let showSelected: Bool
    public let expandsAtAccessibilitySize: Bool
    public let accessibilityHint: String
    private let avatar: AnyView?
    private let accessory: AnyView?
    private let action: () -> Void

    public init(
        title: String = "Title", description: String = "Description", caption: String = "Caption",
        variant: Variant = .fixedHeight, heightMode: HeightMode = .standard,
        layout: LayoutOptions = LayoutOptions(), textOptions: TextOptions = TextOptions(),
        showAvatar: Bool = true,
        showCaption: Bool = false, showDescription: Bool = true, showSelected: Bool = true,
        expandsAtAccessibilitySize: Bool = true, accessibilityHint: String = "",
        reflowsAccessoryAtAccessibilitySize: Bool = false,
        avatar: AnyView? = nil, accessory: AnyView? = nil, action: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.caption = caption
        self.variant = variant
        self.heightMode = heightMode
        self.layout = layout
        self.textOptions = textOptions
        self.reflowsAccessoryAtAccessibilitySize = reflowsAccessoryAtAccessibilitySize
        self.showAvatar = showAvatar
        self.showCaption = showCaption
        self.showDescription = showDescription
        self.showSelected = showSelected
        self.expandsAtAccessibilitySize = expandsAtAccessibilitySize
        self.accessibilityHint = accessibilityHint
        self.avatar = avatar
        self.accessory = accessory
        self.action = action
    }

    public var figmaNodeID: String { variant.figmaNodeID }
    private var limited: Bool {
        variant == .fixedHeight && !(expandsAtAccessibilitySize && dynamicTypeSize >= .accessibility1)
    }
    private var hasAccessory: Bool { variant != .skeleton && (accessory != nil || showSelected) }
    private var reflowsAccessory: Bool {
        hasAccessory && reflowsAccessoryAtAccessibilitySize && dynamicTypeSize >= .accessibility1
    }
    private var spokenLabel: String {
        ([showCaption ? caption : "", title, showDescription ? description : ""])
            .filter { !$0.isEmpty }.joined(separator: ", ")
    }
    private var contentAnimation: Animation? {
        reduceMotion || reduceMotionPreview ? nil : TUIMotionCurve.productiveStandard.animation(duration: .fast)
    }

    public var body: some View {
        Group {
            if variant == .skeleton {
                content.accessibilityHidden(true)
            } else {
                Button(action: action) { content }
                    .buttonStyle(TUICellCheckiconButtonStyle())
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(spokenLabel)
                    .accessibilityValue(showSelected ? "Выбрано" : "")
                    .accessibilityHint(accessibilityHint)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAddTraits(showSelected ? .isSelected : [])
            }
        }
        .accessibilityIdentifier("tuiCellCheckicon-\(figmaNodeID)")
    }

    private var content: some View {
        TUICellCheckiconLayout(options: layout, minimumHeight: heightMode.minimumHeight) {
            if showAvatar {
                Group {
                    if variant == .skeleton {
                        Circle().fill(TUIColor.named("Service/Skeleton"))
                            .frame(width: TUISpacing.x10, height: TUISpacing.x10)
                    } else if let avatar {
                        avatar
                    } else {
                        Image("tui-cell-checkicon-star", bundle: .module)
                            .renderingMode(.template).resizable()
                            .foregroundStyle(TUIColor.named("Text/Primary On Dark"))
                            .frame(width: TUISpacing.x6, height: TUISpacing.x6)
                            .frame(width: TUISpacing.x10, height: TUISpacing.x10)
                            .background(TUIColor.named("Background/Accent 2"), in: Circle())
                    }
                }
                .padding(.vertical, max(0, layout.accessoryVerticalInset ?? heightMode.verticalPadding))
                .accessibilityHidden(true)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .clipped()
                .layoutValue(key: TUICellCheckiconSlot.self, value: .avatar)
            }
            VStack(alignment: .leading, spacing: max(0, layout.textSpacing)) {
                if showCaption { row(caption, role: .uiSmall, style: textOptions.caption, skeletonWidth: 96, isTitle: false, limit: false) }
                row(title, role: .bodyLarge, style: textOptions.title, skeletonWidth: 160, isTitle: true, limit: limited)
                if showDescription { row(description, role: .uiSmall, style: textOptions.description, skeletonWidth: 96, isTitle: false, limit: limited) }
                if reflowsAccessory {
                    accessoryContent
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .clipped()
                        .padding(.top, max(0, TUISpacing.x2 - layout.textSpacing))
                }
            }
            .frame(maxWidth: .infinity, minHeight: TUISpacing.x10, alignment: .leading)
            .padding(.vertical, max(0, layout.textVerticalInset ?? heightMode.verticalPadding))
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            .layoutValue(key: TUICellCheckiconSlot.self, value: .text)
            if hasAccessory && !reflowsAccessory {
                accessoryContent
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: TUISpacing.x10, alignment: .trailing)
                    .clipped()
                    .padding(.vertical, max(0, layout.accessoryVerticalInset ?? heightMode.verticalPadding))
                    .transition(.opacity)
                    .layoutValue(key: TUICellCheckiconSlot.self, value: .accessory)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .contentShape(Rectangle())
        .animation(contentAnimation, value: showSelected)
    }

    @ViewBuilder private var accessoryContent: some View {
        Group {
            if let accessory {
                accessory
            } else {
                Image("tui-cell-checkicon-check", bundle: .module)
                    .renderingMode(.template).resizable()
                    .foregroundStyle(TUIColor.named("Text/Action"))
                    .frame(width: TUISpacing.x4, height: TUISpacing.x4)
            }
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder private func row(_ text: String, role: TUITypographyRole, style: TextStyle, skeletonWidth: CGFloat, isTitle: Bool, limit: Bool) -> some View {
        if variant == .skeleton {
            TUISkeletonText(textStyle: isTitle ? .bodyLarge : .uiSmall, width: skeletonWidth)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()
        } else {
            TUICellCheckiconText(text: text, role: role, style: style, isTitle: isTitle, limited: limit)
                .id(text)
                .transition(.opacity)
                .animation(contentAnimation, value: text)
        }
    }
}

// Internal catalog control for previewing reduced motion; the actual system
// accessibility setting always takes precedence and cannot be overridden off.
private struct TUICellCheckiconReduceMotionPreviewKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var tuiCellCheckiconReduceMotionPreview: Bool {
        get { self[TUICellCheckiconReduceMotionPreviewKey.self] }
        set { self[TUICellCheckiconReduceMotionPreviewKey.self] = newValue }
    }
}

private enum TUICellCheckiconSlot: LayoutValueKey {
    enum Role { case avatar, text, accessory }
    static let defaultValue = Role.text
}

/// Reserve space for the checkmark and the specified minimum text share before
/// proposing a width to a caller-supplied avatar. Text determines row height.
private struct TUICellCheckiconLayout: Layout {
    let options: TUICellCheckicon.LayoutOptions
    let minimumHeight: CGFloat

    private struct Metrics {
        let width: CGFloat
        let height: CGFloat
        let sizes: [CGSize]
        let spacing: CGFloat
    }

    private func measure(_ proposal: ProposedViewSize, _ subviews: Subviews) -> Metrics {
        let leading = max(0, options.leadingInset)
        let trailing = max(0, options.trailingInset)
        let spacing = max(0, options.elementSpacing)
        let idealWidths = subviews.map { $0.sizeThatFits(.unspecified).width }
        let proposedWidth = proposal.width.flatMap { $0.isFinite ? $0 : nil }
        let width = max(0, proposedWidth ?? (idealWidths.reduce(0, +) + leading + trailing + CGFloat(max(0, subviews.count - 1)) * spacing))
        let gap = CGFloat(max(0, subviews.count - 1)) * spacing
        let available = max(0, width - leading - trailing - gap)
        let fraction = min(1, max(0, options.minimumTextFraction))
        let textMinimum = min(available, width * fraction)
        var sizes = Array(repeating: CGSize.zero, count: subviews.count)
        var accessoryWidth: CGFloat = 0
        for index in subviews.indices where subviews[index][TUICellCheckiconSlot.self] == .accessory {
            let maxWidth = max(0, available - textMinimum)
            let actualWidth = min(idealWidths[index], maxWidth)
            sizes[index] = subviews[index].sizeThatFits(ProposedViewSize(width: actualWidth, height: nil))
            sizes[index].width = actualWidth
            accessoryWidth += actualWidth
        }
        var avatarWidth: CGFloat = 0
        for index in subviews.indices where subviews[index][TUICellCheckiconSlot.self] == .avatar {
            let maxWidth = max(0, available - accessoryWidth - textMinimum)
            let actualWidth = min(idealWidths[index], maxWidth)
            sizes[index] = subviews[index].sizeThatFits(ProposedViewSize(width: actualWidth, height: nil))
            sizes[index].width = actualWidth
            avatarWidth += actualWidth
        }
        for index in subviews.indices where subviews[index][TUICellCheckiconSlot.self] == .text {
            let actualWidth = max(0, available - accessoryWidth - avatarWidth)
            sizes[index] = subviews[index].sizeThatFits(ProposedViewSize(width: actualWidth, height: nil))
            sizes[index].width = actualWidth
        }
        return Metrics(width: width, height: max(minimumHeight, sizes.map(\.height).max() ?? 0), sizes: sizes, spacing: spacing)
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let metrics = measure(proposal, subviews)
        return CGSize(width: metrics.width, height: metrics.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let metrics = measure(ProposedViewSize(width: bounds.width, height: nil), subviews)
        var x = bounds.minX + max(0, options.leadingInset)
        for index in subviews.indices {
            let alignment: TUICellCheckicon.ContentAlignment
            switch subviews[index][TUICellCheckiconSlot.self] {
            case .avatar: alignment = options.avatarAlignment
            case .text: alignment = options.textAlignment
            case .accessory: alignment = options.accessoryAlignment
            }
            let size = metrics.sizes[index]
            let y = bounds.minY + (alignment == .center ? max(0, (bounds.height - size.height) / 2) : 0)
            subviews[index].place(at: CGPoint(x: x, y: y), anchor: .topLeading,
                                 proposal: ProposedViewSize(width: size.width, height: size.height))
            x += size.width + metrics.spacing
        }
    }
}

private struct TUICellCheckiconText: View {
    let text: String
    let role: TUITypographyRole
    let style: TUICellCheckicon.TextStyle
    let isTitle: Bool
    let limited: Bool
    @ScaledMetric private var scale: CGFloat

    init(text: String, role: TUITypographyRole, style: TUICellCheckicon.TextStyle, isTitle: Bool, limited: Bool) {
        self.text = text
        self.role = role
        self.style = style
        self.isTitle = isTitle
        self.limited = limited
        _scale = ScaledMetric(wrappedValue: 1, relativeTo: (style.role ?? role).textStyle.swiftUITextStyle)
    }

    var body: some View {
        let metrics = (style.role ?? role).metrics
        let font: UIFont = {
            guard style.role != nil else { return TUIFigmaTextFont.regular(size: metrics.size * scale) }
            return metrics.nativeFont(at: metrics.size * scale)
        }()
        let tracking = style.tracking ?? (style.role != nil ? 0 : isTitle ? -0.41 : metrics.letterSpacing)
        let color = style.color ?? TUIColor.named(isTitle ? "Text/Primary" : "Text/Secondary")
        let lineHeight = style.role == nil ? (isTitle ? 20.0 : 16.0) * scale : max(metrics.lineHeight * scale, font.lineHeight)
        let displayText = style.role?.isUppercase == true ? text.uppercased() : text
        let label = Text(displayText).font(Font(font)).tracking(tracking).foregroundStyle(color)
            .lineSpacing(max(0, lineHeight - font.lineHeight))
        Group {
            if limited {
                TUICellCheckiconClippedText(text: displayText, font: font, tracking: tracking, color: UIColor(color))
                    .frame(height: lineHeight, alignment: .topLeading)
            } else {
                label.fixedSize(horizontal: false, vertical: true)
                    .frame(minHeight: lineHeight, alignment: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct TUICellCheckiconClippedText: UIViewRepresentable {
    let text: String
    let font: UIFont
    let tracking: CGFloat
    let color: UIColor

    func makeUIView(context: Context) -> TUICellCheckiconFadeLabel {
        let label = TUICellCheckiconFadeLabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byClipping
        label.isAccessibilityElement = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    func updateUIView(_ label: TUICellCheckiconFadeLabel, context: Context) {
        label.attributedText = NSAttributedString(string: text, attributes: [
            .font: font, .kern: tracking, .foregroundColor: color
        ])
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: TUICellCheckiconFadeLabel, context: Context) -> CGSize? {
        CGSize(width: proposal.width ?? 0, height: proposal.height ?? font.lineHeight)
    }
}

private final class TUICellCheckiconFadeLabel: UILabel {
    private let fade = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        fade.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        fade.locations = [0, 0.85065, 1]
        fade.startPoint = CGPoint(x: 0, y: 0.5)
        fade.endPoint = CGPoint(x: 1, y: 0.5)
        layer.mask = fade
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        fade.frame = bounds
        CATransaction.commit()
    }
}

private struct TUICellCheckiconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.background(configuration.isPressed ? TUIColor.named("Background/Neutral 1") : .clear)
    }
}
