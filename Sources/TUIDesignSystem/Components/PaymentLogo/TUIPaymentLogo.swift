import SwiftUI

/// A payment-network mark exported from the corresponding TUI Mobile Figma component.
public struct TUIPaymentLogo: View {
    public enum Network: String, CaseIterable, Identifiable, Sendable {
        case maestro
        case mastercard
        case mastercardGold = "mastercard-gold"
        case mastercardMetal = "mastercard-metal"
        case mastercardMetalInverse = "mastercard-metal-inverse"
        case mir
        case mirMonochrome = "mir-monochrome"
        case mirSupreme = "mir-supreme"
        case mirSupremeMetall = "mir-supreme-metall"
        case unionpay
        case unionpayMonochrome = "unionpay-monochrome"
        case visa
        case visaMonochrome = "visa-monochrome"

        public var id: String { rawValue }

        public var figmaNodeID: String {
            switch self {
            case .mastercardMetal: "45931:47329"
            case .maestro: "45931:47327"
            case .mastercard: "45931:47325"
            case .mastercardGold: "45931:47331"
            case .mastercardMetalInverse: "45931:47333"
            case .mir: "45931:47335"
            case .mirMonochrome: "45931:47337"
            case .unionpay: "45931:47339"
            case .unionpayMonochrome: "45931:47341"
            case .visa: "45931:47343"
            case .visaMonochrome: "45931:47345"
            case .mirSupreme: "98597:29047"
            case .mirSupremeMetall: "98597:29055"
            }
        }

        fileprivate var artworkWidth: CGFloat {
            switch self {
            case .mir, .mirMonochrome, .visa, .visaMonochrome: 40
            case .mirSupreme, .mirSupremeMetall: 35
            default: 32
            }
        }

        fileprivate var leadingInset: CGFloat {
            switch self {
            case .mir, .mirMonochrome, .visa, .visaMonochrome: 3
            case .mirSupreme, .mirSupremeMetall: 8
            default: 11
            }
        }
    }

    public let network: Network

    public init(_ network: Network = .mastercardMetal) {
        self.network = network
    }

    public var body: some View {
        HStack(spacing: 0) {
            Color.clear.frame(width: network.leadingInset)
            Image("tui-payment-logo-\(network.rawValue)", bundle: .module)
                .resizable()
                .interpolation(.high)
                .frame(width: network.artworkWidth, height: 24)
        }
        .frame(width: 43, height: 24, alignment: .leading)
        .clipped()
        .accessibilityHidden(true)
    }
}
