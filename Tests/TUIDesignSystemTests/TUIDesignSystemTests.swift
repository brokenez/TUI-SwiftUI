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
    #expect(TUILibraryCatalog.shared.variants.filter(\.isIOS).count == 2_008)
    #expect(TUILibraryCatalog.shared.variants(for: "55278:70443").count == 15)
    #expect(TUILibraryCatalog.shared.variants(for: "41658:296906").count == 147)
}

@MainActor @Test func buttonStylesCoverEveryImportedIOSVariant() {
    #expect(TUIButton.importedVariantCount == 147)
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

@Test func motionUsesFigmaDurationTokens() {
    #expect(abs(TUIMotionDuration.fast.seconds - 0.15) < 0.0001)
    #expect(abs(TUIMotionDuration.moderate.seconds - 0.30) < 0.0001)
}

@Test func listSizeMappingMatchesImportedIOSVariants() {
    let catalog = TUILibraryCatalog.shared
    for id in ["53190:295267", "79180:42849", "79180:42610", "79180:42880"] {
        #expect(catalog.variants(for: id).count == 3)
    }
    #expect(TUIListSize.large.componentLetterSpacing == -0.41)
    #expect(TUIListSize.medium.componentLetterSpacing == -0.24)
    #expect(TUIListSize.small.componentLetterSpacing == -0.08)
}
