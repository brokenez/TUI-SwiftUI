import json
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from resolve_figma_node import ROOT, resolve, resolve_component_key


class ComponentKeyResolutionTests(unittest.TestCase):
    def test_source_binding_exception_is_exposed_for_the_affected_header_variant(self):
        url = "https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=18083-44906"
        resolved = resolve(url)
        self.assertEqual(resolved["variantMapping"]["parameters"], {"variant": "descriptionLeadingExtended"})
        self.assertEqual(resolved["sourceBindingExceptions"][0]["variantId"], "18083:44906")
        self.assertIn("descrption#42565:86", resolved["sourceBindingExceptions"][0]["properties"])

    def test_unaffected_header_variant_does_not_inherit_the_binding_exception(self):
        url = "https://www.figma.com/design/OBPLqL8JDThLuOP8M4JzBL/TUI-Mobile?node-id=42565-305013"
        self.assertEqual(resolve(url)["sourceBindingExceptions"], [])

    def test_known_cross_file_keys_resolve_to_verified_mobile_variants(self):
        registry = json.loads((ROOT / "Sources/TUIDesignSystem/Resources/Metadata/figma-component-keys.json").read_text())
        self.assertGreaterEqual(len(registry["components"]), 6)
        for item in registry["components"]:
            with self.subTest(key=item["key"]):
                resolved = resolve_component_key(item["key"])
                self.assertEqual(resolved["nodeId"], item["id"])
                self.assertEqual(resolved["componentSetId"], item["setId"])
                self.assertEqual(resolved["variantProperties"], item["variantProperties"])
                self.assertIn(resolved["status"], {"catalogued", "in-progress", "complete", "blocked"})

    def test_unknown_key_is_reported_instead_of_name_based_guess(self):
        resolved = resolve_component_key("0" * 40)
        self.assertEqual(resolved["resolution"], "unindexed-component-key")
        self.assertNotIn("swiftAPI", resolved)

    def test_malformed_key_is_rejected(self):
        for invalid in ["", "not-a-key", "A" * 40, "g" * 40, "a" * 39]:
            with self.subTest(key=invalid):
                with self.assertRaises(ValueError):
                    resolve_component_key(invalid)


if __name__ == "__main__":
    unittest.main()
