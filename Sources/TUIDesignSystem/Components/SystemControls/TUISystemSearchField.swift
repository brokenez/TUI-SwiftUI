import SwiftUI

/// Placement of the native iOS search field documented by TUI Mobile.
public enum TUISystemSearchFieldPlacement: String, CaseIterable, Sendable {
    case inline
    case floating

    var swiftUIPlacement: SearchFieldPlacement {
        switch self {
        case .inline: .navigationBarDrawer(displayMode: .always)
        case .floating: .toolbar
        }
    }
}

/// Applies Apple's search field so focus, clearing, keyboard and iOS 26 motion stay native.
public struct TUISystemSearchFieldModifier: ViewModifier {
    @Binding public var text: String
    public let placement: TUISystemSearchFieldPlacement
    public let prompt: String

    public init(
        text: Binding<String>,
        placement: TUISystemSearchFieldPlacement = .floating,
        prompt: String = "Поиск"
    ) {
        _text = text
        self.placement = placement
        self.prompt = prompt
    }

    public func body(content: Content) -> some View {
        content.searchable(text: $text, placement: placement.swiftUIPlacement, prompt: prompt)
    }
}

public extension View {
    func tuiSystemSearchField(
        text: Binding<String>,
        placement: TUISystemSearchFieldPlacement = .floating,
        prompt: String = "Поиск"
    ) -> some View {
        modifier(TUISystemSearchFieldModifier(text: text, placement: placement, prompt: prompt))
    }
}
