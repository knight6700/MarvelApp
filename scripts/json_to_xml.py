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
            absolute_path = file.get("path")
            if not absolute_path or not os.path.exists(absolute_path):
                continue  # skip if path is invalid or doesn't exist

            # Convert to relative path for SonarQube compatibility
            relative_path = os.path.relpath(absolute_path, start=os.getcwd())
            file_element = ET.SubElement(root, "file", path=relative_path)

            seen_lines = set()
            for function in file.get("functions", []):
                line_number = function.get("lineNumber")
                execution_count = function.get("executionCount", 0)

                if line_number is not None and line_number not in seen_lines:
                    seen_lines.add(line_number)
                    ET.SubElement(
                        file_element,
                        "lineToCover",
                        lineNumber=str(line_number),
                        covered=str(execution_count > 0).lower()
                    )

        # Save XML
        tree = ET.ElementTree(root)
        ET.indent(tree, space="  ", level=0)  # Pretty-print (Python 3.9+)
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
