# Floating Container: независимый аудит native-записи после стабилизации расстояния Slide

Результат: исходные кадры подтверждают устранение начального скачка размещения, каноническую delta ±16 pt при secondary↔legal и отсутствие позднего outgoing shape в записанном результате. Это **узкие доказательства регрессии**, а не full motion/specification/visual passed и не статус complete.

## Запись и версия

[stable-slide-events.json](stable-slide-events.json) содержит `captureID=10ACD515-EBEE-4415-AC95-59EC337A3C8D`, `complete:true` и все 10 этапов. Значение complete относится к завершению QA-сценария, не к приёмке компонента. Consumer width 402 pt, scale 3. [StableSlideFrames/frames.json](StableSlideFrames/frames.json) содержит 285 исходных PNG с movie timestamps. Контактный лист [stable-slide-measurement.png](stable-slide-measurement.png) служит для просмотра, числа берутся из исходных кадров.

Оба текущих файла совпали с [stable-slide-source-versions.json](stable-slide-source-versions.json): Floating Container SHA 256 `b52829047e6c4a62c75f2ffcffc9a6f3ad39097c682f65911245e3372365e842`; probe SHA 256 `052fbd15eee13bbac4c664b4c6db29814f6efbe3e96cd8cf660ffa115fa27d5d`. Проверка касается этих двух записанных inputs, не произвольных зависимостей. Текущий Slide ViewModifier фиксирует travel на уходе, когда анимирующийся родитель иначе мог бы постоянно менять его global-distance endpoint.

Независимо проверены bounding boxes девяти raw PNG через PIL/NumPy, без записи или изменения изображений. RGB threshold `R>210,G>160,B<100` в нижней области подтвердил координаты, отсутствие дополнительного жёлтого остатка в конечных shape-кадрах и отсутствие yellow pixels после ухода primary.

## Сравнение с source без подгонки

[Forward source JSON](../../../References/FloatingContainer/2026-10-12/PrototypeObservation/secondary-to-legal-transition.json) задаёт корневую delta высоты −16 / позиции +16 и productiveStandard 200 ms; [reverse](../../../References/FloatingContainer/2026-10-12/PrototypeObservation/legal-to-secondary-transition.json) — +16 / −16 и productiveStandard 300 ms. Это общая длительность направления, не разные одновременно running in/out 200/300.

Сверка использует native начальную координату и каноническую delta соответствующего корневого перехода. Direct primary-node keyframes в source JSON отсутствуют: движение primary вслед за footer является выводом из построения. `I3438:380;44286:299563` / `I3438:382;44286:299518` — system-bottom-bar; их local Y не используется как primary. Исторические root heights 170/154 включают 34 pt Apple bar, кастомный контент 136/120. Native iOS 26 панель не перерисовывается.

`t₀` — first recorded stage marker. Время не сдвигается, кривая не подбирается, source absolute Y разных frames не выравнивается. Ожидаемое `y=y₀+(y₁-y₀)*By(u)`, где `Bx(u)=clamp((t-t₀)/duration,0,1)`; обратное вычисление производится 60 шагами bisection. В [independent-motion-metrics.json](independent-motion-metrics.json) сохранены формула, source curves, все использованные timestamp/bounds/residuals и SHA checks.

| Сценарий | Native primary Y, pt | Nominal duration | Кадров с отдельным wide primary | Max / RMS residual, pt |
| --- | --- | --- | --- | --- |
| show-primary | 874 → 760 | 500 ms | 29 | 3.988708 / 1.352703 |
| show-secondary | 760 → 704 | 500 ms | 30 | 3.742803 / 1.196585 |
| secondary-to-legal | 704 → 720 | 200 ms | 12 | 1.872475 / 1.034280 |
| legal-to-secondary | 720 → 704 | 300 ms | 19 | 1.451804 / 0.875609 |
| hide-secondary | 704 → 760 | 200 ms | 13 | 1.477924 / 0.940774 |
| hide-primary | 760 → 874 | 200 ms | 12 | 7.228079 / 3.351532 |

Для presence/secondary rows параметры кривых и duration берутся из Guide/Primitive, координаты — из native окна/построения. Только swap rows имеют дополнительно прочитанные directional source JSON. Residuals — диагностика, не придуманная допустимая погрешность и не passed curve acceptance.

## Устранённые начальные скачки

В предыдущем [FloatingContainerMotion/final-measurement.json](../FloatingContainerMotion/final-measurement.json) уже первый кадр show secondary показывалY 704 вместо прежнего 760; swap — сразу 720/704; hide secondary — сразу 760. Новая запись сохраняет исходную позицию на первом stage-кадре и показывает промежуточные координаты:

- Show secondary: 760 → 753.333 на 25 ms → 739.333 на 55 ms, далее overshoot 702.667 и конечное 704. Прежний мгновенный сдвиг 56 pt отсутствует.
- Secondary→legal: 704 на t₀ → 704.667 на 31.667 ms → 708.667 на 63.333 ms → 720. Максимальный наблюдаемый соседний шаг 4 pt, не весь 16 pt.
- Legal→secondary: 720 на t₀ → 718.667 на 46.667 ms →…→ 704. Максимальный соседний шаг 1.667 pt.
- Hide secondary: 704 → 706 на 21.667 ms → 709.333 на 38.333 ms →…→ 760 на 206.667 ms.
- Different shape stage 4 начинается с wide Y 760, stage 5 — с compact Y 786. Старые начальные скачки ±26 pt исчезли. Перекрытие жёлтых элементов местами объединяет их детектором; это не полная проверка двух независимых траекторий.

Show primary появляется снизу: первый видимый верхY 860 на 13.333 ms, затем 846/832/818.333, overshoot 756.667 и конечное 760. Hide primary проходит 760/764/778.667/…/862.667; на 203.333 ms yellow pixels отсутствуют. Движение зафиксировано, но max error 7.228079 pt у hide не объявляется точным совпадением.

## Outgoing ghost: история и новое доказательство

[initial-measurement.json](initial-measurement.json) сохраняется как история первой height-реализации с регрессией retargeting: outgoing wide stage 4 ещё виден на 596.667 ms; compact stage 5 — на 746.667 ms. Это не доказательства новой версии.

В StableSlide stage 4 последний видимый wide — 153.333 ms, следующий кадр 171.667 ms его уже не содержит. На 635 ms [frame-00164.png](StableSlideFrames/frame-00164.png) содержит только compact bounds `[148.667,786,253.667,815.667]` pt. Тем самым имеется свежий frame после 550 ms без старой wide формы.

В stage 5 последний отдельный compact — 206.667 ms; на 221.667 ms он отсутствует. Конечный [frame-00194.png](StableSlideFrames/frame-00194.png) на 526.667 ms содержит только wide bounds `[16,760,385.667,815.667]` pt. Он удерживается в записи до следующего frame/stage на 1168.333 ms. **Свежего stage 5 frame ровно на 550 ms или позднее нет**: отсутствие ghost после 550 ms описывает удерживаемый movie frame, не независимую дополнительную выборку. Первый следующий stage 6 frame также содержит только wide primary перед его новым перемещением.

## Ограничения и границы вывода

Максимальный интервал активных frames — 36.667 ms; у swap 31.667/30 ms, у show secondary 35 ms. Первый recorded marker не точное начало SwiftUI animation, поэтому отсутствие временной подгонки сохранено, а residuals не списываются автоматически на compositor. Поздние большие gaps статических held frames не повышают временную точность.

RGB thresholds/compression не подтверждают per-pixel opacity curve или точный момент полного fade. Новая запись снята в Day; существующие Day/Night preview и конечные native checks не заменяют отсутствующие Night-эталоны Figma. Полный граф остальных source flows, rapid interruptions, arbitrary/custom slot replacements, дополнительные width/state combinations и полная typography/visual приёмка остаются открытыми. Сборки и финальные package/native tests проверяются и сохраняются отдельно; данный readonly аудит их не запускал и не выдаёт запись за их результат.

Исходные записи и отчёты не переписаны. Созданы только этот независимый review и его metrics JSON. Figma/UI/Simulator/builds не запускались; реестр и production source не изменялись.
