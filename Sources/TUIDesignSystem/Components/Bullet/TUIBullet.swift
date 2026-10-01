import SwiftUI

public enum TUIBulletType: String, CaseIterable, Sendable {
    case primary = "Bullet - Primary"
    case accent = "Bullet - Accent"
    case opposite = "Bullet - Opposite"

    var color: Color {
        switch self {
        case .primary: Color(red: 1, green: 221 / 255, blue: 45 / 255)
        case .accent: Color(red: 66 / 255, green: 139 / 255, blue: 249 / 255)
        case .opposite: .black
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
            .accessibilityLabel(type.rawValue)
    }
}
