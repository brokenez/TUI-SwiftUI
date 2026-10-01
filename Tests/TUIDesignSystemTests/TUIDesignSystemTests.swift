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

@Test func typographyUsesExactFigmaMetrics() {
    let heading = TUITypographyRole.headingLarge.metrics
    #expect(heading.size == 30)
    #expect(heading.lineHeight == 36)
    #expect(heading.letterSpacing == 0.4)

    let body = TUITypographyRole.bodyLarge.metrics
    #expect(body.size == 17)
    #expect(body.lineHeight == 24)
    #expect(body.letterSpacing == -0.43)
}

