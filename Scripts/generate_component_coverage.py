#!/usr/bin/env python3
import json
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
metadata = root / "Sources/TUIDesignSystem/Resources/Metadata"
documentation = root / "Documentation"

component_sets = json.loads((metadata / "figma-components.json").read_text())["componentSets"]
variants = json.loads((metadata / "figma-component-variants.json").read_text())["variants"]

variants_by_set = {}
for variant in variants:
    variants_by_set.setdefault(variant["setId"], []).append(variant)

implemented_ids = {"41658:296906", "10312:84", "28036:523553", "53309:296335", "9999:26", "55278:70443", "25942:708453", "10467:91596", "37840:45833", "25738:689227", "6392:51900", "53190:295267", "79180:42849", "79180:42610", "79180:42880", "9940:39560", "9151:1662", "53362:296599", "44720:304564", "91657:37703", "24689:584469", "87688:44061", "25745:690323", "39739:293413", "41691:305320", "42638:295990", "115603:32334"}
complete_ids = {"6392:51900", "87688:44061"}
swift_api = {
    "53309:296335": ("TUIBullet", "Components/Bullet/TUIBullet.swift"),
    "9151:1662": ("tuiSystemActionSheet", "Components/SystemControls/TUISystemControls.swift"),
    "24689:584469": ("tuiSystemAlert", "Components/SystemControls/TUISystemControls.swift"),
    "10312:84": ("TUISystemCheckbox", "Components/SystemCheckbox/TUISystemCheckbox.swift"),
    "53362:296599": ("tuiSystemContextMenu", "Components/SystemControls/TUISystemControls.swift"),
    "28036:523553": ("TUISystemRadioButton", "Components/SystemRadioButton/TUISystemRadioButton.swift"),
    "91657:37703": ("tuiSystemSearchField", "Components/SystemControls/TUISystemSearchField.swift"),
    "44720:304564": ("TUISystemShareLink", "Components/SystemControls/TUISystemControls.swift"),
    "9940:39560": ("TUISystemSwitch", "Components/SystemControls/TUISystemControls.swift"),
    "87688:44061": ("TUISubscriptionBadge", "Components/ClientBadge/TUISubscriptionBadge.swift"),
    "6392:51900": ("TUIClientBadge", "Components/ClientBadge/TUIClientBadge.swift"),
    "25738:689227": ("TUINotificationBadge", "Components/NotificationBadge/TUINotificationBadge.swift"),
    "25745:690323": ("TUIBadgedContent", "Components/BadgedContent/TUIBadgedContent.swift"),
    "41658:296906": ("TUIButton", "Components/Button/TUIButton.swift"),
    "41691:305320": ("TUIButtonVertical", "Components/ButtonVertical/TUIButtonVertical.swift"),
    "42638:295990": ("TUIChip", "Components/Chip/TUIChip.swift"),
    "115603:32334": ("TUIChipGroup", "Components/Chip/TUIChipGroup.swift"),
    "55278:70443": ("TUILink", "Components/Link/TUILink.swift"),
    "79180:42610": ("TUIList", "Components/List/TUIList.swift"),
    "79180:42880": ("TUIList", "Components/List/TUIList.swift"),
    "53190:295267": ("TUIListItem", "Components/List/TUIList.swift"),
    "79180:42849": ("TUIListItem", "Components/List/TUIList.swift"),
    "9999:26": ("TUILoader", "Components/Loader/TUILoader.swift"),
    "39739:293413": ("TUINotificationMiddle", "Components/NotificationMiddle/TUINotificationMiddle.swift"),
    "25942:708453": ("TUIProgressCircle", "Components/ProgressCircle/TUIProgressCircle.swift"),
    "10467:91596": ("TUIRating", "Components/Rating/TUIRating.swift"),
    "37840:45833": ("TUISkeleton", "Components/Skeleton/TUISkeleton.swift"),
}
assert set(swift_api) == implemented_ids
coverage = []
for component_set in component_sets:
    component_variants = variants_by_set.get(component_set["id"], [])
    property_values = {}
    for variant in component_variants:
        for key, value in (variant.get("variantProperties") or {}).items():
            property_values.setdefault(key, set()).add(value)

    def is_ios(variant):
        properties = variant.get("variantProperties") or {}
        platform = next((value for key, value in properties.items()
                         if key.lower().replace("е", "e") in ("system", "platform")), None)
        return platform is None or platform.lower().startswith("ios") or platform == "–"

    has_implementation = component_set["id"] in implemented_ids

    api = swift_api.get(component_set["id"])
    coverage.append({
        "id": component_set["id"],
        "name": component_set["name"],
        "figmaURL": "https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=" + component_set["id"].replace(":", "-"),
        "status": "complete" if component_set["id"] in complete_ids else ("in-progress" if has_implementation else "catalogued"),
        "swiftAPI": {"symbol": api[0], "source": "Sources/TUIDesignSystem/" + api[1]} if api else None,
        "totalVariants": len(component_variants),
        "iOSVariants": sum(1 for variant in component_variants if is_ios(variant)),
        "variantProperties": {key: sorted(values) for key, values in sorted(property_values.items())},
        "componentProperties": sorted(component_set.get("properties", {}).keys()),
        "specificationURLs": [link["uri"] for link in component_set.get("documentationLinks", [])],
        "verification": {"metadata": True, "implementation": has_implementation, "visual": component_set["id"] in complete_ids}
    })

payload = {
    "summary": {
        "componentSets": len(component_sets),
        "variants": len(variants),
        "iOSVariants": sum(item["iOSVariants"] for item in coverage),
        "documentedComponents": sum(bool(item["specificationURLs"]) for item in coverage),
        "completeComponents": len(complete_ids)
    },
    "components": coverage
}

rendered = json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
output = documentation / "component-coverage.json"
if "--check" in sys.argv:
    if not output.exists() or output.read_text() != rendered:
        raise SystemExit("component-coverage.json is out of date")
else:
    documentation.mkdir(parents=True, exist_ok=True)
    output.write_text(rendered)

known_set_ids = {component_set["id"] for component_set in component_sets}
unknown = [variant["id"] for variant in variants if variant["setId"] not in known_set_ids]
if unknown:
    raise SystemExit(f"Variants without a known component set: {len(unknown)}")
if sum(item["totalVariants"] for item in coverage) != len(variants):
    raise SystemExit("Variant totals do not match")

print(json.dumps(payload["summary"], ensure_ascii=False))
