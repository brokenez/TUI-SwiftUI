#!/usr/bin/env python3
"""Resolve a TUI Mobile component or variant URL to the local SwiftUI API."""

import json
import sys
from pathlib import Path
from urllib.parse import parse_qs, urlparse
from coverage_model import evaluate, ios_scope


ROOT = Path(__file__).resolve().parents[1]
COMPONENT_FILE_KEY = "OBPLqL8JDThLuOP8M4JzBL"


def resolve(url: str) -> dict:
    parsed = urlparse(url)
    parts = parsed.path.strip("/").split("/")
    if parsed.hostname not in {"figma.com", "www.figma.com"} or len(parts) < 3 or parts[0] != "design":
        raise ValueError("Ожидается ссылка figma.com/design на TUI Mobile")
    if parts[1] != COMPONENT_FILE_KEY:
        raise ValueError("Ссылка ведёт в другой Figma-файл; этот реестр описывает TUI Mobile")
    node_ids = parse_qs(parsed.query).get("node-id", [])
    if len(node_ids) != 1:
        raise ValueError("В ссылке нужен один параметр node-id")
    node_id = node_ids[0].replace("-", ":")
    if len(node_id.split(":")) != 2 or not all(part.isdigit() for part in node_id.split(":")):
        raise ValueError("Некорректный node-id")

    coverage = json.loads((ROOT / "Documentation/component-coverage.json").read_text())
    acceptance = json.loads((ROOT / "Documentation/component-verification.json").read_text())
    records = {item["id"]: item for item in acceptance["components"]}
    components = {item["id"]: item for item in coverage["components"]}
    variants = json.loads((ROOT / "Sources/TUIDesignSystem/Resources/Metadata/figma-component-variants.json").read_text())["variants"]
    variant = next((item for item in variants if item["id"] == node_id), None)
    component = components.get(variant["setId"] if variant else node_id)
    if component is None:
        return {
            "nodeId": node_id,
            "resolution": "frame-or-unindexed-node",
            "guidance": "Получите get_design_context этого узла и найдите вложенные component set ID; затем разрешите их по отдельности.",
        }

    record = records[component["id"]]
    _, applicable, historical = ios_scope(
        [item for item in variants if item["setId"] == component["id"]], coverage["platformPolicy"]
    )
    status, settled, stale = evaluate(ROOT, record, applicable)
    scope = None
    if variant:
        scope = ("historical" if node_id in {item["id"] for item in historical} else
                 "iOS26" if node_id in {item["id"] for item in applicable} else "other-platform")
    if status == "excluded":
        guidance = "Системный набор Apple исключён из переноса по решению пользователя. Используйте нативные API iOS 26 напрямую в приложении; не реализуйте этот набор и не создавайте его дубликат в TUI. Исходные варианты сохранены для справки."
    elif scope == "historical":
        guidance = "Исторический вариант: сохранён для справки. Выберите соответствующий нативный вариант iOS 26; исполнение iOS 18 не поддерживается."
    elif scope == "other-platform":
        guidance = "Этот вариант относится к другой платформе. Выберите применимый вариант iOS 26 из этого набора; не подменяйте параметры автоматически."
    elif not component["swiftAPI"]:
        guidance = "SwiftUI-реализации пока нет; сначала реализуйте набор по полной применимой iOS 26 матрице."
    else:
        guidance = "Проверьте публичный API и спецификацию; для in-progress завершите проверки нужного варианта."

    return {
        "nodeId": node_id,
        "resolution": "variant" if variant else "component-set",
        "componentSetId": component["id"],
        "componentName": component["name"],
        "status": status,
        "platformPolicy": coverage["platformPolicy"],
        "historicalVariant": scope == "historical",
        "variantScope": scope,
        "verification": {**component["verification"], **settled, "staleInputs": stale},
        "swiftAPI": component["swiftAPI"],
        "scopeExclusion": record.get("scopeExclusion"),
        "componentPropertyMappings": record.get("componentPropertyMappings", {}),
        "sourceBindingExceptions": [item for item in record.get("sourceBindingExceptions", [])
                                    if not variant or item["variantId"] == node_id],
        "variantMapping": record["variantMappings"].get(node_id) if variant and status != "excluded" else None,
        "availableMappings": record["variantMappings"] if not variant and status != "excluded" else None,
        "variantProperties": variant["variantProperties"] if variant else None,
        "specificationURLs": component["specificationURLs"],
        "guidance": guidance,
    }


def resolve_component_key(key: str) -> dict:
    """Resolve published Figma identity; file-local node IDs cannot cross files."""
    if len(key) != 40 or any(c not in "0123456789abcdef" for c in key):
        raise ValueError("Ожидается постоянный Figma component key: 40 строчных hex-символов")
    registry = json.loads((ROOT / "Sources/TUIDesignSystem/Resources/Metadata/figma-component-keys.json").read_text())
    matches = [item for item in registry["components"] if item["key"] == key]
    if len(matches) > 1:
        raise ValueError("Неоднозначный постоянный ключ в реестре; исправьте источник")
    if not matches:
        return {"componentKey": key, "resolution": "unindexed-component-key",
                "registryScope": registry["source"]["scope"],
                "guidance": "Прочитайте исходный компонент через Figma и подтвердите его постоянный ключ. Не сопоставляйте по одному названию или локальному ID другого файла."}
    match = matches[0]
    result = resolve(f"https://www.figma.com/design/{COMPONENT_FILE_KEY}/TUI-Mobile?node-id={match['id'].replace(':', '-')}")
    if result.get("componentSetId") != match["setId"] or result.get("variantProperties") != match["variantProperties"]:
        raise ValueError("Ключ не согласован с текущей матрицей; обновите индекс из Figma")
    return {**result, "componentKey": key, "registryScope": registry["source"]["scope"]}


if __name__ == "__main__":
    try:
        if len(sys.argv) == 3 and sys.argv[1] == "--component-key":
            result = resolve_component_key(sys.argv[2])
        elif len(sys.argv) == 2:
            result = resolve(sys.argv[1])
        else:
            raise ValueError("Укажите ссылку TUI Mobile либо --component-key с постоянным ключом Figma")
        print(json.dumps(result, ensure_ascii=False, indent=2))
    except ValueError as error:
        raise SystemExit(str(error))
