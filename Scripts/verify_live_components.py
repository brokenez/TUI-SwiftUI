#!/usr/bin/env python3
"""Check that live previews cover the imported Figma variant data."""

import json
import re
import struct
import zlib
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
    "44217:298609": 9,
    "41569:290555": 21,
    "42587:291989": 24,
    "11335:41574": 21,
    "42565:305012": 10,
    "44290:299199": 6,
    "44290:299166": 12,
    "41637:306903": 3,
    "7319:38983": 6,
    "37840:45836": 13,
    "34357:426019": 10,
    "16661:51922": 9,
    "41658:296906": 147,
    "10312:84": 5,
    "28036:523553": 4,
    "53309:296335": 3,
    "9999:26": 5,
    "46866:304541": 5,
    "65702:51131": 22,
    "44286:299509": 6,
    "16273:42831": 2,
    "43816:296648": 4,
    "55278:70443": 15,
    "25942:708453": 217,
    "10467:91596": 6,
    "37840:45833": 2,
    "53606:308726": 1,
    "42221:48343": 3,
    "48700:323897": 2,
    "25738:689227": 3,
    "16753:52842": 1,
    "39739:293413": 2,
    "25738:689227": 3,
    "16753:52842": 1,
    "39739:293413": 2,
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
    "39867:46664": 8,
    "47912:303878": 2,
    "16753:52842": 1,
    "39739:293413": 2,
    "45931:47324": 13,
    "55278:70654": 2,
    "55278:70659": 2,
    "28406:482266": 21,
    "24689:584469": 6,
    "87688:44061": 4,
    "25745:690323": 5,
    "39739:293413": 2,
    "41691:305320": 4,
    "42638:295990": 60,
    "115603:32334": 4,
    "43816:296032": 1,
    "44286:300575": 6,
    "44286:300668": 6,
    "44286:300482": 6,
    "44305:306527": 9,
    "53204:296101": 2,
    "54757:286088": 2,
    "30258:432933": 8,
}
import subprocess
import sys
subprocess.run([sys.executable, str(root / "Scripts/generate_component_coverage.py"), "--check"], check=True)
catalog_source = (root / "Sources/TUIDesignSystem/Catalog/TUIComponentCatalogView.swift").read_text()
assert 'catalog.coverage(for: component.id)' in catalog_source
coverage_by_id = {component["id"]: component for component in coverage["components"]}
expected = {set_id: count for set_id, count in expected.items()
            if coverage_by_id[set_id]["status"] != "excluded"}
complete_ids = {item["id"] for item in coverage["components"] if item["status"] == "complete"}
assert {item["id"] for item in coverage["components"] if item["swiftAPI"] is not None} == set(expected)
for set_id, count in expected.items():
    imported = [v for v in variants if v["setId"] == set_id and is_ios(v)]
    assert len(imported) == count, (set_id, len(imported), count)
    assert coverage_by_id[set_id]["iOSVariants"] == count
    assert coverage_by_id[set_id]["status"] in {"complete", "in-progress", "blocked"}
    assert coverage_by_id[set_id]["verification"]["implementation"]
    if set_id in complete_ids:
        assert coverage_by_id[set_id]["verification"]["visual"]
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

pager_source = (root / "Sources/TUIDesignSystem/Components/Pager/TUIPager.swift").read_text()
pager_variants = [v for v in variants if v["setId"] == "34357:426019" and is_ios(v)]
for variant in pager_variants:
    assert variant["id"] in pager_source, variant["id"]
assert {v["variantProperties"]["size"] for v in pager_variants} == {"small", "medium"}
assert {v["variantProperties"]["pages"] for v in pager_variants} == {"2", "3", "4", "5", "6+"}
for size in ("small", "medium"):
    for state in ("selected", "unselected", "previous", "last"):
        name = f"tui-pager-{state}-{size}"
        original = (root / f"Sources/TUIDesignSystem/Resources/OriginalSVG/Pager/{name}.svg").read_text()
        runtime = (assets / f"{name}.imageset/{name}.svg").read_text()
        assert runtime == original.replace('fill-opacity="0.12"', 'fill-opacity="1"'), name

skeleton_text_source = (root / "Sources/TUIDesignSystem/Components/Skeleton/TUISkeletonText.swift").read_text()
for variant in variants:
    if variant["setId"] == "37840:45836" and is_ios(variant):
        assert variant["id"] in skeleton_text_source, variant["id"]
        assert variant["variantProperties"]["text-style"] in skeleton_text_source

skeleton_text_evidence = root / "Documentation/References/SkeletonText"
measurements = json.loads((skeleton_text_evidence / "matrix-measurements.json").read_text())
assert len(measurements) == 13
measurements_by_id = {row["nodeID"]: row for row in measurements}
for variant in variants:
    if variant["setId"] == "37840:45836" and is_ios(variant):
        row = measurements_by_id[variant["id"]]
        assert row["style"] == variant["variantProperties"]["text-style"]
        assert row["height"] == variant["height"]
        assert row["width"] == variant["width"]
        assert row["barRGB"] == [247, 247, 247]
        assert (skeleton_text_evidence / f"simulator-{row['style']}-crop-3x.png").read_bytes().startswith(b"\x89PNG")
assert (skeleton_text_evidence / "simulator-night.png").read_bytes().startswith(b"\x89PNG")

add_card_source = (root / "Sources/TUIDesignSystem/Components/ButtonAddCard/TUIButtonAddCard.swift").read_text()
add_card_variants = [v for v in variants if v["setId"] == "7319:38983" and is_ios(v)]
for variant in add_card_variants:
    assert variant["id"] in add_card_source
    assert variant["variantProperties"]["size"] in add_card_source
assert {v["variantProperties"]["state"] for v in add_card_variants} == {"normal", "pressed"}
assert 'configuration.isPressed' in add_card_source
assert 'pressed ? 0.95 : 1' in add_card_source
add_card_original = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/ButtonAddCard/tui-button-add-card-plus.svg"
assert add_card_original.read_bytes() == (assets / "tui-button-add-card-plus.imageset/tui-button-add-card-plus.svg").read_bytes()
add_card_evidence = root / "Documentation/References/ButtonAddCard"
add_card_measurements = json.loads((add_card_evidence / "matrix-measurements.json").read_text())
assert {row["nodeID"] for row in add_card_measurements} == {v["id"] for v in add_card_variants}
for variant in add_card_variants:
    row = next(row for row in add_card_measurements if row["nodeID"] == variant["id"])
    assert row["outerSizePoints"] == [variant["width"], variant["height"]]
    assert row["meanAbsoluteError1x"] < 2
    assert (add_card_evidence / ("ios-" + variant["id"].replace(":", "-") + "-3x.png")).read_bytes().startswith(b"\x89PNG")
for mode in ("ax1", "ax5"):
    assert (add_card_evidence / f"simulator-{mode}.png").read_bytes().startswith(b"\x89PNG")

checkicon_source = (root / "Sources/TUIDesignSystem/Components/Cell/TUICellCheckicon.swift").read_text()
for variant in variants:
    if variant["setId"] == "41637:306903" and is_ios(variant):
        assert variant["id"] in checkicon_source
for name in ("tui-cell-checkicon-check",):
    original = root / f"Sources/TUIDesignSystem/Resources/OriginalSVG/CellCheckicon/{name}.svg"
    assert original.read_bytes() == (assets / f"{name}.imageset/{name}.svg").read_bytes()
# The Apple SVG importer drops this alpha mask. Flatten its identical contour
# and alpha-gradient into a directly painted path, preserving source geometry.
import xml.etree.ElementTree as ET
svg_ns = {"s": "http://www.w3.org/2000/svg"}
star_original = ET.parse(root / "Sources/TUIDesignSystem/Resources/OriginalSVG/CellCheckicon/tui-cell-checkicon-star.svg")
star_runtime = ET.parse(assets / "tui-cell-checkicon-star.imageset/tui-cell-checkicon-star.svg")
assert star_original.find('.//s:path[@id="Mask_2"]', svg_ns).attrib == star_runtime.find('s:path', svg_ns).attrib
assert ET.tostring(star_original.find('s:defs', svg_ns)) == ET.tostring(star_runtime.find('s:defs', svg_ns))

rating_quantities = {
    "10467:91597": "0",
    "10467:91608": "1",
    "10467:91619": "2",
    "10467:91630": "3",
    "10467:91641": "4",
    "10467:91652": "5",
}
swipe_variants = {v["id"]: v for v in variants if v["setId"] == "53204:296101" and is_ios(v)}
assert set(swipe_variants) == {"53204:296102", "23373:45753"}
assert (swipe_variants["53204:296102"]["width"], swipe_variants["53204:296102"]["height"]) == (405, 56)
assert (swipe_variants["23373:45753"]["width"], swipe_variants["23373:45753"]["height"]) == (405, 80)
swipe_source = (root / "Sources/TUIDesignSystem/Components/SwipeActions/TUISwipeActions.swift").read_text()
assert ".swipeActions(edge: .trailing, allowsFullSwipe: false)" in swipe_source
assert "Array(actions.prefix(3))" in swipe_source
wallet_variants = {v["id"]: v for v in variants if v["setId"] == "54757:286088" and is_ios(v)}
close_variants = {v["id"]: v for v in variants if v["setId"] == "30258:432933" and is_ios(v)}
close_nodes = {
    "30258:432918": ("on-base", "light", "small", 30),
    "38487:470419": ("on-base", "dark", "small", 30),
    "38502:471895": ("on-base", "light", "x-small", 24),
    "38502:471897": ("on-base", "dark", "x-small", 24),
    "30258:432950": ("on-light", "—", "small", 30),
    "38502:471901": ("on-light", "—", "x-small", 24),
    "30263:433024": ("on-dark", "—", "small", 30),
    "38502:471899": ("on-dark", "—", "x-small", 24),
}
assert set(close_variants) == set(close_nodes)
for node_id, (environment, theme, size, diameter) in close_nodes.items():
    variant = close_variants[node_id]
    props = variant["variantProperties"]
    assert (props["environment"], props["Theme"], props["size"]) == (environment, theme, size)
    assert (variant["width"], variant["height"]) == (diameter, diameter)
cross_filename = "tui-button-close-cross.svg"
assert (assets / "tui-button-close-cross.imageset" / cross_filename).read_bytes() == (
    root / "Sources/TUIDesignSystem/Resources/OriginalSVG/ButtonClose" / cross_filename
).read_bytes()
assert set(wallet_variants) == {"54757:286089", "54757:286101"}
assert (wallet_variants["54757:286089"]["width"], wallet_variants["54757:286089"]["height"]) == (343, 56)
assert (wallet_variants["54757:286101"]["width"], wallet_variants["54757:286101"]["height"]) == (290, 48)
wallet_component = (root / "Sources/TUIDesignSystem/Components/ButtonWallet/TUIButtonWallet.swift").read_text()
font_resources = [path for path in (root / "Sources/TUIDesignSystem/Resources").rglob("*")
                  if path.suffix.lower() in {".otf", ".ttf", ".woff", ".woff2"}]
assert not font_resources, "2026-10-20 decision: use native iOS 26 SF Pro without bundled font binaries"
wallet_evidence = root / "Documentation/References/ButtonWallet"
assert (wallet_evidence / "audit.md").is_file()
for evidence in ("figma-large.png", "figma-medium.png", "simulator-default.png", "simulator-ax1.png", "simulator-ax5.png"):
    assert (wallet_evidence / evidence).read_bytes().startswith(b"\x89PNG\r\n\x1a\n")
for asset_name in ("tui-button-wallet-large", "tui-button-wallet-medium"):
    image_set = assets / f"{asset_name}.imageset"
    contents = json.loads((image_set / "Contents.json").read_text())
    filename = contents["images"][0]["filename"]
    assert (image_set / filename).read_bytes() == (
        root / "Sources/TUIDesignSystem/Resources/OriginalSVG/ButtonWallet" / filename
    ).read_bytes()
    assert asset_name in wallet_component
rating_variants = {v["id"]: v for v in variants if v["setId"] == "10467:91596" and is_ios(v)}
assert set(rating_variants) == set(rating_quantities)
for variant_id, quantity in rating_quantities.items():
    variant = rating_variants[variant_id]
    assert variant["variantProperties"]["quantity"] == quantity
    assert (variant["width"], variant["height"]) == (264, 40)

progress_circle_variants = {
    v["id"]: v for v in variants
    if v["setId"] == "25942:708453" and is_ios(v)
}
assert len(progress_circle_variants) == 217
assert {"25942:710757", "26056:506834", "25942:708452"} <= set(progress_circle_variants)
for variant in progress_circle_variants.values():
    props = variant["variantProperties"]
    assert props["System"] == "iOS"
    assert props["circleMode"] in {"Closed", "Open"}
    assert props["Size"] in {"32", "40", "56", "64", "80", "96", "128"}
    assert props["Preset"] in {"Icon", "None", "Text"}
    assert props["Thickness"] in {"2", "4", "6", "8", "12"}
    assert props["Skeleton"] in {"off", "on"}
    assert variant["width"] == variant["height"] == int(props["Size"])

block_details_variants = {
    v["id"]: v for v in variants if v["setId"] == "47912:303878" and is_ios(v)
}
assert set(block_details_variants) == {"47901:306045", "55902:297975"}
for variant_id, skeleton in (("47901:306045", "off"), ("55902:297975", "on")):
    variant = block_details_variants[variant_id]
    assert variant["variantProperties"]["skeleton"] == skeleton
    assert (variant["width"], variant["height"]) == (375, 395)

badged_content_variants = {
    v["id"]: v for v in variants if v["setId"] == "25745:690323" and is_ios(v)
}
badged_content_expected = {
    "25745:687845": "top-plus-bottom",
    "25745:690324": "bottom",
    "25745:690371": "off",
    "25745:690376": "top",
    "6328:52311": "t-client",
}
assert set(badged_content_variants) == set(badged_content_expected)
for variant_id, badge in badged_content_expected.items():
    variant = badged_content_variants[variant_id]
    assert variant["variantProperties"]["Badge"] == badge
    assert (variant["width"], variant["height"]) == (128, 128)
badged_playground = catalog_source[catalog_source.index("private struct TUIBadgedContentPlayground:"):catalog_source.index("private struct TUISystemSearchFieldPlayground:")]
assert 'Picker("Badge"' in badged_playground

chip_group_variants = {
    v["id"]: v for v in variants
    if v["setId"] in {"115603:32334", "44286:300575", "44286:300668", "44286:300482"} and is_ios(v)
}
chip_group_expected = {
    "115603:32335": ("115603:32334", "on", "S", None, 375, 46),
    "115603:32343": ("115603:32334", "on", "M", None, 375, 52),
    "115603:32367": ("115603:32334", "off", "S", None, 375, 84),
    "115603:32397": ("115603:32334", "off", "M", None, 375, 96),
    "44286:300576": ("44286:300575", "on", "S", "Start", 375, 46),
    "44286:300584": ("44286:300575", "on", "M", "Start", 375, 52),
    "44286:300608": ("44286:300575", "off", "S", "Start", 375, 84),
    "44286:300623": ("44286:300575", "off", "M", "Start", 375, 96),
    "513:134820": ("44286:300575", "off", "S", "Center", 375, 84),
    "513:134835": ("44286:300575", "off", "M", "Center", 375, 96),
    "44286:300669": ("44286:300668", "on", "S", "Start", 375, 46),
    "44286:300677": ("44286:300668", "on", "M", "Start", 375, 52),
    "44286:300701": ("44286:300668", "off", "S", "Start", 375, 84),
    "44286:300716": ("44286:300668", "off", "M", "Start", 375, 96),
    "513:134424": ("44286:300668", "off", "S", "Center", 375, 84),
    "513:134439": ("44286:300668", "off", "M", "Center", 375, 96),
    "44286:300483": ("44286:300482", "on", "S", "Start", 375, 46),
    "44286:300491": ("44286:300482", "on", "M", "Start", 375, 52),
    "44286:300515": ("44286:300482", "off", "S", "Start", 375, 84),
    "44286:300530": ("44286:300482", "off", "M", "Start", 375, 96),
    "513:134095": ("44286:300482", "off", "S", "Center", 375, 84),
    "513:134110": ("44286:300482", "off", "M", "Center", 375, 96),
}
assert set(chip_group_variants) == set(chip_group_expected)
for variant_id, expected_values in chip_group_expected.items():
    variant = chip_group_variants[variant_id]
    set_id, scrollable, size, alignment, width, height = expected_values
    assert variant["setId"] == set_id
    props = variant["variantProperties"]
    assert (props["Scrollable"], props["Size"]) == (scrollable, size)
    if alignment is None:
        assert "Alignment" not in props
    else:
        assert props["Alignment"] == alignment
    assert (variant["width"], variant["height"]) == (width, height)
assert 'private struct TUIChipGroupUseCasePlayground' in catalog_source
assert 'Picker("Выравнивание"' in catalog_source
assert 'LabeledContent("Figma node"' in badged_playground

progress_circle_source = (root / "Sources/TUIDesignSystem/Components/ProgressCircle/TUIProgressCircle.swift").read_text()
for required in ("TUIProgressCircleMode", "TUIProgressCircleSize", "TUIProgressCirclePreset", "skeleton", "thickness"):
    assert required in progress_circle_source
playground_source = catalog_source[catalog_source.index("private struct TUIProgressCirclePlayground:"):catalog_source.index("private struct TUIRatingPlayground:")]
for required in ('Picker("Режим"', 'Picker("Размер"', 'Picker("Содержимое"', 'Picker("Толщина"', 'Toggle("Скелетон"', 'LabeledContent("Figma node"'):
    assert required in playground_source

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
    "tui-block-status-alert",
    "tui-block-status-alert-vector",
    "tui-block-status-magnifier-bubble",
    "tui-block-status-magnifier-handle",
    "tui-block-status-magnifier-bubble-dark",
    "tui-block-status-magnifier-handle-dark",
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
    "tui-search-input-search",
    "tui-search-input-clear",
    "tui-block-details-avatar",
    "tui-block-details-comment-tail",
    "tui-block-details-skeleton-tail",
    "tui-block-details-crown",
    "tui-block-details-clock",
    "tui-illustration-briefcase-light",
):
    imageset = assets / f"{name}.imageset"
    manifest = json.loads((imageset / "Contents.json").read_text())
    image = imageset / manifest["images"][0]["filename"]
    assert image.is_file() and image.stat().st_size > 100, image


def png_corner_rgba(path):
    data = path.read_bytes()
    offset = 8
    image_data = bytearray()
    width = height = depth = color_type = None
    while offset < len(data):
        length = struct.unpack(">I", data[offset:offset + 4])[0]
        kind = data[offset + 4:offset + 8]
        chunk = data[offset + 8:offset + 8 + length]
        offset += length + 12
        if kind == b"IHDR":
            width, height, depth, color_type, *_ = struct.unpack(">IIBBBBB", chunk)
        elif kind == b"IDAT":
            image_data.extend(chunk)
    assert (width, height, depth, color_type) == (40, 40, 8, 6)
    first_row = zlib.decompress(image_data)[:1 + width * 4]
    assert first_row[0] == 0, "Rating star export must use a non-interlaced, unfiltered first row"
    return tuple(first_row[1:5])


for star_name in ("tui-rating-star-empty", "tui-rating-star-filled"):
    manifest = json.loads((assets / f"{star_name}.imageset" / "Contents.json").read_text())
    image = assets / f"{star_name}.imageset" / manifest["images"][0]["filename"]
    assert png_corner_rgba(image)[3] == 0, f"{image} must preserve Figma's transparent star bounds"

for suffix, height in (("body-l", 72), ("body-m", 64), ("ui-s", 56)):
    name = f"tui-text-expandable-skeleton-{suffix}"
    imageset = assets / f"{name}.imageset"
    manifest = json.loads((imageset / "Contents.json").read_text())
    vector = imageset / manifest["images"][0]["filename"]
    original = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/TextExpandable" / f"{suffix}.svg"
    source = original.read_text()
    assert vector.is_file() and original.is_file() and vector.read_bytes() == original.read_bytes()
    assert f'width="303" height="{height}" viewBox="0 0 303 {height}"' in source

payment_networks = (
    "maestro", "mastercard", "mastercard-gold", "mastercard-metal",
    "mastercard-metal-inverse", "mir", "mir-monochrome", "mir-supreme",
    "mir-supreme-metall", "unionpay", "unionpay-monochrome", "visa",
    "visa-monochrome",
)
for network in payment_networks:
    name = f"tui-payment-logo-{network}"
    image_set = assets / f"{name}.imageset"
    manifest = json.loads((image_set / "Contents.json").read_text())
    image = image_set / manifest["images"][0]["filename"]
    original = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/PaymentLogo" / f"{network}.svg"
    assert image.is_file() and image.stat().st_size > 100, image
    assert original.is_file() and original.read_bytes() == image.read_bytes(), network

for name in ("primary-no", "primary-yes", "secondary-yes"):
    asset_name = f"tui-underline-{name}"
    imageset = assets / f"{asset_name}.imageset"
    manifest = json.loads((imageset / "Contents.json").read_text())
    image = imageset / manifest["images"][0]["filename"]
    original = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/Underline" / f"{name}.svg"
    assert image.is_file() and image.stat().st_size > 100, image
    assert original.is_file() and original.read_bytes() == image.read_bytes(), name

illustration_source = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/Illustrations/tui-illustration-briefcase-light.svg"
illustration_asset = assets / "tui-illustration-briefcase-light.imageset/tui-illustration-briefcase-light.svg"
assert illustration_source.is_file() and illustration_asset.is_file()
assert illustration_source.read_bytes() == illustration_asset.read_bytes()
assert 'width="220" height="220" viewBox="0 0 220 220"' in illustration_asset.read_text()

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

for name, source_name in (
    ("tui-search-input-search", "tui-ic-service-search-ios.svg"),
    ("tui-search-input-clear", "tui-ic-service-clearfield-ios.svg"),
):
    original = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/SearchInput" / source_name
    vector = assets / f"{name}.imageset" / f"{name}.svg"
    assert original.is_file() and vector.is_file()
    assert original.read_bytes() == vector.read_bytes(), name

block_assets = root / "Sources/TUIDesignSystem/Resources/Assets.xcassets"
block_originals = root / "Sources/TUIDesignSystem/Resources/OriginalSVG/BlockDetails"
for stem in ("comment-tail", "skeleton-tail", "crown", "clock"):
    original = block_originals / f"{stem}.svg"
    asset_name = f"tui-block-details-{stem}"
    vector = block_assets / f"{asset_name}.imageset" / f"{asset_name}.svg"
    assert original.is_file() and vector.is_file()
    assert original.read_bytes() == vector.read_bytes(), stem
avatar_original = block_originals / "avatar.png"
avatar_asset = block_assets / "tui-block-details-avatar.imageset/tui-block-details-avatar.png"
assert avatar_original.is_file() and avatar_asset.is_file()
assert avatar_original.read_bytes() == avatar_asset.read_bytes()

assert coverage["summary"]["importedIOSVariants"] == 2008
assert coverage["summary"]["iOSVariants"] == sum(item["iOSVariants"] for item in coverage["components"] if item["status"] != "excluded")
theme = next(collection for collection in foundations["collections"] if collection["name"] == "Theme")
theme_names = {variable["name"] for variable in theme["variables"]}
swift_source = "\n".join(path.read_text() for path in (root / "Sources/TUIDesignSystem").rglob("*.swift"))
named_colors = set(re.findall(r'TUIColor\.named\("([^"]+)"', swift_source))
assert named_colors <= theme_names, sorted(named_colors - theme_names)
assert coverage["summary"]["completeComponents"] == len(complete_ids)
print(f"Checked metadata for {len(expected)} live component sets ({sum(expected.values())} iOS variants) and their image assets")

# The runtime PDFs are direct Figma exports: retain their vector masks and alpha.
for folder, name in [("ButtonShare", "tui-button-share"), ("ButtonLike", "tui-button-like-outline"), ("ButtonLike", "tui-button-like-filled")]:
    original = root / f"Sources/TUIDesignSystem/Resources/OriginalPDF/{folder}/{name}.pdf"
    runtime = assets / f"{name}.imageset/{name}.pdf"
    assert original.read_bytes().startswith(b"%PDF")
    assert original.read_bytes() == runtime.read_bytes(), name
