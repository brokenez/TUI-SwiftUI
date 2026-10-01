import Foundation

public final class TUITokenCatalog: @unchecked Sendable {
    public static let shared = TUITokenCatalog()

    private let collections: [[String: Any]]
    private let variablesByID: [String: [String: Any]]
    private let collectionByVariableID: [String: [String: Any]]

    public init(bundle requestedBundle: Bundle? = nil) {
        let bundle = requestedBundle ?? .module
        guard
            let url = bundle.url(forResource: "figma-foundations", withExtension: "json", subdirectory: "Metadata"),
            let data = try? Data(contentsOf: url),
            let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let collections = root["collections"] as? [[String: Any]]
        else {
            self.collections = []
            self.variablesByID = [:]
            self.collectionByVariableID = [:]
            return
        }

        self.collections = collections
        var variablesByID: [String: [String: Any]] = [:]
        var collectionByVariableID: [String: [String: Any]] = [:]
        for collection in collections {
            for variable in collection["variables"] as? [[String: Any]] ?? [] {
                guard let id = variable["id"] as? String else { continue }
                variablesByID[id] = variable
                collectionByVariableID[id] = collection
            }
        }
        self.variablesByID = variablesByID
        self.collectionByVariableID = collectionByVariableID
    }

    public var collectionNames: [String] {
        collections.compactMap { $0["name"] as? String }
    }

    public func variableNames(in collectionName: String) -> [String] {
        guard let collection = collection(named: collectionName) else { return [] }
        return (collection["variables"] as? [[String: Any]] ?? [])
            .compactMap { $0["name"] as? String }
    }

    public func value(
        named variableName: String,
        collection collectionName: String,
        mode modeName: String? = nil
    ) -> Any? {
        guard
            let collection = collection(named: collectionName),
            let variable = (collection["variables"] as? [[String: Any]])?.first(where: {
                ($0["name"] as? String)?.caseInsensitiveCompare(variableName) == .orderedSame
            })
        else { return nil }

        return resolve(variable: variable, collection: collection, modeName: modeName, visited: [])
    }

    public func number(
        named variableName: String,
        collection collectionName: String,
        mode modeName: String? = nil
    ) -> Double? {
        if let value = value(named: variableName, collection: collectionName, mode: modeName) as? NSNumber {
            return value.doubleValue
        }
        return value(named: variableName, collection: collectionName, mode: modeName) as? Double
    }

    private func collection(named name: String) -> [String: Any]? {
        collections.first {
            ($0["name"] as? String)?.caseInsensitiveCompare(name) == .orderedSame
        }
    }

    private func resolve(
        variable: [String: Any],
        collection: [String: Any],
        modeName: String?,
        visited: Set<String>
    ) -> Any? {
        guard let id = variable["id"] as? String, !visited.contains(id) else { return nil }
        let modes = collection["modes"] as? [[String: Any]] ?? []
        let chosenMode = modeName.flatMap { requested in
            modes.first { ($0["name"] as? String)?.caseInsensitiveCompare(requested) == .orderedSame }
        } ?? modes.first
        guard
            let modeID = chosenMode?["modeId"] as? String,
            let values = variable["valuesByMode"] as? [String: Any],
            let rawValue = values[modeID]
        else { return nil }

        guard
            let alias = rawValue as? [String: Any],
            alias["type"] as? String == "VARIABLE_ALIAS",
            let targetID = alias["id"] as? String,
            let target = variablesByID[targetID],
            let targetCollection = collectionByVariableID[targetID]
        else { return rawValue }

        var nextVisited = visited
        nextVisited.insert(id)
        return resolve(
            variable: target,
            collection: targetCollection,
            modeName: modeName,
            visited: nextVisited
        )
    }
}
