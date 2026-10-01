#!/usr/bin/env python3
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
metadata = root / "Sources/TUIDesignSystem/Resources/Metadata"
documentation = root / "Documentation"

component_sets = json.loads((metadata / "figma-components.json").read_text())["componentSets"]
variants = json.loads((metadata / "figma-component-variants.json").read_text())["variants"]

variants_by_set = {}
for variant in variants:
    variants_by_set.setdefault(variant["setId"], []).append(variant)

coverage = []
for component_set in component_sets:
    component_variants = variants_by_set.get(component_set["id"], [])
    property_values = {}
    for variant in component_variants:
        for key, value in (variant.get("variantProperties") or {}).items():
            property_values.setdefault(key, set()).add(value)

    def is_ios(variant):
        properties = variant.get("variantProperties") or {}
        system = properties.get("system")
        return system is None or system.lower() == "ios"

    coverage.append({
        "id": component_set["id"],
        "name": component_set["name"],
        "status": "catalogued",
        "totalVariants": len(component_variants),
        "iOSVariants": sum(1 for variant in component_variants if is_ios(variant)),
        "variantProperties": {key: sorted(values) for key, values in sorted(property_values.items())},
        "componentProperties": sorted(component_set.get("properties", {}).keys()),
        "specificationURLs": [link["uri"] for link in component_set.get("documentationLinks", [])],
        "verification": {"metadata": True, "implementation": False, "visual": False}
    })

payload = {
    "summary": {
        "componentSets": len(component_sets),
        "variants": len(variants),
        "iOSVariants": sum(item["iOSVariants"] for item in coverage),
        "documentedComponents": sum(bool(item["specificationURLs"]) for item in coverage),
        "completeComponents": 0
    },
    "components": coverage
}

documentation.mkdir(parents=True, exist_ok=True)
(documentation / "component-coverage.json").write_text(
    json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
)

known_set_ids = {component_set["id"] for component_set in component_sets}
unknown = [variant["id"] for variant in variants if variant["setId"] not in known_set_ids]
if unknown:
    raise SystemExit(f"Variants without a known component set: {len(unknown)}")
if sum(item["totalVariants"] for item in coverage) != len(variants):
    raise SystemExit("Variant totals do not match")

print(json.dumps(payload["summary"], ensure_ascii=False))
