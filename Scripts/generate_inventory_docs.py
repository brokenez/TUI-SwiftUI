#!/usr/bin/env python3
"""Index existing evidence; never turn a discovered link into an accepted specification."""
import argparse
import hashlib
import json
import re
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from pathlib import Path
from coverage_model import ios_scope

ROOT = Path(__file__).resolve().parents[1]
META = ROOT / "Sources/TUIDesignSystem/Resources/Metadata"
SNAPSHOT = ROOT / "Documentation/Inventory/2026-10-08"
GROUPS = ("Foundations", "Buttons", "Textfields", "Cells", "Cards", "Navigation",
          "Bottom Sheets", "Controls", "Feedback", "Content")
BASE_SETS = {"41658:296906": "button", "65702:51131": "textfield", "41569:290555": "cell"}


def read(path):
    return json.loads(path.read_text())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def group(name):
    name = name.strip().lower()
    if name in {"tui-spacing", "underline"}:
        return "Foundations"
    if name.startswith(("tui-button", "tui-link")):
        return "Buttons"
    if name.startswith(("tui-textfield", "[pwa] tui-input-search")):
        return "Textfields"
    if name.startswith("tui-cell"):
        return "Cells"
    if name.startswith(("tui-card", "tui-thumbnail-card")):
        return "Cards"
    if name in {"tui-bottom-sheet", "system-action-sheet", "system-share-sheet"}:
        return "Bottom Sheets"
    if name.startswith(("tui-header", "tui-app-bar", "tui-tab-bar", "tui-search-bar")) or name in {
        "system-bottom-bar", "system-browser-bar", "system-browser-chrome", "system-status-bar", "system-searchfield"
    }:
        return "Navigation"
    if name.startswith(("tui-chip", "tui-counter", "tui-pager", "tui-rating", "tui-segmented", "tui-swipe-actions")) or name in {
        "system-checkbox", "system-radiobutton", "system-switch", "system-segmented-control (tabs)", "system-context-menu"
    }:
        return "Controls"
    if name.startswith(("tui-notification", "tui-loader", "tui-progress", "tui-skeleton", "tui-tooltip", "tui-block-status")) or name in {
        "system-alert", "system-push", "[pwa-webview] tui-dialog"
    }:
        return "Feedback"
    return "Content"


def figma_link(node):
    return "https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=" + node.replace(":", "-")


def xml_snapshot(name):
    data = read(SNAPSHOT / name)
    value = next(c["text"] for c in data["content"] if c["type"] == "text" and c["text"].startswith("<canvas"))
    return ET.fromstring(value)


def md(value):
    return str(value).replace("|", "\\|").replace("\n", " ").strip()


def relative_link(path, from_path):
    import os
    return os.path.relpath(ROOT / path, (ROOT / from_path).parent)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    sets = read(META / "figma-components.json")["componentSets"]
    variants = read(META / "figma-component-variants.json")["variants"]
    coverage = read(ROOT / "Documentation/component-coverage.json")
    current = {c["id"]: c for c in coverage["components"]}
    records = {c["id"]: c for c in read(ROOT / "Documentation/component-verification.json")["components"]}
    redirects = read(ROOT / "Documentation/figma-spec-links.json")["links"]
    variables_source = SNAPSHOT / "component-variable-definitions-mcp.json"
    variable_records = {c["id"]: c for c in read(variables_source)["components"]}
    assert len(sets) == len({c["id"] for c in sets})
    assert {c["id"] for c in sets} == set(current) == set(records)
    assert len(variants) == len({v["id"] for v in variants})
    by_set = defaultdict(list)
    for variant in variants:
        assert variant["setId"] in current
        by_set[variant["setId"]].append(variant)

    main_tree = xml_snapshot("tui-mobile-components-metadata-mcp.json")
    legacy_tree = xml_snapshot("tui-mobile-legacy-metadata-mcp.json")
    observed = {n.attrib["id"]: n.attrib for n in main_tree.iter() if "id" in n.attrib}
    legacy_ids = {n.attrib["id"] for n in legacy_tree.iter() if "id" in n.attrib}
    assert not (set(current) & legacy_ids), "An imported main set moved to Legacy; review its lifecycle before generating docs"
    candidates = [
        {"id": n.attrib["id"], "name": n.attrib["name"], "figmaURL": figma_link(n.attrib["id"]),
         "observedSymbolCount": len(n.findall("symbol")), "componentSetStatus": "UNVERIFIED",
         "publicationStatus": "UNVERIFIED"}
        for n in main_tree.iter("frame") if n.findall("symbol") and n.attrib["id"] not in current
    ]
    legacy = [
        {"id": n.attrib["id"], "name": n.attrib["name"], "figmaURL": figma_link(n.attrib["id"]),
         "observedSymbolCount": len(n.findall("symbol")), "includedInMainLibrary": False,
         "sourcePageID": legacy_tree.attrib["id"]}
        for n in legacy_tree.iter("frame") if n.findall("symbol")
    ]
    rows = []
    for component in sets:
        c = current[component["id"]]
        record = records[c["id"]]
        historical = {v["id"] for v in c["historicalVariants"]}
        source_variants = by_set[c["id"]]
        # Use the same scope function as acceptance, including shared variants.
        _, applicable, _ = ios_scope(source_variants, coverage["platformPolicy"])
        specifications = []
        for link in component.get("documentationLinks", []):
            uri = link["uri"]
            specifications.append({"originalURL": uri, "resolvedURL": redirects.get(uri, {}).get("destination"),
                                   "resolutionSource": "Documentation/figma-spec-links.json"})
        evidence = sorted({e["path"] for e in record["checks"]["specification"].get("evidence", [])})
        api = c["swiftAPI"]
        dependencies = []
        if api and (ROOT / api["source"]).exists():
            dependencies = sorted(set(re.findall(r"\bTUI[A-Za-z0-9_]+\b", (ROOT / api["source"]).read_text())) - {api["symbol"]})
        variables = {"status": "UNVERIFIED", "bindings": None}
        nested = {"status": "UNVERIFIED", "dependencies": None}
        variable_record = variable_records.get(c["id"])
        if variable_record and variable_record.get("result") and not variable_record["result"].get("isError"):
            definitions = json.loads(next(b["text"] for b in variable_record["result"]["content"] if b["type"] == "text"))
            variables = {"status": "PARTIAL", "definitions": definitions, "bindings": None,
                         "source": str(variables_source.relative_to(ROOT)), "sourceComponentSetID": c["id"],
                         "limitation": "Definitions for the whole set; individual bindings, aliases and all theme modes remain UNVERIFIED. An empty response does not prove no variables are used."}
        if c["id"] in BASE_SETS:
            label = BASE_SETS[c["id"]]
            nested_path = SNAPSHOT / (label + "-variant-metadata-mcp.json")
            data = read(nested_path)
            value = next(b["text"] for b in data["result"]["content"] if b["type"] == "text" and b["text"].startswith("<symbol"))
            items = []
            def visit(node, hidden=False):
                hidden = hidden or node.attrib.get("hidden") == "true"
                if node.tag == "instance":
                    items.append({"instanceNodeID": node.attrib["id"], "name": node.attrib["name"],
                                  "effectiveHidden": hidden, "componentID": None, "componentIDStatus": "UNVERIFIED"})
                for child in node:
                    visit(child, hidden)
            visit(ET.fromstring(value))
            nested = {"status": "PARTIAL", "observedVariantID": data["nodeId"], "dependencies": items,
                      "source": str(nested_path.relative_to(ROOT)), "limitation": "One observed variant; not the complete dependency graph."}
        state_keys = [key for key in component.get("properties", {})
                      if re.search(r"state|select|enable|skeleton|loading|focus|error|disable|hover|pressed", key, re.I)]
        ready_spec = c["verification"]["specification"] and not c["verification"]["staleInputs"]
        rows.append({
            "name": component["name"], "componentSetID": c["id"], "figmaURL": c["figmaURL"],
            "group": group(component["name"]), "description": component.get("description", ""),
            "publicationStatus": "UNVERIFIED", "lifecycle": "not-on-observed-Legacy-page",
            "lifecycleLimitation": "Components-page membership does not prove publication or absence of other deprecation annotations.",
            "currentPageObserved": c["id"] in observed,
            "variantIDsNotObservedInCurrentPage": [v["id"] for v in source_variants if v["id"] not in observed],
            "variants": source_variants, "applicableIOS26VariantIDs": [v["id"] for v in applicable],
            "historicalIOS18VariantIDs": sorted(historical), "properties": component.get("properties", {}),
            "statePropertyNames": state_keys, "variables": variables, "nestedComponents": nested,
            "foundationsDependencies": {"status": "UNVERIFIED", "observedSwiftSymbols": dependencies,
                                        "observationSource": api["source"] if api else None},
            "specifications": specifications, "specificationStatus": "VERIFIED" if ready_spec else "UNVERIFIED",
            "specificationEvidence": evidence, "implementationStatus": "IMPLEMENTED" if api else "NOT_IMPLEMENTED",
            "swiftAPI": api, "verificationStatus": c["status"], "checks": record["checks"],
            "scopeExclusion": c.get("scopeExclusion"),
            "staleInputs": c["verification"]["staleInputs"], "openIssues": record.get("openIssues", [])
        })
    rows.sort(key=lambda x: (GROUPS.index(x["group"]), x["name"].strip().lower(), x["componentSetID"]))
    excluded_rows = [r for r in rows if r["verificationStatus"] == "excluded"]
    rows = [r for r in rows if r["verificationStatus"] != "excluded"]
    payload = {"schemaVersion": 1, "reviewDate": "2026-10-09", "target": "iOS 26",
               "scope": "128 imported source sets; 112 active sets; 16 system-* sets excluded by user decision 2026-10-09; additional unverified candidates",
               "publicationStatus": "UNVERIFIED", "publicationEvidence": "Documentation/Inventory/2026-10-08/tui-mobile-published-mcp.json",
               "sources": {str(p.relative_to(ROOT)): sha(p) for p in [META / "figma-components.json", META / "figma-component-variants.json",
                          ROOT / "Documentation/component-coverage.json", ROOT / "Documentation/figma-spec-links.json",
                          SNAPSHOT / "tui-mobile-components-metadata-mcp.json", SNAPSHOT / "tui-mobile-legacy-metadata-mcp.json", variables_source]},
               "summary": {"importedComponentSets": len(rows) + len(excluded_rows),
                           "activeComponentSets": len(rows), "excludedSystemComponents": len(excluded_rows),
                           "implemented": sum(bool(r["swiftAPI"]) for r in rows),
                           "accepted": sum(r["verificationStatus"] == "complete" for r in rows),
                           "groups": dict(Counter(r["group"] for r in rows)), "additionalCandidates": len(candidates),
                           "observedLegacyCandidates": len(legacy),
                           "setsWithMCPVariableDefinitionsRead": sum(r["variables"]["status"] == "PARTIAL" for r in rows),
                           "importedVariantIDsNotObserved": sum(len(r["variantIDsNotObservedInCurrentPage"]) for r in rows + excluded_rows),
                           "activeVariantIDsNotObserved": sum(len(r["variantIDsNotObservedInCurrentPage"]) for r in rows)},
               "components": rows, "excludedSystemComponents": excluded_rows,
               "additionalCandidates": candidates, "legacy": legacy}
    outputs = {"docs/inventory.json": json.dumps(payload, ensure_ascii=False, indent=2) + "\n"}
    table = ["# Статусы компонентов", "", "Сгенерировано из действующей приёмки; наличие кода и готовность разделены.", "",
             "UNVERIFIED означает, что спецификация ещё не принята целиком. Сохранённые фрагменты перечислены в документах групп.", "",
             "| COMPONENT | FIGMA LINK | SPECIFICATION LINK | IMPLEMENTATION STATUS | VERIFICATION STATUS |",
             "| --- | --- | --- | --- | --- |"]
    for r in rows:
        links = "<br>".join(f"[Спецификация]({s['resolvedURL'] or s['originalURL']})" for s in r["specifications"]) or "UNVERIFIED: ссылка не импортирована"
        checks = sum(c["status"] in {"passed", "not-applicable"} for c in r["checks"].values())
        table.append(f"| {md(r['name'])} | [Figma]({r['figmaURL']}) | {links} · {r['specificationStatus']} | {r['implementationStatus']} | {r['verificationStatus']} · {checks}/7{' · STALE' if r['staleInputs'] else ''} |")
    outputs["docs/component-status.md"] = "\n".join(table) + "\n"
    exclusions = ["# Системные наборы вне объёма переноса", "",
                  "Решение пользователя: [область поставки от 9 октября](../Documentation/system-components-scope-2026-10-09.md).",
                  "Исходные ID и варианты сохранены; эти наборы не считаются complete и не требуют переноса. Для экранов используйте нативные API iOS 26.", "",
                  "| COMPONENT | FIGMA LINK | STATUS |", "| --- | --- | --- |"]
    exclusions += [f"| {md(r['name'])} | [Figma]({r['figmaURL']}) | excluded |" for r in excluded_rows]
    outputs["docs/excluded-system-components.md"] = "\n".join(exclusions) + "\n"
    for category in GROUPS:
        slug = category.lower().replace(" ", "-")
        path = f"docs/specifications/{slug}.md"
        text = [f"# {category}", "", "Это индекс сохранённых источников и текущей приёмки. Он не добавляет новых требований Figma.", "",
                "Публикация через MCP: UNVERIFIED. Полные ID вариантов и определения свойств: [inventory.json](../inventory.json).", ""]
        if category == "Foundations":
            foundations = read(META / "figma-foundations.json")
            text += ["## Токены", "", "Источник: [TUI Foundations](https://www.figma.com/design/gGt4PaQxQhX7ozPVImsgL5/TUI-Foundations?node-id=1-75).",
                     "Ассеты: [TUI Assets](https://www.figma.com/design/R1oI4T6X9CHxl2x55MDypT/TUI-Assets?node-id=67-0).", "",
                     "| Коллекция | Variables в сохранённом импорте | Modes |", "| --- | --- | --- |"]
            text += [f"| {c['name']} | {len(c['variables'])} | {', '.join(m['name'] for m in c['modes'])} |" for c in foundations["collections"]]
            text += ["", "Публичные типы уже существуют: TUIColor, TUITypographyRole, TUISpacing, TUIRadius, TUIControlSize, TUIMotionDuration, TUIMotionCurve.",
                     "Тема Day/Night, платформа iOS 26. Desktop Hover/Focus и Android не считаются исполненными на iOS.",
                     "Первичная проверка импорта и runtime: [аудит Foundations](../../Documentation/References/Foundations/token-audit-2026-10-08.md). Она не заменяет визуальную приёмку и актуализацию источника.",
                     "Прочитана спецификация Typography и особенности iOS: [источники, 31 роль, Dynamic Type и ограничения](../../Documentation/References/Foundations/typography-specification-2026-10-08.md). Правило line box остаётся PARTIAL; отметка полного совпадения не присваивается.",
                     "Потребители Foundation-ролей исправлены и проверены: [45 тестов, Caps и сопоставление снимков](../../Documentation/References/Foundations/typography-consumers-2026-10-08.md). Legacy-стили остаются отдельным вопросом.",
                     "Прочитаны Color, Size, Shadow и Animation: [правила, исходные ссылки и ограничения](../../Documentation/References/Foundations/color-size-shadow-motion-2026-10-08.md). Medium-тень добавлена в публичный API; составные стили и renderer ещё требуют проверки.",
                     "Решение пользователя от 20 октября 2026: системный SF Pro iOS 26; файлы старых шрифтов исключены из пакета. [Решение и повторная приёмка](../../Documentation/typography-decision-2026-10-20.md), [текущая проверка Foundations](../../Documentation/References/Foundations/release-2026-10-20.md). Неподтверждённые составные стили и line box не объявляются принятыми.", ""]
        for r in (r for r in rows if r["group"] == category):
            text += [f"## {r['name'].strip()} · {r['componentSetID']}", "", f"Назначение из описания Figma: {md(r['description']) or 'UNVERIFIED: описание в импорте отсутствует.'}", "",
                     f"Исходный Component Set: [Figma]({r['figmaURL']}). Публикация: UNVERIFIED; набор наблюдается на Components: {r['currentPageObserved']}.", "",
                     f"Спецификация: **{r['specificationStatus']}**."]
            for s in r["specifications"]:
                text.append(f"- [Исходная ссылка]({s['originalURL']})" + (f" → [разрешённая ссылка Figma]({s['resolvedURL']})" if s["resolvedURL"] else " · разрешение ссылки UNVERIFIED"))
            if not r["specifications"]:
                text.append("Ссылка не импортирована; это не доказательство отсутствия спецификации в Figma.")
            text += ["", f"Варианты: {len(r['variants'])} всего; {len(r['applicableIOS26VariantIDs'])} применимых iOS 26; {len(r['historicalIOS18VariantIDs'])} исторических iOS 18.", "",
                     "### Свойства и состояния", "", "| Свойство Figma | Тип | Значение по умолчанию | Варианты / preferred values |", "| --- | --- | --- | --- |"]
            for name, prop in sorted(r["properties"].items()):
                options = prop.get("variantOptions", prop.get("preferredValues", []))
                text.append(f"| {md(name)} | {md(prop['type'])} | {md(json.dumps(prop.get('defaultValue'), ensure_ascii=False))} | {md(json.dumps(options, ensure_ascii=False))} |")
            text += ["", "Свойства состояний из импортированной матрицы: " + (", ".join(r["statePropertyNames"]) or "UNVERIFIED: отдельные свойства состояний не импортированы."), "",
                     "### Правила и ограничения", "",
                     "Правила поведения и использования, ограничения, платформенные исключения и accessibility: прочитать перечисленные ниже первоисточники. Непринятые требования остаются UNVERIFIED; описание API не заменяет спецификацию.", "",
                     "Variables и полная Figma-цепочка вложенных компонентов: **UNVERIFIED**. Instance-swap свойства выше сохранены без подмены графом SwiftUI."]
            if r["variables"]["status"] == "PARTIAL":
                text += ["", f"Определения из свежего MCP для всего набора: [источник]({relative_link(r['variables']['source'], path)}). Это не полная таблица bindings и режимов тем.", "",
                         "| Имя из MCP | Наблюдаемое определение |", "| --- | --- |"]
                text += [f"| {md(name)} | {md(value)} |" for name, value in sorted(r["variables"]["definitions"].items())]
                if not r["variables"]["definitions"]:
                    text += ["", "MCP вернул пустой словарь. Это не доказательство отсутствия Variables; bindings остаются UNVERIFIED."]
            if r["nestedComponents"]["status"] == "PARTIAL":
                text += ["", f"Вложенные instances одного варианта `{r['nestedComponents']['observedVariantID']}`: [источник]({relative_link(r['nestedComponents']['source'], path)}). Их main Component ID и полный граф остаются UNVERIFIED."]
                text += [f"- `{item['instanceNodeID']}` · {md(item['name'])} · скрыт в наблюдаемом варианте: {item['effectiveHidden']}" for item in r["nestedComponents"]["dependencies"]]
            if r["swiftAPI"]:
                source = r["swiftAPI"]["source"]
                text += ["", f"Текущий публичный API: `{r['swiftAPI']['symbol']}`, [реализация]({relative_link(source, path)}).",
                         "Зависимости, наблюдаемые в Swift-коде (не подтверждённый граф Figma): " + ", ".join(r["foundationsDependencies"]["observedSwiftSymbols"]) + "."]
            text += ["", "### Сохранённые материалы и результат проверки", ""]
            for evidence in r["specificationEvidence"]:
                text.append(f"- [{md(evidence)}]({relative_link(evidence, path)})")
            if not r["specificationEvidence"]:
                text.append("Материалы извлечения спецификации ещё не привязаны к паспорту: UNVERIFIED.")
            text += ["", f"Реализация: {r['implementationStatus']}. Приёмка: **{r['verificationStatus']}**.", ""]
            for name, check in r["checks"].items():
                text.append(f"- {name}: **{check['status']}**. {md(check.get('reason', 'Проверка не завершена.'))}")
            if r["openIssues"]:
                text += ["", "Открытые вопросы:"] + ["- " + md(issue) for issue in r["openIssues"]]
            if r["variantIDsNotObservedInCurrentPage"]:
                text += ["", f"{len(r['variantIDsNotObservedInCurrentPage'])} импортированных variant ID не наблюдаются в свежем page metadata. Это не доказательство удаления; требуется get_design_context конкретного набора."]
            text.append("")
        outputs[path] = "\n".join(text) + "\n"
    stale = []
    for name, value in outputs.items():
        path = ROOT / name
        if args.check:
            if not path.exists() or path.read_text() != value:
                stale.append(name)
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(value)
    if stale:
        raise SystemExit("Inventory docs are stale: " + ", ".join(stale))
    print(json.dumps(payload["summary"], ensure_ascii=False))


if __name__ == "__main__":
    main()
