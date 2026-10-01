import Testing
@testable import TUIDesignSystem

@Test func tokenCatalogLoadsFigmaCollections() {
    let names = TUITokenCatalog.shared.collectionNames
    #expect(names.contains("Primitive"))
    #expect(names.contains("Theme"))
    #expect(names.contains("Platform"))
    #expect(names.contains("State"))
}

@Test func libraryCatalogLoadsCompleteFigmaIndexes() {
    #expect(TUILibraryCatalog.shared.components.count == 128)
    #expect(TUILibraryCatalog.shared.assets.count == 3_518)
    #expect(TUILibraryCatalog.shared.variants.count == 3_927)
    #expect(TUILibraryCatalog.shared.components.filter { !$0.specificationURLs.isEmpty }.count == 108)
}
