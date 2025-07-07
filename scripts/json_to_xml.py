import json
import xml.etree.ElementTree as ET
import os

def convert_to_sonar_coverage_xml(json_path, xml_path):
    try:
        with open(json_path, "r") as f:
            data = json.load(f)

        root = ET.Element("coverage", version="1")

        targets = data.get("targets", [])
        if not targets:
            print(f"⚠️ No targets found in {json_path}")
            return

        for file in targets[0].get("files", []):
            file_path = file["path"]
            file_element = ET.SubElement(root, "file", path=file_path)

            for function in file.get("functions", []):
                line_number = function.get("lineNumber")
                execution_count = function.get("executionCount", 0)

                if line_number is not None:
                    ET.SubElement(
                        file_element,
                        "lineToCover",
                        lineNumber=str(line_number),
                        covered=str(execution_count > 0).lower()
                    )

        tree = ET.ElementTree(root)
        tree.write(xml_path, encoding="utf-8", xml_declaration=True)
        print(f"✅ XML generated: {xml_path}")

    except Exception as e:
        print(f"❌ Error converting {json_path}: {e}")

# Convert both core and snapshot coverage files
files_to_convert = [
    ("coverage_output/core_coverage.json", "coverage_output/core_coverage.xml"),
    ("coverage_output/snapshot_coverage.json", "coverage_output/snapshot_coverage.xml"),
]

for json_file, xml_file in files_to_convert:
    if os.path.exists(json_file):
        convert_to_sonar_coverage_xml(json_file, xml_file)
    else:
        print(f"⚠️ File not found: {json_file}")
