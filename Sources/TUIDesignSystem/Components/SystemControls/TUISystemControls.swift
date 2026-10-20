import SwiftUI

public enum TUISystemSwitchPlatform: String, CaseIterable, Sendable {
    case iOS18 = "iOS 18"
    case iOS26 = "iOS 26"

    public static var current: Self {
        if #available(iOS 26.0, *) { .iOS26 } else { .iOS18 }
    }
}

/// Figma's native switch state matrix. The rendered control remains the OS-native `Toggle`.
public struct TUISystemSwitchVariant: Identifiable, Equatable, Sendable {
    public let platform: TUISystemSwitchPlatform
    public let isOn: Bool
    public let isEnabled: Bool

    public init(platform: TUISystemSwitchPlatform, isOn: Bool, isEnabled: Bool) {
        self.platform = platform
        self.isOn = isOn
        self.isEnabled = isEnabled
    }

    public var id: String { figmaNodeID }

    public var figmaNodeID: String {
        switch (platform, isOn, isEnabled) {
        case (.iOS18, true, true): "18:707"
        case (.iOS18, true, false): "18:715"
        case (.iOS18, false, true): "18:723"
        case (.iOS18, false, false): "18:727"
        case (.iOS26, false, true): "88671:44070"
        case (.iOS26, true, true): "88671:44072"
        case (.iOS26, true, false): "90225:32220"
        case (.iOS26, false, false): "90225:32222"
        }
    }

    public static let all: [Self] = TUISystemSwitchPlatform.allCases.flatMap { platform in
        [false, true].flatMap { isOn in
            [true, false].map { isEnabled in
                Self(platform: platform, isOn: isOn, isEnabled: isEnabled)
            }
        }
    }

    public static func current(isOn: Bool, isEnabled: Bool) -> Self {
        Self(platform: .current, isOn: isOn, isEnabled: isEnabled)
    }
}

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

public enum TUISystemActionSheetPlatform: String, CaseIterable, Sendable {
    case iOS18 = "iOS 18"
    case iOS26 = "iOS 26"

    public static var current: Self {
        if #available(iOS 26.0, *) { .iOS26 } else { .iOS18 }
    }
}

/// Platform-specific Figma reference for the system-provided confirmation dialog.
public struct TUISystemActionSheetVariant: Identifiable, Equatable, Sendable {
    public let platform: TUISystemActionSheetPlatform

    public init(platform: TUISystemActionSheetPlatform) {
        self.platform = platform
    }

    public var id: String { figmaNodeID }
    public var figmaNodeID: String { platform == .iOS18 ? "1444:3120" : "90500:303337" }

    public static let all = TUISystemActionSheetPlatform.allCases.map(Self.init(platform:))
    public static var current: Self { Self(platform: .current) }
}

public struct TUISystemContextMenuVariant: Identifiable, Equatable, Sendable {
    public let isDarkMode: Bool

    public init(isDarkMode: Bool) {
        self.isDarkMode = isDarkMode
    }

    public var id: String { figmaNodeID }
    public var figmaNodeID: String { isDarkMode ? "53489:297102" : "53362:296600" }

    public static let all = [Self(isDarkMode: false), Self(isDarkMode: true)]
}

public struct TUISystemShareSheetVariant: Identifiable, Equatable, Sendable {
    public let isDarkMode: Bool

    public init(isDarkMode: Bool) {
        self.isDarkMode = isDarkMode
    }

    public var id: String { figmaNodeID }
    public var figmaNodeID: String { isDarkMode ? "44737:304939" : "44720:304565" }

    public static let all = [Self(isDarkMode: false), Self(isDarkMode: true)]
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
