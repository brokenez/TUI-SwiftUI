import SwiftUI
import Testing
@testable import TUIDesignSystem

@Test func skeletonPrototypeUsesBothSourceTransitions() {
    #expect(TUISkeletonMotion.transitionDuration == 0.5)
    #expect(TUISkeletonMotion.triggerDelay == 0.001)
    for keyframe in TUISkeletonKeyframe.allCases {
        let start = keyframe == .first ? 1.0 : 0.5
        let end = keyframe == .first ? 0.5 : 1.0
        #expect(TUISkeletonMotion.opacity(at: 0, startingAt: keyframe) == start)
        #expect(TUISkeletonMotion.opacity(at: 0.0005, startingAt: keyframe) == start)
        #expect(abs(TUISkeletonMotion.opacity(at: 0.501, startingAt: keyframe) - end) < 0.00001)
        #expect(abs(TUISkeletonMotion.opacity(at: 1.002, startingAt: keyframe) - start) < 0.00001)

        // Independently invert the exact Figma Bézier x coordinate.
        // Both legs use this same curve; an autoreversed curve would fail the second leg.
        for step in 1..<100 {
            let progress = Double(step) / 100
            var lower = 0.0
            var upper = 1.0
            for _ in 0..<50 {
                let t = (lower + upper) / 2
                let x = 3 * (1 - t) * (1 - t) * t * 0.2
                    + 3 * (1 - t) * t * t * 0.4 + t * t * t
                if x < progress { lower = t } else { upper = t }
            }
            let t = (lower + upper) / 2
            let eased = 3 * (1 - t) * t * t * 0.9 + t * t * t
            let firstLeg = TUISkeletonMotion.opacity(
                at: 0.001 + progress * 0.5, startingAt: keyframe)
            let secondLeg = TUISkeletonMotion.opacity(
                at: 0.502 + progress * 0.5, startingAt: keyframe)
            #expect(abs(firstLeg - (start + (end - start) * eased)) < 0.0001)
            #expect(abs(secondLeg - (end + (start - end) * eased)) < 0.0001)
        }
    }
}

@Test @MainActor func skeletonStopsForReducedMotionAndInactiveScenes() {
    #expect(TUISkeletonMotion.shouldAnimate(isAnimating: true, reduceMotion: false, scenePhase: .active))
    #expect(!TUISkeletonMotion.shouldAnimate(isAnimating: false, reduceMotion: false, scenePhase: .active))
    #expect(!TUISkeletonMotion.shouldAnimate(isAnimating: true, reduceMotion: true, scenePhase: .active))
    #expect(!TUISkeletonMotion.shouldAnimate(isAnimating: true, reduceMotion: false, scenePhase: .inactive))
    #expect(!TUISkeletonMotion.shouldAnimate(isAnimating: true, reduceMotion: false, scenePhase: .background))
    #expect(TUISkeleton().isAnimating)
    #expect(TUISkeletonText().isAnimating)
}
