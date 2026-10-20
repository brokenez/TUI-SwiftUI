#!/usr/bin/env python3
"""Compare actual container content with source PNGs, excluding Apple chrome.

Diagnostic only: 1x MCP source raster and downsampled 3x ImageRenderer differ
in antialiasing. This does not approve the component or fabricate Night refs.
"""
import json
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'Documentation/References/FloatingContainer/2026-10-12/Variants'
RESULT = ROOT / 'Documentation/Validation/2026-10-12/FloatingContainer'
RENDERS = RESULT / 'Package'


def main():
    entries = [a for group in json.loads((RENDERS / 'manifest.json').read_text())
               for a in group.get('attachments', [])]
    rows = []
    pairs = []
    for entry in entries:
        name = entry['suggestedHumanReadableName'].split('_0_')[0]
        if '-Day-' not in name:
            continue
        node = name.removeprefix('floating-').removesuffix('-Day-3x')
        source = Image.open(SOURCE / (node + '.png')).convert('RGBA')
        # Exact imported source records contain 34 pt system-bottom-bar.
        # The delivered container leaves that space to native iOS 26.
        source = source.crop((0, 0, 375, source.height - 34))
        actual = Image.open(RENDERS / entry['exportedFileName']).convert('RGBA')
        assert actual.size == (source.width * 3, source.height * 3)
        actual = actual.resize(source.size, Image.Resampling.LANCZOS)
        source_rgb = Image.alpha_composite(Image.new('RGBA', source.size, 'white'), source).convert('RGB')
        actual_rgb = Image.alpha_composite(Image.new('RGBA', actual.size, 'white'), actual).convert('RGB')
        delta = np.abs(np.asarray(source_rgb, dtype=float) - np.asarray(actual_rgb, dtype=float))
        rows.append({'variantID': node.replace('-', ':'), 'theme': 'Day',
                     'contentSize': list(source.size), 'rgbMAE255': float(delta.mean()),
                     'rasterLimitation': 'MCP screenshot bakes a checkerboard into transparent pixels; alpha comparison is invalid.',
                     'source': str((SOURCE / (node + '.png')).relative_to(ROOT)),
                     'native': str((RENDERS / entry['exportedFileName']).relative_to(ROOT)),
                     'acceptance': 'pending'})
        pairs.append((node, source_rgb, actual_rgb))
    canvas = Image.new('RGB', (810, sum(max(s.height, a.height) + 38 for _, s, a in pairs)), '#eceff2')
    draw = ImageDraw.Draw(canvas)
    y = 0
    for node, source, actual in pairs:
        draw.text((12, y + 5), node + ' Figma', fill='black')
        draw.text((420, y + 5), 'SwiftUI', fill='black')
        canvas.paste(source, (12, y + 25)); canvas.paste(actual, (420, y + 25))
        y += max(source.height, actual.height) + 38
    (RESULT / 'comparison.json').write_text(json.dumps({'pairs': rows, 'scope':
        'Five Day presets; custom-content editor Placeholder excluded. Night source refs unavailable. Source checkerboard retained; RGB MAE is diagnostic only.'},
        ensure_ascii=False, indent=2) + '\n')
    canvas.save(RESULT / 'comparison.png')
    print(json.dumps(rows, ensure_ascii=False))


if __name__ == '__main__':
    main()
