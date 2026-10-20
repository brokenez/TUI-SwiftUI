import base64
import hashlib
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from coverage_model import CHECKS, evaluate, ios_scope


class CoverageGateTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.root = Path(self.directory.name)
        self.addCleanup(self.directory.cleanup)
        self.source = "Sources/Component.swift"
        self.write(self.source, b"import SwiftUI\n")
        self.inputs = [self.source,
                       "Sources/TUIDesignSystem/Resources/Metadata/figma-component-variants.json",
                       "Sources/TUIDesignSystem/Resources/Metadata/figma-foundations.json"]
        for name in self.inputs[1:]:
            self.write(name, b"{}\n")
        self.write("audit.md", b"Fixture for testing acceptance validation.\n")
        png = base64.b64decode("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aWQAAAABJRU5ErkJggg==")
        self.write("figma.png", png)
        self.write("runtime.png", png)
        self.variants = [{"id": "1:2", "variantProperties": {"system": "iOS 26"}}]
        self.record = {
            "id": "1:1", "swiftAPI": {"source": self.source, "symbol": "Component"},
            "variantMappings": {"1:2": {"symbol": "Component", "parameters": {}}},
            "inputHashes": {name: self.digest(name) for name in self.inputs},
            "openIssues": [],
            "checks": {name: {"status": "passed", "reviewedAt": "2026-10-05",
                              "reason": "Acceptance gate test fixture.",
                              "evidence": [self.evidence("audit.md")]} for name in CHECKS},
        }
        self.record["checks"]["visual"].update({
            "variantIDs": ["1:2"],
            "evidence": [self.evidence("figma.png", variantID="1:2", kind="figma-reference"),
                         self.evidence("runtime.png", variantID="1:2", kind="runtime-render")],
        })

    def write(self, path, data):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)

    def digest(self, path):
        return hashlib.sha256((self.root / path).read_bytes()).hexdigest()

    def evidence(self, path, **attributes):
        return {"path": path, "sha256": self.digest(path), **attributes}

    def evaluate(self, record=None):
        return evaluate(self.root, record or self.record, self.variants)[0]

    def test_all_verified_inputs_produce_complete(self):
        self.assertEqual(self.evaluate(), "complete")

    def test_excluded_set_cannot_become_complete_even_with_passed_checks(self):
        self.record["scopeExclusion"] = {
            "classification": "apple-system-component", "reviewedAt": "2026-10-09",
            "reason": "Explicit scope decision for this test fixture.",
            "evidence": [self.evidence("audit.md")],
        }
        self.assertEqual(self.evaluate(), "excluded")

    def test_exclusion_without_decision_evidence_is_rejected(self):
        self.record["scopeExclusion"] = {"classification": "apple-system-component"}
        with self.assertRaisesRegex(ValueError, "Scope exclusion needs"):
            self.evaluate()

    def test_changed_exclusion_decision_is_rejected(self):
        self.record["scopeExclusion"] = {
            "classification": "apple-system-component", "reviewedAt": "2026-10-09",
            "reason": "Explicit scope decision for this test fixture.",
            "evidence": [self.evidence("audit.md")],
        }
        self.write("audit.md", b"Changed scope decision\n")
        with self.assertRaisesRegex(ValueError, "Exclusion evidence changed"):
            self.evaluate()

    def test_legacy_complete_alone_cannot_grant_readiness(self):
        self.record["previousStatus"] = "complete"
        self.record["checks"]["motion"]["status"] = "pending"
        self.assertEqual(self.evaluate(), "in-progress")

    def test_open_issue_prevents_complete(self):
        self.record["openIssues"] = ["Known dark appearance mismatch"]
        self.assertEqual(self.evaluate(), "in-progress")

    def test_changed_source_invalidates_approval(self):
        self.write(self.source, b"import SwiftUI\n// changed component\n")
        self.assertEqual(self.evaluate(), "in-progress")

    def test_missing_input_snapshot_prevents_complete(self):
        self.record["inputHashes"] = {}
        self.assertEqual(self.evaluate(), "in-progress")

    def test_missing_variant_mapping_is_rejected(self):
        self.record["variantMappings"] = {}
        with self.assertRaisesRegex(ValueError, "mapping is incomplete"):
            self.evaluate()

    def test_missing_visual_variant_is_rejected(self):
        self.record["checks"]["visual"]["variantIDs"] = []
        with self.assertRaisesRegex(ValueError, "Visual comparison is incomplete"):
            self.evaluate()

    def test_text_notes_cannot_replace_runtime_images(self):
        self.record["checks"]["visual"]["evidence"] = [self.evidence("audit.md")]
        with self.assertRaisesRegex(ValueError, "image pair"):
            self.evaluate()

    def test_changed_evidence_is_rejected(self):
        self.write("audit.md", b"Different claim\n")
        with self.assertRaisesRegex(ValueError, "Evidence changed"):
            self.evaluate()

    def test_required_check_cannot_be_waived(self):
        self.record["checks"]["visual"]["status"] = "not-applicable"
        with self.assertRaisesRegex(ValueError, "cannot be waived"):
            self.evaluate()

    def test_waiver_needs_evidence_and_rationale(self):
        self.record["checks"]["motion"].update(status="not-applicable", evidence=[])
        with self.assertRaisesRegex(ValueError, "dated rationale and evidence"):
            self.evaluate()

    def test_evidence_cannot_escape_the_project(self):
        self.record["checks"]["motion"]["evidence"] = [{"path": "../external.md", "sha256": "0" * 64}]
        with self.assertRaisesRegex(ValueError, "external evidence"):
            self.evaluate()

    def test_scope_keeps_history_without_claiming_ios18_execution(self):
        variants = self.variants + [{"id": "1:3", "variantProperties": {"system": "iOS 18"}},
                                    {"id": "1:4", "variantProperties": {"system": "Android"}}]
        imported, applicable, historical = ios_scope(variants, {"historicalPlatforms": ["iOS 18"]})
        self.assertEqual([v["id"] for v in imported], ["1:2", "1:3"])
        self.assertEqual([v["id"] for v in applicable], ["1:2"])
        self.assertEqual([v["id"] for v in historical], ["1:3"])


if __name__ == "__main__":
    unittest.main()
