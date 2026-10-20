const escape = value => String(value ?? '').replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
const labels = {'complete':'Проверен','in-progress':'В работе','catalogued':'В реестре','blocked':'Есть препятствие'};
const checkLabels = {variantMapping:'Варианты и API',specification:'Спецификация',visual:'Внешний вид',interaction:'Взаимодействия',accessibility:'Доступность',motion:'Анимация',integration:'Подключение пакета'};
const titles = {'11335:41574':'Card Medium','42565:305012':'Header Large','37840:45833':'Skeleton','37840:45836':'Skeleton Text','25738:689227':'Notification Badge'};
let library, component, variant, tab = 'preview', query = '', filter = 'all', theme = 'day', zoom = 1, mode = 'native', codeMode = 'example', documentIndex = 0;
let toastTimer;
const app = document.querySelector('#app');
const title = item => titles[item.id] || item.name.trim().replace(/^tui-/, '').replaceAll('-', ' ');
const badge = item => `<span class="status ${escape(item.status)}"><i></i>${labels[item.status]}</span>`;
const currentVariant = () => component.variants.find(v => v.id === variant);
const defaultVariant = item => (item.id==='11335:41574' ? item.variants.find(v=>v.id==='11335:41685') : item.variants.find(v=>v.properties.skeleton==='off'))?.id || item.variants[0]?.id;
const currentCode = () => codeMode === 'source' ? component.sourceCode : currentVariant()?.snippet;
function toast(text) {
  const element = document.querySelector('#toast'); element.textContent = text; element.classList.add('visible');
  clearTimeout(toastTimer); toastTimer = setTimeout(() => element.classList.remove('visible'), 2200);
}
function inline(text) {
  return escape(text).replace(/`([^`]+)`/g,'<code>$1</code>').replace(/\*\*([^*]+)\*\*/g,'<strong>$1</strong>')
    .replace(/\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/g,'<a href="$2" target="_blank" rel="noreferrer">$1 ↗</a>');
}
function markdown(text) {
  const output = []; let fence = false, code = [], list = false;
  for (const line of text.split('\n')) {
    if (line.startsWith('```')) { if (fence) {output.push(`<pre>${escape(code.join('\n'))}</pre>`); code=[];} fence=!fence; continue; }
    if (fence) {code.push(line); continue;}
    if (/^[-*] /.test(line)) {if (!list) {output.push('<ul>');list=true;} output.push(`<li>${inline(line.slice(2))}</li>`);continue;}
    if (list) {output.push('</ul>');list=false;}
    if (/^#{1,6} /.test(line)) {const n=Math.min(4,line.match(/^#+/)[0].length+1);output.push(`<h${n}>${inline(line.replace(/^#+ /,''))}</h${n}>`);}
    else if (line.trim()) output.push(`<p>${inline(line)}</p>`);
  }
  if (list) output.push('</ul>');
  if (fence) output.push(`<pre>${escape(code.join('\n'))}</pre>`);
  return output.join('');
}
function setRoute() {
  history.replaceState(null,'',`#component=${encodeURIComponent(component.id)}&variant=${encodeURIComponent(variant || '')}&tab=${tab}`);
}
function visibleComponents() {
  const text = query.toLowerCase();
  return library.components.filter(c => (filter === 'all' || (filter==='implemented' ? c.swiftAPI : c.status==='complete')) &&
    `${c.name} ${title(c)} ${c.id} ${c.swiftAPI?.symbol || ''}`.toLowerCase().includes(text));
}
function sidebarList() {
  const items=visibleComponents();
  return `<div class="list-label">КОМПОНЕНТЫ <span>${items.length}</span></div>` + (items.length ? items.map(c=>
    `<button class="component-link ${c.id===component.id?'active':''}" data-component="${escape(c.id)}" aria-current="${c.id===component.id?'page':'false'}"><span>${escape(title(c))}</span><i class="state-dot ${c.status}" title="${labels[c.status]}"></i><small>${c.iOS26Variants} вариантов</small></button>`).join('') : '<p class="no-results">Ничего не найдено. Попробуйте название или Figma ID.</p>');
}
function sidebar() {
  return `<aside class="sidebar" aria-label="Библиотека компонентов">
    <a class="brand" href="#"><span class="brand-mark">T</span><span>TUI<span class="brand-sub">iOS Library</span></span><span class="version">26</span></a>
    <label class="search-label"><span>Поиск компонента</span><input type="search" id="search" placeholder="Название или Figma ID" value="${escape(query)}" autocomplete="off"></label>
    <select id="filter" aria-label="Фильтр готовности"><option value="all" ${filter==='all'?'selected':''}>Все компоненты</option><option value="implemented" ${filter==='implemented'?'selected':''}>С реализацией</option><option value="verified" ${filter==='verified'?'selected':''}>Проверенные</option></select>
    <nav id="component-list" aria-label="Компоненты">${sidebarList()}</nav>
    <footer class="sidebar-footer"><span class="state-dot complete"></span>${library.components.filter(c=>c.status==='complete').length} из ${library.components.length} проверены<button data-guide>Как собрать экран ↗</button></footer>
  </aside>`;
}
function properties() {
  const v=currentVariant();
  return `<section class="panel controls"><div class="section-heading"><h2>Вариант</h2><span>${component.variants.length}</span></div>
    ${component.variants.length ? `<label>Матрица Figma<select id="variant" aria-label="Вариант компонента">${component.variants.map((v,i)=>`<option value="${v.id}" ${v.id===variant?'selected':''}>${i+1}. ${escape(v.name)}</option>`).join('')}</select></label>`:'<p>Нет применимых вариантов iOS 26.</p>'}
    <dl class="property-list">${Object.entries(v?.properties||{}).map(([key,value])=>`<div><dt>${escape(key)}</dt><dd>${escape(value)}</dd></div>`).join('')}</dl>
    <div class="control-divider"></div><label>Тема<select id="theme"><option value="day" ${theme==='day'?'selected':''}>Day</option><option value="night" ${theme==='night'?'selected':''}>Night</option></select></label>
    <label class="range-label">Масштаб<span>${Math.round(zoom*100)}%</span><input id="zoom" type="range" min="0.75" max="2" step="0.25" value="${zoom}"></label>
    <div class="variant-id">NODE ID <code>${escape(v?.id || component.id)}</code></div>
    <a class="text-link" href="${escape(component.figmaURL.replace(/node-id=[^&]+/,`node-id=${(v?.id||component.id).replace(':','-')}`))}" target="_blank" rel="noreferrer">Открыть вариант в Figma ↗</a>
  </section>`;
}
function preview() {
  const v=currentVariant(), image=(mode==='native'?v?.renders:v?.references)?.[theme];
  const surfaceColor=/^#[0-9a-f]{6}$/i.test(image?.surface?.color || '') ? image.surface.color : 'transparent';
  return `<div class="preview-grid"><div class="preview-column"><section class="scene" aria-label="Предпросмотр компонента">
    <div class="scene-label"><span class="tiny-dot"></span>${mode==='native'?'SWIFTUI · НАТИВНЫЙ РЕНДЕР':'FIGMA · ИСХОДНЫЙ МАКЕТ'}</div>
    <div class="scene-object">${image ? `<img id="native-render" src="${image.url}" alt="${escape(title(component))}, ${escape(v.name)}, ${theme}" style="width:${image.width*zoom}px;height:${image.height*zoom}px;background:${surfaceColor}" draggable="false">` : `<div class="empty-render"><span>${mode==='native'?'Рендер ещё не подготовлен':'Исходный снимок ещё не добавлен'}</span><p>Этот вариант есть в реестре. Предпросмотр появится после нативной проверки.</p></div>`}</div>
    <div class="scene-bottom"><span>${image ? `${image.width.toFixed(1).replace('.0','')} × ${image.height.toFixed(1).replace('.0','')} pt · ${image.scale}x` : 'iOS 26'}</span><div class="mini-segments" aria-label="Источник изображения"><button data-mode="native" aria-pressed="${mode==='native'}">SwiftUI</button><button data-mode="figma" aria-pressed="${mode==='figma'}">Figma</button></div></div>
  </section><p class="preview-note">${image ? (mode==='native'?'Результат отрисовки настоящего компонента в iOS. Варианты переключаются справа; взаимодействия смотрите на вкладке «Анимация» и в нативном каталоге.':'Исходный макет Figma для выбранного варианта. Для результата выполнения кода переключитесь на SwiftUI.') : 'Готовность предпросмотра и готовность компонента учитываются отдельно.'}${image?.surface ? ` Прозрачность показана на поверхности ${escape(image.surface.label)}.` : ''}</p>
  ${codeCard(true)}
  </div>${properties()}</div>`;
}
function codeCard(compact=false) {
  const snippet=currentVariant()?.snippet;
  const text=currentCode() || (component.sourceCode ? component.sourceCode : null);
  const isSource=codeMode==='source'||!snippet;
  return `<section class="panel code-panel ${compact?'compact':''}"><div class="section-heading"><h2>SwiftUI</h2><div class="code-actions"><div class="mini-segments"><button data-code-mode="example" aria-pressed="${!isSource}" ${!snippet?'disabled':''}>Пример</button><button data-code-mode="source" aria-pressed="${isSource}" ${!component.sourceCode?'disabled':''}>Исходник</button></div><button class="copy-button" data-copy-code ${!text?'disabled':''}>Копировать ↗</button></div></div>
    ${text ? `<div class="code-caption">${isSource?'Исходный файл библиотеки. Для подключения используйте Swift Package.':'Готовый пример через публичный API · import TUIDesignSystem'}</div><pre class="source-code"><code>${escape(text)}</code></pre>` : '<div class="blank-content"><p>Публичная реализация ещё не добавлена.</p><span>Код появится вместе с подтверждённым сопоставлением Figma → API.</span></div>'}
    ${!snippet&&component.sourceCode?'<p class="footnote">Сопоставление этого варианта ещё не подтверждено. Здесь доступен исходник; готовый пример использования пока не предлагается.</p>':''}
  </section>`;
}
function specification() {
  return `<div class="spec-grid"><section class="panel specification"><div class="section-heading"><h2>Спецификация</h2><a class="text-link" href="${escape(component.specificationURLs[0]||component.figmaURL)}" target="_blank" rel="noreferrer">Источник в Figma ↗</a></div>
    ${component.description?`<p class="lead-description">${inline(component.description)}</p>`:''}
    <h3>Свойства компонента</h3><div class="table-scroll"><table><thead><tr><th>Свойство</th><th>Тип</th><th>Значение по умолчанию</th><th>Варианты</th></tr></thead><tbody>${Object.entries(component.properties).map(([key,p])=>`<tr><td><code>${escape(key)}</code></td><td>${escape(p.type)}</td><td>${escape(p.defaultValue)}</td><td>${escape((p.variantOptions||[]).join(', '))}</td></tr>`).join('')}</tbody></table></div>
    ${component.docs.length?`<label class="document-picker">Документ<select id="document">${component.docs.map((d,i)=>`<option value="${i}" ${i===documentIndex?'selected':''}>${escape(d.name)}</option>`).join('')}</select></label><article class="document">${markdown(component.docs[documentIndex]?.content || component.docs[0].content)}</article>`:'<p class="notice">Локальная спецификация ещё не подготовлена. Исходная страница доступна по ссылке выше; её наличие не означает, что компонент уже проверен.</p>'}
    ${component.historicalVariants.length?`<details><summary>Исторические варианты (${component.historicalVariants.length})</summary><ul>${component.historicalVariants.map(v=>`<li>${escape(v.name)} · ${v.id}</li>`).join('')}</ul></details>`:''}
  </section>${acceptancePanel()}</div>`;
}
function acceptancePanel() {
  return `<section class="panel acceptance"><div class="section-heading"><h2>Проверка</h2>${badge(component)}</div><p class="footnote">Данные из реестра приёмки. Изменённые исходники требуют повторной проверки.</p>
    ${Object.entries(component.checks).map(([key,c])=>`<details class="check"><summary><i class="check-dot ${c.current?'passed':''}"></i>${checkLabels[key]}<span>${c.current?'✓':'—'}</span></summary><p>${escape(c.reason)}</p>${c.reviewedAt?`<small>Проверено ${escape(c.reviewedAt)}</small>`:''}</details>`).join('')}
    ${component.openIssues.length?`<h3>Осталось проверить</h3><ul class="open-issues">${component.openIssues.map(i=>`<li>${escape(i)}</li>`).join('')}</ul>`:''}
    ${component.staleInputs.length?`<p class="notice">Изменено входных файлов: ${component.staleInputs.length}. Статус проверок не считается актуальным.</p>`:''}
  </section>`;
}
function motion() {
  const m=component.motion;
  return `<div class="motion-grid"><section class="panel motion-video"><div class="section-heading"><h2>${escape(m?.title||'Анимация компонента')}</h2><span class="eyebrow">NATIVE iOS</span></div>
    ${m?.recording?`<video id="recording" controls muted playsinline preload="metadata" aria-label="Нативная запись анимации ${escape(title(component))}"><source src="${m.recording.url}" type="video/mp4"></video><div class="video-controls"><button class="primary-button" data-replay>Проиграть сначала ↗</button><label>Скорость<select id="playback"><option value="1">1×</option><option value="0.5">0.5×</option><option value="0.25">0.25×</option><option value="2">2×</option></select></label></div><p class="footnote">${escape(m.description)}</p>`:`<div class="blank-content"><h3>Нативная запись пока не добавлена</h3><p>${escape(m?.description || 'Анимацию нельзя подтвердить по статическому снимку. Данные появятся после проверки поведения компонента.')}</p></div>`}
    </section><section class="panel motion-spec"><div class="section-heading"><h2>Механика</h2><button class="copy-button" data-copy-motion ${!m?'disabled':''}>Копировать ↗</button></div>
    ${m?`<dl class="motion-parameters">${Object.entries(m.parameters).map(([k,v])=>`<div><dt>${escape(k)}</dt><dd><code>${escape(v)}</code></dd></div>`).join('')}</dl>`:''}
    <h3>Приёмка анимации</h3><p>${escape(component.checks.motion.reason)}</p><p class="footnote">Видео запускается только по вашему действию. Веб-оболочка учитывает prefers-reduced-motion; системное Reduce Motion компонента проверяется в iOS.</p>
    <button class="secondary-button" data-tab="spec">Посмотреть спецификацию ↗</button></section></div>`;
}
function main() {
  return `<main id="main" tabindex="-1"><header class="page-header"><div><div class="breadcrumb">Библиотека <span>/</span> Компоненты <span>/</span> iOS 26</div><div class="title-row"><h1>${escape(title(component))}</h1>${badge(component)}</div><p>${escape(component.swiftAPI?.symbol || component.name.trim())}<span class="header-divider">·</span>${component.iOS26Variants} вариантов iOS 26</p></div><a class="figma-link" href="${escape(component.figmaURL)}" target="_blank" rel="noreferrer">Figma ↗</a></header>
    <div class="tabs" role="tablist" aria-label="Разделы компонента">${[['preview','Предпросмотр'],['code','SwiftUI-код'],['spec','Спецификация'],['motion','Анимация']].map(([id,name])=>`<button role="tab" id="tab-${id}" aria-controls="content" aria-selected="${tab===id}" tabindex="${tab===id?'0':'-1'}" data-tab="${id}">${name}</button>`).join('')}</div>
    <div id="content" role="tabpanel" aria-labelledby="tab-${tab}">${tab==='preview'?preview():tab==='code'?codeCard():tab==='spec'?specification():motion()}</div>
    <footer class="page-footer">Swift Package — источник компонентов<span>Figma — источник спецификации</span></footer>
  </main>`;
}
function render() {setRoute();app.innerHTML=sidebar()+main();bind();}
function renderMain() {setRoute();document.querySelector('#main').outerHTML=main();bindMain();}
function choose(id) {
  component=library.components.find(c=>c.id===id) || library.components[0];variant=defaultVariant(component);documentIndex=0;codeMode='example';mode='native';render();document.querySelector('#main').scrollIntoView({block:'start',behavior:'auto'});
}
function bindMain() {
  document.querySelectorAll('[data-tab]').forEach(button=>button.onclick=()=>{tab=button.dataset.tab;renderMain();document.querySelector(`#tab-${tab}`)?.focus();});
  document.querySelector('.tabs').onkeydown=event=>{
    const ids=['preview','code','spec','motion'];let index=ids.indexOf(tab);
    if (event.key==='ArrowRight') index=(index+1)%4;else if(event.key==='ArrowLeft')index=(index+3)%4;else if(event.key==='Home')index=0;else if(event.key==='End')index=3;else return;
    event.preventDefault();tab=ids[index];renderMain();document.querySelector(`#tab-${tab}`).focus();
  };
  const select=document.querySelector('#variant');if(select)select.onchange=()=>{variant=select.value;renderMain();};
  const t=document.querySelector('#theme');if(t)t.onchange=()=>{theme=t.value;renderMain();};
  const z=document.querySelector('#zoom');if(z)z.oninput=()=>{zoom=Number(z.value);const img=document.querySelector('#native-render');const v=currentVariant();const data=(mode==='native'?v.renders:v.references)[theme];if(img&&data){img.style.width=`${data.width*zoom}px`;img.style.height=`${data.height*zoom}px`;}document.querySelector('.range-label span').textContent=`${Math.round(zoom*100)}%`;};
  document.querySelectorAll('[data-mode]').forEach(button=>button.onclick=()=>{mode=button.dataset.mode;renderMain();});
  document.querySelectorAll('[data-code-mode]').forEach(button=>button.onclick=()=>{codeMode=button.dataset.codeMode;renderMain();});
  document.querySelectorAll('[data-copy-code]').forEach(button=>button.onclick=async()=>{try{await navigator.clipboard.writeText(currentCode()||component.sourceCode);toast('SwiftUI-код скопирован');}catch{toast('Буфер обмена недоступен. Выделите код и скопируйте вручную.');}});
  const d=document.querySelector('#document');if(d)d.onchange=()=>{documentIndex=Number(d.value);renderMain();};
  const replay=document.querySelector('[data-replay]');if(replay)replay.onclick=async()=>{const video=document.querySelector('#recording');video.currentTime=0;try{await video.play();}catch{toast('Запустите запись кнопкой плеера.');}};
  const playback=document.querySelector('#playback');if(playback)playback.onchange=()=>{document.querySelector('#recording').playbackRate=Number(playback.value);};
  const copyMotion=document.querySelector('[data-copy-motion]');if(copyMotion)copyMotion.onclick=async()=>{try{await navigator.clipboard.writeText(JSON.stringify(component.motion.parameters,null,2));toast('Параметры анимации скопированы');}catch{toast('Не удалось получить доступ к буферу обмена.');}};
}
function bind() {
  bindMain();
  const list=document.querySelector('#component-list');list.onclick=event=>{const item=event.target.closest('[data-component]');if(item)choose(item.dataset.component);};
  const search=document.querySelector('#search');search.oninput=()=>{query=search.value;list.innerHTML=sidebarList();};
  document.querySelector('#filter').onchange=event=>{filter=event.target.value;list.innerHTML=sidebarList();};
  document.querySelector('.brand').onclick=event=>{event.preventDefault();query='';filter='all';choose('11335:41574');};
  document.querySelector('[data-guide]').onclick=()=>{
    const dialog=document.createElement('dialog');dialog.className='guide-dialog';dialog.innerHTML=`<div class="section-heading"><h2>Сборка экрана из библиотеки</h2><button class="secondary-button" data-close>Закрыть</button></div><article class="document">${markdown(library.assemblyGuide)}</article>`;
    document.body.append(dialog);dialog.querySelector('[data-close]').onclick=()=>dialog.close();dialog.onclose=()=>dialog.remove();dialog.showModal();
  };
}
try {
  const response=await fetch('./library.json');if(!response.ok)throw new Error('Не удалось загрузить реестр');library=await response.json();
  const params=new URLSearchParams(location.hash.slice(1));component=library.components.find(c=>c.id===params.get('component'))||library.components.find(c=>c.id==='11335:41574');
  variant=component.variants.find(v=>v.id===params.get('variant'))?.id||defaultVariant(component);
  if(['preview','code','spec','motion'].includes(params.get('tab')))tab=params.get('tab');render();
  window.addEventListener('hashchange',()=>{const p=new URLSearchParams(location.hash.slice(1));const c=library.components.find(c=>c.id===p.get('component'));if(c){component=c;variant=c.variants.find(v=>v.id===p.get('variant'))?.id||defaultVariant(c);tab=['preview','code','spec','motion'].includes(p.get('tab'))?p.get('tab'):'preview';documentIndex=0;render();}});
} catch(error) {app.innerHTML=`<div class="load-error"><h1>Каталог не загрузился</h1><p>${escape(error.message)}</p><p>Соберите каталог и откройте его через локальный сервер.</p><button onclick="location.reload()">Повторить</button></div>`;}
