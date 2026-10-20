# Textfield: чтение и совместимые опции, 15 октября 2026

Статус: **READ / IMPLEMENTED, проверка изменений ещё не выполнена**. Этот документ не является приёмкой. Реестр и generated coverage не изменялись. Figma не редактировалась; новые обращения — только read-only MCP screenshots.

До изменения кода прочитаны все сохранённые тексты основного Guide, сводка `../specification-reading-2026-10-09.md`, связанные правила Forms и текущие отчёты проверки 9/12 октября. Просмотрены все девять PNG основного Guide: состояния `4802:3778`, построение `4803:6152`, размеры `4827:6778`, поведение `4830:6945`, подсказки `7084:56801`, анимация `4859:6710`, дополнительные возможности `4831:7321`, кастомизация `4857:7477`, использование `4880:8888`. Также просмотрены сохранённые схемы quantity/SmartFields; их числовые/compound контракты не переносятся в обычный ввод.

Полный основной источник: [Figma, Design 4923:11438](https://www.figma.com/design/R4dFzxFzgDIGTcdlrqaRpe?node-id=4923-11438). Набор: [TUI Mobile 65702:51131](https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL?node-id=65702-51131).

## Подтверждённые контракты малого пакета

- `4859:6725` и `4859:6741`: центрирование допускается без label, accessories и clear; placeholder в фокусе выключен. `4859:6731`: отдельного Figma preset нет, выравнивание меняют вручную. Добавлен `TUITextfield.TextAlignment` с `leading` / `center`, default `leading`; нативный UITextField получает `.natural` / `.center`. В фокусе centered placeholder скрыт. Библиотека не удаляет переданные label/accessories и не падает на неподдержанном сочетании. Допустимые настройки документированы; проверка запрещённых сочетаний не заявляется. Playground при выборе center выставляет допустимую начальную конфигурацию.
- `4857:7477` → текст `4877:8496`, схема `4891:19534`: для custom end action можно выключить правые 12 pt, чтобы библиотечная кнопка упиралась в край. Добавлен `trailingAccessoryInset: Bool = true`; `false` влияет только на видимый custom `endContent`. Левые 12 pt и gap 8 pt сохраняются. Ветви lock/clear/без custom content сохраняют прежнюю геометрию.
- Forms `9702:66367`, схема `9723:66061`: внешние боковые 16 pt включены по умолчанию и отключаемы. Добавлен `TUITextfieldForm(screenPadding: Bool = true)`; false убирает только внешний inset содержимого формы. Standalone Textfield сохраняет существующую модель: внешний Screen Padding задаёт consumer, как уже делали source-mode и публичные примеры. Добавление ещё одних 16 pt внутрь самого поля удвоило бы существующие inset. Кнопка над клавиатурой сохраняет собственные 16 pt по `9707:118368` / `9702:66372`, независимо от screenPadding формы.

## Повторно просмотренные Forms diagrams

Read-only screenshots в этом каталоге получены из [Forms 9702:48708](https://www.figma.com/design/R4dFzxFzgDIGTcdlrqaRpe?node-id=9702-48708). Все 12 просмотрены перед изменением Form:

- `9702:66358`, `9702:66361` — одиночная/многоэлементная форма, экран/шторка.
- `9723:66061` — внешние 16 pt.
- `9723:66749` — gap 12 pt и hints, включая несколько подсказок.
- `9702:66372` — кнопка medium, 12 pt до последнего содержимого, 16 pt до клавиатуры и справа.
- `9725:64298`, `9702:66352` — автопрокрутка и снятие фокуса.
- `9702:66355` — compound example, отдельный тип не реализуется этим изменением.
- `9702:66337`, `9702:66339`, `9702:66341`, `9702:66343` — переход фокуса, dropdown/select, пропуск disabled. Dropdown/select не заменяются обычным вводом.

## Проверки и остающееся

Добавлены проверки реальной геометрии нативного редактора: центрирование/placeholder/value, разница 12 pt при flush accessory на ширинах 200/320/600, неизменность поля без custom accessory, разница 16 pt по сторонам Form. Тесты добавлены в существующие TextfieldTests и TextfieldFormTests. Запуск package/catalog/native проверок выполняет основной агент; здесь Simulator, Xcode и GUI не запускались.

Нативное взаимодействие новых опций, Light/Dark и точная визуальная приёмка пока **UNVERIFIED**. Предыдущая интеграционная проверка не подтверждает новые API. Отдельно остаются accessory hit areas, overflow fade и selection token, hint/clear/label motion, точные шаги error shake, counter и применимость number/prefix/suffix. Растровые Night эталоны и SF typography acceptance не получены этим пакетом. VoiceOver и увеличенные шрифты не аудировались по текущему scope.

## Уточнение после фактических package-прогонов

Первый запуск новых geometry tests не создал UIViewRepresentable в безоконном хосте. Setup заменён настоящим UIWindow с удержанием хоста, ожиданием нативного layout и cleanup. Повторный запуск обнаружил реальный native height 21 pt при SwiftUI wrapper 20 pt, а не подтвердил соответствие. Тестовый oracle для пустого UIKit attributedPlaceholder нормализован как `?.string ?? ""`; ожидаемая геометрия не ослаблена.

До исправления размера повторно прочитан свежий read-only get_design_context `65702:51258` (`source-65702-51258-context.txt` / PNG в этом каталоге) и сохранённые исходные metadata: `65702:51264` value-container 264×20, `65702:51266` placeholder 263×20, `65702:51265` cursor 2×19 при y=0.5. TUITextfieldEditor теперь принимает конечный explicit ProposedViewSize через UIViewRepresentable.sizeThatFits; исходный `.frame(height:20)` управляет и фактическим native editor. Шрифт, line-height tokens и caret не менялись. Нужны повторный package-run, native interaction и обновлённая матрица: предыдущие PNG не являются доказательством нового размера.
