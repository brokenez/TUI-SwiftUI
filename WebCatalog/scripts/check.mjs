import { readFileSync, existsSync } from 'node:fs';
import { createHash } from 'node:crypto';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import assert from 'node:assert/strict';
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const publicRoot = path.join(root, 'public');
const data = JSON.parse(readFileSync(path.join(publicRoot, 'library.json')));
// Header Card's attachment filenames are UUIDs: theme must come from evidence,
// and every displayed image must be the exact native file for that theme.
const passports = JSON.parse(readFileSync(path.join(root, '..', 'Documentation/component-verification.json')));
for (const id of ['44217:298609', '42587:291989', '41569:290555', '65702:51131']) {
  const component = data.components.find(c => c.id === id);
  for (const e of passports.components.find(c => c.id === id).checks.visual.evidence) {
    if (e.kind === 'runtime-render' && e.theme) {
      const render = component.variants.find(v => v.id === e.variantID).renders[e.theme];
      assert.equal(render.sourcePath, e.path);
      assert.deepEqual(render.surface, e.surface ?? null);
      if (id === '41569:290555') {
        assert(e.surface?.color, 'Transparent Cell PNG needs its catalog surface');
        assert.equal(e.surface.label, `${e.theme === 'day' ? 'Day' : 'Night'} / Background / Base`);
      }
    }
  }
}
const button = data.components.find(c => c.id === '41658:296906');
const buttonRecord = passports.components.find(c => c.id === button.id);
const floating = button.variants.filter(v => buttonRecord.variantMappings[v.id]?.parameters.appearance === 'floating');
assert.equal(floating.length, 12);
for (const variant of floating) {
  for (const theme of ['day', 'night']) {
    const evidence = buttonRecord.checks.visual.evidence.find(e => e.variantID === variant.id
      && e.kind === 'runtime-render' && e.theme === theme);
    assert(evidence?.path.includes('/ButtonFloatingShadow/MatrixNative/'),
      'Floating previews must use the corrected native shadow matrix');
    assert.equal(variant.renders[theme].sourcePath, evidence.path);
  }
}
const textfield = data.components.find(c => c.id === '65702:51131');
assert.equal(textfield.variants.length, 22);
assert(textfield.motion.recording?.sourcePath.endsWith('/ErrorMotionNativeVerified/validation-feedback.mp4'),
  'Textfield motion must use the inspected native Simulator recording');
for (const variant of textfield.variants) {
  assert(variant.renders.day && variant.renders.night, 'Textfield needs actual native renders for both themes');
  assert(variant.references.day, 'Textfield Day needs its exact Figma reference');
  assert(!variant.references.night, 'Do not fabricate Night source references');
  assert(variant.snippet.includes('TUITextfield('), 'Textfield must expose its public SwiftUI API');
}
assert.equal(data.components.length, data.summary.componentSets);
assert.equal(new Set(data.components.map(c=>c.id)).size, data.summary.componentSets);
const excluded = passports.components.filter(c=>c.scopeExclusion);
assert.equal(data.summary.importedComponentSets, passports.components.length);
assert.equal(data.summary.excludedSystemComponents, excluded.length);
assert.equal(data.components.length + excluded.length, passports.components.length);
assert(!data.components.some(c=>excluded.some(e=>e.id===c.id)), 'Excluded system sets must not be offered in the catalog');
const variants = data.components.flatMap(c=>c.variants);
assert.equal(variants.length, data.summary.iOS26Variants);
const assets = new Set();
function inspect(value) {
  if (Array.isArray(value)) { value.forEach(inspect); return; }
  if (!value || typeof value !== 'object') return;
  if (value.url?.startsWith('assets/')) {
    const file=path.resolve(publicRoot,value.url);
    assert(file.startsWith(publicRoot+path.sep));
    assert(existsSync(file), value.url);
    assert(!/\.(otf|ttf)$/i.test(file), 'Do not distribute Apple fonts in the web reader');
    assert.equal(createHash('sha256').update(readFileSync(file)).digest('hex'),value.sha256);
    assets.add(value.url);
  }
  Object.values(value).forEach(inspect);
}
inspect(data);
for (const c of data.components.filter(c=>c.status==='complete')) {
  assert.equal(c.staleInputs.length,0);
  assert(Object.values(c.checks).every(c=>c.current));
}
if (process.argv.includes('--http')) {
  const missing=await fetch('http://127.0.0.1:4317/not-a-resource');assert.equal(missing.status,404);
  const url=data.components.find(c=>c.id==='11335:41574').motion.recording.url;
  const range=await fetch(`http://127.0.0.1:4317/${url}`,{headers:{Range:'bytes=0-127'}});
  assert.equal(range.status,206);assert.equal((await range.arrayBuffer()).byteLength,128);
  const textfieldRange=await fetch(`http://127.0.0.1:4317/${textfield.motion.recording.url}`,{headers:{Range:'bytes=0-127'}});
  assert.equal(textfieldRange.status,206);assert.equal((await textfieldRange.arrayBuffer()).byteLength,128);
}
console.log(JSON.stringify({status:'passed',componentSets:data.components.length,applicableVariants:variants.length,
  nativePreviewVariants:variants.filter(v=>Object.keys(v.renders).length).length,assetsWithVerifiedSHA256:assets.size,
  copyableUniqueExamples:new Set(variants.map(v=>v.snippet).filter(Boolean)).size,
  completeSets:data.components.filter(c=>c.status==='complete').length,fontsCopied:0,httpChecked:process.argv.includes('--http')},null,2));
