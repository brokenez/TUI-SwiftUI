import SwiftUI

public enum TUILoaderSize: Int, CaseIterable, Sendable {
    case x12 = 12
    case x16 = 16
    case x24 = 24
    case x32 = 32
    case x40 = 40

    /// Component node exported from the Figma size matrix.
    public var figmaNodeID: String {
        switch self {
        case .x12: "42819:293394"
        case .x16: "42678:293418"
        case .x24: "42819:293395"
        case .x32: "42977:286792"
        case .x40: "43680:292637"
        }
    }
}

/// Loader Guide: a four-second trim cycle and one rotation every two seconds.
/// `isAnimating: false` shows the source pose for inspection, rather than freezing elapsed time.
/// The caller owns loading visibility and should normally retain it for at least 500 ms.
public struct TUILoader: View {
    public static let figmaComponentSetID = "9999:26"
    public static let recommendedMinimumVisibleDuration: Duration = .milliseconds(500)
    public let size: TUILoaderSize
    public let color: Color?
    public let diameter: CGFloat
    public let lineWidth: CGFloat
    public let isAnimating: Bool
    private let usesSourceContour: Bool
    @Environment(\.scenePhase) private var scenePhase
    @State private var startedAt = Date()

    public init(
        size: TUILoaderSize = .x24,
        color: Color? = nil,
        diameter: CGFloat? = nil,
        lineWidth: CGFloat? = nil,
        isAnimating: Bool = true
    ) {
        self.size = size
        self.color = color
        let resolvedDiameter = diameter.flatMap { $0.isFinite ? $0 : nil } ?? CGFloat(size.rawValue)
        self.diameter = max(1.5, resolvedDiameter)
        let resolvedWidth = lineWidth.flatMap { $0.isFinite ? $0 : nil } ?? self.diameter / 12
        self.lineWidth = min(self.diameter, max(1.5, resolvedWidth))
        self.isAnimating = isAnimating
        usesSourceContour = diameter == nil && lineWidth == nil
    }

    /// The selected base Figma variant; custom geometry is an instance override.
    public var figmaNodeID: String { size.figmaNodeID }

    public var body: some View {
        TimelineView(.animation(paused: !shouldAnimate)) { context in
            if !shouldAnimate && usesSourceContour {
                if let color {
                    sourceContour.renderingMode(.template).foregroundStyle(color)
                } else {
                    sourceContour
                }
            } else {
                let frame = shouldAnimate
                    ? TUILoaderMotion.frame(at: context.date.timeIntervalSince(startedAt))
                    : TUILoaderMotion.sourcePose
                Circle()
                    .trim(from: frame.start, to: frame.end)
                    .stroke(color ?? TUIColor.named("Brand/T-Bank"), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .padding(lineWidth / 2)
                    .rotationEffect(.degrees(frame.rotation))
            }
        }
        .frame(width: diameter, height: diameter)
        .onAppear { startedAt = Date() }
        .onChange(of: shouldAnimate) { _, _ in startedAt = Date() }
        .accessibilityLabel("Загрузка")
        .accessibilityIdentifier(figmaNodeID)
    }

    private var sourceContour: Image {
        Image("tui-loader-\(size.rawValue)", bundle: .module).resizable()
    }

    private var shouldAnimate: Bool { isAnimating && scenePhase == .active }
}

enum TUILoaderMotion {
    struct Frame: Equatable {
        let start: CGFloat
        let end: CGFloat
        let rotation: Double
    }

    static let sourcePose = Frame(start: 0, end: 0.8, rotation: 0)

    static func frame(at elapsed: TimeInterval) -> Frame {
        let time = (elapsed.isFinite ? max(0, elapsed) : 0).truncatingRemainder(dividingBy: 4)
        return Frame(
            start: time <= 2 ? 0 : CGFloat((time - 2) / 2) * 0.95,
            end: time <= 2 ? CGFloat(time / 2) * 0.95 : 0.95,
            rotation: time * 180
        )
    }
}

#Preview("Loader · Sizes and customization") {
    VStack(spacing: TUISpacing.x6) {
        HStack(spacing: TUISpacing.x6) {
            ForEach(TUILoaderSize.allCases, id: \.self) { TUILoader(size: $0) }
        }
        HStack(spacing: TUISpacing.x6) {
            TUILoader(color: TUIColor.action, diameter: 18)
            TUILoader(diameter: 28, lineWidth: 3)
            TUILoader(diameter: 36, lineWidth: 4)
        }
    }
    .padding(TUISpacing.x6)
}
