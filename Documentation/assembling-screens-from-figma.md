# Сборка экранов из TUI Design System

Этот Swift Package предназначен для новых сценариев, а не только для «Зарплатного клуба». Если на входе дана ссылка на экран или компонент TUI Mobile, сначала прочитайте узел через Figma `get_design_context`. У ссылки вида `...?node-id=115603-32334` идентификатор набора — `115603:32334`.

## Как найти реализацию

1. Найдите ID набора в `Documentation/component-coverage.json`. Поле `swiftAPI` указывает публичный SwiftUI-символ и исходный файл. `status: complete` означает, что вся iOS-матрица и визуальное сравнение пройдены. `in-progress` означает рабочий компонент с незавершённой сверкой; `catalogued` — реализации пока нет.
2. Если ссылка ведёт на вариант, найдите его ID в `Sources/TUIDesignSystem/Resources/Metadata/figma-component-variants.json`. Поля `setId` и `variantProperties` связывают этот вариант с компонентом и его свойствами. Для экрана с несколькими компонентами повторите это для каждого вложенного набора.
3. Проверьте детали в файле `swiftAPI.source` и в Figma-спецификации из `specificationURLs`: допустимые значения, поведение, контент и доступность. Сопоставьте свойства варианта с публичным инициализатором. Не выводите готовность из одного только наличия символа.
4. Используйте `TUIColor`, `TUITypographyRole`, `TUISpacing`, `TUIRadius` и `TUIControlSize` для недостающей композиции экрана. Системные элементы навигации, шторки, меню, списки и поля поиска оставляйте нативными для iOS 26.
5. После сборки экрана сравните его на симуляторе с Figma в том же размере и теме. Если нужный набор ещё `catalogued` либо его вариант не покрыт API, сначала реализуйте и проверьте компонент здесь, затем собирайте экран потребителя.

Для интерактивной проверки откройте `TUIDesignSystemCatalog.xcodeproj`: каталог использует реальные SwiftUI-компоненты, а у живых наборов показывает текущий ID варианта Figma. Полная матрица хранится отдельно от кода, чтобы при появлении новых сценариев можно было искать компоненты по Figma ID без зависимости от названия экрана.

## Пример использования компонента

```swift
import SwiftUI
import TUIDesignSystem

struct CategoryFilter: View {
    @State private var selectedCategory = "Все"
    private let categories = ["Все", "Карты", "Вклады"]

    var body: some View {
        TUIChipGroup(size: .small, scrollable: true) { size in
            ForEach(categories, id: \.self) { category in
                TUIChip(
                    category,
                    size: size,
                    appearance: selectedCategory == category ? .accent : .neutral
                ) {
                    selectedCategory = category
                }
            }
        }
    }
}
```

Группа передаёт размер каждому дочернему чипу через замыкание. Для многострочного режима передайте `scrollable: false`; расположение подстраивается под доступную ширину экрана.
