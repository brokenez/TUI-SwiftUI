#!/usr/bin/env python3
"""Compare 24 Accent/Secondary source poses with historical native renders.

Measurements are diagnostic. This never assigns component acceptance.
"""
import argparse
import hashlib
import json
import re
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[4]
SOURCES = Path(__file__).resolve().parent


def native_index(folder):
    result = {}
    for test in json.loads((folder / 'manifest.json').read_text()):
        for item in test['attachments']:
            match = re.match(r'button-(\d+)-(\d+)-(day|night)-source-frame-3x_',
                             item['suggestedHumanReadableName'])
            if match:
                key = (f'{match[1]}:{match[2]}', match[3])
                assert key not in result, key
                result[key] = folder / item['exportedFileName']
    return result


def on_white(image):
    rgba = image.convert('RGBA')
    return Image.alpha_composite(Image.new('RGBA', rgba.size, 'white'), rgba).convert('RGB')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--native', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    for key in ['native', 'output']:
        path = getattr(args, key).resolve()
        assert path.is_relative_to(ROOT), path
        setattr(args, key, path)
    styles = json.loads((ROOT / 'Sources/TUIDesignSystem/Resources/Metadata/figma-button-styles.json').read_text())['styles']
    applicable = {s['id']: s for s in styles if s['properties']['appearance'] != 'glass'}
    primary = [s for s in applicable.values() if s['properties']['appearance'] in ['accent', 'secondary']
               and s['properties']['skeleton'] == 'off']
    assert len(primary) == 24
    native = native_index(args.native)
    expected = {(node, theme) for node in applicable for theme in ['day', 'night']}
    assert len(expected) == 270
    assert set(native) == expected
    for key in sorted(expected):
        image = Image.open(native[key])
        style = applicable[key[0]]
        assert image.size == (int(style['width'] * 3), int(style['height'] * 3)), key
    rows, records = [], []
    for style in sorted(primary, key=lambda s: (s['properties']['appearance'], s['properties']['size'], s['properties']['state'])):
        node = style['id']
        source_path = SOURCES / f'{style["properties"]["appearance"]}-{node.replace(":", "-")}.png'
        source = on_white(Image.open(source_path))
        assert source.size == (int(style['width']), int(style['height'])), node
        row = Image.new('RGB', (1030, source.height + 27), 'white')
        draw = ImageDraw.Draw(row)
        draw.text((5, 3), f'{style["properties"]["appearance"]} {node} {style["properties"]["size"]} {style["properties"]["state"]}: Figma / native / difference x4', fill='black')
        row.paste(source, (5, 25))
        path = native[(node, 'day')]
        actual = on_white(Image.open(path).resize(source.size, Image.Resampling.LANCZOS))
        delta = np.abs(np.asarray(source, dtype=float) - np.asarray(actual, dtype=float))
        contents_width = (16 if style['properties']['size'] == 'small' else 24) \
            if style['properties']['state'] == 'loading' else min(source.width, 52)
        x = (source.width - contents_width) // 2
        contents = delta[:, x:x + contents_width]
        records.append({'variantID': node, 'properties': style['properties'], 'theme': 'day',
            'source': str(source_path.relative_to(ROOT)),
            'sourceSHA256': hashlib.sha256(source_path.read_bytes()).hexdigest(),
            'native': str(path.relative_to(ROOT)),
            'nativeSHA256': hashlib.sha256(path.read_bytes()).hexdigest(),
            'surfaceSamplePoint': [source.width // 2, source.height // 6],
            'sourceSurfaceRGB': source.getpixel((source.width // 2, source.height // 6)),
            'nativeSurfaceRGB': actual.getpixel((source.width // 2, source.height // 6)),
            'MAE_255': round(float(delta.mean()), 5),
            'contentColumnMAE_255': round(float(contents.mean()), 5),
            'maxDifference_255': int(delta.max())})
        row.paste(actual, (345, 25))
        row.paste(Image.fromarray(np.clip(delta * 4, 0, 255).astype('uint8')), (685, 25))
        rows.append(row)
    args.output.mkdir(parents=True, exist_ok=True)
    sheet = Image.new('RGB', (1030, sum(r.height for r in rows)), 'white')
    y = 0
    for row in rows:
        sheet.paste(row, (0, y)); y += row.height
    sheet.save(args.output / 'accent-secondary-comparison.png')
    report = {'scope': 'Twenty-four exact Accent/Secondary Day exports read 2026-10-15 and 270 historical native source-frame renders from 2026-10-13. '
              'Native 3x reduced with LANCZOS on white. No alignment or color correction. '
              'Native renders precede shared Skeleton integration; these selected non-skeleton paths were not changed by that integration. Static loading pose only, not animation timing. Night source comparison is UNVERIFIED. No acceptance assigned.',
              'sourcePairs': 24, 'nativeMatrix': 270, 'measurements': records}
    (args.output / 'accent-secondary-comparison.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'dayPairs': 24, 'nativeMatrix': 270,
                      'maxMeanDifference_255': max(r['MAE_255'] for r in records)}, indent=2))


if __name__ == '__main__':
    main()
