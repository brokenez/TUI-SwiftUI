# Floating Container: координация адаптивной высоты

Результат: исправлены скачки размещения при изменении высоты и задержавшийся уход прежнего элемента. **Полная приёмка набора 44286:299509 остаётся in-progress.** Проверены кастомные TUI-компоненты на iOS 26; историческая Apple-панель из прототипа не переносится. Figma не редактировалась, дополнительные accessibility-режимы не реализовывались.

## Прочитанный источник

Вся доступная основная спецификация была прочитана до реализации; предыдущие записи сохранены. Затем из ссылки Behavior 4351:40803 открыт исходный прототип в авторизованной нативной Figma. Dev Mode Inspect предоставил фактический Generated animation code двух направлений secondary↔legal. Пустые прежние MCP motion responses не были признаны отсутствием движения.

Два полных JSON восстановлены только из видимых AX-строк: head100 + tail100, overlap72. Исходный файл носит имя [ARCHIVE] Animation Examples и режим iOS18; актуальный Guide продолжает ссылаться на него для общих правил кастомного компонента. Это не проверка исторической ОС. [Протокол чтения и ограничения](../../../References/FloatingContainer/2026-10-12/PrototypeObservation/reading-review.md) различает source/destination ID и system-bottom-bar от primary.

Дорожки показывают совместный dissolve и изменение корневой геометрии: **200 ms к legal, 300 ms к secondary**, productive-standard (0.2,0,0.4,0.9). Это уточняет прежнюю ошибочную трактовку «incoming всегда200, outgoing всегда300». Общая высота исторического footer170/154 включает34pt системной панели; custom content136/120 остаётся над реальной native safe area.

Дополнительный UI-вызов для другого flow не был выполнен: автоматическая проверка разрешений завершилась usage-limit, а не решением о небезопасности. Ограничение не обходилось. Frame3492:654 лишь замечен; его полный motion export пока не прочитан.

## Изменения в пакете

- Incoming primary/supplement измеряются до id/transition, с отдельным ключом идентичности. Сохраняемый outgoing ZStack не определяет высоту нового содержимого.
- Placement получает фактическую целевую высоту через private Preference и анимирует занятую область нативного safeAreaInset. Первый размер устанавливается без дополнительного перехода. Нет постоянной высоты136/120 и новых public API.
- Сохраняется одна ветка optional secondary/legal. Их fade и layout используют общую анимацию соответствующего направления; состояния loading/disabled не меняют identity.
- geometryGroup изолирует полный footer. [Apple описывает](https://developer.apple.com/documentation/swiftui/view/geometrygroup%28%29) его как барьер геометрии; необходимая animation transaction задаётся на уровне Placement.
- При уходе Slide фиксирует измеренное расстояние. Движущийся родитель больше не пересчитывает конечную точку на каждом кадре. Раздельные phase timings500/200 и primary fade75 сохранены; глобальные скорости iOS не менялись.
- DEBUG probe записывает новый captureID и complete:false перед запуском, complete:true только после десяти шагов. Прежний журнал не может подтвердить новый незавершённый запуск.

## Проверки последней версии

Устройство: iPhone17Pro, iOS26.4.1 Simulator,402×874pt,@3x; Xcode26.4.1. [Версии исходников](source-versions.json) фиксируют проверенный пакет, зависимости, тесты, probe, потребителя и метаданные.

| Проверка | Фактический результат | Доказательство |
| --- | --- | --- |
| Swift Package | 4 passed,0 failed | package-summary.json, package-tests.log |
| Native каталог + независимый consumer | 4 passed,0 failed | native-summary.json, native-tests.log |
| Каталог | BUILD SUCCEEDED | catalog-build.log |
| Независимый consumer | BUILD SUCCEEDED | consumer-build.log |
| Native package renders | 10 снимков пяти стандартных пресетов в Day/Night | Package/manifest.json |
| Реальные сцены | 9 attachments: пресеты, нажатия/состояния/повтор, consumer Day/Night | Native/manifest.json |
| Motion probe | complete:true,10 шагов, новый captureID | stable-slide-events.json |
| Видео |285 необработанных decoded frames с исходными timestamps | stable-slide-native.mp4, StableSlideFrames/frames.json |

Пакетные проверки охватывают шесть source ID, ширины240/375/430, custom slot180/375/600 и разные фактические высоты, fade и legal максимум3 строки. Native проверки выполняют прокрутку, нажатия, loading/disabled, повтор видимости, замену primary и secondary/legal, импорт публичного пакета независимым приложением. Они проверяют конкретные случаи, а не всю временную матрицу. Corpus318 примеров не запускался повторно: public API не менялся, предыдущая проверка сохранена как история, текущий test target компилируется.

Команды последней версии:

```sh
xcodebuild -workspace PackageTests.xcworkspace -scheme TUIDesignSystemTests -configuration Debug -destination 'id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' -derivedDataPath /private/tmp/tui-foundations-audit-derived -resultBundlePath /private/tmp/tui-floating-height-final-package-20261012.xcresult -only-testing:TUIDesignSystemTests/FloatingContainerTests test
xcodebuild -project TUIDesignSystemCatalog.xcodeproj -scheme TUIDesignSystemCatalogUITests -configuration Debug -destination 'id=6D3F35A1-AC30-4F0E-BDD6-0F912B714E59' -derivedDataPath /private/tmp/tui-typography-catalog-derived -resultBundlePath /private/tmp/tui-floating-height-final-native-20261012.xcresult -only-testing:TUIDesignSystemCatalogUITests/FloatingContainerUITests -only-testing:TUIDesignSystemCatalogUITests/FloatingContainerConsumerUITests test
```

## Динамическое и визуальное сравнение

[stable-slide-measurement.json](stable-slide-measurement.json) получен существующим измерителем из реальных пикселей. Secondary→legal проходит704→720pt с промежуточными положениями; reverse720→704. Начальный полный скачок16pt отсутствует. Show/hide secondary проходят760↔704, different shape сохраняет исходное положение на первом marker frame.

Первый measured-height вариант устранил скачки, но создал outgoing ghosts: большой элемент оставался после596.667ms, маленький — после746.667ms. Эта неудачная попытка сохранена в initial-native.mp4/InitialFrames/initial-measurement.json, с отдельными source hashes. В исправленной записи большой outgoing исчезает между153.333–171.667ms, маленький между206.667–221.667ms. Их удержание после перехода не обнаружено в проверенных конечных кадрах. [Независимый разбор](independent-motion-review.md) описывает точную область проверки и дискретность выборки.

Для двух направлений swap source productiveStandard сравнен с primary delta без сдвига t0 или подбора easing: max residual1.872475/1.451804pt, RMS1.034280/0.875609pt. Это диагностические значения, **не установленный порог полной приёмки**. Source не содержит отдельной primary-track: её перенос следует из корневой геометрии. Local Y system-bottom-bar не использован как primary.

Активные интервалы достигают36.667ms, swap31.667/30ms. Marker указывает первый записанный этап, не точное начало native animation. Видео/цветовые пороги не подтверждают точную opacity curve; nominal average FPS включает паузы. Полные кривые show/hide, перекрытия, быстрые прерывания и произвольные replacement/custom cases ещё требуют проверки.

Пять свежих Day статических сравнений проверены в comparison.png/json. Высоты и типографика сохранены; диагностические RGB MAE остаются около0.87 для двух кнопок,1.25 для legal,4.96 для single с запечённой исходной checkerboard. Alpha этой шахматной PNG не считается исходной прозрачностью; свежие Night Figma-эталоны не получены. Custom editor Placeholder не становится runtime-ассетом. Source gradient46 против annotation40, Button/Foundations typography и SF distribution остаются открытыми.

Для веб-каталога подготовлен floating-transitions.mp4: AVFoundation passthrough12.1s, без retiming, дорисовки или замены кадров. recording-preparation.json отделяет display clip от исходного movie, используемого для измерений.

После сохранения доказательств обновляются только проверенные входы этого набора. Исторические отчёты не переписываются, остальные acceptance categories не назначаются passed автоматически. Полный объём остаётся112 custom sets,16 system sets excluded; статус complete генерируется только из полного реестра.
