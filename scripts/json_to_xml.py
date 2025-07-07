import json
import os
import xml.etree.ElementTree as ET

def dict_to_etree(d, root_name="root"):
    root = ET.Element(root_name)
    def build_tree(elem, data):
        if isinstance(data, dict):
            for k, v in data.items():
                child = ET.SubElement(elem, str(k))
                build_tree(child, v)
        elif isinstance(data, list):
            for item in data:
                item_elem = ET.SubElement(elem, "item")
                build_tree(item_elem, item)
        else:
            elem.text = str(data)
    build_tree(root, d)
    return root

def convert(json_path, xml_path):
    try:
        with open(json_path, "r") as f:
            data = json.load(f)
        root = dict_to_etree(data)
        tree = ET.ElementTree(root)
        tree.write(xml_path, encoding="utf-8", xml_declaration=True)
        print(f"✅ Converted {json_path} → {xml_path}")
    except Exception as e:
        print(f"❌ Failed to convert {json_path}: {e}")

files_to_convert = [
    ("coverage_output/core_coverage.json", "coverage_output/core_coverage.xml"),
    ("coverage_output/snapshot_coverage.json", "coverage_output/snapshot_coverage.xml")
]

for json_file, xml_file in files_to_convert:
    if os.path.exists(json_file):
        convert(json_file, xml_file)
    else:
        print(f"⚠️ Skipping {json_file}, file not found.")
