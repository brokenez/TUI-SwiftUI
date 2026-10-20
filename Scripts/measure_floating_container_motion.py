#!/usr/bin/env python3
"""Measure the public Floating Container in lossless decoded native video frames.

The debug scene's color strip identifies state mutations. Pixels are never
aligned, painted or retimed. Bounds and frame intervals are diagnostic evidence,
not a substitute for complete specification/visual/motion acceptance.
"""
import argparse
import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw


def colored_runs(mask, top, scale):
    counts = mask.sum(axis=1)
    rows = np.flatnonzero(counts > 20 * scale)
    if not len(rows):
        return []
    runs = np.split(rows, np.flatnonzero(np.diff(rows) != 1) + 1)
    rectangles = []
    for run in runs:
        if len(run) < 3 * scale:
            continue
        ys, xs = np.where(mask[run[0]:run[-1] + 1])
        rectangles.append({
            "boundsPoints": [float(xs.min()) / scale, float(run[0] + top) / scale,
                             float(xs.max() + 1) / scale, float(run[-1] + top + 1) / scale],
            "wide": bool(counts[run].max() > 200 * scale),
        })
    return rectangles


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--frames", type=Path, required=True)
    parser.add_argument("--events", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--scale", type=float, required=True)
    args = parser.parse_args()
    if args.scale <= 0:
        parser.error("A positive native pixel scale is required")
    manifest = json.loads((args.frames / "frames.json").read_text())
    events = json.loads(args.events.read_text())["events"]
    marker_y = None
    samples = []
    for frame in manifest:
        rgb = np.asarray(Image.open(args.frames / frame["path"]).convert("RGB"))
        if marker_y is None:
            # Find the real stage-zero strip. It spans the consumer's entire
            # inner width, unlike native blue labels or navigation buttons.
            inner = rgb[:, int(20 * args.scale):-int(20 * args.scale), :].astype(float)
            strip = ((inner[:, :, 0] < 4) & (abs(inner[:, :, 1] - 51) < 4)
                     & (abs(inner[:, :, 2] - 204) < 4)).mean(axis=1)
            candidates = np.flatnonzero(strip > 0.9)
            if not len(candidates):
                continue
            marker_y = int(np.median(candidates))
        marker = rgb[marker_y, rgb.shape[1] // 2].astype(float)
        stage = round(marker[0] * 16 / 255)
        if (abs(marker[1] - 51) > 3 or abs(marker[2] - 204) > 3
                or abs(marker[0] - stage * 255 / 16) > 3 or not 0 <= stage <= 10):
            continue
        top = int(rgb.shape[0] - 240 * args.scale)
        footer = rgb[top:]
        yellow = ((footer[:, :, 0] > 235) & (footer[:, :, 1] > 180)
                  & (footer[:, :, 2] < 125))
        samples.append({**frame, "stage": stage, "markerRGB": marker.tolist(),
                        "yellowComponents": colored_runs(yellow, top, args.scale)})
    groups = []
    for event in events:
        selected = [sample for sample in samples if sample["stage"] == event["stage"]]
        if len(selected) < 3:
            raise SystemExit(f"Too few real frames for {event['name']}")
        first = selected[0]["time"]
        intervals = [b["time"] - a["time"] for a, b in zip(selected, selected[1:])
                     if b["time"] - a["time"] < 0.1]
        for sample in selected:
            sample["elapsedFromFirstRenderedStage"] = sample["time"] - first
        groups.append({**event, "firstRenderedMovieTime": first,
                       "maximumActiveFrameInterval": max(intervals) if intervals else None,
                       "sampleCount": len(selected), "samples": selected})
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps({
        "scope": "Unaltered native pixels and timestamps; diagnostic, not full acceptance",
        "scale": args.scale, "markerYInPixels": marker_y,
        "source": str(args.frames / "frames.json"), "events": groups,
        "limitations": ["First rendered stage is quantized to the recorded frame interval",
                         "Compressed color thresholds do not prove per-pixel opacity curves",
                         "Overlapping yellow buttons may form one detected component"],
    }, indent=2) + "\n")
    # A compact review sheet shows actual footer crops, including source
    # overshoot and removals. Resizing here affects only this diagnostic sheet.
    sheet = Image.new("RGB", (5 * 220, len(groups) * 168), "#FFFFFF")
    draw = ImageDraw.Draw(sheet)
    for row, group in enumerate(groups):
        draw.text((8, row * 168 + 3), group["name"], fill="#000000")
        for column, target in enumerate([0, 0.05, 0.15, 0.30, 0.55]):
            sample = min(group["samples"], key=lambda x: abs(x["elapsedFromFirstRenderedStage"] - target))
            image = Image.open(args.frames / sample["path"]).convert("RGB")
            crop = image.crop((0, image.height - int(240 * args.scale), image.width, image.height))
            crop.thumbnail((216, 132))
            sheet.paste(crop, (column * 220 + 2, row * 168 + 24))
            draw.text((column * 220 + 4, row * 168 + 156),
                      f"{sample['elapsedFromFirstRenderedStage']:.3f} s", fill="#000000")
    sheet.save(args.output.with_suffix(".png"))
    print(json.dumps([{k: v for k, v in group.items() if k != "samples"} for group in groups], indent=2))


if __name__ == "__main__":
    main()
