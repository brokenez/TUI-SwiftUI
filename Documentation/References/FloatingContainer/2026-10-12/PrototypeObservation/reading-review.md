# Floating Container: чтение исходного прототипа secondary ↔ legal

Статус: **READ для двух сохранённых directional transition exports; полная motion-приёмка компонента UNVERIFIED / in-progress.** Документ фиксирует новые исходные сведения, а не успешную проверку текущей SwiftUI-реализации. Figma не изменялась. Перенос системных Apple-компонентов и дополнительные accessibility-режимы исключены текущим scope.

## Источник и фактический доступ

[Behavior Guide 4351:40803](https://www.figma.com/design/jvYMs0sCSCZCHEFrRcL4vW/tui-floating-container?node-id=4351-40803) действительно содержит ссылку на этот прототип в файле `usDNc7HuHlFSGp0DZhPKVL`: [исходный proto URL](https://www.figma.com/proto/usDNc7HuHlFSGp0DZhPKVL/Mobile.-Animation-Examples?page-id=3351%3A2207&type=design&node-id=3438-381&t=34YlKF8HCExqXItS-0&scaling=min-zoom&starting-point-node-id=3438%3A381&show-proto-sidebar=1). Ссылка сохранена в [observed-links.json](../observed-links.json), её первоначальный текст — в [context-4351-40803.txt](../context-4351-40803.txt).

В текущей сессии прямой веб-просмотр прототипа показал состояние без авторизации. Нативное приложение Figma открыло прототип в уже авторизованной сессии; чтение удалось через его UI. Авторизация не переносилась между браузерами, скрытые данные сессии не извлекались. [secondary-start-ax.txt](secondary-start-ax.txt) и [secondary-legal-ax.txt](secondary-legal-ax.txt) подтверждают заголовок **[ARCHIVE] Animation Examples - Floating-container**, доступные flows и исходную композицию.

После перехода Open in editor окно и имя файла — **[ARCHIVE] Animation Examples**. Сохранённые Inspect AX показывают режим **iOS version: Auto (iOS 18)**. Это исторический источник общих правил движения кастомного Floating Container, связанный актуальным Guide. Он не служит доказательством проверки на iOS 26 и не разрешает воспроизводить исторический Apple home indicator.

## Что именно прочитано

В Dev Mode Inspect открыт раздел Motion → Generated animation code. Для каждого направления сохранены две видимые части: `showing 0-100 of 128 items` и `showing 28-128 of 128 items`. Перекрытие составляет 72 строки. JSON восстановлен объединением этих видимых строк с проверкой перекрытия, без скриптов внутри Figma и без изменения файла:

- Forward: [первые строки](secondary-to-legal-transition-ax.txt), [последние строки](secondary-to-legal-transition-tail-ax.txt), [полный JSON](secondary-to-legal-transition.json).
- Reverse: [первые строки](legal-to-secondary-transition-ax.txt), [последние строки](legal-to-secondary-transition-tail-ax.txt), [полный JSON](legal-to-secondary-transition.json).

Forward Inspect URL указывает на [3438:381](https://www.figma.com/design/usDNc7HuHlFSGp0DZhPKVL/-ARCHIVE--Animation-Examples?node-id=3438-381&m=dev); reverse — на [3438:379](https://www.figma.com/design/usDNc7HuHlFSGp0DZhPKVL/-ARCHIVE--Animation-Examples?node-id=3438-379&m=dev). Эти выбранные исходные frames отличаются от корневых destination nodes в экспортированном JSON: **3438:380** и **3438:382** соответственно. Их нельзя смешивать при интерпретации координат.

## Переходы и геометрия

| Направление | Duration всех экспортированных nodes | Корневой dissolve | Корневая высота | Корневой motionTranslationY |
| --- | --- | --- | --- | --- |
| Secondary → legal | 200 ms | 0 → 1 | 170.00100708007812 → 154.00100708007812 | 657.9990234375 → 673.9990234375 |
| Legal → secondary | 300 ms | 0 → 1 | 154.00100708007812 → 170.00100708007812 | 641.9990234375 → 625.9990234375 |

Во всех сохранённых keyframes используется одна кривая: `p1x=0.20000000298023224`, `p1y=0`, `p2x=0.4000000059604645`, `p2y=0.8999999761581421` — productiveStandard. Fade и изменение корневой геометрии имеют общую длительность **по направлению**: 200 ms к legal, 300 ms к secondary. Эти exports не подтверждают одновременную модель «входящий слой всегда 200 ms, исходящий всегда 300 ms».

Корневая высота изменяется на −16 / +16 pt, корневое положение — на +16 / −16 pt. Начальные absolute Y разных source frames отличаются; нельзя соединять forward и reverse absolute Y в одну траекторию или подгонять native screen под эти координаты. Для сверки пригодны направление, delta, duration и easing соответствующего перехода.

Канонические полные высоты **170 / 154** включают историческую системную нижнюю область **34 pt**. Кастомный контент над нативной safe area — **136 / 120 pt**. Эти исходные размеры описывают конкретные presets с Large buttons; они не заменяют измерение фактической высоты адаптивного/custom content.

Экспортированный `I3438:380;44286:299558` — **Buttons cont** legal-варианта, его height 136 → 72. В [variant-44286-299553.txt](../variant-44286-299553.txt) legal Buttons cont состоит из primary с нижним отступом 16; отдельный LegalTextCont имеет minimum height 48. Поэтому высота одного Buttons cont не равна высоте всего action+legal footer. Reverse `I3438:382;44286:299515` — Buttons cont two-actions, height 72 → 136; связь имени и ID подтверждается [remote-mobile-set.txt](../remote-mobile-set.txt).

**`I3438:380;44286:299563` и `I3438:382;44286:299518` — system-bottom-bar, не primary button.** Это прямо следует из тех же variant/set contexts. Их экспортированные local motionTranslationY — 120.0009994506836 → 104.00099182128906 и 136.00100708007812 → 152.00100708007812. Эти поля нельзя подписывать как измерение primary. Direct primary-node keyframes в сохранённых JSON отсутствуют. Перенос primary вслед за закреплённым footer на 16 pt — вывод из общей геометрии и построения, а не отдельный экспорт primary-анимации.

В iOS 26 реализации home indicator остаётся нативным. Исходные bar nodes не перерисовываются, 34 pt не добавляются компонентом как фиктивный runtime-отступ. Исторические bar coordinates сохраняются только для правильного чтения первоисточника.

## Ограничения наблюдения

Файлы **secondary-legal.png** и **secondary-legal-ax.txt** после наблюдения loop фактически снова показывают **two-actions**, включая Main action и Secondary action. Их имена не подтверждают legal end state. Они не используются как legal end-state visual evidence или как покадровое доказательство совпадения анимации. Названия исходных файлов сохранены для трассируемости; правильное толкование зафиксировано здесь.

Другой presence frame **3492:654** был только замечен при навигации. Его полный animation export не прочитан; этот документ не подтверждает правила или исполнение его переходов. Остальные связанные motion flows, недоступные старые nodes и полная iOS 26 runtime-сверка остаются открытыми.

Последний запрос на дополнительное read-only UI capture был отклонён автоматическим review по **usage-limit**. Причина не относилась к небезопасности чтения или разрешению редактирования. Повторный обход ограничения не выполнялся; отсутствующий capture не считается полученным.

## Отношение к реализации и прежним отчётам

[specification-reading.md](../specification-reading.md), [implementation-review.md](../implementation-review.md), [motion-implementation-review.md](../motion-implementation-review.md) и прежние validation reports сохраняют историю состояния на момент своих проверок. Первоначальные записи `PROTOTYPE_MOTION_UNVERIFIED` в observed-links.json также не переписываются этим документом. Новые JSON уточняют только фактически прочитанные forward/reverse transitions secondary↔legal и исправляют трактовку их направленных duration.

Текущая native production implementation изменяется и требует новых сборок, реальных runtime-записей и проверки непрерывности размещения. Чтение исходных keyframes не означает совпадения SwiftUI-анимации, принятой visual/specification/motion проверки или статуса complete. Все acceptance claims должны опираться на актуальные независимые доказательства в реестре, который этим документом не изменён.
