import SwiftUI
import Observation

/// Explicit visual order for the mobile form Guide. A boundary represents any
/// non-field element between groups: Next dismisses instead of jumping across it.
public enum TUITextfieldFormItem: Equatable, Sendable {
    case field(String)
    case boundary
}

/// Source Guide 9702:48708. Consumers own values and validation; this container
/// coordinates the package fields, scrolling and the Next/Done keyboard action.
public struct TUITextfieldForm<Content: View>: View {
    /// Source 9702:66367 / 9723:66061: the form owns its fields' optional
    /// external 16 pt screen inset. The keyboard action keeps its own inset.
    public let screenPadding: Bool
    private let order: [TUITextfieldFormItem]
    private let content: Content
    @State private var session = TUITextfieldFormSession()

    public init(order: [TUITextfieldFormItem], screenPadding: Bool = true, @ViewBuilder content: () -> Content) {
        let ids = order.compactMap { if case let .field(id) = $0 { id } else { nil } }
        precondition(Set(ids).count == ids.count, "Form field IDs must be unique")
        self.order = order; self.screenPadding = screenPadding; self.content = content()
    }

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: TUISpacing.x3) {
                    content
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, screenPadding ? TUISpacing.x4 : 0)
                .padding(.top, TUISpacing.x3)
                .background {
                    Color.clear.contentShape(Rectangle()).onTapGesture { session.dismiss() }
                }
            }
            .background {
                Color.clear.contentShape(Rectangle()).onTapGesture { session.dismiss() }
            }
            .scrollDismissesKeyboard(.interactively)
            .coordinateSpace(name: session.coordinateSpace)
            .onGeometryChange(for: CGRect.self) { geometry in
                // ScrollView receives the area already reduced by keyboard
                // and safeAreaInset. Its named coordinates start at that
                // area's origin; subtracting the parent's insets again would
                // make the viewport zero-height while the keyboard is shown.
                CGRect(origin: .zero, size: geometry.size)
            } action: { session.viewport = $0; session.ensureVisible() }
            .safeAreaInset(edge: .bottom, spacing: TUISpacing.x3) {
                if let id = session.activeID {
                    HStack {
                        Spacer(minLength: 0)
                        TUIButton(session.hasFollowingField(after: id) ? "Дальше" : "Готово",
                                  appearance: .accent, size: .medium) { session.advance(from: id) }
                            .fixedSize(horizontal: true, vertical: false)
                            .accessibilityIdentifier("tuiTextfieldFormAdvance")
                    }
                    .padding(.horizontal, TUISpacing.x4)
                    .padding(.bottom, TUISpacing.x4)
                }
            }
            .environment(session)
            .onAppear {
                session.order = order
                session.scrollTo = { id, anchor in withAnimation { proxy.scrollTo(id, anchor: anchor) } }
            }
            .onChange(of: order) { _, value in session.order = value }
            .onDisappear { session.scrollTo = nil }
        }
    }
}

public extension View {
    /// Apply to each TUITextfield listed in TUITextfieldForm's explicit order.
    func tuiTextfieldFormID(_ id: String) -> some View {
        environment(\.tuiTextfieldFormID, id).id(id)
    }
}

private struct TUITextfieldFormIDKey: EnvironmentKey {
    static let defaultValue: String? = nil
}

extension EnvironmentValues {
    var tuiTextfieldFormID: String? {
        get { self[TUITextfieldFormIDKey.self] }
        set { self[TUITextfieldFormIDKey.self] = newValue }
    }
}

@MainActor @Observable
final class TUITextfieldFormSession {
    var activeID: String?
    private(set) var availabilityRevision = 0
    @ObservationIgnored var order: [TUITextfieldFormItem] = []
    @ObservationIgnored let coordinateSpace = UUID().uuidString
    @ObservationIgnored var viewport: CGRect = .zero
    @ObservationIgnored var scrollTo: ((String, UnitPoint) -> Void)?
    @ObservationIgnored private var refreshScheduled = false
    @ObservationIgnored private var lastScroll: ScrollRequest?
    @ObservationIgnored private var entries: [String: Entry] = [:]
    @ObservationIgnored private var frames: [String: CGRect] = [:]

    private struct Entry {
        weak var editor: TUITextfieldNativeEditor?
        var state: Binding<TUITextfieldState>
        var eligible: Bool
    }
    private struct ScrollRequest: Equatable {
        let id: String
        let height: CGFloat
        let viewport: CGRect
    }

    func register(_ editor: TUITextfieldNativeEditor, id: String,
                  state: Binding<TUITextfieldState>, eligible: Bool) {
        let changed = entries[id]?.editor !== editor || entries[id]?.eligible != eligible
        entries[id] = Entry(editor: editor, state: state, eligible: eligible)
        if changed { refreshAvailability() }
    }

    func unregister(_ editor: TUITextfieldNativeEditor, id: String) {
        guard entries[id]?.editor === editor else { return }
        entries.removeValue(forKey: id); frames.removeValue(forKey: id)
        refreshAvailability()
        DispatchQueue.main.async { [weak self] in
            if self?.activeID == id, self?.entries[id] == nil { self?.activeID = nil }
        }
    }

    func began(_ id: String) {
        guard entries[id]?.eligible == true else { return }
        if activeID != id { lastScroll = nil }
        activeID = id; ensureVisible()
    }
    func ended(_ id: String) { if activeID == id { activeID = nil } }
    func updateFrame(_ rect: CGRect, id: String) { frames[id] = rect; if id == activeID { ensureVisible() } }

    private func eligible(_ id: String) -> Bool {
        entries[id]?.eligible == true && entries[id]?.editor != nil
    }
    func nextField(after id: String) -> String? {
        _ = availabilityRevision
        guard let index = order.firstIndex(of: .field(id)) else { return nil }
        for item in order.dropFirst(index + 1) {
            switch item {
            case .boundary: return nil
            case let .field(next): if eligible(next) { return next }
            }
        }
        return nil
    }
    func hasFollowingField(after id: String) -> Bool {
        _ = availabilityRevision
        guard let index = order.firstIndex(of: .field(id)) else { return false }
        return order.dropFirst(index + 1).contains { item in
            if case let .field(next) = item { return eligible(next) }; return false
        }
    }
    func advance(from id: String) {
        let next = nextField(after: id)
        guard let next, let entry = entries[next] else { dismiss(); return }
        lastScroll = nil; activeID = next
        entry.state.wrappedValue = entry.state.wrappedValue.isInvalid ? .invalidFocus : .focus
        // This is a user action, outside updateUIView. Transfer the native
        // responder directly before queued state synchronization can resign
        // the old editor; an intermediate resignation hides the keyboard.
        entry.editor?.becomeFirstResponder()
        for (otherID, other) in entries where otherID != next && other.state.wrappedValue.isFocused {
            other.state.wrappedValue = other.state.wrappedValue.isInvalid ? .invalid : .normal
        }
        ensureVisible()
    }
    func dismiss() {
        for entry in entries.values where entry.state.wrappedValue.isFocused {
            entry.state.wrappedValue = entry.state.wrappedValue.isInvalid ? .invalid : .normal
        }
        activeID = nil; lastScroll = nil
    }
    func ensureVisible() {
        guard let id = activeID, let rect = frames[id], viewport.height > 0,
              rect.minY < viewport.minY || rect.maxY > viewport.maxY else { return }
        let request = ScrollRequest(id: id, height: rect.height, viewport: viewport)
        guard request != lastScroll else { return }
        lastScroll = request
        scrollTo?(id, rect.minY < viewport.minY ? .top : .bottom)
    }
    private func refreshAvailability() {
        guard !refreshScheduled else { return }
        refreshScheduled = true
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.refreshScheduled = false; self.availabilityRevision += 1
            if let id = self.activeID, !self.eligible(id) {
                // Read-only may retain native selection focus for Copy, but
                // no longer owns the keyboard navigation action.
                self.activeID = nil; self.lastScroll = nil
            }
        }
    }
}

#Preview("Form") {
    @Previewable @State var first = ""
    @Previewable @State var second = ""
    @Previewable @State var firstState = TUITextfieldState.normal
    @Previewable @State var secondState = TUITextfieldState.normal
    TUITextfieldForm(order: [.field("first"), .field("second")]) {
        TUITextfield(text: $first, state: $firstState, label: "Имя").tuiTextfieldFormID("first")
        TUITextfield(text: $second, state: $secondState, label: "Фамилия").tuiTextfieldFormID("second")
    }
}
