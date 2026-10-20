# Floating Container: спецификация и текущая реализация

Статус: **in-progress**. Вся доступная основная спецификация и схемы прочитаны до реализации; полный список разделов сохранён в specification-reading.md. Файлы Figma не изменялись. Этот документ дополняет исходную запись чтения, не объявляет компонент принятым.

## Источники и доступность

- [Актуальный набор Mobile](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=44286-299509): полный контекст сохранён в remote-mobile-set.txt. Контексты всех шести применимых вариантов и снимки сохранены в variant-*.txt и Variants. Свойства совпали с импортированной матрицей. Remote metadata вернул для набора только frame; публикация, полная цепочка master/instance и ID связанных Variables остаются UNVERIFIED.
- [Спецификация](https://www.figma.com/design/jvYMs0sCSCZCHEFrRcL4vW/tui-floating-container?node-id=0-1): Construction, Behavior, Customization, Rules со всеми содержательными children, Styles и Changes прочитаны. Getting Started используется как навигация. Доступность исключена текущим решением пользователя.
- [Появление основной кнопки](https://www.figma.com/design/usDNc7HuHlFSGp0DZhPKVL/Mobile-Animation-Examples?node-id=3445-1212): доступный контекст прочитан, remote-proto-primary.txt. Он показывает статическое стартовое расположение; motion MCP вернул nodes:[], что не подтверждает отсутствие переходов прототипа.
- [Замена элемента другой формы](https://www.figma.com/design/usDNc7HuHlFSGp0DZhPKVL/Mobile-Animation-Examples?node-id=3351-4506): прочитан remote-proto-same-shape.txt. Имя сохранённого файла исторически следует позиции ссылки, фактическое имя узла — «Замена элемента на элемент другой формы». Не выдаём его за пример одинаковой формы.
- [Вторая кнопка → текст](https://www.figma.com/design/usDNc7HuHlFSGp0DZhPKVL/Mobile-Animation-Examples?node-id=3438-381): прочитан remote-proto-different-shape.txt. Фактическое имя — «Смена второстепенной кнопки на текст и наоборот».
- Два сохранённых исходных proto URL в jvYMs0sCSCZCHEFrRcL4vW с узлами 63:3657 и 63:2454, а также их page 26:2239, MCP сейчас не находит. Ответы сохранены. Их содержимое остаётся **UNVERIFIED**, а не объявляется отсутствующим в самой Figma. Полное динамическое исполнение всех пяти прототипов ещё не проверено.

## Точная геометрия и токены

| Содержимое | Горизонтальные поля | Контент без системной панели | Прочие размеры |
| --- | --- | --- | --- |
| action | Screen Padding / 16 | 80 при Large button | 24 снизу |
| two-actions | Screen Padding / 16 | 136 при двух Large buttons | gap 8, 16 снизу |
| action+legal | Screen Padding / 16 | 120 при Large button | gap 16, legal min 48, максимум 3 строки |
| custom-content | Screen Padding / 16 | фактическая высота + 24 | слот не ограничен редакционными 56 |

Применяются TUISpacing, TUIButton с его исходными tokens/variants/states, TUIColor Background/Base и Background/Elevation 1, Text/Secondary и TUITypographyRole.uiSmall. Отдельный трекинг к современному системному шрифту legal не добавляется: Foundations задаёт автоматический платформенный интервал. Исходное значение Figma — −0.08 pt, оно сохранено в контекстах, но повторное применение давало более узкий текст.

Исходная iOS SVG-маска fade-mask-ios.svg имеет линейную прозрачность от y=0 до y=46, затем alpha=1. Реализация воспроизводит этот профиль нативным LinearGradient с цветом выбранного Theme token. Аннотация 40 на Construction-схеме находится внутри верхней области кнопки, **не задаёт отступ 40 выше кнопки**. Расхождение аннотации 40 с актуальной маской 46 сохраняется как ограничение визуальной приёмки; не сдвигаем компонент и не редактируем Figma. Отключённый fade оставляет область прозрачной. Две кнопки/legal требуют подложки; одиночный always-visible использует showsFade=true, появляющийся по scroll/trigger — false.

Home indicator, статусная панель и навигация принадлежат нативному экрану iOS 26. Импортированный show-home-indicator — системная настройка; компонент не рисует отдельную панель и не добавляет фиктивные 34 pt. Отступ после конца обычного скролла — 20; специализированная кнопка Forms над клавиатурой сохраняет собственные правила 12/16, этот helper туда не подставляется.

## Публичный API и матрица

| Figma ID | API |
| --- | --- |
| 44286:299616 | TUIFloatingContainer(primary:showsFade:backgroundColor:) |
| 44286:299510 | TUIFloatingContainer(primary:secondary:background: .base) |
| 55095:283896 | TUIFloatingContainer(primary:secondary:background: .elevation1) |
| 44286:299553 | TUIFloatingContainer(primary:legalText:background: .base) |
| 55095:283930 | TUIFloatingContainer(primary:legalText:background: .elevation1) |
| 44286:299621 | TUIFloatingContainer { actualConsumerContent } |

Размер, оформление, состояние, иконка, текст и действие кнопки задаются существующим TUIButton. Контейнер не дублирует его API. Предпочтительный secondary — flat; полупрозрачные кнопки над градиентом запрещены Guide. Custom content получает реальную SwiftUI-композицию, не изображение Placeholder. Данные/действия принадлежат экрану.

Модификатор .tuiFloatingContainer(isPresented:content:) использует нативный safeAreaInset, 20 pt end gap и движение основного блока снизу: expressive-entrance/500 ms, productive-exit/200 ms. Primitive/fast равен 150 ms и не подменяет явные 200 ms спецификации. Глобальная скорость системных анимаций не изменяется.

**Пока не реализованы:** fade замены основной кнопки 75 ms, уход/появление элементов другой формы 200/500 ms, swap secondary/legal fade 200/300 ms и отдельное движение secondary/background. Изменение preset в демо показывает конечный layout, не считается реализацией этих переходов. Измерение фактической временной кривой появления/скрытия и видеозапись остаются pending.

## Проверка и ограничения

Текущие тесты и снимки: [отчёт](../../../Validation/2026-10-12/FloatingContainer/verification-report.md). Тесты подтверждают сопоставление 6 ID, адаптивность ширины/слота, геометрию, реальную прокрутку, нажатия и блокировку loading/disabled. Сборка и интеракции проверены в независимом потребителе публичного пакета.

Визуальное сравнение пока диагностическое: MCP PNG содержит запечённую шахматную сетку в прозрачных областях и получен в 1x; native output — 3x. Нельзя сравнивать alpha этого PNG как исходную маску или объявлять среднюю RGB-ошибку приёмкой. Night-эталоны Figma ещё не выгружены. Custom slot сравнивается с переданным кодом, а редакционный Placeholder не включается в продукт. Полная визуальная/спецификационная/motion приёмка и решение по распределению SF fonts остаются открытыми.
