import SwiftUI

/// A reusable trailing swipe-action container that keeps the gesture and reveal behavior native to iOS.
public enum TUISwipeContents: String, CaseIterable, Sendable {
    case cell = "Cell"
    case card = "Card"

    public var figmaNodeID: String {
        switch self {
        case .cell: "53204:296102"
        case .card: "23373:45753"
        }
    }
}

public struct TUISwipeActions: ViewModifier {
    public let actions: [TUISwipeAction]

    public init(actions: [TUISwipeAction]) {
        self.actions = Array(actions.prefix(3))
    }

    public func body(content: Content) -> some View {
        content.swipeActions(edge: .trailing, allowsFullSwipe: false) {
            ForEach(actions) { action in
                Button(role: action.role, action: action.perform) { action.label }
                .tint(action.tint)
                .accessibilityLabel(action.title)
            }
        }
    }
}

public extension View {
    /// Adds native trailing swipe actions to this list row.
    func tuiSwipeActions(_ actions: [TUISwipeAction]) -> some View {
        modifier(TUISwipeActions(actions: actions))
    }
}

/// An action exposed by ``TUISwipeActions``. A custom label can render the exact icon or asset used by the consuming row.
public struct TUISwipeAction: Identifiable {
    public let id: UUID
    public let title: String
    public let role: ButtonRole?
    public let tint: Color
    fileprivate let label: AnyView
    private let action: () -> Void

    public init<Label: View>(
        _ title: String,
        role: ButtonRole? = nil,
        tint: Color = TUIColor.named("Background/Accent 2", fallback: 0x428BF9),
        @ViewBuilder label: () -> Label,
        action: @escaping () -> Void
    ) {
        self.id = UUID()
        self.title = title
        self.role = role
        self.tint = tint
        self.label = AnyView(label())
        self.action = action
    }

    public init(
        _ title: String,
        systemImage: String,
        role: ButtonRole? = nil,
        tint: Color = TUIColor.named("Background/Accent 2", fallback: 0x428BF9),
        action: @escaping () -> Void
    ) {
        self.init(title, role: role, tint: tint, label: { Image(systemName: systemImage) }, action: action)
    }

    fileprivate func perform() { action() }
}
