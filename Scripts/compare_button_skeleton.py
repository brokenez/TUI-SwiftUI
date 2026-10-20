#!/usr/bin/env python3
"""Verify default Skeleton regression and measure Button Skeleton source pairs.

Uses native XCTest attachments; never assigns component acceptance.
"""
import hashlib
import json
import re
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'Documentation/Validation/2026-10-13/ButtonSkeleton'
CURRENT = OUT / 'PackageNative'
PREVIOUS = ROOT / 'Documentation/Validation/2026-10-13/ButtonSkeletonRadius/Native'
SOURCE = ROOT / 'Documentation/References/Button/2026-10-13'


def attachment_index(folder):
    result = {}
    for test in json.loads((folder / 'manifest.json').read_text()):
        for item in test['attachments']:
            name = item['suggestedHumanReadableName'].split('_0_')[0].removesuffix('.png')
            assert name not in result, name
            result[name] = folder / item['exportedFileName']
    return result


def relative(path):
    return str(path.relative_to(ROOT))


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rgba(path):
    return np.array(Image.open(path).convert('RGBA')).astype('int16')


def on_white(image):
    image = image.convert('RGBA')
    return Image.alpha_composite(Image.new('RGBA', image.size, 'white'), image).convert('RGB')


def main():
    current, previous = attachment_index(CURRENT), attachment_index(PREVIOUS)
    registry = json.loads((ROOT / 'Documentation/component-verification.json').read_text())
    accepted = {}
    for record in registry['components']:
        if record['id'] in ['37840:45833', '37840:45836']:
            for item in record['checks']['visual']['evidence']:
                if item.get('kind') == 'runtime-render' and '2026-10-05' in item['path']:
                    accepted[item['variantID']] = ROOT / item['path']
    regression, buttons, pairs, rows = [], [], [], []
    for name, actual_path in sorted(current.items()):
        match = re.fullmatch(r'skeleton-(?:text-)?(\d+)-(\d+)-day-3x', name)
        if match:
            node = f'{match[1]}:{match[2]}'
            reference = accepted[node]
            actual, expected = rgba(actual_path), rgba(reference)
            assert actual.shape == expected.shape, name
            assert np.array_equal(actual, expected), name
            regression.append({'variantID': node, 'native': relative(actual_path),
                               'reference': relative(reference), 'RGBAIdentical': True,
                               'nativeSHA256': digest(actual_path), 'referenceSHA256': digest(reference)})
        match = re.fullmatch(r'button-skeleton-(55915)(350412|350422|350432)-(Day|Night)-3x', name)
        if not match:
            continue
        node = f'{match[1]}:{match[2]}'
        actual, expected = rgba(actual_path), rgba(previous[name])
        assert actual.shape == expected.shape, name
        delta = abs(actual - expected)
        buttons.append({'variantID': node, 'theme': match[3], 'native': relative(actual_path),
                        'previous': relative(previous[name]), 'nativeSHA256': digest(actual_path),
                        'previousSHA256': digest(previous[name]),
                        'changedChannels': int(np.count_nonzero(delta)),
                        'maximumDifference_255': int(delta.max()), 'MAE_255': float(delta.mean())})
        if match[3] != 'Day':
            continue
        source_path = SOURCE / f'skeleton-{node.replace(":", "-")}.png'
        source = on_white(Image.open(source_path))
        pose = on_white(Image.open(actual_path).resize(source.size, Image.Resampling.LANCZOS))
        delta = abs(np.array(source).astype('int16') - np.array(pose).astype('int16'))
        pairs.append({'variantID': node, 'theme': 'Day', 'figma': relative(source_path),
                      'figmaSHA256': digest(source_path), 'native': relative(actual_path),
                      'nativeSHA256': digest(actual_path), 'sourceSize': list(source.size),
                      'MAE_255': float(delta.mean()), 'maximumDifference_255': int(delta.max())})
        row = Image.new('RGB', (1030, source.height + 26), 'white')
        ImageDraw.Draw(row).text((5, 3), f'{node}: Figma / native / difference x8', fill='black')
        row.paste(source, (5, 25))
        row.paste(pose, (345, 25))
        row.paste(Image.fromarray(np.clip(delta * 8, 0, 255).astype('uint8')), (685, 25))
        rows.append(row)
    assert len(regression) == 15 and len(buttons) == 6 and len(pairs) == 3
    sheet = Image.new('RGB', (1030, sum(row.height for row in rows)), 'white')
    y = 0
    for row in rows:
        sheet.paste(row, (0, y))
        y += row.height
    sheet.save(OUT / 'source-pairs.png')
    result = {'regressionMethod': 'Full original 3x RGBA; no resizing, alignment or normalization',
              'sourcePairMethod': 'Native 3x downsampled to Figma 1x with LANCZOS; white composite; no alignment or color adjustment',
              'acceptedStaticPoses': regression, 'buttonBeforeAfter': buttons, 'buttonFigmaPairs': pairs,
              'limitations': 'Three Day source pairs only. Night source pairing and full Button acceptance remain pending; edge rasterization is reported, not waived.'}
    (OUT / 'static-regression.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    measurements = []
    ui = OUT / 'NativeUI'
    for test in json.loads((ui / 'manifest.json').read_text()):
        for item in test['attachments']:
            path = ui / item['exportedFileName']
            if path.suffix == '.txt':
                measurements.append({'name': item['suggestedHumanReadableName'],
                                     'file': relative(path), 'measurement': path.read_text()})
    (OUT / 'native-ui-measurements.json').write_text(json.dumps(measurements, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps({'acceptedDayPosesIdentical': len(regression), 'buttonRuntimePoses': len(buttons),
                      'buttonDaySourcePairs': len(pairs), 'liveMeasurementFiles': len(measurements)}))


if __name__ == '__main__':
    main()
