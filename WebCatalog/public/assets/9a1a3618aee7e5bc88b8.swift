import SwiftUI

/// Индикатор страниц. `selection` использует индексы с нуля.
/// Геометрия соответствует iOS-матрице tui-pager; прокруткой контента управляет контейнер.
public struct TUIPager: View {
    public enum Size: String, CaseIterable, Sendable {
        case small, medium

        public var height: CGFloat { self == .small ? TUISpacing.x4 : TUISpacing.x5 }
        public var dotSize: CGFloat { self == .small ? 6 : TUISpacing.x2 }
        public var gap: CGFloat { self == .small ? 7 : 9 }

        public func figmaNodeID(pages: Int) -> String? {
            guard pages >= 2 else { return nil }
            let index = min(pages, 6) - 2
            switch self {
            case .small:
                return ["34357:426020", "34376:426038", "34376:426046", "34376:426056", "34376:426068"][index]
            case .medium:
                return ["56366:52141", "56366:52149", "56366:52159", "56366:52171", "56366:52185"][index]
            }
        }
    }

    public let pages: Int
    public let size: Size
    @Binding public var selection: Int
    @State private var windowStart: Int

    public init(pages: Int, selection: Binding<Int>, size: Size = .small) {
        self.pages = max(0, pages)
        self._selection = selection
        self.size = size
        self._windowStart = State(initialValue: TUIPagerWindow.initialStart(pages: pages, selection: selection.wrappedValue))
    }

    public var figmaNodeID: String? { size.figmaNodeID(pages: pages) }

    private var currentPage: Int { min(max(selection, 0), max(pages - 1, 0)) }
    private var visibleStart: Int { min(max(windowStart, 0), max(pages - 6, 0)) }

    public var body: some View {
        Group {
            if pages >= 2 {
                HStack(spacing: size.gap) {
                    ForEach(visibleStart..<min(visibleStart + 6, pages), id: \.self) { page in
                        let state = TUIPagerWindow.dotState(page: page, pages: pages, selection: currentPage, start: visibleStart)
                        Image("tui-pager-\(state.rawValue)-\(size.rawValue)", bundle: .module)
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(state == .selected ? TUIColor.action : TUIColor.named("Background/Neutral 3"))
                            .frame(width: size.dotSize, height: size.dotSize)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: size.height)
                .clipped()
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Страницы")
                .accessibilityValue("\(currentPage + 1) из \(pages)")
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment: selection = min(currentPage + 1, pages - 1)
                    case .decrement: selection = max(currentPage - 1, 0)
                    @unknown default: break
                    }
                }
            }
        }
        // Figma MCP exposes endpoint diagrams, but no transition timing.
        // Keep the indicator instantaneous until that part of the specification is verified.
        .transaction { $0.animation = nil }
        .onChange(of: selection) { old, new in
            windowStart = TUIPagerWindow.nextStart(pages: pages, oldSelection: old, selection: new, start: visibleStart)
        }
        .onChange(of: pages) { _, new in
            windowStart = TUIPagerWindow.initialStart(pages: new, selection: currentPage)
        }
    }
}

/// Direction-sensitive window described on the default-scroll specification page.
/// Internal model is kept separate so boundary and direction changes can be verified.
enum TUIPagerWindow {
    enum DotState: String { case selected, unselected, previous, last }

    static func initialStart(pages: Int, selection: Int) -> Int {
        guard pages > 6, selection >= 4 else { return 0 }
        return min(max(selection - 2, 0), pages - 6)
    }

    static func nextStart(pages: Int, oldSelection: Int, selection: Int, start: Int) -> Int {
        guard pages > 6 else { return 0 }
        let current = min(max(selection, 0), pages - 1)
        let bounded = min(max(start, 0), pages - 6)
        if current > oldSelection, current >= bounded + 4 {
            return min(current - 2, pages - 6)
        }
        if current < oldSelection, current <= bounded + 1 {
            return current <= 2 ? 0 : max(current - 2, 0)
        }
        return bounded
    }

    static func dotState(page: Int, pages: Int, selection: Int, start: Int) -> DotState {
        if page == selection { return .selected }
        guard pages >= 6 else { return .unselected }
        let slot = page - start
        if selection > 2 {
            if slot == 0 { return .last }
            if slot == 1 { return .previous }
        }
        if selection < pages - 3 {
            if slot == 5 { return .last }
            if slot == 4 { return .previous }
        }
        return .unselected
    }
}
