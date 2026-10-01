import Foundation

public struct TUIComponentReference: Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let summary: String
    public let specificationURLs: [URL]
    public let variantCount: Int
    public let properties: [String]
}

public struct TUIAssetReference: Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let category: String
    public let width: Double
    public let height: Double
    public let summary: String
}

public struct TUIComponentVariantReference: Sendable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let componentSetID: String
    public let properties: [String: String]
    public let width: Double
    public let height: Double

    public var isIOS: Bool {
        guard let platform = properties.first(where: { key, _ in
            let normalized = key.lowercased().replacingOccurrences(of: "е", with: "e")
            return normalized == "system" || normalized == "platform"
        })?.value else { return true }
        return platform.lowercased().hasPrefix("ios") || platform == "–"
    }
}

public final class TUILibraryCatalog: @unchecked Sendable {
    public static let shared = TUILibraryCatalog()

    public let components: [TUIComponentReference]
    public let assets: [TUIAssetReference]
    public let variants: [TUIComponentVariantReference]

    public init(bundle requestedBundle: Bundle? = nil) {
        let bundle = requestedBundle ?? .module
        components = Self.loadComponents(bundle: bundle)
        assets = Self.loadAssets(bundle: bundle)
        variants = Self.loadVariants(bundle: bundle)
    }

    public func components(matching query: String) -> [TUIComponentReference] {
        guard !query.isEmpty else { return components }
        return components.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    public func assets(matching query: String, category: String? = nil) -> [TUIAssetReference] {
        assets.filter { asset in
            (category == nil || asset.category.caseInsensitiveCompare(category!) == .orderedSame)
                && (query.isEmpty || asset.name.localizedCaseInsensitiveContains(query))
        }
    }

    public func variants(for componentSetID: String, iOSOnly: Bool = true) -> [TUIComponentVariantReference] {
        variants.filter { variant in
            variant.componentSetID == componentSetID && (!iOSOnly || variant.isIOS)
        }
    }

    private static func loadComponents(bundle: Bundle) -> [TUIComponentReference] {
        guard
            let root = json(named: "figma-components", bundle: bundle),
            let items = root["componentSets"] as? [[String: Any]]
        else { return [] }

        return items.compactMap { item in
            guard let id = item["id"] as? String, let name = item["name"] as? String else { return nil }
            let links = (item["documentationLinks"] as? [[String: Any]] ?? [])
                .compactMap { ($0["uri"] as? String).flatMap(URL.init(string:)) }
            let properties = (item["properties"] as? [String: Any])?.keys.sorted() ?? []
            return TUIComponentReference(
                id: id,
                name: name,
                summary: item["description"] as? String ?? "",
                specificationURLs: links,
                variantCount: (item["variantCount"] as? NSNumber)?.intValue ?? 0,
                properties: properties
            )
        }
    }

    private static func loadAssets(bundle: Bundle) -> [TUIAssetReference] {
        guard
            let root = json(named: "figma-assets", bundle: bundle),
            let pages = root["pages"] as? [[String: Any]]
        else { return [] }

        return pages.flatMap { page -> [TUIAssetReference] in
            let category = page["name"] as? String ?? "Assets"
            return (page["assets"] as? [[String: Any]] ?? []).compactMap { item in
                guard let id = item["id"] as? String, let name = item["name"] as? String else { return nil }
                return TUIAssetReference(
                    id: id,
                    name: name,
                    category: category,
                    width: (item["width"] as? NSNumber)?.doubleValue ?? 0,
                    height: (item["height"] as? NSNumber)?.doubleValue ?? 0,
                    summary: item["description"] as? String ?? ""
                )
            }
        }
    }

    private static func loadVariants(bundle: Bundle) -> [TUIComponentVariantReference] {
        guard
            let root = json(named: "figma-component-variants", bundle: bundle),
            let items = root["variants"] as? [[String: Any]]
        else { return [] }

        return items.compactMap { item in
            guard
                let id = item["id"] as? String,
                let name = item["name"] as? String,
                let componentSetID = item["setId"] as? String
            else { return nil }
            return TUIComponentVariantReference(
                id: id,
                name: name,
                componentSetID: componentSetID,
                properties: item["variantProperties"] as? [String: String] ?? [:],
                width: (item["width"] as? NSNumber)?.doubleValue ?? 0,
                height: (item["height"] as? NSNumber)?.doubleValue ?? 0
            )
        }
    }

    private static func json(named name: String, bundle: Bundle) -> [String: Any]? {
        guard
            let url = bundle.url(forResource: name, withExtension: "json", subdirectory: "Metadata")
                ?? bundle.url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
}
