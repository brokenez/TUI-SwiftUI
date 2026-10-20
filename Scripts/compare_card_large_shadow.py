#!/usr/bin/env python3
"""Compare actual Card Large PNGs over the original Figma effect bounds."""
import json
import re
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
folder = Path(sys.argv[1]).resolve()
assert folder.is_relative_to(ROOT), 'Evidence must remain inside the repository'
records = []
rows = []
groups = {}
for test in json.loads((folder / 'manifest.json').read_text()):
    for attachment in test['attachments']:
        match = re.match(r'card-large-(?:cell-)?full-shadow-(\d+)-(\d+)-(?:(.+)-)?day-3x_',
                         attachment['suggestedHumanReadableName'])
        if match:
            groups.setdefault(f'{match[1]}:{match[2]}', {})[match[3] or 'production'] = folder / attachment['exportedFileName']
assert groups, 'No native full-shadow attachments found'

def on_white(image):
    image = image.convert('RGBA')
    return Image.alpha_composite(Image.new('RGBA', image.size, 'white'), image).convert('RGB')

for node, variants in sorted(groups.items()):
    source_path = ROOT / 'Documentation/References/CardLarge/FigmaPNG' / (node.replace(':', '-') + '-day-1x.png')
    source = on_white(Image.open(source_path))
    natural_height = source.height - 68
    assert source.width == 411 and natural_height in [72, 80, 84, 144]
    source_pixels = np.asarray(source, dtype=float)
    outside = np.ones(source_pixels.shape[:2], dtype=bool)
    outside[28:28 + natural_height, 34:377] = False
    modes = sorted(variants)
    row = Image.new('RGB', ((source.width + 10) * (len(modes) + 1), source.height + 35), '#F1F2F3')
    draw = ImageDraw.Draw(row)
    draw.text((0, 5), node + ' Figma', fill='black')
    row.paste(source, (0, 25))
    for index, mode in enumerate(modes, 1):
        native_path = variants[mode]
        original = Image.open(native_path)
        assert original.size == (source.width * 3, source.height * 3), native_path
        native = on_white(original.resize(source.size, Image.Resampling.LANCZOS))
        difference = np.abs(source_pixels - np.asarray(native, dtype=float))
        records.append({'variantID': node, 'mode': mode, 'sourceSize': list(source.size),
                        'nativeSize': list(original.size),
                        'MAE_255': round(float(difference.mean()), 5),
                        'outsideSurfaceMAE_255': round(float(difference[outside].mean()), 5),
                        'outsideSurfaceMax_255': round(float(difference[outside].max()), 5),
                        'source': str(source_path.relative_to(ROOT)),
                        'native': str(native_path.relative_to(ROOT))})
        x = index * (source.width + 10)
        draw.text((x, 5), mode, fill='black')
        row.paste(native, (x, 25))
    rows.append(row)

canvas = Image.new('RGB', (max(row.width for row in rows), sum(row.height for row in rows)), 'white')
y = 0
for row in rows:
    canvas.paste(row, (0, y))
    y += row.height
canvas.save(folder / 'full-shadow-contact-sheet.png')
report = {'scope': f'{len(groups)} elevated Day compositions, full original Figma export bounds. '
                  'Native 3x reduced with LANCZOS; both composited on white. '
                  'Outside-surface mask excludes x=34..376, y=28..naturalHeight+27. '
                  'Measurements are diagnostic, not automatic acceptance.', 'results': records}
(folder / 'comparison.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(records, indent=2))
