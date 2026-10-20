#if DEBUG
import SwiftUI
import UIKit
import TUIDesignSystem

/// A real application scene for frame-by-frame motion acceptance.
/// Only shown when explicitly launched with --tui-skeleton-motion-probe.
struct SkeletonMotionProbe: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var systemReduceMotion = UIAccessibility.isReduceMotionEnabled

    var body: some View {
        VStack(spacing: 32) {
            Text("Scene: \(String(describing: scenePhase))")
            Text("Reduce Motion: \(reduceMotion ? "on" : "off")")
            Text("System Reduce Motion: \(systemReduceMotion ? "on" : "off")")
            HStack(spacing: 40) {
                VStack(spacing: 16) {
                    Text("Live")
                    TUISkeleton()
                    TUISkeletonText()
                }
                VStack(spacing: 16) {
                    Text("Static")
                    TUISkeleton(isAnimating: false)
                    TUISkeletonText(isAnimating: false)
                }
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .environment(\.colorScheme, .dark)
        .navigationTitle("Skeleton motion QA")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification)) { _ in
            systemReduceMotion = UIAccessibility.isReduceMotionEnabled
        }
        .onChange(of: scenePhase) { _, _ in
            systemReduceMotion = UIAccessibility.isReduceMotionEnabled
        }
    }
}
#endif
