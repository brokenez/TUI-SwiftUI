import SwiftUI
import Foundation

public struct TUIComponentCatalogView: View {
    private let catalog = TUILibraryCatalog.shared

    public init() {}

    public var body: some View {
        List {
            Section("Figma snapshot") {
                LabeledContent("Variables", value: "957")
                LabeledContent("Component sets", value: "128")
                LabeledContent("Variants", value: "3 927")
                LabeledContent("Assets", value: "3 518")
            }
            Section("TUI Typography · iOS") {
                ForEach(TUITypographyRole.allCases, id: \.self) { role in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(role.rawValue.split(separator: "/").suffix(2).joined(separator: " / "))
                            .tuiTypography(role)
                        Text(typographyDetails(role.metrics))
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            Section("Components · source matrix") {
                ForEach(catalog.components) { component in
                    NavigationLink {
                        TUIComponentReferenceView(component: component)
                    } label: {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(component.name)
                            Text("\(catalog.variants(for: component.id).count) iOS / \(component.variantCount) total")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("TUI Design System")
    }

    private func typographyDetails(_ metrics: TUITypographyMetrics) -> String {
        "\(metrics.family) · \(Int(metrics.size)) / \(Int(metrics.lineHeight)) · tracking \(String(format: "%.2f", Double(metrics.letterSpacing)))"
    }
}

private struct TUIComponentReferenceView: View {
    let component: TUIComponentReference
    private let catalog = TUILibraryCatalog.shared

    var body: some View {
        let variants = catalog.variants(for: component.id)
        List {
            Section("Coverage") {
                LabeledContent("Status", value: "Catalogued")
                LabeledContent("iOS variants", value: "\(variants.count)")
                LabeledContent("All variants", value: "\(component.variantCount)")
            }
            if !component.specificationURLs.isEmpty {
                Section("Specification") {
                    ForEach(component.specificationURLs, id: \.self) { url in
                        Link(url.absoluteString, destination: url)
                    }
                }
            }
            if !component.properties.isEmpty {
                Section("Component properties") {
                    ForEach(component.properties, id: \.self) { Text($0) }
                }
            }
            Section("iOS variant matrix") {
                ForEach(variants) { variant in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(variant.name).font(.subheadline.weight(.semibold))
                        Text(variant.properties.keys.sorted().map { "\($0)=\(variant.properties[$0]!)" }.joined(separator: ", "))
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle(component.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
