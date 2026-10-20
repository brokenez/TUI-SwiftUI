# Skeleton — регрессия маршрута после Header Card

В `CatalogApp/TUIDesignSystemCatalogApp.swift` добавлена только ветка DEBUG для отдельного хоста Header Card. Производственные TUISkeleton/TUISkeletonText, их токены, параметры движения и прежний `--tui-skeleton-motion-probe` не изменены.

На iPhone 17 Pro, iOS 26.4.1, повторно прошли оба SystemMotionUITests. Штатные аудиты elementDetection/sufficientElementDescription/trait выполнены без фильтрации. Системный Reduce Motion включён через Settings: оба скелетона останавливаются; после выключения, возврата из фона и перезапуска цикл возобновляется. Исходное значение настройки восстанавливается тестом. Снимки и измерения сохранены в `Documentation/Validation/2026-10-07/HeaderCardSkeletonRouteRegression/`; итог — два Passed, ноль Failed.

Обновляется только hash изменённого файла точки входа приложения. Прежние полная матрица, визуальные пары, спецификация и доказательства приёмки сохраняются. Проверка этого маршрута не объявляется новой приёмкой всех компонентов библиотеки.
