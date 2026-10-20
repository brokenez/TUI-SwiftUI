# Skeleton: проверка после добавления Textfield QA route

В shared CatalogApp entry point добавлена отдельная DEBUG ветка TextfieldMotionProbe. Реализация TUISkeleton/TUISkeletonText, их токены, ресурсы, source matrices и прежние визуальные/временные доказательства не изменились. Сгенерированная приёмка временно стала stale по entry-point hash; checksum обновляется только после проверки.

Новый узкий тест `SystemMotionUITests.testExistingSkeletonRouteRetainsLiveCoreAndTextAfterNewProbeRoute` запускает существующий `--tui-skeleton-motion-probe` в настоящей сцене. Проверены восемь снимков core и восемь Text/Heading Large: обе области меняют пиксели. Тест и сборка каталога прошли: 1 passed, 0 failed/skipped. iPhone 17 Pro, iOS Simulator 26.4.1, Xcode 26.4.1, scale 3. Доказательства: `Documentation/Validation/2026-10-09/TextfieldSkeletonRouteRegression/summary.json`, test.log и Attachments/manifest.json. Команда сохранена в начале лога, версии — input-versions.json.

Дополнительно текущая нормальная навигация каталога и Skeleton внутри Textfield прошли отдельный live test с восемью кадрами. Это дополнительное доказательство host integration, не новая приёмка всей исходной матрицы Skeleton.

Обновлены только hashes CatalogApp/TUIDesignSystemCatalogApp.swift и изменённого тестового файла CatalogUITests/SystemMotionUITests.swift. Прежние проверки спецификации, полной матрицы, Visual/Light/Dark и motion сохраняются на неизменившихся production-входах. Расширенная accessibility/Reduce Motion исключена пользователем из текущего объёма; новых проверок и системных настроек доступности не добавлено.
