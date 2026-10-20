import SwiftUI
import TUIDesignSystem

@main
struct TUIDesignSystemCatalogApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                #if DEBUG
                if ProcessInfo.processInfo.arguments.contains("--tui-header-card-snapshot-probe") {
                    HeaderCardSnapshotProbe()
                } else if ProcessInfo.processInfo.arguments.contains("--tui-floating-motion-probe") {
                    FloatingContainerMotionProbe()
                } else if ProcessInfo.processInfo.arguments.contains("--tui-textfield-motion-probe") {
                    TextfieldMotionProbe()
                } else if ProcessInfo.processInfo.arguments.contains("--tui-skeleton-motion-probe") {
                    SkeletonMotionProbe()
                } else if ProcessInfo.processInfo.arguments.contains("--tui-social-button-probe") {
                    SocialButtonProbe()
                } else if ProcessInfo.processInfo.arguments.contains("--tui-button-interaction-probe") {
                    ButtonInteractionProbe()
                } else {
                    TUIComponentCatalogView()
                }
                #else
                TUIComponentCatalogView()
                #endif
            }
        }
    }
}
