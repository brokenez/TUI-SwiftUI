import UIKit
import ObjectiveC

/// Test-only inspection through public UIKit accessibility/container APIs.
@MainActor enum HeaderAccessibilityProbe {
    private static func elements() -> [NSObject] {
        let windows = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap(\.windows)
        var visited: Set<ObjectIdentifier> = []
        var result: [NSObject] = []
        func visit(_ object: NSObject, depth: Int) {
            guard depth < 40, visited.insert(ObjectIdentifier(object)).inserted else { return }
            result.append(object)
            if let view = object as? UIView { view.subviews.forEach { visit($0, depth: depth + 1) } }
            for child in object.accessibilityElements ?? [] {
                if let child = child as? NSObject { visit(child, depth: depth + 1) }
            }
            let count = object.accessibilityElementCount()
            if count > 0 && count < 10_000 {
                for index in 0..<count {
                    if let child = object.accessibilityElement(at: index) as? NSObject { visit(child, depth: depth + 1) }
                }
            }
        }
        windows.forEach { visit($0, depth: 0) }
        return result
    }

    static func snapshot() -> String {
        let rows: [[String: Any]] = elements().compactMap { element in
            let label = element.accessibilityLabel ?? ""
            let actions = element.accessibilityCustomActions ?? []
            guard label.contains("Длинный заголовок") || label.contains("Настройки уведомлений") ||
                    label.contains("Получать новости") || label.contains("Описание условий") ||
                    label.contains("Подробнее") || label == "уведомлений" || label == "новости" ||
                    label == "конце" || !actions.isEmpty else { return nil }
            let frame = element.accessibilityFrame
            return ["label": label, "isHeader": element.accessibilityTraits.contains(.header),
                    "isButton": element.accessibilityTraits.contains(.button),
                    "isElement": element.isAccessibilityElement,
                    "actions": actions.map(\.name),
                    "frame": ["x": frame.minX, "y": frame.minY, "width": frame.width, "height": frame.height]]
        }
        guard let data = try? JSONSerialization.data(withJSONObject: rows, options: [.sortedKeys]),
              let value = String(data: data, encoding: .utf8) else { return "[]" }
        return value
    }

    static func performLinkAction(label: String) -> Bool {
        guard let action = elements().flatMap({ $0.accessibilityCustomActions ?? [] })
            .first(where: { $0.name.contains(label) }) else { return false }
        if let handler = action.actionHandler { return handler(action) }
        // UIKit's public action contract permits exactly these two BOOL signatures.
        guard let target = action.target as? NSObject,
              let method = class_getInstanceMethod(type(of: target), action.selector) else { return false }
        let implementation = method_getImplementation(method)
        switch method_getNumberOfArguments(method) {
        case 2:
            typealias Callback = @convention(c) (AnyObject, Selector) -> Bool
            return unsafeBitCast(implementation, to: Callback.self)(target, action.selector)
        case 3:
            typealias Callback = @convention(c) (AnyObject, Selector, UIAccessibilityCustomAction) -> Bool
            return unsafeBitCast(implementation, to: Callback.self)(target, action.selector, action)
        default: return false
        }
    }
}
