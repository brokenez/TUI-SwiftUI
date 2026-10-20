import SwiftUI

/// An interactive quantity counter matching the iOS `tui-counter` component.
public struct TUICounter: View {
    public enum Size: String, CaseIterable, Sendable, Hashable {
        case large
        case medium
        case small

        var height: CGFloat {
            switch self {
            case .large: 56
            case .medium: 44
            case .small: 32
            }
        }

        var controlWidth: CGFloat { height }

        var cornerRadius: CGFloat {
            switch self {
            case .large: TUIRadius.large
            case .medium: TUIRadius.medium
            case .small: TUIRadius.round
            }
        }

        var typography: TUITypographyRole {
            switch self {
            case .large: .headingMedium
            case .medium: .headingSmall
            case .small: .uiSmallBold
            }
        }

        var figmaNodes: [Preset: String] {
            switch self {
            case .large:
                [.primary: "16661:51923", .secondary: "16661:51937", .secondarySeparated: "16661:51951"]
            case .medium:
                [.primary: "16661:51965", .secondary: "16661:51979", .secondarySeparated: "16661:51993"]
            case .small:
                [.primary: "16661:52007", .secondary: "16661:52021", .secondarySeparated: "16661:52035"]
            }
        }
    }

    public enum Preset: String, CaseIterable, Sendable, Hashable {
        case primary = "Primary"
        case secondary = "Secondary"
        case secondarySeparated = "Secondary Separated"
    }

    @Binding private var value: Int
    public let size: Size
    public let preset: Preset

    public init(value: Binding<Int>, size: Size = .large, preset: Preset = .primary) {
        self._value = value
        self.size = size
        self.preset = preset
    }

    public var figmaNodeID: String { size.figmaNodes[preset]! }

    private var foreground: Color {
        preset == .primary
            ? TUIColor.named("Text/Primary On T-Bank", fallback: 0x333333)
            : TUIColor.named("Text/Action", fallback: 0x428BF9)
    }

    private var rootFill: Color {
        switch preset {
        case .primary: TUIColor.accent
        case .secondary: TUIColor.named("Background/Neutral 1", fallback: 0xF7F7F8)
        case .secondarySeparated: .clear
        }
    }

    public var body: some View {
        HStack(spacing: 0) {
            actionButton(direction: .decrement)
            Spacer(minLength: 0)
            Text("\(value) шт")
                .tuiTypography(size.typography)
                .foregroundStyle(TUIColor.named("Text/Primary", fallback: 0x333333))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(minWidth: size.controlWidth)
                .accessibilityIdentifier("tuiCounterValue")
            Spacer(minLength: 0)
            actionButton(direction: .increment)
        }
        .frame(width: 200, height: size.height)
        .background(rootFill)
        .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(figmaNodeID)
    }

    private enum Direction { case decrement, increment }

    @ViewBuilder
    private func actionButton(direction: Direction) -> some View {
        let isSeparated = preset == .secondarySeparated
        let assetName = direction == .decrement ? "tui-counter-minus" : "tui-counter-plus"
        let targetNode = direction == .decrement ? "92339:29385" : "88181:44120"
        Button {
            value += direction == .increment ? 1 : -1
        } label: {
            Group {
                Image(assetName, bundle: .module)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: size == .small && direction == .decrement ? 24 : (size == .small ? 18 : 24),
                        height: size == .small && direction == .decrement ? 24 : (size == .small ? 18 : 24)
                    )
                    .foregroundStyle(foreground)
                    .frame(width: size == .small ? 16 : 24, height: size == .small ? 16 : 24)
                    .clipped()
            }
            .frame(width: size == .small ? 16 : 24, height: size == .small ? 16 : 24)
                .frame(width: size.controlWidth, height: size.height)
                .background(isSeparated ? TUIColor.named("Background/Neutral 1", fallback: 0xF7F7F8) : .clear)
                .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(direction == .decrement ? "Уменьшить количество" : "Увеличить количество")
        .accessibilityIdentifier("\(direction == .decrement ? "decrement" : "increment")-\(targetNode)")
    }
}
