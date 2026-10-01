#!/usr/bin/env python3
"""Check that live previews cover the imported Figma variant data."""

import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
metadata = root / "Sources/TUIDesignSystem/Resources/Metadata"
assets = root / "Sources/TUIDesignSystem/Resources/Assets.xcassets"
variants = json.loads((metadata / "figma-component-variants.json").read_text())["variants"]
button_styles = json.loads((metadata / "figma-button-styles.json").read_text())["styles"]
coverage = json.loads((root / "Documentation/component-coverage.json").read_text())


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
}
coverage_by_id = {component["id"]: component for component in coverage["components"]}
for set_id, count in expected.items():
    imported = [v for v in variants if v["setId"] == set_id and is_ios(v)]
    assert len(imported) == count, (set_id, len(imported), count)
    assert coverage_by_id[set_id]["iOSVariants"] == count
    assert coverage_by_id[set_id]["status"] == "in-progress"
    assert coverage_by_id[set_id]["verification"]["implementation"]

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
):
    imageset = assets / f"{name}.imageset"
    manifest = json.loads((imageset / "Contents.json").read_text())
    image = imageset / manifest["images"][0]["filename"]
    assert image.is_file() and image.stat().st_size > 100, image

assert coverage["summary"]["iOSVariants"] == 2008
print("Checked metadata for 10 live component sets (407 iOS variants) and their image assets")
