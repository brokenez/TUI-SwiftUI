#!/usr/bin/env python3
"""Generate the web reader from the real iOS library, without changing acceptance."""
import hashlib
import json
import re
import shutil
import struct
import sys
from pathlib import Path
from coverage_model import evaluate, ios_scope

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'WebCatalog/public'
META = ROOT / 'Sources/TUIDesignSystem/Resources/Metadata'
OUT.mkdir(parents=True, exist_ok=True)
used_assets = set()

def read(path):
    return json.loads((ROOT / path).read_text())

def asset(relative):
    source = (ROOT / relative).resolve()
    if not source.is_relative_to(ROOT) or not source.is_file():
        raise ValueError(f'Missing or unsafe catalog asset: {relative}')
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    name = f'assets/{digest[:20]}{source.suffix}'
    target = OUT / name
    used_assets.add(target.name)
    target.parent.mkdir(exist_ok=True)
    if not target.exists():
        shutil.copy2(source, target)
    return {'url': name, 'sourcePath': relative, 'sha256': digest}

def image(relative, scale=3, surface=None):
    value = asset(relative)
    raw = (ROOT / relative).read_bytes()
    if raw[:8] != b'\x89PNG\r\n\x1a\n':
        raise ValueError(f'Expected native PNG: {relative}')
    width, height = struct.unpack('>II', raw[16:24])
    return {**value, 'width': width / scale, 'height': height / scale, 'scale': scale, 'surface': surface}

def example(symbol, parameters):
    """Only supported public APIs; every emitted sample is compiled by QA."""
    p = dict(parameters)
    action = False
    state = ''
    if symbol in ['TUICardMedium', 'TUIHeaderLarge']:
        expression = symbol + '(variant: .' + p['variant'] + ')'
    elif symbol == 'TUIHeaderCard':
        variant = p['variant']
        if variant in ['button', 'buttonLink']:
            state = '    @State private var presses = 0\n'
            expression = 'TUIHeaderCard(variant: .' + variant + ', accessoryAction: { presses += 1 })'
            expression += '\n            Text("Нажатий: \\(presses)")'
        elif variant == 'switch':
            state = '    @State private var selected = false\n'
            expression = 'TUIHeaderCard(variant: .switch, isOn: $selected)'
        else:
            expression = 'TUIHeaderCard(variant: .' + variant + ', isSkeletonAnimating: false)'
    elif symbol == 'TUICardLarge' and p['variant'] == 'headerSubheaderSkeleton':
        expression = 'TUICardLarge(variant: .headerSubheaderSkeleton, isSkeletonAnimating: false)\n            .frame(width: 375)'
    elif symbol == 'TUICardLarge' and p['variant'] in ['cell', 'cellFlat']:
        expression = 'TUICardLarge(variant: .' + p['variant'] + ') {\n                EmptyView()\n            } content: {\n                TUICell(variant: .defaultNone)\n            }\n            .frame(width: 375)'
    elif symbol == 'TUICardLarge' and p['variant'] in [
            'header', 'headerFlat', 'headerSubheader', 'headerSubheaderFlat',
            'headerSubheaderWithFooter', 'headerSubheaderFlatWithFooter']:
        variant = p['variant']
        has_footer = variant.endswith('WithFooter')
        expression = 'TUICardLarge(variant: .' + variant + ') {\n'
        expression += '                TUIHeaderCard(variant: .avatar, showsSubheader: ' + str(variant not in ['header', 'headerFlat']).lower() + ')\n'
        expression += '            } content: {\n                EmptyView()\n'
        if has_footer:
            state = '    @State private var presses = 0\n'
            expression += '            } footer: {\n                TUIButton("Label", appearance: .secondary, size: .medium) { presses += 1 }\n'
        expression += '            }\n            .frame(width: 375)'
        if has_footer:
            expression += '\n            Text("Нажатий: \\(presses)")'
    elif symbol == 'TUISkeleton':
        expression = f'TUISkeleton(keyframe: .{p["keyframe"]}, width: 140, height: 32)'
    elif symbol == 'TUISkeletonText':
        expression = f'TUISkeletonText(textStyle: .{p["textStyle"]})'
    elif symbol == 'TUILoader':
        expression = f'TUILoader(size: .{p["size"]})'
    elif symbol == 'TUISensitiveMode':
        expression = f'TUISensitiveMode(fontSize: .{p["fontSize"]})'
    elif symbol == 'TUITextfield':
        state = '    @State private var text = ' + json.dumps(p['text'], ensure_ascii=False) + '\n'
        state += '    @State private var state = TUITextfieldState.' + p['state'] + '\n'
        label = 'nil' if p['label'] is None else json.dumps(p['label'], ensure_ascii=False)
        error = 'nil' if p['errorText'] is None else json.dumps(p['errorText'], ensure_ascii=False)
        expression = 'TUITextfield(text: $text, state: $state, label: ' + label
        expression += ', placeholder: ' + json.dumps(p['placeholder'], ensure_ascii=False)
        expression += ', isSkeleton: ' + str(p['isSkeleton']).lower() + ', errorText: ' + error + ')'
        if p['isSkeleton']:
            expression = expression.replace(', errorText:', ', isSkeletonAnimating: ' + str(p['isSkeletonAnimating']).lower() + ', errorText:')
    elif symbol == 'TUIFloatingContainer':
        state = '    @State private var presses = 0\n'
        primary = 'TUIButton(' + json.dumps(p.get('primary', {}).get('title', 'Продолжить'), ensure_ascii=False) + ') { presses += 1 }'
        if 'secondary' in p:
            secondary_title = json.dumps(p['secondary']['title'], ensure_ascii=False)
            expression = 'TUIFloatingContainer(primary: ' + primary + ', secondary: TUIButton(' + secondary_title + ', appearance: .flat) { presses = 0 }, background: .' + p['background'] + ')'
        elif 'legalText' in p:
            expression = 'TUIFloatingContainer(primary: ' + primary + ', legalText: ' + json.dumps(p['legalText'], ensure_ascii=False) + ', background: .' + p['background'] + ')'
        elif 'primary' in p:
            expression = 'TUIFloatingContainer(primary: ' + primary + ', showsFade: ' + str(p['showsFade']).lower() + ')'
        elif 'content' in p:
            expression = 'TUIFloatingContainer {\n                HStack(spacing: TUISpacing.x4) {\n                    Text("1 000 ₽").tuiTypography(.bodyLarge)\n                    TUIButton("Оплатить", size: .small) { presses += 1 }\n                }.frame(minHeight: TUIControlSize.large)\n            }'
        else:
            raise ValueError('Unsupported Floating Container initializer')
        expression += '\n            Text("Нажатий: \\(presses)")'
    elif symbol == 'TUINotificationBadge':
        expression = 'HStack {\n                Text("Уведомления")\n                TUINotificationBadge("1", size: .' + p['size'] + ')\n            }\n            .accessibilityElement(children: .ignore)\n            .accessibilityLabel("Уведомления")\n            .accessibilityValue("Одно обновление")'
    elif symbol == 'TUIButtonClose':
        expression = f'TUIButtonClose(size: .{p["size"]}, environment: .{p["environment"]}, theme: .{p["theme"]})'
        action = True
    elif symbol == 'TUIButton':
        title = json.dumps(p['title'], ensure_ascii=False)
        expression = f'TUIButton({title}, appearance: .{p["appearance"]}, size: .{p["size"]}, state: .{p["state"]}, skeleton: {str(p["skeleton"]).lower()}, showsIcon: {str(p["showsIcon"]).lower()}, showsLabel: {str(p["showsLabel"]).lower()}, width: {p["width"]})'
        action = True
    elif symbol in ['TUIButtonLike', 'TUIButtonShare']:
        if symbol == 'TUIButtonLike':
            state = '    @State private var selected = ' + str(p['isSelected']).lower() + '\n'
            expression = f'TUIButtonLike(isSelected: $selected, appearance: .{p["appearance"]}, state: .{p["state"]})'
        else:
            expression = f'TUIButtonShare(appearance: .{p["appearance"]}, state: .{p["state"]})'
        action = True
    elif symbol == 'TUICell':
        state = '    @State private var hintPresses = 0\n'
        expression = 'TUICell(variant: .' + p['variant'] + ', hintAction: { hintPresses += 1 }, isSkeletonAnimating: false)\n            .frame(width: 375)'
        expression += '\n            Text("Подсказка: \\(hintPresses)")'
    elif symbol == 'TUICellCheckicon':
        expression = f'TUICellCheckicon(variant: .{p["variant"]})'
        action = True
    elif symbol == 'TUISpacingIndicator':
        expression = f'TUISpacingIndicator(size: .{p["size"]}, visible: {str(p["visible"]).lower()})'
    else:
        return None
    if action:
        state += '    @State private var presses = 0\n'
        expression += ' { presses += 1 }'
        expression += '\n            Text("Нажатий: \\(presses)")'
    return 'import SwiftUI\nimport TUIDesignSystem\n\nstruct ComponentExample: View {\n' + state + '    var body: some View {\n        VStack {\n            ' + expression + '\n        }\n    }\n}\n'

verification = read('Documentation/component-verification.json')
records = {v['id']: v for v in verification['components']}
coverage = read('Documentation/component-coverage.json')
sets = {v['id']: v for v in read(str(META.relative_to(ROOT) / 'figma-components.json'))['componentSets']}
all_variants = read(str(META.relative_to(ROOT) / 'figma-component-variants.json'))['variants']
components = []
for c in coverage['components']:
    if c['status'] == 'excluded':
        continue
    record = records[c['id']]
    variants = [v for v in all_variants if v['setId'] == c['id']]
    _, applicable, historical = ios_scope(variants, verification['platformPolicy'])
    status, checks, stale = evaluate(ROOT, record, applicable)
    source = c.get('swiftAPI')
    items = []
    for v in applicable:
        mapping = record['variantMappings'].get(v['id'])
        snippet = example(mapping['symbol'], mapping['parameters']) if mapping else None
        items.append({'id': v['id'], 'name': v['name'], 'properties': v['variantProperties'],
                      'sourceSize': {'width': v['width'], 'height': v['height']},
                      'mapping': mapping, 'snippet': snippet, 'renders': {}, 'references': {}})
    indexed = {v['id']: v for v in items}
    if c['id'] == '41658:296906':
        updated_floating_ids = {e['variantID'] for e in record['checks']['visual']['evidence']
                                if e.get('kind') == 'runtime-render'
                                and '/ButtonFloatingShadow/MatrixNative/' in e['path']}
        folder = 'Documentation/Validation/2026-10-08/ButtonCustomization/PackageNative'
        for test in read(folder + '/manifest.json'):
            for a in test['attachments']:
                match = re.match(r'button-(\d+)-(\d+)-(day|night)-source-frame-3x', a['suggestedHumanReadableName'])
                if match:
                    node = f'{match[1]}:{match[2]}'
                    # Preserve the registry's corrected radii and Floating shadow renders.
                    if node in {'55915:350412', '55915:350432', '55915:350422'} or node in updated_floating_ids:
                        continue
                    indexed[node]['renders'][match[3]] = image(folder + '/' + a['exportedFileName'],
                        surface='white' if match[3] == 'day' else 'black')
    docs = {}
    for check in record['checks'].values():
        for e in check['evidence']:
            path = e['path']
            if not (ROOT / path).is_file():
                continue
            if e.get('variantID') in indexed and e.get('kind') in ['runtime-render', 'figma-reference'] and path.endswith('.png'):
                key = 'renders' if e['kind'] == 'runtime-render' else 'references'
                theme = e.get('theme') or ('night' if 'night' in path.lower() else 'day')
                scale = e.get('scale', 1 if '1x' in path else 2 if '2x' in path else 3)
                indexed[e['variantID']][key].setdefault(theme, image(path, scale, e.get('surface')))
            if path.endswith('.md'):
                docs[path] = {**asset(path), 'name': Path(path).stem, 'content': (ROOT / path).read_text()}
    # Latest native Card Medium matrix: actual package output, not Figma images.
    if c['id'] == '11335:41574':
        folder = 'Documentation/Validation/2026-10-07/NotificationBadge/Native'
        for test in read(folder + '/manifest.json'):
            for a in test['attachments']:
                match = re.match(r'card-medium-(\d+)-(\d+)-(day|night)-3x', a['suggestedHumanReadableName'])
                if match:
                    node = f'{match[1]}:{match[2]}'
                    indexed[node]['renders'][match[3]] = image(folder + '/' + a['exportedFileName'])
    if c['id'] == '25738:689227':
        folder = 'Documentation/Validation/2026-10-07/NotificationBadge/Native'
        size_ids = {'small':'25738:689221', 'medium':'25738:689224', 'large':'25738:689222'}
        for test in read(folder + '/manifest.json'):
            for a in test['attachments']:
                match = re.match(r'notification-(small|medium|large)-1-(Day|Night)-standard', a['suggestedHumanReadableName'])
                if match:
                    indexed[size_ids[match[1]]]['renders'][match[2].lower()] = image(folder + '/' + a['exportedFileName'])
        for v in items:
            v['snippet'] = example('TUINotificationBadge', {'size':v['properties']['size']})
    for v in items:
        if v['id'] in ['37840:45834','37840:45835']:
            for theme in ['day','night']:
                path = 'Documentation/References/Skeleton/ios-' + v['id'].replace(':','-') + f'-{theme}-motion-2026-10-05-3x.png'
                v['renders'][theme] = image(path)
    motion = None
    if c['id'] == '11335:41574':
        motion = {'title':'Нажатие карточки', 'parameters':{'duration':'100 ms', 'curve':'cubic(0.2, 0, 0.4, 0.9)', 'scale':'1 → 0.95 → 1', 'Reduce Motion':'Без масштабирования'},
                  'description':'Нативная запись: нажатие, возврат и отмена жеста. Скорость и кривая проверены отдельно; весь компонент ещё не принят.',
                  'recording': asset('Documentation/Validation/2026-10-07/CardMediumMotion/coordinate-probe-native-recording.mp4')}
    elif c['id'] in ['37840:45833','37840:45836']:
        motion = {'title':'Цикл Skeleton', 'parameters':{'transition':'500 ms · Animation/Duration/slow', 'trigger delay':'1 ms', 'period':'1002 ms', 'curve':'cubic(0.2, 0, 0.4, 0.9)', 'opacity':'1 → 0.5 → 1', 'Reduce Motion':'Статический кадр', 'Неактивная сцена':'Цикл приостановлен'},
                  'description':'Запись реального приложения: цикл, системное Reduce Motion и возобновление. Точные ключевые кадры и проверка длительности доступны в отчёте.',
                  'recording': asset('Documentation/Validation/2026-10-06/SkeletonSystemMotionVerified/C2ACF5EC-7B93-428F-9348-82DE73F00762.mp4')}
    elif c['id'] == '9999:26':
        motion = {'title':'Цикл Loader по тексту спецификации',
                  'parameters':{'line growth':'0 → 95% · 2000 ms', 'line shrink':'95% → 0 · 2000 ms',
                                'rotation':'360° · 2000 ms', 'period':'4000 ms', 'curve':'linear',
                                'minimum visibility':'500 ms · состояние потребителя'},
                  'description':'Движение подтверждено сменой пикселей в активной сцене iOS. Точная запись цикла ещё не добавлена; связанный Lottie-прототип расходится с текстом по вращению. Приёмка motion остаётся pending.',
                  'recording': None}
    elif c['id'] == '44286:299509':
        motion = {'title':'Floating Container · переходы содержимого',
                  'parameters':{'entrance':'500 ms · expressive-entrance',
                                'exit':'200 ms · productive-exit',
                                'same-shape replacement':'75 ms · productive-exit',
                                'different shape':'200 ms out / 500 ms in',
                                'secondary swap':'к legal: 200 ms / к secondary: 300 ms · productive-standard',
                                'verification':'pending · остальные source transitions, temporal curves и быстрый повтор'},
                  'description':'Реальная запись Simulator: десять изменений состояния и обратные переключения. Входящее содержимое измеряется; контейнер меняет высоту плавно. Дорожки Figma подтверждают общий fade и layout 200 мс к legal, 300 мс к secondary. Прежний элемент после замены уходит за экран. Полная motion-приёмка остаётся открытой. Видео показывает настоящий компонент SwiftUI на native QA-экране.',
                  'recording':asset('Documentation/Validation/2026-10-12/FloatingContainerHeight/floating-transitions.mp4')}
    elif c['id'] == '65702:51131':
        motion = {'title':'Валидация Textfield',
                  'parameters':{'first error':'500 ms · duration-slow · 0 → −3 → 3 → −3 → 3 → 0',
                                'repeated error':'300 ms · duration-moderate · 0 → −3 → 3 → 0',
                                'curve':'productive-standard · cubic(0.2, 0, 0.4, 0.9)',
                                'haptic':'notification error · физическая проверка вне Simulator',
                                'per-step timing':'UNVERIFIED · равные узлы progress — выбор реализации'},
                  'description':'Запись реального симулятора: первая и повторная ошибка, смена фокуса и сброс. 114 измерений нативного редактора подтверждают движение и возврат. Старый прототип расходится с текстом Guide по отдельным смещениям; полная приёмка motion, hints и clear остаётся pending.',
                  'recording':asset('Documentation/Validation/2026-10-09/Textfield/ErrorMotionNativeVerified/validation-feedback.mp4')}
    components.append({**c, 'status':status, 'checks':{k:{**v, 'current':checks.get(k,False)} for k,v in record['checks'].items()},
                       'staleInputs':stale, 'description':sets[c['id']].get('description',''),
                       'properties':sets[c['id']].get('properties',{}), 'variants':items,
                       'historicalVariants':historical, 'docs':list(docs.values()), 'motion':motion,
                       'sourceCode':(ROOT / source['source']).read_text() if source else None,
                       'sourceAsset':asset(source['source']) if source else None, 'openIssues':record['openIssues']})
payload = {'schemaVersion':1, 'target':'iOS 26', 'components':components,
           'summary':coverage['summary'], 'assemblyGuide':(ROOT/'Documentation/assembling-screens-from-figma.md').read_text()}
(OUT/'library.json').write_text(json.dumps(payload,ensure_ascii=False,indent=2))
for generated in (OUT/'assets').iterdir():
    if re.fullmatch(r'[0-9a-f]{20}\.[a-z]+', generated.name) and generated.name not in used_assets:
        generated.unlink()
if '--swift-fixture' in sys.argv:
    snippets = list(dict.fromkeys(v['snippet'] for c in components for v in c['variants'] if v['snippet']))
    fixture = '// Generated by Scripts/generate_web_catalog.py --swift-fixture.\nimport SwiftUI\nimport UIKit\nimport XCTest\nimport TUIDesignSystem\n\n'
    for i, snippet in enumerate(snippets):
        fixture += snippet.replace('import SwiftUI\nimport TUIDesignSystem\n\n', '').replace('struct ComponentExample: View', f'private struct WebCatalogExample{i}: View') + '\n'
    fixture += 'final class WebCatalogExamplesTests: XCTestCase {\n    @MainActor func testCopyableExamplesCompileAndRenderThroughPublicPackageAPI() throws {\n'
    for i, snippet in enumerate(snippets):
        if 'TUITextfield(' in snippet:
            fixture += f'        _ = WebCatalogExample{i}().body // UIKit editor: native render evidence must come from TextfieldUITests.\n'
        elif 'TUIHeaderCard(variant: .switch' in snippet:
            fixture += f'        _ = WebCatalogExample{i}().body // UIKit control: actual rendering verified in HeaderCardUITests.\n'
        elif 'size: .zero' in snippet or 'visible: false' in snippet:
            fixture += f'        _ = WebCatalogExample{i}().body // Deliberately zero-size spacing.\n'
        else:
            fixture += f'        XCTAssertNotNil(ImageRenderer(content: WebCatalogExample{i}()).uiImage, "Example {i} must render without the catalog app")\n'
    fixture += '    }\n}\n'
    (ROOT/'Tests/TUIDesignSystemTests/WebCatalogExamplesTests.swift').write_text(fixture)
print(f'Generated {len(components)} component sets; {sum(bool(v["renders"]) for c in components for v in c["variants"])} variants with native renders.')
