import SwiftUI

public enum TUIRowCardMediumPreset: String, CaseIterable, Sendable {
    case x140 = "140x140"
    case x92 = "92x92"

    public var figmaNodeID: String {
        switch self {
        case .x140: "16273:42830"
        case .x92: "16753:50831"
        }
    }

    var dimension: CGFloat { self == .x140 ? 140 : 92 }
    fileprivate var spacing: CGFloat { self == .x140 ? TUISpacing.x3 : TUISpacing.x2 }
}

/// A clipped row of medium cards. Content remains static because the Figma set
/// specifies layout presets, not an intrinsic card action.
public struct TUIRowCardMedium: View {
    public let preset: TUIRowCardMediumPreset
    public let titles: [String]
    public let subtitles: [String]

    public init(
        preset: TUIRowCardMediumPreset = .x140,
        titles: [String] = Array(repeating: "Title", count: 5),
        subtitles: [String] = Array(repeating: "Subtitle", count: 5)
    ) {
        self.preset = preset
        self.titles = titles
        self.subtitles = subtitles
    }

    public var body: some View {
        HStack(spacing: preset.spacing) {
            ForEach(0..<5, id: \.self) { index in
                card(at: index)
            }
        }
        .padding(.horizontal, TUISpacing.x4)
        .frame(width: 375, alignment: .leading)
        .clipped()
        .accessibilityIdentifier(preset.figmaNodeID)
    }

    @ViewBuilder
    private func card(at index: Int) -> some View {
        VStack(alignment: .leading, spacing: TUISpacing.x3) {
            if preset == .x140 {
                ZStack {
                    Circle().fill(TUIColor.named("Background/Accent 2", fallback: 0x428BF9))
                        .frame(width: 56, height: 56)
                    TUIRowCardMediumStarMark()
                        .fill(LinearGradient(
                            stops: [
                                .init(color: .white, location: 0),
                                .init(color: .white.opacity(0.65), location: 1)
                            ],
                            startPoint: UnitPoint(x: 7.95807 / 34, y: 11.1792 / 34),
                            endPoint: UnitPoint(x: 24.9503 / 34, y: 26.0479 / 34)
                        ))
                        .frame(width: 34, height: 34)
                }
                .accessibilityHidden(true)
            } else {
                TUIRowCardMediumNoteMark()
                    .frame(width: 30, height: 30)
                    .accessibilityHidden(true)
            }

            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: TUISpacing.x1) {
                Text(value(titles, at: index, fallback: "Title"))
                    .tuiTypography(preset == .x140 ? .uiMediumBold : .uiXSmallBold)
                    .foregroundStyle(TUIColor.named("Text/Primary", fallback: 0x333333))
                    .lineLimit(preset == .x140 ? 2 : 1)
                if preset == .x140 {
                    Text(value(subtitles, at: index, fallback: "Subtitle"))
                        .tuiTypography(.uiSmall)
                        .foregroundStyle(TUIColor.named("Text/Primary", fallback: 0x333333))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, TUISpacing.x3)
        .padding(.horizontal, TUISpacing.x3)
        .padding(.bottom, 10)
        .frame(width: preset.dimension, height: preset.dimension, alignment: .topLeading)
        .background(TUIColor.named("Background/Neutral 1 Opaque", fallback: 0xF6F7F8))
        .clipShape(RoundedRectangle(cornerRadius: TUIRadius.medium))
    }

    private func value(_ values: [String], at index: Int, fallback: String) -> String {
        values.indices.contains(index) ? values[index] : fallback
    }
}

/// The Figma SVG uses a mask gradient that the system SVG renderer drops.
/// These paths preserve its original geometry and gradient using native SwiftUI drawing.
private struct TUIRowCardMediumStarMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: point(18.1054, 2.54257, in: rect))
        path.addCurve(to: point(15.8946, 2.54257, in: rect), control1: point(17.6661, 1.60812, in: rect), control2: point(16.3481, 1.60812, in: rect))
        path.addLine(to: point(12.2664, 11.7313, in: rect))
        path.addLine(to: point(2.50173, 12.0428, in: rect))
        path.addCurve(to: point(1.82146, 14.1666, in: rect), control1: point(1.45298, 12.1561, in: rect), control2: point(1.04198, 13.4587, in: rect))
        path.addLine(to: point(9.33278, 20.198, in: rect))
        path.addLine(to: point(6.89515, 29.4151, in: rect))
        path.addCurve(to: point(8.68086, 30.7318, in: rect), control1: point(6.68256, 30.4345, in: rect), control2: point(7.75966, 31.2274, in: rect))
        path.addLine(to: point(17, 25.4366, in: rect))
        path.addLine(to: point(25.3191, 30.7318, in: rect))
        path.addCurve(to: point(27.1049, 29.4151, in: rect), control1: point(26.2262, 31.2274, in: rect), control2: point(27.3033, 30.4345, in: rect))
        path.addLine(to: point(24.6672, 20.198, in: rect))
        path.addLine(to: point(32.1785, 14.1666, in: rect))
        path.addCurve(to: point(31.4983, 12.0428, in: rect), control1: point(32.958, 13.4587, in: rect), control2: point(32.547, 12.1702, in: rect))
        path.addLine(to: point(21.7335, 11.7313, in: rect))
        path.closeSubpath()
        return path
    }

    private func point(_ x: CGFloat, _ y: CGFloat, in rect: CGRect) -> CGPoint {
        CGPoint(x: rect.minX + x / 34 * rect.width, y: rect.minY + y / 34 * rect.height)
    }
}

private struct TUIRowCardMediumNoteMark: View {
    private var accent: Color { TUIColor.named("Background/Accent 2", fallback: 0x428BF9) }

    var body: some View {
        ZStack {
            TUIRowCardMediumNoteShape()
                .fill(LinearGradient(
                    stops: [
                        .init(color: accent, location: 0),
                        .init(color: accent.opacity(0.7), location: 1)
                    ],
                    startPoint: UnitPoint(x: 18.5 / 30, y: 16 / 30),
                    endPoint: UnitPoint(x: 3.79101 / 30, y: -1.80562 / 30)
                ), style: FillStyle(eoFill: true))
            Path { path in
                path.move(to: CGPoint(x: 27.5, y: 18.75))
                path.addLine(to: CGPoint(x: 19.375, y: 18.75))
                path.addLine(to: CGPoint(x: 19.375, y: 26.875))
                path.closeSubpath()
            }
            .fill(.black.opacity(0.4))
        }
    }
}

private struct TUIRowCardMediumNoteShape: Shape {
    func path(in rect: CGRect) -> Path {
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + x / 30 * rect.width, y: rect.minY + y / 30 * rect.height)
        }
        var path = Path()
        path.move(to: p(22.5, 4.375))
        path.addCurve(to: p(27.5, 9.375), control1: p(25.2614, 4.375), control2: p(27.5, 6.61358))
        path.addLine(to: p(27.5, 18.75))
        path.addLine(to: p(19.375, 18.75))
        path.addLine(to: p(19.375, 26.875))
        path.addLine(to: p(7.5, 26.875))
        path.addCurve(to: p(2.5, 21.875), control1: p(4.73858, 26.875), control2: p(2.5, 24.6364))
        path.addLine(to: p(2.5, 4.375))
        path.closeSubpath()
        path.move(to: p(13.6255, 13.6255))
        path.addLine(to: p(10.2502, 13.6255))
        path.addLine(to: p(10.2502, 16.6248))
        path.addLine(to: p(13.6255, 16.6248))
        path.addLine(to: p(13.6255, 19.7498))
        path.addLine(to: p(16.6248, 19.7498))
        path.addLine(to: p(16.6248, 16.6248))
        path.addLine(to: p(19.7498, 16.6248))
        path.addLine(to: p(19.7498, 13.6255))
        path.addLine(to: p(16.6248, 13.6255))
        path.addLine(to: p(16.6248, 10.2502))
        path.addLine(to: p(13.6255, 10.2502))
        path.closeSubpath()
        return path
    }
}
