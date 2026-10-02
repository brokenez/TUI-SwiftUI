import SwiftUI

/// Uses the operating system's switch, including its iOS 26 appearance and motion.
public struct TUISystemSwitch: View {
    @Binding public var isOn: Bool
    public let isEnabled: Bool
    public let label: String

    public init(_ label: String, isOn: Binding<Bool>, isEnabled: Bool = true) {
        self.label = label
        _isOn = isOn
        self.isEnabled = isEnabled
    }

    public var body: some View {
        Toggle(label, isOn: $isOn)
            .labelsHidden()
            .tint(TUIColor.named("Background/Accent 2"))
            .disabled(!isEnabled)
            .accessibilityLabel(label)
    }
}

public struct TUISystemMenuAction: Identifiable {
    public let id: String
    public let title: String
    public let role: ButtonRole?
    public let isEnabled: Bool
    public let handler: () -> Void

    public init(
        id: String,
        title: String,
        role: ButtonRole? = nil,
        isEnabled: Bool = true,
        handler: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.role = role
        self.isEnabled = isEnabled
        self.handler = handler
    }
}

public struct TUISystemActionSheetModifier: ViewModifier {
    @Binding public var isPresented: Bool
    public let title: String
    public let showsTitle: Bool
    public let actions: [TUISystemMenuAction]

    public init(isPresented: Binding<Bool>, title: String, showsTitle: Bool = true, actions: [TUISystemMenuAction]) {
        _isPresented = isPresented
        self.title = title
        self.showsTitle = showsTitle
        self.actions = actions
    }

    public func body(content: Content) -> some View {
        content.confirmationDialog(title, isPresented: $isPresented, titleVisibility: showsTitle ? .visible : .hidden) {
            ForEach(actions) { action in
                Button(action.title, role: action.role, action: action.handler)
                    .disabled(!action.isEnabled)
            }
        }
    }
}

public struct TUISystemAlertModifier: ViewModifier {
    @Binding public var isPresented: Bool
    public let title: String
    public let message: String?
    public let actions: [TUISystemMenuAction]

    public init(isPresented: Binding<Bool>, title: String, message: String? = nil, actions: [TUISystemMenuAction]) {
        _isPresented = isPresented
        self.title = title
        self.message = message
        self.actions = actions
    }

    public func body(content: Content) -> some View {
        content.alert(title, isPresented: $isPresented) {
            ForEach(actions) { action in
                Button(action.title, role: action.role, action: action.handler)
                    .disabled(!action.isEnabled)
            }
        } message: {
            if let message, !message.isEmpty {
                Text(message)
            }
        }
    }
}

public extension View {
    func tuiSystemAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        actions: [TUISystemMenuAction]
    ) -> some View {
        modifier(TUISystemAlertModifier(isPresented: isPresented, title: title, message: message, actions: actions))
    }

    func tuiSystemActionSheet(
        isPresented: Binding<Bool>,
        title: String,
        showsTitle: Bool = true,
        actions: [TUISystemMenuAction]
    ) -> some View {
        modifier(TUISystemActionSheetModifier(isPresented: isPresented, title: title, showsTitle: showsTitle, actions: actions))
    }

    func tuiSystemContextMenu(actions: [TUISystemMenuAction]) -> some View {
        contextMenu {
            ForEach(actions) { action in
                Button(action.title, role: action.role, action: action.handler)
                    .disabled(!action.isEnabled)
            }
        }
    }
}

/// Native iOS share sheet entry point. The caller supplies the actual URL to share.
public struct TUISystemShareLink: View {
    public let title: String
    public let url: URL

    public init(_ title: String, url: URL) {
        self.title = title
        self.url = url
    }

    public var body: some View {
        ShareLink(title, item: url)
    }
}
