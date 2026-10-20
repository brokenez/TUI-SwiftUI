import SwiftUI
import UIKit

/// Compatibility entry points for existing components. User decision
/// 2026-10-20: use the native iOS 26 SF face and do not ship font binaries.
/// Historical legacy renders must be reverified after this change.
enum TUIFigmaTextFont {
    static func displayBold(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .bold)
    }

    static func regular(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .regular)
    }
}
