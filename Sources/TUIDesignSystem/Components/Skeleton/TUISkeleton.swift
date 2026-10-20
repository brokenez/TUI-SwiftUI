import SwiftUI

public enum TUISkeletonKeyframe: String, CaseIterable, Sendable {
    case first = "1"
    case second = "2"
}

/// The looping opacity prototype supplied by Figma. Disable animation to inspect a keyframe.
public struct TUISkeleton: View {
    public let keyframe: TUISkeletonKeyframe
    public let width: CGFloat
    public let height: CGFloat
    public let isAnimating: Bool
    /// The source component uses 4 pt; instances can override its geometry.
    public let cornerRadius: CGFloat
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var startedAt = Date()

    public init(
        keyframe: TUISkeletonKeyframe = .first,
        width: CGFloat = 40,
        height: CGFloat = 40,
        isAnimating: Bool = true,
        cornerRadius: CGFloat = TUIRadius.xSmall
    ) {
        self.keyframe = keyframe
        self.width = width
        self.height = height
        self.isAnimating = isAnimating
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        TimelineView(.animation(paused: !shouldAnimate)) { context in
            RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                .fill(TUIColor.named("Service/Skeleton"))
                .opacity(shouldAnimate
                    ? TUISkeletonMotion.opacity(at: context.date.timeIntervalSince(startedAt), startingAt: keyframe)
                    : TUISkeletonMotion.opacity(of: keyframe))
                .frame(width: width, height: height)
        }
        .onAppear { startedAt = Date() }
        .onChange(of: shouldAnimate) { _, _ in startedAt = Date() }
        .onChange(of: keyframe) { _, _ in startedAt = Date() }
        .accessibilityHidden(true)
    }

    private var shouldAnimate: Bool {
        TUISkeletonMotion.shouldAnimate(isAnimating: isAnimating,
            reduceMotion: reduceMotion, scenePhase: scenePhase)
    }
}

enum TUISkeletonMotion {
    // Figma AFTER_TIMEOUT on both keyframes; transition uses foundation tokens.
    static let triggerDelay = 0.001
    static var transitionDuration: Double { TUIMotionDuration.slow.seconds }
    static var legDuration: Double { triggerDelay + transitionDuration }
    static let curve = TUIMotionCurve.productiveStandard.unitCurve

    static func shouldAnimate(isAnimating: Bool, reduceMotion: Bool, scenePhase: ScenePhase) -> Bool {
        isAnimating && !reduceMotion && scenePhase == .active
    }

    static func opacity(of keyframe: TUISkeletonKeyframe) -> Double {
        keyframe == .first ? 1 : 0.5
    }

    static func opacity(at elapsed: Double, startingAt keyframe: TUISkeletonKeyframe) -> Double {
        let time = max(0, elapsed).truncatingRemainder(dividingBy: 2 * legDuration)
        let reverse = time >= legDuration
        let localTime = reverse ? time - legDuration : time
        let progress = min(1, max(0, (localTime - triggerDelay) / transitionDuration))
        let startsDimmed = (keyframe == .second) != reverse
        let start = startsDimmed ? 0.5 : 1.0
        let end = startsDimmed ? 1.0 : 0.5
        return start + (end - start) * curve.value(at: progress)
    }
}
