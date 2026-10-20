#!/usr/bin/env python3
"""Index real native Textfield snapshots and compare Day against exact Figma exports.

Requires the same Pillow/numpy runtime used by the other visual comparison scripts.
Metrics are diagnostic; this script never assigns acceptance or paints missing UI.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]


def relative(path):
    return str(path.resolve().relative_to(ROOT))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def on_white(image):
    image = image.convert("RGBA")
    return Image.alpha_composite(Image.new("RGBA", image.size, "white"), image).convert("RGB")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--native", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.native = args.native.resolve()
    args.output = args.output.resolve()
    assert args.native.is_relative_to(ROOT) and args.output.is_relative_to(ROOT)
    source_path = ROOT / "Sources/TUIDesignSystem/Resources/Metadata/figma-component-variants.json"
    variants = [v for v in json.loads(source_path.read_text())["variants"]
                if v["setId"] == "65702:51131" and v["variantProperties"]["system"] == "iOS"]
    expected = {v["id"]: v for v in variants}
    assert len(expected) == 22
    manifest = json.loads((args.native / "manifest.json").read_text())
    native = {}
    capture_metadata = None
    for test in manifest:
        for item in test["attachments"]:
            name = item["suggestedHumanReadableName"]
            path = args.native / item["exportedFileName"]
            if name.startswith("textfield-source-native-matrix-metadata"):
                capture_metadata = json.loads(path.read_text())
            match = re.match(r"textfield-source-(\d+)-(\d+)-(Day|Night)-native-3x", name)
            if match:
                key = (f"{match[1]}:{match[2]}", match[3].lower())
                assert key not in native, f"Ambiguous native render: {key}"
                native[key] = path
    assert set(native) == {(node, theme) for node in expected for theme in ("day", "night")}
    assert capture_metadata is not None and len(capture_metadata) == 44
    capture = {(m["variantID"], m["theme"].lower()): m for m in capture_metadata}
    assert set(capture) == set(native)
    args.output.mkdir(parents=True, exist_ok=True)
    index, measurements, tiles = [], [], []
    for node in sorted(expected):
        variant = expected[node]
        for theme in ("day", "night"):
            path = native[(node, theme)]
            image = Image.open(path).convert("RGBA")
            scale = capture[(node, theme)]["scale"]
            assert scale == 3 and image.size == (int(variant["width"] * scale), int(variant["height"] * scale)), node
            assert image.getchannel("A").getextrema()[1] > 0, f"Transparent blank render: {node}/{theme}"
            focused = variant["variantProperties"]["state"] in ("focus", "invalid-focus")
            assert capture[(node, theme)]["focused"] == focused
            assert not focused or capture[(node, theme)]["cursorVisible"]
            index.append({"variantID": node, "theme": theme, "path": relative(path),
                          "sha256": digest(path), "scale": scale, "pixelSize": list(image.size),
                          "focused": focused, "cursorVisible": capture[(node, theme)]["cursorVisible"]})
        reference = ROOT / "Documentation/References/Textfield/FreshFigma" / (node.replace(":", "-") + ".png")
        source_rgba = Image.open(reference).convert("RGBA")
        original = on_white(source_rgba)
        frame_size = (int(variant["width"]), int(variant["height"]))
        actual = on_white(Image.open(native[(node, "day")])).resize(frame_size, Image.Resampling.LANCZOS)
        source_overflow = None
        if original.size != frame_size:
            # Observed source error-container x=16, width=320 extends beyond its
            # 320 pt parent. The export retains 16 blank white pixels at the right.
            # Keep the original export and native text scale; compare on one canvas.
            assert node == "65702:51258" and original.size == (336, 98), (node, original.size, frame_size)
            assert source_rgba.crop((320, 0, 336, 98)).getextrema() == ((255, 255),) * 4
            canvas = Image.new("RGB", original.size, "white")
            canvas.paste(actual, (0, 0)); actual = canvas
            source_overflow = {"sourceParentWidth": 320, "exportWidth": 336, "blankWhiteRightOverflow": 16,
                               "sourceEvidence": "Documentation/References/Textfield/width-source-65702-51258-metadata-2026-10-09.txt",
                               "acceptance": "UNVERIFIED: source hint bounds differ from parent; no Figma change or content scaling applied."}
        delta = np.abs(np.asarray(original, dtype=int) - np.asarray(actual, dtype=int))
        measurements.append({"variantID": node, "theme": "day", "reference": relative(reference),
                             "referenceSHA256": digest(reference), "native": relative(native[(node, "day")]),
                             "nativeSHA256": digest(native[(node, "day")]), "sourceSize": list(original.size),
                             "sourceOverflow": source_overflow,
                             "meanAbsoluteRGBDifference": float(delta.mean()), "maximumRGBDifference": int(delta.max()),
                             "fractionPixelsOver12": float((delta.max(axis=2) > 12).mean())})
        tile = Image.new("RGB", (1000, original.height + 28), "white")
        draw = ImageDraw.Draw(tile)
        draw.text((8, 3), f"{node} · Figma / actual native / difference x4", fill="black")
        tile.paste(original, (8, 24)); tile.paste(actual, (340, 24))
        tile.paste(Image.fromarray(np.clip(delta * 4, 0, 255).astype("uint8")), (672, 24))
        tiles.append(tile)
    sheet = Image.new("RGB", (1000, sum(tile.height for tile in tiles)), "white")
    offset = 0
    for tile in tiles:
        sheet.paste(tile, (0, offset)); offset += tile.height
    sheet.save(args.output / "source-native-day-contact-sheet.png")
    (args.output / "native-matrix-index.json").write_text(json.dumps(index, indent=2) + "\n")
    (args.output / "source-native-day-comparison.json").write_text(json.dumps({
        "method": "Exact Figma Day 1x PNG compared with active native 3x PNG downsampled to its measured frame with LANCZOS on white. For observed blank source overflow, extend only the comparison canvas at the right without scaling content. No alignment correction, RGB correction, cursor painting or automatic acceptance.",
        "sourceMatrix": {"path": relative(source_path), "sha256": digest(source_path)},
        "nightSourceComparison": "UNVERIFIED: these source exports represent Day; Night native snapshots are retained without fabricated Night references.",
        "variants": measurements}, indent=2) + "\n")
    print(json.dumps({"nativeSnapshots": len(index), "dayPairs": len(measurements),
                      "focusedSnapshotsWithNativeCaret": sum(m["focused"] and m["cursorVisible"] for m in index),
                      "largestMeanAbsoluteRGBDifference": max(m["meanAbsoluteRGBDifference"] for m in measurements)}))


if __name__ == "__main__":
    main()
