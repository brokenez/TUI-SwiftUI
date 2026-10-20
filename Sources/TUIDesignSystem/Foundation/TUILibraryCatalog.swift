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

    public var isHistoricalIOS18: Bool {
        properties.contains { key, value in
            let normalized = key.lowercased().replacingOccurrences(of: "е", with: "e")
            return (normalized == "system" || normalized == "platform") && value.lowercased() == "ios 18"
        }
    }
}

public enum TUIComponentCoverageStatus: String, Sendable {
    case catalogued, complete, blocked, excluded
    case inProgress = "in-progress"

    public var label: String {
        switch self {
        case .catalogued: "Нет реализации"
        case .complete: "Проверен"
        case .inProgress: "На проверке"
        case .blocked: "Проверка заблокирована"
        case .excluded: "Вне объёма переноса"
        }
    }
}

public struct TUIComponentCoverageReference: Sendable, Identifiable, Hashable {
    public let id: String
    public let status: TUIComponentCoverageStatus
    public let previousStatus: String
    public let applicableVariantCount: Int
    public let historicalVariantCount: Int
    public let pendingChecks: [String]
    public let evidenceArchive: String?
}

public final class TUILibraryCatalog: @unchecked Sendable {
    public static let shared = TUILibraryCatalog()

    public let components: [TUIComponentReference]
    public let assets: [TUIAssetReference]
    public let variants: [TUIComponentVariantReference]
    public let coverageEntries: [TUIComponentCoverageReference]

    public init(bundle requestedBundle: Bundle? = nil) {
        let bundle = requestedBundle ?? .module
        components = Self.loadComponents(bundle: bundle)
        assets = Self.loadAssets(bundle: bundle)
        variants = Self.loadVariants(bundle: bundle)
        coverageEntries = Self.loadCoverage(bundle: bundle)
    }

    public func coverage(for componentSetID: String) -> TUIComponentCoverageReference? {
        coverageEntries.first { $0.id == componentSetID }
    }

    public func components(matching query: String) -> [TUIComponentReference] {
        activeComponents.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }

    /// Imported sources stay available in `components`; excluded system sets
    /// are omitted from the current implementation catalog and search.
    public var activeComponents: [TUIComponentReference] {
        let excludedIDs = Set(coverageEntries.filter { $0.status == .excluded }.map(\.id))
        return components.filter { !excludedIDs.contains($0.id) }
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

    private static func loadCoverage(bundle: Bundle) -> [TUIComponentCoverageReference] {
        guard let root = json(named: "component-coverage", bundle: bundle),
              let items = root["components"] as? [[String: Any]] else { return [] }
        let checks = ["variantMapping", "specification", "visual", "interaction", "accessibility", "motion", "integration"]
        return items.compactMap { item in
            guard let id = item["id"] as? String,
                  let rawStatus = item["status"] as? String,
                  let status = TUIComponentCoverageStatus(rawValue: rawStatus),
                  let verification = item["verification"] as? [String: Any] else { return nil }
            return TUIComponentCoverageReference(
                id: id, status: status,
                previousStatus: item["previousStatus"] as? String ?? "",
                applicableVariantCount: item["iOS26Variants"] as? Int ?? 0,
                historicalVariantCount: (item["historicalVariants"] as? [[String: Any]] ?? []).count,
                pendingChecks: checks.filter { verification[$0] as? Bool != true },
                evidenceArchive: verification["evidenceArchive"] as? String
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
