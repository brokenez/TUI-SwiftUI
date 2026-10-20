import SwiftUI

public enum TUIProgressCircleMode: String, CaseIterable, Sendable {
    case closed = "Closed"
    case open = "Open"

    fileprivate var startAngle: Double { self == .closed ? -90 : 135 }
    fileprivate var sweepAngle: Double { self == .closed ? 360 : 270 }
    public var figmaDefaultProgress: Double { 115.2 / sweepAngle }
}

public enum TUIProgressCirclePreset: String, CaseIterable, Sendable {
    case none = "None"
    case icon = "Icon"
    case text = "Text"
}

public enum TUIProgressCircleSize: Int, CaseIterable, Sendable {
    case x32 = 32, x40 = 40, x56 = 56, x64 = 64
    case x80 = 80, x96 = 96, x128 = 128

    fileprivate var textSize: CGFloat {
        switch self {
        case .x32, .x40: 9
        case .x56, .x64: 10
        case .x80: 14
        case .x96: 18
        case .x128: 24
        }
    }
}

/// Live, scalable implementation of the Figma `tui-progress-circle` component.
public struct TUIProgressCircle: View {
    public let progress: Double
    public let mode: TUIProgressCircleMode
    public let size: TUIProgressCircleSize
    public let preset: TUIProgressCirclePreset
    public let thickness: CGFloat
    public let skeleton: Bool
    public let label: String

    public init(
        progress: Double? = nil,
        mode: TUIProgressCircleMode = .closed,
        size: TUIProgressCircleSize = .x80,
        preset: TUIProgressCirclePreset = .none,
        thickness: CGFloat = 6,
        skeleton: Bool = false,
        label: String = "100%"
    ) {
        self.progress = min(max(progress ?? mode.figmaDefaultProgress, 0), 1)
        self.mode = mode
        self.size = size
        self.preset = preset
        self.thickness = thickness
        self.skeleton = skeleton
        self.label = label
    }

    public var body: some View {
        let dimension = CGFloat(size.rawValue)
        ZStack {
            TUIProgressArc(start: mode.startAngle, sweep: mode.sweepAngle, inset: thickness / 2)
                .stroke(
                    skeleton ? TUIColor.named("Service/Skeleton") : TUIColor.named("Background/Neutral 2"),
                    style: StrokeStyle(lineWidth: thickness, lineCap: .round)
                )
            if !skeleton && progress > 0 {
                TUIProgressArc(start: mode.startAngle, sweep: mode.sweepAngle * progress, inset: thickness / 2)
                    .stroke(
                        TUIColor.named("Status/Info"),
                        style: StrokeStyle(lineWidth: thickness, lineCap: .round)
                    )
            }
            if !skeleton {
                switch preset {
                case .none:
                    EmptyView()
                case .icon:
                    Image("tui-progress-mountains-flag", bundle: .module)
                        .resizable()
                        .frame(width: dimension / 2, height: dimension / 2)
                case .text:
                    Text(label)
                        .font(.system(size: size.textSize, weight: .bold, design: .rounded))
                        .foregroundStyle(TUIColor.textPrimary)
                }
            }
        }
        .frame(width: dimension, height: dimension)
        .accessibilityLabel("Прогресс")
        .accessibilityValue(skeleton ? "Загрузка" : "\(Int((progress * 100).rounded())) процентов")
    }
}

private struct TUIProgressArc: Shape {
    let start: Double
    let sweep: Double
    let inset: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (min(rect.width, rect.height) - 2 * inset) / 2
        let steps = max(2, Int(abs(sweep).rounded(.up)))
        var path = Path()
        for step in 0...steps {
            let radians = (start + sweep * Double(step) / Double(steps)) * .pi / 180
            let point = CGPoint(
                x: center.x + radius * cos(radians),
                y: center.y + radius * sin(radians)
            )
            if step == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        return path
    }
}
