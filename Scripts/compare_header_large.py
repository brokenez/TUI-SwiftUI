#!/usr/bin/env python3
"""Compare original 1x Figma Header PNGs with native 3x render attachments.

Requires Pillow and NumPy. Native images are downsampled to source resolution;
this is a diagnostic, not an automatic assertion of visual acceptance.
"""
import argparse
import json
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "Documentation/References/HeaderLarge"
NATIVE = ROOT / "Documentation/Validation/2026-10-06/HeaderLargeNative"


def run(scale=1, native_folder=None, output_folder=None):
    NATIVE = ROOT / native_folder if native_folder else ROOT / "Documentation/Validation/2026-10-06/HeaderLargeNative"
    OUT = ROOT / output_folder if output_folder else ROOT / ("Documentation/Validation/2026-10-06/HeaderLargeComparison" + ("3x" if scale == 3 else ""))
    OUT.mkdir(exist_ok=True)
    attachments = [a for test in json.loads((NATIVE / "manifest.json").read_text()) for a in test["attachments"]]
    manifest = "figma-png-3x-export-2026-10-06.json" if scale == 3 else "figma-png-export-2026-10-06.json"
    variants = json.loads((SOURCE / manifest).read_text())["variants"]
    column_width = 375 * scale + 4
    row_height = 104 * scale + 28
    sheet = Image.new("RGB", (column_width * 3, len(variants) * row_height + 24), "#E8E8E8")
    draw = ImageDraw.Draw(sheet)
    draw.text((8, 4), f"Figma {scale}x", fill="black")
    draw.text((column_width + 8, 4), "Native 3x" if scale == 3 else "Native 3x -> 1x (LANCZOS)", fill="black")
    draw.text((column_width * 2 + 8, 4), "Absolute difference x4", fill="black")
    results = []
    for index, record in enumerate(variants):
        node = record["nodeId"].replace(":", "-")
        name = f"header-{node}-day-3x_"
        attachment = next(a for a in attachments if a["suggestedHumanReadableName"].startswith(name))
        source = Image.open(ROOT / record["path"]).convert("RGBA")
        background = Image.new("RGBA", source.size, "white")
        source = Image.alpha_composite(background, source).convert("RGB")
        native_path = NATIVE / attachment["exportedFileName"]
        native_full = Image.open(native_path).convert("RGB")
        assert native_full.size == (source.width * 3 // scale, source.height * 3 // scale), (node, native_full.size, source.size)
        native = native_full if scale == 3 else native_full.resize(source.size, Image.Resampling.LANCZOS)
        difference = np.abs(np.asarray(source).astype(np.int16) - np.asarray(native).astype(np.int16))
        diff_image = Image.fromarray(np.clip(difference * 4, 0, 255).astype(np.uint8))
        native.save(OUT / f"{node}-native-comparison-scale.png")
        diff_image.save(OUT / f"{node}-diff-x4.png")
        y = 24 + index * row_height
        draw.text((8, y), record["nodeId"], fill="black")
        sheet.paste(source, (0, y + 16))
        sheet.paste(native, (column_width, y + 16))
        sheet.paste(diff_image, (column_width * 2, y + 16))
        results.append({"variantId": record["nodeId"], "source": record["path"],
                        "runtime": str(native_path.relative_to(ROOT)), "dimensionsMatch": True,
                        "meanAbsoluteRGBDifference": float(difference.mean()),
                        "maximumRGBDifference": int(difference.max()),
                        "pixelsOver16Fraction": float((difference.max(axis=2) > 16).mean())})
    sheet.save(OUT / "contact-sheet.png")
    (OUT / "comparison.json").write_text(json.dumps({
        "method": "Figma RGBA composited on white; actual native 3x PNG compared directly at 3x." if scale == 3 else "Figma RGBA composited on white; actual native 3x PNG downsampled with LANCZOS to Figma 1x. No alignment shifts or color correction.",
        "sourceScale": scale,
        "automaticAcceptance": False, "variants": results
    }, ensure_ascii=False, indent=2) + "\n")
    for result in results:
        print(result["variantId"], "mean", round(result["meanAbsoluteRGBDifference"], 3),
              "pixels>16", round(result["pixelsOver16Fraction"] * 100, 2), "%")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-scale", type=int, choices=[1, 3], default=1)
    parser.add_argument("--native-folder", help="Native attachment directory relative to repository")
    parser.add_argument("--output-folder", help="Comparison output directory relative to repository")
    args = parser.parse_args()
    run(args.source_scale, args.native_folder, args.output_folder)
