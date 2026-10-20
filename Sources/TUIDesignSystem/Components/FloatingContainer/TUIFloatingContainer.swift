import SwiftUI

public enum TUIFloatingContainerPreset: String, CaseIterable, Sendable {
    case action, twoActions = "two-actions", actionLegal = "action+legal"
    case customContent = "custom-content"
}
public enum TUIFloatingContainerBackground: String, CaseIterable, Sendable {
    case off, base, elevation1 = "elevation-1"
}
public enum TUIFloatingContainerReplacementKind: Equatable, Sendable {
    case sameShape, differentShape
}

/// Source set 44286:299509. The home indicator belongs to the native screen,
/// so this view contains only the content above the bottom safe area.
public struct TUIFloatingContainer<Content: View>: View {
    public typealias Preset = TUIFloatingContainerPreset
    public typealias Background = TUIFloatingContainerBackground

    public static var figmaComponentSetID: String { "44286:299509" }
    public let preset: Preset
    public let background: Background
    public let showsFade: Bool
    private let backgroundColor: Color?
    private let content: Content
    @Environment(\.tuiFloatingContainerMotionBottom) private var motionBottom

    /// A custom slot grows with its actual content; it never renders the
    /// Figma editor's dashed Placeholder component.
    public init(@ViewBuilder content: () -> Content) {
        self.init(preset: .customContent, background: .off, showsFade: false,
                  backgroundColor: nil, content: content())
    }

    fileprivate init(preset: Preset, background: Background, showsFade: Bool,
                     backgroundColor: Color?, content: Content) {
        self.preset = preset; self.background = background
        self.showsFade = showsFade; self.backgroundColor = backgroundColor
        self.content = content
    }

    public var figmaNodeID: String? {
        switch (preset, background) {
        case (.action, .off): "44286:299616"
        case (.customContent, .off): "44286:299621"
        case (.twoActions, .base): "44286:299510"
        case (.twoActions, .elevation1): "55095:283896"
        case (.actionLegal, .base): "44286:299553"
        case (.actionLegal, .elevation1): "55095:283930"
        default: nil
        }
    }

    public var figmaProperties: [String: String] {
        ["system": "iOS", "content": preset.rawValue, "background": background.rawValue]
    }

    public var body: some View {
        content
            .frame(maxWidth: .infinity)
            .background {
                if preset == .customContent {
                    GeometryReader { geometry in
                        Color.clear.preference(key: TUIFloatingContainerTargetLayoutKey.self,
                            value: TUIFloatingContainerTargetLayout(height: geometry.size.height,
                                preset: .customContent))
                    }
                }
            }
            .padding(.horizontal, TUISpacing.x4)
            .padding(.bottom, preset == .action || preset == .customContent ? TUISpacing.x6 : 0)
            .background {
                if showsFade {
                    (backgroundColor ?? (background == .elevation1
                        ? TUIColor.backgroundSecondary : TUIColor.backgroundPrimary))
                        .mask(alignment: .top) {
                            VStack(spacing: 0) {
                                // Exact iOS SVG mask: y=0 alpha 0, y=46 alpha 1.
                                // 46 is source geometry, not an invented token.
                                LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
                                    .frame(height: TUIFloatingContainerMetrics.fadeHeight)
                                Rectangle().fill(.white)
                            }
                        }
                        .ignoresSafeArea(.container, edges: .bottom)
                        .allowsHitTesting(false)
                        .transition(TUIFloatingContainerSlideTransition(bottom: motionBottom))
                }
            }
            .transformPreference(TUIFloatingContainerTargetLayoutKey.self) { layout in
                if layout != nil {
                    layout?.preset = preset
                    if preset == .action || preset == .customContent {
                        layout?.height += TUISpacing.x6
                    }
                }
            }
            .animation(showsFade ? TUIFloatingContainerMetrics.entranceAnimation
                : TUIFloatingContainerMetrics.exitAnimation, value: showsFade)
    }
}

public extension TUIFloatingContainer where Content == TUIFloatingContainerActions {
    /// Figma's default is no fade. Set it to true for a button visible on entry;
    /// the Guide hides the fade when a single button appears by scroll/trigger.
    /// Keep the same initializer/view identity when switching optional
    /// secondary/legal content: the primary action survives the transition.
    init(primary: TUIButton, secondary: TUIButton? = nil, legalText: String? = nil,
         background: Background? = nil, showsFade: Bool = false,
         backgroundColor: Color? = nil) {
        precondition(secondary == nil || legalText == nil,
                     "Legal text cannot be combined with two actions")
        let preset: Preset = secondary != nil ? .twoActions : legalText != nil ? .actionLegal : .action
        let resolvedBackground = background ?? (preset == .action ? .off : .base)
        precondition(preset == .action ? resolvedBackground == .off : resolvedBackground != .off,
                     "Use off for one action and base/elevation1 for secondary or legal content")
        self.init(preset: preset, background: resolvedBackground,
                  showsFade: preset == .action ? showsFade : true,
                  backgroundColor: backgroundColor,
                  content: TUIFloatingContainerActions(primary: primary, secondary: secondary, legalText: legalText))
    }
}

/// Inferred content type of the action initializers. Consumers configure the
/// buttons through TUIButton and keep their actions/state in the screen.
public struct TUIFloatingContainerActions: View {
    fileprivate let primary: TUIButton
    fileprivate let secondary: TUIButton?
    fileprivate let legalText: String?
    @Environment(\.tuiFloatingContainerMotionBottom) private var motionBottom
    @State private var measuredHeights: [String: CGFloat] = [:]

    private enum Supplement: String { case none, button, legal }
    private var supplement: Supplement { secondary != nil ? .button : legalText != nil ? .legal : .none }
    private var hasSupplement: Bool { supplement != .none }
    private var supplementIdentity: String {
        supplement.rawValue + ":" + (secondary.map(TUIFloatingContainerButtonIdentity.init)?.content ?? legalText ?? "")
    }
    private var primaryMeasurementID: String {
        "primary:" + TUIFloatingContainerButtonIdentity(primary).content
    }
    private var supplementMeasurementID: String { "supplement:" + supplementIdentity }
    private var primaryHeight: CGFloat? { measuredHeights[primaryMeasurementID] }
    private var supplementHeight: CGFloat? {
        hasSupplement ? measuredHeights[supplementMeasurementID] : 0
    }
    private var swapAnimation: Animation {
        supplement == .legal ? TUIFloatingContainerMetrics.supplementFadeEntranceAnimation
            : TUIMotionCurve.productiveStandard.animation(duration: .moderate)
    }
    private var targetLayout: TUIFloatingContainerTargetLayout? {
        guard let primaryHeight, let supplementHeight else { return nil }
        return .init(height: primaryHeight + supplementHeight,
            preset: supplement == .button ? .twoActions : supplement == .legal ? .actionLegal : .action)
    }

    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                ZStack(alignment: .top) {
                    primary.floatingContainerMeasureHeight(id: primaryMeasurementID)
                        .id(TUIFloatingContainerButtonIdentity(primary).content)
                        .transition(TUIFloatingContainerFadeTransition(
                            entrance: TUIFloatingContainerMetrics.primaryFadeAnimation,
                            exit: TUIFloatingContainerMetrics.primaryFadeAnimation))
                }
                .animation(TUIFloatingContainerMetrics.primaryFadeAnimation,
                           value: TUIFloatingContainerButtonIdentity(primary).content)
                .id(TUIFloatingContainerButtonIdentity(primary).shape)
                .transition(TUIFloatingContainerSlideTransition(bottom: motionBottom))
            }
            .frame(height: primaryHeight, alignment: .top)
            .animation(TUIFloatingContainerMetrics.entranceAnimation,
                       value: TUIFloatingContainerButtonIdentity(primary).shape)
            .animation(TUIFloatingContainerMetrics.entranceAnimation, value: primaryHeight)
            if hasSupplement {
                ZStack(alignment: .top) {
                    supplementaryContent.floatingContainerMeasureHeight(id: supplementMeasurementID)
                        .id(supplementIdentity)
                        .transition(.opacity)
                }
                .frame(height: supplementHeight, alignment: .top)
                .animation(swapAnimation, value: supplementIdentity)
                .animation(swapAnimation, value: supplementHeight)
                .transition(TUIFloatingContainerSlideTransition(bottom: motionBottom))
            }
        }
        .onPreferenceChange(TUIFloatingContainerMeasuredHeightsKey.self) { measuredHeights = $0 }
        .preference(key: TUIFloatingContainerTargetLayoutKey.self, value: targetLayout)
        .animation(hasSupplement ? TUIFloatingContainerMetrics.entranceAnimation
            : TUIFloatingContainerMetrics.exitAnimation, value: hasSupplement)
    }

    @ViewBuilder private var supplementaryContent: some View {
        if let secondary {
            secondary.padding(.top, TUISpacing.x2).padding(.bottom, TUISpacing.x4)
        } else if let legalText {
                Text(legalText)
                    .tuiTypography(.uiSmall)
                    .foregroundStyle(TUIColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, minHeight: TUISpacing.x12, alignment: .top)
                    .padding(.top, TUISpacing.x4)
        }
    }
}

private struct TUIFloatingContainerMeasuredHeightsKey: PreferenceKey {
    static let defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, incoming in incoming })
    }
}
private struct TUIFloatingContainerTargetLayout: Equatable, Sendable {
    var height: CGFloat
    var preset: TUIFloatingContainerPreset
}
private struct TUIFloatingContainerTargetLayoutKey: PreferenceKey {
    static let defaultValue: TUIFloatingContainerTargetLayout? = nil
    static func reduce(value: inout TUIFloatingContainerTargetLayout?,
                       nextValue: () -> TUIFloatingContainerTargetLayout?) {
        if let next = nextValue() { value = next }
    }
}
private extension View {
    /// Measure the incoming node before its transition. A transition's ZStack
    /// can retain the outgoing, taller view and must not determine target size.
    func floatingContainerMeasureHeight(id: String) -> some View {
        fixedSize(horizontal: false, vertical: true)
            .background {
                GeometryReader { geometry in
                    Color.clear.preference(key: TUIFloatingContainerMeasuredHeightsKey.self,
                        value: [id: geometry.size.height])
                }
            }
    }
}

private struct TUIFloatingContainerButtonIdentity {
    let content: String
    let shape: String
    init(_ button: TUIButton) {
        // Loading/pressed/disabled belong to TUIButton's own state behavior;
        // changing them must not replace or resize the action's identity.
        content = [button.title, button.appearance.rawValue, button.size.rawValue,
                   String(button.showsIcon), String(button.showsLabel)].joined(separator: "\u{1F}")
        shape = [button.size.rawValue, String(button.showsLabel),
                 String(describing: button.width), String(describing: button.cornerRadius)].joined(separator: "\u{1F}")
    }
}

enum TUIFloatingContainerMetrics {
    static let fadeHeight: CGFloat = 46
    static let entranceDuration: Double = TUIMotionDuration.slow.seconds
    // The Guide specifies 200 ms explicitly; Primitive/fast is 150 ms.
    static let exitDuration: Double = 0.2
    static var entranceAnimation: Animation { TUIMotionCurve.expressiveEntrance.animation(duration: .slow) }
    static var exitAnimation: Animation {
        .timingCurve(TUIMotionCurve.productiveExit.unitCurve, duration: exitDuration)
    }
    static var primaryFadeAnimation: Animation { TUIMotionCurve.productiveExit.animation(duration: .fastest) }
    static var supplementFadeEntranceAnimation: Animation {
        .timingCurve(TUIMotionCurve.productiveStandard.unitCurve, duration: 0.2)
    }
    fileprivate static func layoutAnimation(from previous: TUIFloatingContainerTargetLayout,
                                            to next: TUIFloatingContainerTargetLayout) -> Animation {
        if previous.preset == .twoActions && next.preset == .actionLegal {
            return supplementFadeEntranceAnimation
        }
        if previous.preset == .actionLegal && next.preset == .twoActions {
            return TUIMotionCurve.productiveStandard.animation(duration: .moderate)
        }
        return next.preset == .action && previous.preset != .action
            ? exitAnimation : entranceAnimation
    }
}

private struct TUIFloatingContainerMotionBottom: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}
private extension EnvironmentValues {
    var tuiFloatingContainerMotionBottom: CGFloat {
        get { self[TUIFloatingContainerMotionBottom.self] }
        set { self[TUIFloatingContainerMotionBottom.self] = newValue }
    }
}

/// Each phase owns its source timing. An enclosing layout animation must not
/// lengthen a removal to the insertion's duration during a replacement.
private struct TUIFloatingContainerSlideTransition: Transition {
    let bottom: CGFloat
    func body(content: Content, phase: TransitionPhase) -> some View {
        content.modifier(TUIFloatingContainerSlidePhase(bottom: bottom, phase: phase))
    }
}

private struct TUIFloatingContainerSlidePhase: ViewModifier {
    let bottom: CGFloat
    let phase: TransitionPhase
    @State private var travel: CGFloat?

    func body(content: Content) -> some View {
        let isIdentity = phase.isIdentity
        let screenBottom = bottom
        let travel = travel
        content.onGeometryChange(for: CGFloat.self) { geometry in
            max(geometry.size.height, screenBottom - geometry.frame(in: .global).minY)
        } action: { distance in
            // Freeze the outgoing distance. An animated parent changes global
            // geometry every frame; retargeting its exit would keep it alive.
            if self.travel == nil || phase.isIdentity { self.travel = distance }
        }
        .animation(phase == .didDisappear ? TUIFloatingContainerMetrics.exitAnimation
            : TUIFloatingContainerMetrics.entranceAnimation) { @Sendable view in
            view.visualEffect { effect, geometry in
                effect.offset(y: isIdentity ? 0 : travel ?? max(geometry.size.height,
                    screenBottom - geometry.frame(in: .global).minY))
            }
        }
        .allowsHitTesting(phase != .didDisappear)
    }
}

private struct TUIFloatingContainerFadeTransition: Transition {
    let entrance: Animation
    let exit: Animation
    func body(content: Content, phase: TransitionPhase) -> some View {
        let opacity = phase.isIdentity ? 1.0 : 0.0
        content.animation(phase == .didDisappear ? exit : entrance) { @Sendable view in
            view.opacity(opacity)
        }
            .allowsHitTesting(phase != .didDisappear)
    }
}

private struct TUIFloatingContainerPlacement<Footer: View>: ViewModifier {
    let isPresented: Bool
    let replacementID: AnyHashable?
    let replacementKind: TUIFloatingContainerReplacementKind
    let footer: Footer
    @State private var bottom: CGFloat = 0
    @State private var targetLayout: TUIFloatingContainerTargetLayout?

    func body(content: Content) -> some View {
        content.safeAreaInset(edge: .bottom, spacing: TUISpacing.x5) {
            if isPresented {
                ZStack {
                    if replacementKind == .sameShape {
                        footer.id(replacementID).transition(TUIFloatingContainerFadeTransition(
                            entrance: TUIFloatingContainerMetrics.primaryFadeAnimation,
                            exit: TUIFloatingContainerMetrics.primaryFadeAnimation))
                    } else {
                        footer.id(replacementID).transition(TUIFloatingContainerSlideTransition(bottom: bottom))
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: targetLayout?.height, alignment: .top)
                .geometryGroup()
                .environment(\.tuiFloatingContainerMotionBottom, bottom)
                .transition(TUIFloatingContainerSlideTransition(bottom: bottom))
            }
        }
        .onPreferenceChange(TUIFloatingContainerTargetLayoutKey.self) { next in
            guard let next, next.height > 0, next != targetLayout else { return }
            let animation = targetLayout.map { TUIFloatingContainerMetrics.layoutAnimation(from: $0, to: next) }
            withAnimation(animation) { targetLayout = next }
        }
        .onChange(of: isPresented) { _, visible in
            if !visible { targetLayout = nil }
        }
        .onGeometryChange(for: CGFloat.self) { geometry in
            // Actual consumer window/safe area, including split-screen and
            // keyboard changes. No global UIScreen size or fake home bar.
            geometry.frame(in: .global).maxY + geometry.safeAreaInsets.bottom
        } action: { bottom = $0 }
        .animation(isPresented ? TUIFloatingContainerMetrics.entranceAnimation
            : TUIFloatingContainerMetrics.exitAnimation, value: isPresented)
        .animation(replacementKind == .sameShape ? TUIFloatingContainerMetrics.primaryFadeAnimation
            : TUIFloatingContainerMetrics.entranceAnimation, value: replacementID)
    }
}

public extension View {
    /// Native placement with the Guide's 20 pt end-of-scroll gap and block
    /// entrance/exit motion. A keyboard reduces this safe area naturally.
    func tuiFloatingContainer<Content: View>(isPresented: Bool = true,
        replacementID: AnyHashable? = nil,
        replacementKind: TUIFloatingContainerReplacementKind = .differentShape,
        @ViewBuilder content: () -> Content) -> some View {
        modifier(TUIFloatingContainerPlacement(isPresented: isPresented,
            replacementID: replacementID, replacementKind: replacementKind, footer: content()))
    }
}

#Preview("Two actions · Day") {
    Color.gray.opacity(0.1).tuiFloatingContainer {
        TUIFloatingContainer(primary: TUIButton("Продолжить") {},
            secondary: TUIButton("Отмена", appearance: .flat) {})
    }
}

#Preview("Legal · Night") {
    Color.black.tuiFloatingContainer {
        TUIFloatingContainer(primary: TUIButton("Продолжить") {},
            legalText: "Продолжая, вы соглашаетесь с условиями", background: .elevation1)
    }.preferredColorScheme(.dark)
}
