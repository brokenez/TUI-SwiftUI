import Foundation

/// The package resource bundle. Consumers can reuse exported TUI artwork
/// without copying it into their application or depending on the catalog.
public enum TUIResources {
    public static var bundle: Bundle { .module }
}
