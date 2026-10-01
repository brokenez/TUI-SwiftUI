# TUI Design System project instructions

- Figma is the source of truth. Components: `OBPLqL8JDThLuOP8M4JzBL`; assets: `R1oI4T6X9CHxl2x55MDypT`; foundations: `gGt4PaQxQhX7ozPVImsgL5`.
- Implement every component against its complete Figma component-set matrix. Preserve property names, values, states, platform variants, sizes, appearances, content options, and accessibility guidance.
- A SwiftUI component is not complete until every iOS-relevant variant in `figma-components.json` is mapped and verified against the component specification page.
- Use `TUIColor`, `TUITypographyRole`, `TUISpacing`, `TUIRadius`, and `TUIControlSize`; do not invent visual constants when a Figma variable exists.
- Prefer native iOS 26 containers and interactions for navigation, sheets, alerts, lists, forms, toolbars, switches, pickers, and system menus.
- Locate source assets through `figma-assets.json`. Export the exact Figma node into `Sources/TUIDesignSystem/Resources/Assets.xcassets` when implementing a component that uses it.
- Keep implementation status in `Documentation/component-coverage.json`. `complete` requires full variant coverage plus a visual comparison; otherwise use `catalogued`, `in-progress`, or `blocked`.
- Build the Swift Package and the standalone catalog application after public API changes.
