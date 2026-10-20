#!/usr/bin/env python3
"""Compare original Figma PNGs with actual native test attachments; no auto-pass."""
import argparse
import json
import re
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw


def composite(image, matte):
    image = image.convert("RGBA")
    background = Image.new("RGBA", image.size, matte)
    return Image.alpha_composite(background, image).convert("RGB")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--native", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.native = args.native.resolve()
    root = Path(__file__).resolve().parents[1]
    references = root / "Documentation/References/CardMedium/SourcePNGs"
    manifest = json.loads((args.native / "manifest.json").read_text())
    exports = json.loads((references / "manifest.json").read_text())["exports"]
    native = {}
    for test in manifest:
        for item in test["attachments"]:
            match = re.match(r"card-medium-(11335-\d+)-day-3x", item["suggestedHumanReadableName"])
            if match:
                native[match[1].replace("-", ":")] = args.native / item["exportedFileName"]
    assert set(native) == {entry["nodeID"] for entry in exports}, "Need all 21 actual native variants"
    args.output.mkdir(parents=True, exist_ok=True)
    sheet = Image.new("RGB", (7 * 450, 3 * 178), "#EEEEEE")
    draw = ImageDraw.Draw(sheet)
    measurements = []
    # All 21 observed whole-card exports have opaque white canvas corners.
    # Native snapshots are transparent there: normalize only alpha compositing, never
    # move geometry, rescale the card, alter text or correct the RGB values.
    matte = (255, 255, 255, 255)
    for index, entry in enumerate(exports):
        original = Image.open(root / entry["path"]).convert("RGBA")
        assert original.getpixel((0, 0)) == matte, "Recheck canvas matte before comparing new exports"
        source = composite(original, matte)
        rendered = composite(Image.open(native[entry["nodeID"]]), matte)
        assert rendered.size == (source.width * 3, source.height * 3), entry["nodeID"]
        rendered = rendered.resize(source.size, Image.Resampling.LANCZOS)
        diff = np.abs(np.asarray(source, dtype=int) - np.asarray(rendered, dtype=int))
        measurements.append({"nodeID": entry["nodeID"], "source": entry["path"],
                             "native": str(native[entry["nodeID"]].relative_to(root)),
                             "meanAbsoluteRGBDifference": float(diff.mean()),
                             "maximumRGBDifference": int(diff.max()),
                             "fractionPixelsOver16": float((diff.max(axis=2) > 16).mean())})
        x, y = index % 7 * 450, index // 7 * 178
        draw.text((x + 8, y + 2), entry["nodeID"] + " · Figma / Native / Difference ×4", fill="black")
        sheet.paste(source, (x + 5, y + 25))
        sheet.paste(rendered, (x + 151, y + 25))
        sheet.paste(Image.fromarray(np.clip(diff * 4, 0, 255).astype("uint8")), (x + 297, y + 25))
    (args.output / "comparison.json").write_text(json.dumps({
        "method": "Unmodified whole-card Figma exports with observed opaque white corners and native 3x PNG composited on white; native downsampled to source 1x with LANCZOS. No alignment correction. Metrics are diagnostic, not acceptance.",
        "variants": measurements}, ensure_ascii=False, indent=2) + "\n")
    sheet.save(args.output / "comparison.png")
    print(json.dumps({"variants": len(measurements), "largestMeanRGBDifference": max(x["meanAbsoluteRGBDifference"] for x in measurements)}))


if __name__ == "__main__":
    main()
