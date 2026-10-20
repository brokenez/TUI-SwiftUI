"""Evidence-based component readiness, shared by generation and validation."""

import hashlib
from pathlib import Path


CHECKS = (
    "variantMapping", "specification", "visual", "interaction",
    "accessibility", "motion", "integration",
)
CHECK_STATES = {"pending", "passed", "not-applicable", "failed", "blocked"}


def platform_label(variant):
    for key, value in (variant.get("variantProperties") or {}).items():
        if key.lower().replace("е", "e") in ("system", "platform"):
            return value
    return None


def is_ios(variant):
    label = platform_label(variant)
    return label is None or label.lower().startswith("ios") or label == "–"


def ios_scope(variants, policy):
    historical_labels = {value.lower() for value in policy["historicalPlatforms"]}
    imported = [variant for variant in variants if is_ios(variant)]
    historical = [variant for variant in imported
                  if (platform_label(variant) or "").lower() in historical_labels]
    excluded_ids = {variant["id"] for variant in historical}
    applicable = [variant for variant in imported if variant["id"] not in excluded_ids]
    return imported, applicable, historical


def local_file(root, relative):
    """Evidence must stay in the project and cannot be a transient remote URL."""
    if not isinstance(relative, str) or Path(relative).is_absolute():
        raise ValueError("Expected a project-relative evidence path")
    candidate = (root / relative).resolve()
    if not candidate.is_relative_to(root.resolve()) or not candidate.is_file():
        raise ValueError(f"Missing or external evidence: {relative}")
    return candidate


def evaluate(root, record, applicable_variants):
    exclusion = record.get("scopeExclusion")
    if exclusion:
        if (exclusion.get("classification") != "apple-system-component"
                or not exclusion.get("reviewedAt") or not exclusion.get("reason")
                or not exclusion.get("evidence")):
            raise ValueError(f"Scope exclusion needs dated user decision and evidence: {record['id']}")
        for entry in exclusion["evidence"]:
            path = local_file(root, entry["path"])
            if hashlib.sha256(path.read_bytes()).hexdigest() != entry.get("sha256"):
                raise ValueError(f"Exclusion evidence changed: {entry['path']}")
    api = record.get("swiftAPI")
    if api:
        local_file(root, api["source"])
        if not api.get("symbol"):
            raise ValueError(f"Missing Swift symbol: {record['id']}")
    checks = record["checks"]
    if set(checks) != set(CHECKS):
        raise ValueError(f"Incomplete check categories: {record['id']}")
    expected_ids = {variant["id"] for variant in applicable_variants}
    mappings = record["variantMappings"]
    if set(mappings) - expected_ids:
        raise ValueError(f"Mappings outside iOS 26 scope: {record['id']}")
    for node_id, mapping in mappings.items():
        if not api or mapping.get("symbol") != api["symbol"] or not isinstance(mapping.get("parameters"), dict):
            raise ValueError(f"Invalid API mapping: {node_id}")

    settled = {}
    for category in CHECKS:
        check = checks[category]
        state = check["status"]
        if state not in CHECK_STATES:
            raise ValueError(f"Unknown check state: {record['id']}/{category}")
        evidence = check.get("evidence", [])
        for entry in evidence:
            path = local_file(root, entry["path"])
            actual = hashlib.sha256(path.read_bytes()).hexdigest()
            if entry.get("sha256") != actual:
                raise ValueError(f"Evidence changed: {entry['path']}")
        if state in {"passed", "not-applicable"}:
            if not check.get("reviewedAt") or not check.get("reason") or not evidence:
                raise ValueError(f"Settled check needs dated rationale and evidence: {record['id']}/{category}")
        if category in {"variantMapping", "visual", "integration"} and state == "not-applicable":
            raise ValueError(f"Required check cannot be waived: {category}")
        if category == "variantMapping" and state == "passed" and set(mappings) != expected_ids:
            raise ValueError(f"Variant mapping is incomplete: {record['id']}")
        if category == "visual" and state == "passed":
            if set(check.get("variantIDs", [])) != expected_ids:
                raise ValueError(f"Visual comparison is incomplete: {record['id']}")
            for variant_id in expected_ids:
                for kind in ("figma-reference", "runtime-render"):
                    matches = [entry for entry in evidence
                               if entry.get("variantID") == variant_id and entry.get("kind") == kind]
                    if not matches or not any(local_file(root, entry["path"]).read_bytes().startswith(b"\x89PNG\r\n\x1a\n")
                                              for entry in matches):
                        raise ValueError(f"Missing visual image pair: {variant_id}/{kind}")
        settled[category] = state in {"passed", "not-applicable"}

    hashes = record["inputHashes"]
    stale = []
    for relative, expected_hash in hashes.items():
        path = local_file(root, relative)
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected_hash:
            stale.append(relative)
    required_inputs = {
        "Sources/TUIDesignSystem/Resources/Metadata/figma-component-variants.json",
        "Sources/TUIDesignSystem/Resources/Metadata/figma-foundations.json",
    }
    if api:
        required_inputs.add(api["source"])
    ready = bool(api) and all(settled.values()) and not record["openIssues"]
    ready = ready and required_inputs <= set(hashes) and not stale
    if exclusion:
        status = "excluded"
    elif not api:
        status = "catalogued"
    elif ready:
        status = "complete"
    elif any(check["status"] == "blocked" for check in checks.values()):
        status = "blocked"
    else:
        status = "in-progress"
    return status, settled, stale
