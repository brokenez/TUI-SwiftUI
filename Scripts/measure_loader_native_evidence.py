#!/usr/bin/env python3
"""Measure exported XCTest screenshots. Diagnostics do not grant acceptance."""
import argparse
import json
import math
import re
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw


def attachments(folder):
    return [item for test in json.loads((folder / "manifest.json").read_text())
            for item in test["attachments"]]


def white(image):
    image = image.convert("RGBA")
    return Image.alpha_composite(Image.new("RGBA", image.size, "white"), image).convert("RGB")


def comparisons(root, output):
    references = root / "Documentation/References/Loader/FreshFigma"
    native = output / "PackageNative"
    node_ids = {12: "42819:293394", 16: "42678:293418", 24: "42819:293395",
                32: "42977:286792", 40: "43680:292637"}
    sheet = Image.new("RGB", (750, 5 * 170), "#EEEEEE")
    draw = ImageDraw.Draw(sheet)
    rows = []
    items = attachments(native)
    for index, (size, node_id) in enumerate(node_ids.items()):
        source_path = references / (node_id.replace(":", "-") + ".png")
        source = white(Image.open(source_path))
        assert source.size == (size, size)
        display = [source]
        for prefix in ["loader-", "loader-native-circle-source-pose-"]:
            for theme in ["Day", "Night"]:
                name = f"{prefix}{size}-{theme}_"
                item, = [entry for entry in items if entry["suggestedHumanReadableName"].startswith(name)]
                path = native / item["exportedFileName"]
                original = white(Image.open(path))
                assert original.size == (size * 3, size * 3)
                rendered = original.resize(source.size, Image.Resampling.LANCZOS)
                difference = np.abs(np.asarray(source, dtype=int) - np.asarray(rendered, dtype=int))
                rows.append({"variantID": node_id, "size": size, "theme": theme,
                             "branch": "source-svg" if prefix == "loader-" else "native-circle-source-pose",
                             "source": str(source_path.relative_to(root)), "native": str(path.relative_to(root)),
                             "meanAbsoluteRGBDifference": float(difference.mean()),
                             "maximumRGBDifference": int(difference.max()),
                             "pixelsOver16": int((difference.max(axis=2) > 16).sum())})
                if theme == "Day":
                    display.append(rendered)
        for column, (image, title) in enumerate(zip(display, ["Figma", "Native SVG", "Native Circle"])):
            x, y = column * 250, index * 170
            draw.text((x + 8, y + 8), f"{size} pt | {title}", fill="black")
            enlarged = image.resize((size * 3, size * 3), Image.Resampling.NEAREST)
            sheet.paste(enlarged, (x + 8, y + 35))
    sheet.save(output / "source-pose-comparison.png")
    (output / "source-pose-comparison.json").write_text(json.dumps({
        "method": "Unmodified Figma 1x exports; native 3x alpha composited on white and LANCZOS downsampled to 1x. No geometry alignment. Sheet enlarges all 1x comparisons equally with nearest neighbor. Night uses white only to compare contours, not to verify scene background.",
        "automaticAcceptance": False, "pairs": rows}, indent=2) + "\n")
    return rows


def timeline(output):
    folder = output / "NativeUI"
    items = attachments(folder)
    metadata_item, = [x for x in items if x["suggestedHumanReadableName"].startswith("loader-native-timeline-timestamps_")]
    metadata = json.loads((folder / metadata_item["exportedFileName"]).read_text())
    files = {}
    for item in items:
        match = re.match(r"loader-native-timeline-frame-(\d+)_", item["suggestedHumanReadableName"])
        if match:
            files[int(match[1])] = item["exportedFileName"]
    assert set(files) == {int(x["index"]) for x in metadata["samples"]}
    bins = 2048
    angles = np.arange(bins) * math.tau / bins
    # Source construction: diameter 40 pt, stroke 40/12 pt, scale 3.
    radius = (40 - 40 / 12) * 3 / 2
    center = 60
    x = np.floor(center + radius * np.cos(angles)).astype(int)
    y = np.floor(center + radius * np.sin(angles)).astype(int)
    rows = []
    for sample in metadata["samples"]:
        path = folder / files[int(sample["index"])]
        rgb = np.asarray(white(Image.open(path)))
        pixels = rgb[y, x]
        mask = (pixels[:, 0] > 240) & (pixels[:, 1] > 170) & (pixels[:, 2] < 100)
        # The longest circular background run separates the round endpoints.
        doubled = np.tile(~mask, 2)
        boundaries = np.diff(np.concatenate(([False], doubled, [False])).astype(int))
        starts, ends = np.where(boundaries == 1)[0], np.where(boundaries == -1)[0]
        valid = [(int(b - a), int(a), int(b)) for a, b in zip(starts, ends) if a < bins]
        length, start, end = max(valid) if valid else (0, 0, 0)
        length = min(length, bins)
        rows.append({**sample, "file": files[int(sample["index"])],
                     "midpointSeconds": (sample["beforeScreenshot"] + sample["afterScreenshot"]) / 2,
                     "captureUncertaintySeconds": (sample["afterScreenshot"] - sample["beforeScreenshot"]) / 2,
                     "visibleArcFraction": 1 - length / bins,
                     "roundCapStartAngleDegrees": (end % bins) * 360 / bins})
    times = np.array([r["midpointSeconds"] for r in rows])
    fractions = np.array([r["visibleArcFraction"] for r in rows])
    best = None
    # Fit period independently over 3..5 seconds; phase is free because tapping is not an animation start timestamp.
    # Also fit slope/round-cap offset, rather than assuming that they match the Swift implementation.
    for period in np.arange(3, 5.0001, .005):
        offsets = np.arange(0, period, .005)
        phases = (times[None, :] + offsets[:, None]) % period / period
        triangles = 1 - np.abs(2 * phases - 1)
        centered = triangles - triangles.mean(axis=1, keepdims=True)
        slopes = (centered @ (fractions - fractions.mean())) / (centered * centered).sum(axis=1)
        intercepts = fractions.mean() - slopes * triangles.mean(axis=1)
        predictions = slopes[:, None] * triangles + intercepts[:, None]
        errors = ((predictions - fractions) ** 2).mean(axis=1)
        i = int(errors.argmin())
        candidate = (float(errors[i]), float(period), float(offsets[i]), float(slopes[i]), float(intercepts[i]))
        if best is None or candidate[0] < best[0]:
            best = candidate
    error, period, offset, peak, cap = best
    phase = (times + offset) % period / period
    # Endpoint angular change contains trim movement in the shrinking half.
    # Subtract the independently fitted trim start before measuring container rotation.
    cap_angle = cap * 180
    observed = np.array([r["roundCapStartAngleDegrees"] for r in rows]) + cap_angle
    trim_start = np.where(phase <= .5, 0, (phase - .5) * 2 * peak * 360)
    container = np.unwrap(np.deg2rad(observed - trim_start)) * 180 / math.pi
    usable = (fractions > .10) & (fractions < .92)
    slope, intercept = np.polyfit(times[usable], container[usable], 1)
    rotation_rmse = float(np.sqrt(((slope * times[usable] + intercept - container[usable]) ** 2).mean()))
    report = {"method": "Actual active-scene screenshots, yellow centerline angular occupancy and longest circular gap. Period search 3..5s with free phase, amplitude and cap offset; container rotation measured from endpoints after removing fitted trim movement. Screenshot time is bounded by before/after timestamps. Not a frame-rate or smoothness measurement.",
              "sourceVariantID": metadata["sourceVariantID"], "samples": len(rows),
              "captureDurationSeconds": metadata["durationSeconds"], "frameInPoints": metadata["frameInPoints"],
              "fittedTrimPeriodSeconds": period, "fittedPhaseOffsetSeconds": offset,
              "fittedMaximumTrimFraction": peak, "fittedRoundCapFraction": cap,
              "arcFractionRMSE": math.sqrt(error),
              "containerDegreesPerSecond": float(slope), "rotationAngleRMSEDegrees": rotation_rmse,
              "maximumScreenshotTimeUncertaintySeconds": max(r["captureUncertaintySeconds"] for r in rows),
              "automaticAcceptance": False, "frames": rows}
    (output / "native-timeline-measurement.json").write_text(json.dumps(report, indent=2) + "\n")
    sheet = Image.new("RGB", (7 * 160, 5 * 160), "#EEEEEE")
    draw = ImageDraw.Draw(sheet)
    for index, row in enumerate(rows):
        x0, y0 = index % 7 * 160, index // 7 * 160
        draw.text((x0 + 4, y0 + 4), f"{row['midpointSeconds']:.2f}s | {row['visibleArcFraction']:.3f}", fill="black")
        sheet.paste(white(Image.open(folder / row["file"])), (x0 + 4, y0 + 28))
    sheet.save(output / "native-timeline-contact-sheet.png")
    return {key: report[key] for key in ["samples", "fittedTrimPeriodSeconds", "fittedMaximumTrimFraction", "arcFractionRMSE", "containerDegreesPerSecond", "rotationAngleRMSEDegrees"]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--evidence", required=True, type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    output = args.evidence.resolve()
    pairs = comparisons(root, output)
    print(json.dumps({"staticPairs": len(pairs), "timeline": timeline(output)}))


if __name__ == "__main__":
    main()
