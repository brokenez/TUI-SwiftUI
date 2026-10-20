import SwiftUI

public enum TUIBulletType: String, CaseIterable, Sendable {
    case primary = "Bullet - Primary"
    case accent = "Bullet - Accent"
    case opposite = "Bullet - Opposite"

    public var figmaNodeID: String {
        switch self {
        case .primary: "53309:296334"
        case .accent: "53309:296336"
        case .opposite: "53480:295831"
        }
    }

    var color: Color {
        switch self {
        case .primary: TUIColor.accent
        case .accent: TUIColor.named("Status/Info", fallback: 0x428BF9)
        case .opposite: TUIColor.named("Background/Accent Opposite", fallback: 0x000000)
        }
    }
}

/// The 6 pt marker from the `.bullet` Figma component set.
public struct TUIBullet: View {
    public let type: TUIBulletType

    public init(type: TUIBulletType = .primary) {
        self.type = type
    }

    public var body: some View {
        Circle()
            .fill(type.color)
            .frame(width: 6, height: 6)
            .accessibilityIdentifier(type.figmaNodeID)
            .accessibilityLabel(type.rawValue)
    }
}
