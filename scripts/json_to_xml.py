import json
import os
import xml.etree.ElementTree as ET

XSD_NS = "http://www.w3.org/2001/XMLSchema"

def guess_type(value):
    if isinstance(value, bool):
        return "xs:boolean"
    elif isinstance(value, int):
        return "xs:integer"
    elif isinstance(value, float):
        return "xs:float"
    elif isinstance(value, list):
        return "xs:sequence"
    else:
        return "xs:string"

def build_element(name, value, parent):
    if isinstance(value, dict):
        element = ET.SubElement(parent, "xs:element", name=name)
        complex_type = ET.SubElement(element, "xs:complexType")
        sequence = ET.SubElement(complex_type, "xs:sequence")
        for k, v in value.items():
            build_element(k, v, sequence)
    elif isinstance(value, list):
        element = ET.SubElement(parent, "xs:element", name=name, minOccurs="0", maxOccurs="unbounded")
        complex_type = ET.SubElement(element, "xs:complexType")
        sequence = ET.SubElement(complex_type, "xs:sequence")
        if value:
            build_element("item", value[0], sequence)
    else:
        ET.SubElement(parent, "xs:element", name=name, type=guess_type(value))

def convert_to_xsd(json_path, xsd_path, root_name="root"):
    try:
        with open(json_path, "r") as f:
            data = json.load(f)

        schema = ET.Element("xs:schema", attrib={"xmlns:xs": XSD_NS})
        build_element(root_name, data, schema)

        tree = ET.ElementTree(schema)
        tree.write(xsd_path, encoding="utf-8", xml_declaration=True)
        print(f"✅ XSD generated: {xsd_path}")
    except Exception as e:
        print(f"❌ Failed to generate XSD from {json_path}: {e}")

# Define the files
files_to_convert = [
    ("coverage_output/core_coverage.json", "coverage_output/core_coverage.xsd"),
    ("coverage_output/snapshot_coverage.json", "coverage_output/snapshot_coverage.xsd")
]

for json_file, xsd_file in files_to_convert:
    if os.path.exists(json_file):
        convert_to_xsd(json_file, xsd_file, root_name="coverage")
    else:
        print(f"⚠️ Skipping {json_file}, file not found.")
