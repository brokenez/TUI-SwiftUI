import SwiftUI
import TUIDesignSystem

@main
struct TUIDesignSystemCatalogApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TUIComponentCatalogView()
            }
        }
    }
}
