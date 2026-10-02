#!/usr/bin/env python3
"""Resolve a TUI Mobile component or variant URL to the local SwiftUI API."""

import json
import sys
from pathlib import Path
from urllib.parse import parse_qs, urlparse


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

    return {
        "nodeId": node_id,
        "resolution": "variant" if variant else "component-set",
        "componentSetId": component["id"],
        "componentName": component["name"],
        "status": component["status"],
        "swiftAPI": component["swiftAPI"],
        "variantProperties": variant["variantProperties"] if variant else None,
        "specificationURLs": component["specificationURLs"],
        "guidance": (
            "Проверьте публичный API и спецификацию; для in-progress выполните визуальную сверку нужного варианта."
            if component["swiftAPI"] else
            "SwiftUI-реализации пока нет; сначала реализуйте набор по полной iOS-матрице."
        ),
    }


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Укажите одну ссылку на узел файла TUI Mobile в Figma")
    try:
        print(json.dumps(resolve(sys.argv[1]), ensure_ascii=False, indent=2))
    except ValueError as error:
        raise SystemExit(str(error)) from error
