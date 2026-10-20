import json
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from resolve_figma_node import ROOT, resolve


class ComponentScopeResolutionTests(unittest.TestCase):
    def test_excluded_system_set_and_variant_recommend_native_api(self):
        coverage = json.loads((ROOT / "Documentation/component-coverage.json").read_text())
        source = json.loads((ROOT / "Sources/TUIDesignSystem/Resources/Metadata/figma-component-variants.json").read_text())
        excluded = [c for c in coverage["components"] if c["status"] == "excluded"]
        self.assertEqual(len(excluded), 16)
        self.assertEqual(coverage["summary"]["componentSets"], 112)
        self.assertEqual(coverage["summary"]["importedComponentSets"], 128)
        for component in excluded:
            self.assertTrue(component["name"].startswith("system-"))
            self.assertIsNone(component["swiftAPI"])
        node_id = next(v["id"] for v in source["variants"] if v["setId"] == "9940:39560")
        for node in ["9940:39560", node_id]:
            resolved = resolve("https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=" + node.replace(":", "-"))
            self.assertEqual(resolved["status"], "excluded")
            self.assertIsNone(resolved["swiftAPI"])
            self.assertIsNone(resolved["variantMapping"])
            self.assertIsNone(resolved["availableMappings"])
            self.assertIn("нативные API iOS 26", resolved["guidance"])

    def test_custom_tui_sets_keep_their_implementation_scope(self):
        coverage = json.loads((ROOT / "Documentation/component-coverage.json").read_text())
        components = {c["id"]: c for c in coverage["components"]}
        for node in ["44431:321226", "25752:487144", "23068:2266", "41569:291397", "65702:51131"]:
            self.assertNotEqual(components[node]["status"], "excluded")


if __name__ == "__main__":
    unittest.main()
