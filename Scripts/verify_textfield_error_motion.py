#!/usr/bin/env python3
"""Check observed native editor coordinates; this is not full Figma acceptance."""
import argparse
import hashlib
import json
import statistics
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def verify(path):
    data = json.loads(path.read_text())
    events = data["events"]
    frames = data["frames"]
    assert [event["name"] for event in events] == ["first", "repeated", "focus-only", "reset"]
    assert data["scale"] == 3
    assert len(frames) >= 60, "An active display-link trace is required"
    assert all(a["elapsed"] < b["elapsed"] for a, b in zip(frames, frames[1:]))
    baseline = statistics.median(frame["renderedX"] for frame in frames if frame["elapsed"] < events[0]["elapsed"])
    results = []
    for index, event in enumerate(events):
        end = events[index + 1]["elapsed"] if index + 1 < len(events) else float("inf")
        rows = [frame for frame in frames if event["elapsed"] <= frame["elapsed"] < end]
        assert rows, event["name"]
        offsets = [frame["renderedX"] - baseline for frame in rows]
        assert max(abs(offset) for offset in offsets) <= 3 + 1 / data["scale"] + 0.001
        signs = []
        for offset in offsets:
            sign = 1 if offset > 0.45 else -1 if offset < -0.45 else 0
            if sign and (not signs or sign != signs[-1]):
                signs.append(sign)
        moved = [frame for frame, offset in zip(rows, offsets) if abs(offset) > 0.25]
        last_movement = moved[-1]["elapsed"] - event["elapsed"] if moved else None
        if event["name"] in {"first", "repeated"}:
            expected_duration = 0.5 if event["name"] == "first" else 0.3
            expected_signs = [-1, 1, -1, 1] if event["name"] == "first" else [-1, 1]
            assert signs == expected_signs, (event["name"], signs)
            assert min(offsets) <= -2.3 and max(offsets) >= 2.3, (event["name"], min(offsets), max(offsets))
            assert last_movement is not None and abs(last_movement - expected_duration) <= 0.08
            assert abs(offsets[-1]) <= 1 / data["scale"] + 0.001, "Field must settle at its original X"
        else:
            assert not moved, "Focus-only and reset are not new validation events"
        results.append({"event": event["name"], "samples": len(rows), "minimumOffset": min(offsets),
                        "maximumOffset": max(offsets), "signSequence": signs,
                        "lastMovementAfterEvent": last_movement})
    return {"status": "passed-observed-native-geometry", "source": str(path.relative_to(ROOT)),
            "sourceSHA256": hashlib.sha256(path.read_bytes()).hexdigest(),
            "frames": len(frames), "baselineX": baseline, "events": results,
            "limits": "Checks native displacement, sign sequence, approximate total duration, return and non-validation focus/reset. Exact per-step source times, hint motion and physical haptic remain UNVERIFIED; no full motion acceptance."}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("samples", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = verify(args.samples.resolve())
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(result, ensure_ascii=False))


if __name__ == "__main__":
    main()
