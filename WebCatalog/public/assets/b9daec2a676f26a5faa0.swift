import SwiftUI

/// The small measurement square used to preview the TUI spacing scale.
public struct TUISpacingIndicator: View {
    public enum Size: String, CaseIterable, Identifiable, Sendable {
        case zero = "0"
        case x2 = "01 - 2px"
        case x4 = "02 - 4px"
        case x8 = "03 - 8px"
        case x12 = "04 - 12px"
        case x16 = "05 - 16px"
        case x20 = "06 - 20px"
        case x24 = "07 - 24px"
        case x32 = "08 - 32px"
        case x40 = "09 - 40px"
        case x48 = "10 - 48px"

        public var id: String { rawValue }

        public var points: CGFloat {
            switch self {
            case .zero: TUISpacing.x0
            case .x2: TUISpacing.x0_5
            case .x4: TUISpacing.x1
            case .x8: TUISpacing.x2
            case .x12: TUISpacing.x3
            case .x16: TUISpacing.x4
            case .x20: TUISpacing.x5
            case .x24: TUISpacing.x6
            case .x32: TUISpacing.x8
            case .x40: TUISpacing.x10
            case .x48: TUISpacing.x12
            }
        }

        public var label: String {
            switch self {
            case .zero: "0"
            case .x2: "2"
            case .x4: "4"
            case .x8: "8"
            case .x12: "12"
            case .x16: "16"
            case .x20: "20"
            case .x24: "24"
            case .x32: "32"
            case .x40: "40"
            case .x48: "48"
            }
        }

        public var figmaVariantIDs: (visible: String, hidden: String?) {
            switch self {
            case .zero: ("28406:482307", nil)
            case .x2: ("28406:482303", "28406:482305")
            case .x4: ("28406:482299", "28406:482301")
            case .x8: ("28406:482295", "28406:482297")
            case .x12: ("28406:482291", "28406:482293")
            case .x16: ("28406:482287", "28406:482289")
            case .x20: ("28406:482283", "28406:482285")
            case .x24: ("28406:482279", "28406:482281")
            case .x32: ("28406:482275", "28406:482277")
            case .x40: ("28406:482271", "28406:482273")
            case .x48: ("28406:482267", "28406:482269")
            }
        }

        fileprivate var labelSize: CGFloat {
            switch self {
            case .zero: 0
            case .x2: 2
            case .x4: 4
            case .x8: 5
            case .x12: 6
            default: 8
            }
        }
    }

    public let size: Size
    public let visible: Bool

    public init(size: Size = .x48, visible: Bool = true) {
        self.size = size
        self.visible = visible
    }

    public var figmaVariantID: String {
        if visible { return size.figmaVariantIDs.visible }
        return size.figmaVariantIDs.hidden ?? size.figmaVariantIDs.visible
    }

    public var body: some View {
        Group {
            if size == .zero {
                Color.clear
                    .frame(width: 1, height: 0)
            } else {
                ZStack {
                    TUIColor.named("Status/Negative Pale")
                    Text(size.label)
                        .font(.system(size: size.labelSize, weight: .regular, design: .default))
                        .foregroundStyle(TUIColor.named("Text/Negative"))
                        .lineLimit(1)
                        .minimumScaleFactor(1)
                }
                .frame(width: size.points, height: size.points)
                .clipped()
                .opacity(visible ? 1 : 0)
            }
        }
        .accessibilityLabel("Spacing \(size.label) points, \(visible ? "visible" : "hidden")")
        .accessibilityIdentifier(figmaVariantID)
    }
}
