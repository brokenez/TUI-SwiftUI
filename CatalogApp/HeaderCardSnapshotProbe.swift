import SwiftUI
import TUIDesignSystem

/// Test-only host for UIKit-backed controls. No List chrome or image substitution.
struct HeaderCardSnapshotProbe: View {
    @State private var night = false
    @State private var selected = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TUIHeaderCard(variant: .switch, isOn: $selected, isSkeletonAnimating: false)
                .frame(width: 375, height: 80)
                .background(night ? Color.black : Color.white)
                .environment(\.colorScheme, night ? .dark : .light)
                .environment(\.dynamicTypeSize, .large)
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("headerCardSnapshot")
            Button("Сменить тему") { night.toggle() }
                .accessibilityIdentifier("headerCardSnapshotTheme")
            Text(night ? "Night" : "Day").accessibilityIdentifier("headerCardSnapshotThemeValue")
        }
        .padding(.top, 120)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(night ? Color.black : Color.white)
        .toolbar(.hidden, for: .navigationBar)
    }
}
