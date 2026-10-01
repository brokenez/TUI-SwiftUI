import SwiftUI

public enum TUISkeletonKeyframe: String, CaseIterable, Sendable {
    case first = "1"
    case second = "2"
}

/// The two opacity keyframes supplied by the Figma `tui-skeleton` component.
public struct TUISkeleton: View {
    public let keyframe: TUISkeletonKeyframe
    public let width: CGFloat
    public let height: CGFloat

    public init(
        keyframe: TUISkeletonKeyframe = .first,
        width: CGFloat = 40,
        height: CGFloat = 40
    ) {
        self.keyframe = keyframe
        self.width = width
        self.height = height
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: TUIRadius.xSmall)
            .fill(TUIColor.named("Service/Skeleton"))
            .opacity(keyframe == .second ? 0.5 : 1)
            .frame(width: width, height: height)
            .accessibilityHidden(true)
    }
}
