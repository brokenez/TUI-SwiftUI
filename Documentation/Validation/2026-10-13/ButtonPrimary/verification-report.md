# Button Primary: 12 исходных поз и 270 нативных рендеров

Сохранены свежие MCP-контексты и PNG всех 12 Primary-вариантов без Skeleton: три размера × normal/pressed/loading/disabled. Источники: `Documentation/References/Button/2026-10-13/primary-*.txt/.png`. Исходная Figma не изменена.

Один фактически выполненный `ButtonCustomizationTests/testEveryNonGlassVariantProducesNativeRenderAtSourceFrameSize` прошёл на iPhone 17 Pro / iOS 26.4.1: **1 passed, 0 failed**. [Сводка](package-summary.json), [журнал](package-tests.log), [вложения](Native/manifest.json). Получены 270 PNG @3x: 135 non-glass iOS-вариантов × Day/Night. Размер каждого совпадает с импортированным source frame. Это доказывает возможность рендера матрицы, а не её полное сходство с Figma.

[Сравнение](comparison.json) воспроизводится `Scripts/compare_button_primary.py`. Native @3x уменьшен LANCZOS до исходного Figma @1x, оба изображения скомпонованы на белом фоне. Сдвиги и коррекция цветов не применялись. Сравниваются ровно 12 свежих Day-пар. [Сравнительный лист](comparison.png): Figma / native / усиленная разница.

MAE по шкале 0–255: Large 0.208–0.734, Medium 0.248–0.916, Small 1.669–3.899. Источник задаёт SF Pro Text Regular 17/15 с kern −0.41/−0.24; Small — Semibold 13 с kern −0.08. Проблема версии legacy/system SF и распределения ресурсов не решена. Ночные runtime PNG не выданы за проверку против независимых Night-экспортов. Эти измерения не переводят visual в passed.

Нативные PNG сняты до последующего подключения анимации общего Skeleton. Варианты без Skeleton используют прежний путь; обновлённые Skeleton проверяются отдельно в [ButtonSkeleton](../ButtonSkeleton/verification-report.md). Исторические PNG не объявляются повторным прогоном после этого изменения.

Проверка отдельного XS-ассета не улучшила результат и отменена; см. [запись эксперимента](../ButtonSmallLoader/README.md). В production оставлен прежний исходный loader. Полный Button остаётся in-progress.
