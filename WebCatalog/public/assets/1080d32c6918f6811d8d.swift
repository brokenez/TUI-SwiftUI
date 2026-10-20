import SwiftUI
import UIKit

/// Branded Apple Wallet action with the two iOS dimensions from TUI Mobile.
public struct TUIButtonWallet: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .body) private var labelFontSize = TUITypographyRole.bodyLarge.metrics.size
    public enum Size: String, CaseIterable, Sendable {
        case large = "L - 56"
        case medium = "M - 44"

        public var width: CGFloat { self == .large ? 343 : 290 }
        public var height: CGFloat { self == .large ? 56 : 48 }
        public var figmaNodeID: String { self == .large ? "54757:286089" : "54757:286101" }
        fileprivate var assetName: String { self == .large ? "tui-button-wallet-large" : "tui-button-wallet-medium" }
        fileprivate var iconSize: CGSize { self == .large ? CGSize(width: 36, height: 28) : CGSize(width: 35.486, height: 27.574) }
        fileprivate var iconLeading: CGFloat { self == .large ? 44 : 28 }
        fileprivate var iconTop: CGFloat { self == .large ? 14 : 10 }
        fileprivate var labelLeading: CGFloat { self == .large ? 100 : 72 }
        fileprivate var labelTop: CGFloat { self == .large ? 17.5 : 13 }
        fileprivate var labelWidth: CGFloat { self == .large ? 199 : width - labelLeading - 8 }
    }

    public let size: Size
    public let prefix: String
    public let action: () -> Void

    public init(
        size: Size = .large,
        prefix: String = "Добавить в ",
        action: @escaping () -> Void = {}
    ) {
        self.size = size
        self.prefix = prefix
        self.action = action
    }

    public var body: some View {
        let accessible = dynamicTypeSize.isAccessibilitySize
        let iconScale: CGFloat = accessible ? 1.25 : 1
        let iconWidth = size.iconSize.width * iconScale
        let labelLeading = accessible ? TUISpacing.x4 + iconWidth + TUISpacing.x5 : size.labelLeading
        let labelWidth = accessible ? size.width - labelLeading - TUISpacing.x2 : size.labelWidth
        let title = prefix + "Apple Wallet"
        let textWidth = (title as NSString).size(withAttributes: [
            .font: TUIFigmaTextFont.regular(size: labelFontSize), .kern: -0.41
        ]).width
        let labelHeight = max(20, labelFontSize * 20 / 17)
        let height = max(size.height, accessible ? labelHeight + TUISpacing.x4 : size.height)
        let labelTop = accessible ? (height - labelHeight) / 2 : size.labelTop
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                Image(size.assetName, bundle: .module)
                    .resizable()
                    .frame(width: iconWidth, height: size.iconSize.height * iconScale)
                    .offset(x: accessible ? TUISpacing.x4 : size.iconLeading,
                            y: accessible ? (height - size.iconSize.height * iconScale) / 2 : size.iconTop)
                    .accessibilityHidden(true)
                Text(title)
                    .font(Font(TUIFigmaTextFont.regular(size: labelFontSize)))
                    .tracking(-0.41)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)
                    .frame(width: labelWidth, height: labelHeight, alignment: .leading)
                    .clipped()
                    .mask {
                        if textWidth > labelWidth {
                            LinearGradient(stops: [.init(color: .white, location: 0),
                                                   .init(color: .white, location: 0.85),
                                                   .init(color: .clear, location: 1)],
                                           startPoint: .leading, endPoint: .trailing)
                        } else {
                            Color.white
                        }
                    }
                    .offset(x: labelLeading, y: labelTop)
            }
            .frame(width: size.width, height: height, alignment: .topLeading)
            .background(.black, in: RoundedRectangle(cornerRadius: TUIRadius.large))
            .overlay {
                if size == .medium {
                    // This source layer uses an explicit brand border, not Border/Normal.
                    RoundedRectangle(cornerRadius: TUIRadius.large)
                        .strokeBorder(Color(red: 146.0 / 255, green: 153.0 / 255, blue: 162.0 / 255), lineWidth: 1)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: TUIRadius.large))
        }
        .buttonStyle(.plain)
        .frame(width: size.width, height: height)
        .accessibilityLabel(prefix + "Apple Wallet")
        .accessibilityIdentifier("tuiButtonWallet-\(size.figmaNodeID)")
    }
}
