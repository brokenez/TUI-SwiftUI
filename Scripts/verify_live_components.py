#!/usr/bin/env python3
"""Check that live previews cover the imported Figma variant data."""

import json
import re
from pathlib import Path

root = Path(__file__).resolve().parents[1]
metadata = root / "Sources/TUIDesignSystem/Resources/Metadata"
assets = root / "Sources/TUIDesignSystem/Resources/Assets.xcassets"
variants = json.loads((metadata / "figma-component-variants.json").read_text())["variants"]
button_styles = json.loads((metadata / "figma-button-styles.json").read_text())["styles"]
coverage = json.loads((root / "Documentation/component-coverage.json").read_text())
foundations = json.loads((metadata / "figma-foundations.json").read_text())


def is_ios(variant):
    for key, value in (variant.get("variantProperties") or {}).items():
        if key.lower().replace("е", "e") in ("system", "platform"):
            return value.lower().startswith("ios") or value == "–"
    return True


expected = {
    "41658:296906": 147,
    "10312:84": 5,
    "28036:523553": 4,
    "53309:296335": 3,
    "9999:26": 5,
    "55278:70443": 15,
    "25942:708453": 217,
    "10467:91596": 6,
    "37840:45833": 2,
    "25738:689227": 3,
    "6392:51900": 1,
    "53190:295267": 3,
    "79180:42849": 3,
    "79180:42610": 3,
    "79180:42880": 3,
    "9940:39560": 8,
    "9151:1662": 2,
    "53362:296599": 2,
    "44720:304564": 2,
    "91657:37703": 8,
    "24689:584469": 6,
    "87688:44061": 4,
    "25745:690323": 5,
    "39739:293413": 2,
    "41691:305320": 4,
    "42638:295990": 60,
    "115603:32334": 4,
}
complete_ids = {"6392:51900", "87688:44061"}
catalog_source = (root / "Sources/TUIDesignSystem/Catalog/TUIComponentCatalogView.swift").read_text()
status_line = next(line for line in catalog_source.splitlines() if 'LabeledContent("Status"' in line)
status_ids = set(re.findall(r'"(\d+:\d+)"', status_line))
assert status_ids == set(expected), sorted(set(expected) ^ status_ids)
coverage_by_id = {component["id"]: component for component in coverage["components"]}
assert {item["id"] for item in coverage["components"] if item["status"] in ("in-progress", "complete")} == set(expected)
assert {item["id"] for item in coverage["components"] if item["status"] == "complete"} == complete_ids
for set_id, count in expected.items():
    imported = [v for v in variants if v["setId"] == set_id and is_ios(v)]
    assert len(imported) == count, (set_id, len(imported), count)
    assert coverage_by_id[set_id]["iOSVariants"] == count
    assert coverage_by_id[set_id]["status"] == ("complete" if set_id in complete_ids else "in-progress")
    assert coverage_by_id[set_id]["verification"]["implementation"]
    assert coverage_by_id[set_id]["verification"]["visual"] == (set_id in complete_ids)
    api = coverage_by_id[set_id]["swiftAPI"]
    source = root / api["source"]
    assert source.is_file(), source
    source_text = source.read_text()
    if api["symbol"][0].islower():
        assert "public extension View" in source_text
        assert re.search(r"\bfunc " + re.escape(api["symbol"]) + r"\b", source_text), api
    else:
        assert re.search(r"public struct " + re.escape(api["symbol"]) + r"\b", source_text), api
    assert coverage_by_id[set_id]["figmaURL"].endswith("node-id=" + set_id.replace(":", "-"))

button_ids = {v["id"] for v in variants if v["setId"] == "41658:296906" and is_ios(v)}
style_ids = {s["id"] for s in button_styles}
assert len(button_styles) == 147
assert button_ids == style_ids, (button_ids - style_ids, style_ids - button_ids)
assert len({tuple(sorted(s["properties"].items())) for s in button_styles}) == 147
for style in button_styles:
    assert style["height"] > 0 and style["radius"] >= 0
    assert style["properties"]["system"] == "ios"

for name in (
    "tui-button-star",
    "tui-button-star-small",
    "tui-checkbox-check",
    "tui-loader-12",
    "tui-loader-16",
    "tui-loader-24",
    "tui-loader-32",
    "tui-loader-40",
    "tui-link-arrow-right-circle",
    "tui-link-chevron-down",
    "tui-progress-mountains-flag",
    "tui-rating-star-empty",
    "tui-rating-star-filled",
    "tui-subscription-badge-x-large",
    "tui-subscription-badge-large",
    "tui-subscription-badge-medium",
    "tui-subscription-badge-small",
    "tui-badged-content-check",
    "tui-button-vertical-star",
    "tui-button-vertical-star-disabled",
    "tui-chip-plus",
    "tui-chip-cross",
    "tui-chip-dropdown",
):
    imageset = assets / f"{name}.imageset"
    manifest = json.loads((imageset / "Contents.json").read_text())
    image = imageset / manifest["images"][0]["filename"]
    assert image.is_file() and image.stat().st_size > 100, image

for name, points in (
    ("x-large", 28), ("large", 24), ("medium", 20), ("small", 16)
):
    stem = f"tui-subscription-badge-{name}"
    original = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/SubscriptionBadge" / f"{stem}.svg"
    assert original.is_file() and f'width="{points}" height="{points}"' in original.read_text()
    png = assets / f"{stem}.imageset" / f"{stem}.png"
    header = png.read_bytes()[:24]
    assert header[:8] == b"\x89PNG\r\n\x1a\n"
    assert int.from_bytes(header[16:20], "big") == points * 3
    assert int.from_bytes(header[20:24], "big") == points * 3

original_check = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/BadgedContent/tui-badged-content-check.svg"
assert original_check.is_file() and 'width="8.125" height="5.625"' in original_check.read_text()
check_png = assets / "tui-badged-content-check.imageset/tui-badged-content-check.png"
check_header = check_png.read_bytes()[:24]
assert check_header[:8] == b"\x89PNG\r\n\x1a\n"
assert int.from_bytes(check_header[16:20], "big") == 25
assert int.from_bytes(check_header[20:24], "big") == 17

assert coverage["summary"]["iOSVariants"] == 2008
theme = next(collection for collection in foundations["collections"] if collection["name"] == "Theme")
theme_names = {variable["name"] for variable in theme["variables"]}
swift_source = "\n".join(path.read_text() for path in (root / "Sources/TUIDesignSystem").rglob("*.swift"))
named_colors = set(re.findall(r'TUIColor\.named\("([^"]+)"', swift_source))
assert named_colors <= theme_names, sorted(named_colors - theme_names)
assert coverage["summary"]["completeComponents"] == len(complete_ids)
print(f"Checked metadata for {len(expected)} live component sets ({sum(expected.values())} iOS variants) and their image assets")
