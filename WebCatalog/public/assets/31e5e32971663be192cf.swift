import SwiftUI

/// Figma's decorative underline vectors; each style preserves its own variant set.
public struct TUIUnderline: View {
    public enum Style: String, CaseIterable, Identifiable, Sendable {
        case primary
        case secondary

        public var id: String { rawValue }

        public var figmaComponentSetID: String {
            switch self {
            case .primary: "55278:70654"
            case .secondary: "55278:70659"
            }
        }

        public func figmaVariantID(pseudo: Bool) -> String {
            switch (self, pseudo) {
            case (.primary, false): "55278:70655"
            case (.primary, true): "55278:70657"
            case (.secondary, false): "55278:70660"
            case (.secondary, true): "55278:70661"
            }
        }

        fileprivate func assetName(pseudo: Bool) -> String? {
            switch (self, pseudo) {
            case (.primary, false): "tui-underline-primary-no"
            case (.primary, true): "tui-underline-primary-yes"
            case (.secondary, false): nil
            case (.secondary, true): "tui-underline-secondary-yes"
            }
        }
    }

    public let style: Style
    public let pseudo: Bool

    public init(style: Style = .primary, pseudo: Bool = false) {
        self.style = style
        self.pseudo = pseudo
    }

    public var body: some View {
        Group {
            if let assetName = style.assetName(pseudo: pseudo) {
                Image(assetName, bundle: .module)
                    .resizable()
                    .interpolation(.high)
                    .frame(width: 49, height: 1)
                    .offset(y: -1)
            }
        }
        .frame(width: 49, height: 0, alignment: .top)
        .accessibilityHidden(true)
    }
}
