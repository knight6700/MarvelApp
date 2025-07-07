import json
import os
import xml.etree.ElementTree as ET

def build_xml_element(name, value):
    if isinstance(value, dict):
        element = ET.Element(name)
        for k, v in value.items():
            child = build_xml_element(k, v)
            element.append(child)
        return element
    elif isinstance(value, list):
        parent = ET.Element(name)
        for item in value:
            child = build_xml_element("item", item)
            parent.append(child)
        return parent
    else:
        element = ET.Element(name)
        element.text = str(value)
        return element

def convert_to_xml(json_path, xml_path, root_name="root"):
    try:
        with open(json_path, "r") as f:
            data = json.load(f)

        root = build_xml_element(root_name, data)
        tree = ET.ElementTree(root)
        tree.write(xml_path, encoding="utf-8", xml_declaration=True)
        print(f"✅ XML generated: {xml_path}")
    except Exception as e:
        print(f"❌ Failed to generate XML from {json_path}: {e}")

# Define the files
files_to_convert = [
    ("coverage_output/core_coverage.json", "coverage_output/core_coverage.xml"),
    ("coverage_output/snapshot_coverage.json", "coverage_output/snapshot_coverage.xml")
]

for json_file, xml_file in files_to_convert:
    if os.path.exists(json_file):
        convert_to_xml(json_file, xml_file, root_name="coverage")
    else:
        print(f"⚠️ Skipping {json_file}, file not found.")
