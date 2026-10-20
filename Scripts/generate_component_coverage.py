#!/usr/bin/env python3
import json
import sys
from pathlib import Path
from coverage_model import evaluate, ios_scope

root = Path(__file__).resolve().parents[1]
metadata = root / "Sources/TUIDesignSystem/Resources/Metadata"
documentation = root / "Documentation"

component_sets = json.loads((metadata / "figma-components.json").read_text())["componentSets"]
variants = json.loads((metadata / "figma-component-variants.json").read_text())["variants"]

variants_by_set = {}
for variant in variants:
    variants_by_set.setdefault(variant["setId"], []).append(variant)

verification_file = documentation / "component-verification.json"
verification = json.loads(verification_file.read_text())
policy = verification["platformPolicy"]
if verification["schemaVersion"] != 1 or policy["target"] != "iOS 26":
    raise SystemExit("Unsupported verification schema or platform policy")
records = {record["id"]: record for record in verification["components"]}
if len(records) != len(verification["components"]) or set(records) != {item["id"] for item in component_sets}:
    raise SystemExit("Verification records must cover each component set exactly once")
scope = verification.get("acceptancePolicy", {}).get("componentScope", {})
excluded_ids = {node_id for node_id, record in records.items() if record.get("scopeExclusion")}
if excluded_ids != set(scope.get("excludedSystemSetIDs", [])):
    raise SystemExit("Excluded sets must match the explicit user scope decision")
if any(item["id"] in excluded_ids and not item["name"].strip().startswith("system-") for item in component_sets):
    raise SystemExit("Apple system exclusion cannot silently remove custom TUI sets")
coverage = []
for component_set in component_sets:
    component_variants = variants_by_set.get(component_set["id"], [])
    property_values = {}
    for variant in component_variants:
        for key, value in (variant.get("variantProperties") or {}).items():
            property_values.setdefault(key, set()).add(value)

    record = records[component_set["id"]]
    imported, applicable, historical = ios_scope(component_variants, policy)
    status, settled, stale = evaluate(root, record, applicable)
    excluded = status == "excluded"
    api = None if excluded else record["swiftAPI"]
    coverage.append({
        "id": component_set["id"],
        "name": component_set["name"],
        "figmaURL": "https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=" + component_set["id"].replace(":", "-"),
        "status": status,
        "previousStatus": record["previousStatus"],
        "swiftAPI": api,
        "scopeExclusion": record.get("scopeExclusion"),
        "totalVariants": len(component_variants),
        "iOSVariants": len(imported),
        "iOS26Variants": len(applicable),
        "historicalVariants": [{"id": item["id"], "reason": policy["decision"]} for item in historical],
        "variantProperties": {key: sorted(values) for key, values in sorted(property_values.items())},
        "componentProperties": sorted(component_set.get("properties", {}).keys()),
        "specificationURLs": [link["uri"] for link in component_set.get("documentationLinks", [])],
        "verification": {"metadata": True, "implementation": bool(api),
                         **settled, "staleInputs": stale,
                         "record": "Documentation/component-verification.json",
                         "evidenceArchive": record["evidenceArchive"]}
    })

active = [item for item in coverage if item["status"] != "excluded"]
excluded = [item for item in coverage if item["status"] == "excluded"]
payload = {
    "schemaVersion": 2,
    "platformPolicy": policy,
    "summary": {
        "importedComponentSets": len(component_sets),
        "excludedSystemComponents": len(excluded),
        "componentSets": len(active),
        "importedVariants": len(variants),
        "importedIOSVariants": sum(item["iOSVariants"] for item in coverage),
        "variants": sum(item["totalVariants"] for item in active),
        "iOSVariants": sum(item["iOSVariants"] for item in active),
        "documentedComponents": sum(bool(item["specificationURLs"]) for item in active),
        "completeComponents": sum(item["status"] == "complete" for item in coverage),
        "previouslyCompleteComponents": sum(item["previousStatus"] == "complete" for item in coverage),
        "implementedComponents": sum(item["swiftAPI"] is not None for item in coverage),
        "variantMappedComponents": sum(item["verification"]["variantMapping"] for item in active),
        "iOS26Variants": sum(item["iOS26Variants"] for item in active),
        "historicalIOS18Variants": sum(len(item["historicalVariants"]) for item in active)
    },
    "components": coverage
}

rendered = json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
outputs = [documentation / "component-coverage.json", metadata / "component-coverage.json"]
for output in outputs:
    if "--check" in sys.argv:
        if not output.exists() or output.read_text() != rendered:
            raise SystemExit(f"{output.relative_to(root)} is out of date")
    else:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(rendered)

known_set_ids = {component_set["id"] for component_set in component_sets}
unknown = [variant["id"] for variant in variants if variant["setId"] not in known_set_ids]
if unknown:
    raise SystemExit(f"Variants without a known component set: {len(unknown)}")
if sum(item["totalVariants"] for item in coverage) != len(variants):
    raise SystemExit("Variant totals do not match")

print(json.dumps(payload["summary"], ensure_ascii=False))
