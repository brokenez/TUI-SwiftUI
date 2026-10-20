import SwiftUI

/// Eight-point T-Bank client marker from the iOS Figma component.
public struct TUIClientBadge: View {
    public init() {}

    public var body: some View {
        Circle()
            .fill(TUIColor.named("Brand/T-Bank"))
            .frame(width: 8, height: 8)
            .accessibilityLabel("Клиент Т-Банка")
    }
}
