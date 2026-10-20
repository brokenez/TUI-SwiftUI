#!/usr/bin/env python3
"""Compare real Floating Button exports outside their component surfaces."""
import argparse
import json
import re
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'Documentation/References/Button/2026-10-13'
SIZES = {'49513:311416': ('large', 323, 56), '49513:311400': ('medium', 323, 44),
         '49513:311393': ('small', 57, 30)}


def attachments(folder):
    result = {}
    for test in json.loads((folder / 'manifest.json').read_text()):
        for item in test['attachments']:
            match = re.match(r'button-floating-full-shadow-(\d+)-(\d+)-(Day|Night)-3x_',
                             item['suggestedHumanReadableName'])
            if match:
                result[(f'{match[1]}:{match[2]}', match[3])] = folder / item['exportedFileName']
    assert all((node, theme) in result for node in SIZES for theme in ['Day', 'Night']), \
        'Expected all three normal source sizes in both native themes'
    return result


def on_white(image):
    rgba = image.convert('RGBA')
    return Image.alpha_composite(Image.new('RGBA', rgba.size, 'white'), rgba).convert('RGB')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--before', type=Path, required=True)
    parser.add_argument('--after', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.before = args.before.resolve()
    args.after = args.after.resolve() if args.after else None
    args.output = args.output.resolve()
    assert all(p.is_relative_to(ROOT) for p in [args.before, args.output] + ([args.after] if args.after else [])), \
        'Keep source and comparison evidence inside the repository'
    args.output.mkdir(parents=True, exist_ok=True)
    groups = {'before': attachments(args.before)}
    if args.after:
        groups['after'] = attachments(args.after)
    records, rows = [], []
    for node, (size, width, height) in SIZES.items():
        source_path = SOURCE / f'floating-{size}-{node.replace(":", "-")}.png'
        source = on_white(Image.open(source_path))
        assert source.size == (width + 40, height + 40)
        outside = np.ones((source.height, source.width), dtype=bool)
        outside[15:15 + height, 20:20 + width] = False
        original = np.asarray(source, dtype=float)
        row = Image.new('RGB', ((source.width + 10) * (len(groups) + 1), source.height + 25), 'white')
        draw = ImageDraw.Draw(row)
        draw.text((0, 3), f'{size} Figma', fill='black')
        row.paste(source, (0, 25))
        for index, (mode, native_files) in enumerate(groups.items(), 1):
            path = native_files[(node, 'Day')]
            native = Image.open(path)
            assert native.size == (source.width * 3, source.height * 3)
            normalized = on_white(native.resize(source.size, Image.Resampling.LANCZOS))
            difference = np.abs(original - np.asarray(normalized, dtype=float))
            records.append({'variantID': node, 'mode': mode,
                            'source': str(source_path.relative_to(ROOT)),
                            'native': str(path.relative_to(ROOT)),
                            'sourceSize': list(source.size), 'nativeSize': list(native.size),
                            'MAE_255': round(float(difference.mean()), 5),
                            'outsideSurfaceMAE_255': round(float(difference[outside].mean()), 5),
                            'outsideSurfaceMax_255': int(difference[outside].max())})
            x = index * (source.width + 10)
            draw.text((x, 3), mode, fill='black')
            row.paste(normalized, (x, 25))
        rows.append(row)
    canvas = Image.new('RGB', (max(r.width for r in rows), sum(r.height for r in rows)), 'white')
    y = 0
    for row in rows:
        canvas.paste(row, (0, y))
        y += row.height
    canvas.save(args.output / 'comparison.png')
    report = {'scope': 'Three normal Floating Button Day source exports, full effect bounds. '
                      'Native 3x reduced with LANCZOS and composited on white. '
                      'Outside-surface metrics exclude the component rectangle and typography. '
                      'Diagnostic measurements do not accept the whole component.', 'results': records}
    if args.after:
        report['nightPixelRegression'] = {
            node: Image.open(groups['before'][(node, 'Night')]).tobytes()
                == Image.open(groups['after'][(node, 'Night')]).tobytes() for node in SIZES}
        assert all(report['nightPixelRegression'].values()), 'Night must remain unchanged'
        for node in SIZES:
            before, after = [next(r for r in records if r['variantID'] == node and r['mode'] == m)
                             for m in ['before', 'after']]
            assert after['outsideSurfaceMAE_255'] < before['outsideSurfaceMAE_255'] / 2, node
    (args.output / 'comparison.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
