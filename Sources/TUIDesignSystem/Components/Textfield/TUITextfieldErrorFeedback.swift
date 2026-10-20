import SwiftUI
import UIKit

/// Guide 4859:6710 defines the positions, total durations and productive-standard
/// curve. Equally spaced progress knots are an implementation choice: the
/// source does not provide the timing of individual shake steps.
struct TUITextfieldErrorMotion {
    let repeated: Bool
    var positions: [CGFloat] { repeated ? [0, -3, 3, 0] : [0, -3, 3, -3, 3, 0] }
    var duration: TUIMotionDuration { repeated ? .moderate : .slow }

    func offset(progress: Double) -> CGFloat {
        let values = positions
        let progress = min(1, max(0, progress)) * Double(values.count - 1)
        let index = min(values.count - 2, Int(progress))
        let fraction = CGFloat(progress - Double(index))
        return values[index] + (values[index + 1] - values[index]) * fraction
    }
}

struct TUITextfieldErrorFeedback: ViewModifier {
    let isInvalid: Bool
    let validationTrigger: Int
    let isEnabled: Bool
    @State private var hasValidatedError: Bool
    @State private var repeated = false
    @State private var revision = 0

    init(isInvalid: Bool, validationTrigger: Int, isEnabled: Bool) {
        self.isInvalid = isInvalid; self.validationTrigger = validationTrigger; self.isEnabled = isEnabled
        _hasValidatedError = State(initialValue: isInvalid)
    }

    private struct Request: Equatable {
        let invalid: Bool
        let trigger: Int
        let enabled: Bool
        func needsFeedback(after old: Request) -> Bool {
            enabled && invalid && (!old.invalid || trigger != old.trigger)
        }
    }

    func body(content: Content) -> some View {
        content.keyframeAnimator(initialValue: 0.0, trigger: revision) { view, progress in
            view.offset(x: isEnabled && isInvalid
                ? TUITextfieldErrorMotion(repeated: repeated).offset(
                    progress: TUIMotionCurve.productiveStandard.unitCurve.value(at: progress)) : 0)
        } keyframes: { _ in
            MoveKeyframe(0.0)
            LinearKeyframe(1.0, duration: TUITextfieldErrorMotion(repeated: repeated).duration.seconds)
        }
            .onChange(of: Request(invalid: isInvalid, trigger: validationTrigger, enabled: isEnabled)) { old, new in
                // Initial invalid render and focus changes are not validation events.
                guard new.needsFeedback(after: old) else { return }
                repeated = hasValidatedError; hasValidatedError = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                revision += 1
            }
    }
}
