import Testing
import Foundation
@testable import TUIDesignSystem

@Suite struct ComponentScopeTests {
@Test func componentCatalogKeepsSourcesAndExcludesAppleSystemSetsFromSearch() {
    let catalog = TUILibraryCatalog.shared
    let sourceSystemSets = catalog.components.filter { $0.name.trimmingCharacters(in: .whitespaces).hasPrefix("system-") }
    #expect(catalog.components.count == 128)
    #expect(sourceSystemSets.count == 16)
    #expect(catalog.activeComponents.count == 112)
    #expect(catalog.components(matching: "").count == 112)
    #expect(catalog.components(matching: "system-").isEmpty)
    for component in sourceSystemSets {
        #expect(catalog.coverage(for: component.id)?.status == .excluded)
        #expect(!catalog.variants(for: component.id, iOSOnly: false).isEmpty)
    }
    for nodeID in ["44431:321226", "25752:487144", "23068:2266", "41569:291397", "65702:51131"] {
        #expect(catalog.activeComponents.contains { $0.id == nodeID })
        #expect(catalog.coverage(for: nodeID)?.status != .excluded)
    }
}
}
