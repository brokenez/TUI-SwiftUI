#!/usr/bin/env python3
"""Check actual pixels of the Card Medium debug scene in native UI recordings.

Input is a frames.json manifest of lossless PNGs decoded from XCTest's MP4.
Color thresholds tolerate video compression; no image alignment is applied.
"""
import argparse
import json
from pathlib import Path

import numpy as np
from PIL import Image


def bounds(mask):
    ys, xs = np.where(mask)
    if len(xs) < 100:
        return None
    return [int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1]


def dimensions(rect):
    left, top, right, bottom = rect
    return [(left + right) / 2, (top + bottom) / 2, right - left, bottom - top]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--frames", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--start", type=float, required=True)
    parser.add_argument("--end", type=float, required=True)
    parser.add_argument("--scale", type=float, required=True)
    arguments = parser.parse_args()
    if arguments.scale <= 0 or arguments.end <= arguments.start:
        parser.error("Positive pixel scale and increasing time interval required")
    frames = json.loads((arguments.frames / "frames.json").read_text())
    samples = []
    roi = None
    for frame in frames:
        if not arguments.start <= frame["time"] <= arguments.end:
            continue
        rgb = np.asarray(Image.open(arguments.frames / frame["path"]).convert("RGB"))
        pink = ((rgb[:, :, 0] > 210) & (rgb[:, :, 1] < 85)
                & (rgb[:, :, 2] > 55) & (rgb[:, :, 2] < 135))
        card = bounds(pink)
        if card is None:
            continue
        if roi is None:
            # Locate the sole pink production card first, then keep the same
            # spatial ROI for the neighboring blue marker throughout scaling.
            ys, xs = np.indices(rgb.shape[:2])
            roi = ((ys >= card[1] - 20) & (ys < card[3] + 20) & (xs > card[2]))
        blue = ((rgb[:, :, 0] < 20) & (rgb[:, :, 1] > 85)
                & (rgb[:, :, 1] < 160) & (rgb[:, :, 2] > 210) & roi)
        neighbor = bounds(blue)
        if neighbor is None:
            continue
        samples.append(dict(frame, card=card, neighbor=neighbor))
    if len(samples) < 10:
        raise SystemExit("Too few actual frames containing both markers; check the interval")
    card = np.array([dimensions(sample["card"]) for sample in samples])
    neighbor = np.array([dimensions(sample["neighbor"]) for sample in samples])
    baseline = card[0]
    scale = card[:, 2] / baseline[2]
    center_delta = np.max(np.abs(card[:, :2] - baseline[:2]), axis=0)
    neighbor_delta = np.max(np.abs(neighbor - neighbor[0]), axis=0)
    # Two compressed edge pixels at a 3x screen are under one logical point.
    # These tolerances cannot conceal the large coordinate jumps that prompted
    # this check; raw bounds remain in the output for independent review.
    checks = {
        "centerStable": bool(np.max(center_delta) <= 2),
        "neighborStable": bool(np.max(neighbor_delta) <= 2),
        "pressedScale": bool(abs(float(scale.min()) - 0.95) <= 2 / baseline[2]),
        "returnsToOriginalSize": bool(abs(card[-1, 2] - baseline[2]) <= 2),
    }
    result = {
        "scope": "Actual pixels, production TUICardMedium with diagnostic background; no typography acceptance",
        "pixelScale": arguments.scale,
        "interval": [arguments.start, arguments.end],
        "sampleCount": len(samples),
        "minimumWidthScale": float(scale.min()),
        "maximumCenterDeviationPoints": (center_delta / arguments.scale).tolist(),
        "maximumNeighborDeviationPoints": (neighbor_delta / arguments.scale).tolist(),
        "checks": checks,
        "samples": samples,
    }
    arguments.output.parent.mkdir(parents=True, exist_ok=True)
    arguments.output.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({key: value for key, value in result.items() if key != "samples"}, indent=2))
    if not all(checks.values()):
        raise SystemExit("Actual recorded geometry does not satisfy the source motion")


if __name__ == "__main__":
    main()
