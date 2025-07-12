#!/usr/bin/env python3
import yaml
import sys
from pathlib import Path
import os
import re

def to_camel_case(name):
    parts = re.split(r'[-_\s]', name)
    return parts[0].lower() + ''.join(part if part.isupper() else part.capitalize() for part in parts[1:])

def generate_package_swift(yaml_path):
    try:
        # Load the YAML file
        with open(yaml_path, 'r') as file:
            data = yaml.safe_load(file)
        
        # Get package settings from YAML
        package_settings = data.get('package', {})
        swift_version = package_settings.get('swift_version', '6.0')
        platforms = package_settings.get('platforms', {})
        ios_version = platforms.get('ios', '17.0')
        macos_version = platforms.get('macos', '12.0')
        
        # Calculate paths
        yaml_dir = Path(yaml_path).parent
        package_dir = yaml_dir / "MarvelCore"
        
        # Initialize Package.swift content with settings from YAML
        package_content = f"""// swift-tools-version: {swift_version}
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let packageDependencies: [Package.Dependency] = [\n"""
        
        # Add dependencies
        for dep in data['dependencies']:
            if 'url' in dep:
                package_content += f"    .package(\n        url: \"{dep['url']}\",\n        from: \"{dep['from']}\"\n    ),\n"
            elif 'path' in dep:
                dep_path = Path(dep['path'])
                if dep_path.is_absolute():
                    rel_path = os.path.relpath(dep_path, package_dir)
                else:
                    rel_path = os.path.relpath(yaml_dir / dep_path, package_dir)
                package_content += f"    .package(path: \"{rel_path}\"),\n"
        
        package_content += "]\n\nprivate let products: [Product] = [\n"
        
        # Add products
        for product in data['products']:
            package_content += f"    .library(\n        name: \"{product['name']}\",\n        targets: [\"{'\", \"'.join(product['targets'])}\"]\n    ),\n"
        
        package_content += "]\n\n"
        
        # Add target dependencies as private variables
        target_deps = set()
        
        # First handle products with custom var_names
        for product in data['products']:
            if 'var_name' in product:
                var_name = product['var_name']
                target_deps.add(f"private let {var_name}: Target.Dependency = \"{product['name']}\"")
        
        # Then handle dependencies with custom var_names
        for dep in data['dependencies']:
            if 'var_name' in dep:
                var_name = dep['var_name']
                pkg_name = dep.get('package_name', dep['name'])
                if 'path' in dep:  # Local package
                    target_deps.add(f"private let {var_name}: Target.Dependency = .product(\n    name: \"{dep['name']}\",\n    package: \"{pkg_name}\"\n)")
                else:  # Remote package
                    target_deps.add(f"private let {var_name}: Target.Dependency = .product(\n    name: \"{dep['name']}\",\n    package: \"{pkg_name}\"\n)")
        
        # Then handle remaining dependencies that don't have custom var_names
        for target in data['targets']:
            for dep in target.get('dependencies', []):
                # Skip if already handled by custom var_name
                custom_var_exists = any(
                    ('var_name' in product and product['name'] == dep) or
                    ('var_name' in dependency and dependency['name'].lower() in dep.lower())
                    for product in data['products']
                    for dependency in data['dependencies']
                )
                if custom_var_exists:
                    continue
                
                var_name = to_camel_case(dep)
                if any(p['name'] == dep for p in data['products']):
                    target_deps.add(f"private let {var_name}: Target.Dependency = \"{dep}\"")
                else:
                    # Find the original package info
                    dep_info = next((d for d in data['dependencies'] if d['name'].lower() in dep.lower()), None)
                    if dep_info:
                        pkg_name = dep_info.get('package_name', dep_info['name'])
                        target_deps.add(f"private let {var_name}: Target.Dependency = .product(\n    name: \"{dep}\",\n    package: \"{pkg_name}\"\n)")
                    else:
                        target_deps.add(f"private let {var_name}: Target.Dependency = .product(\n    name: \"{dep}\",\n    package: \"{dep.lower()}\"\n)")
        
        package_content += "\n".join(sorted(target_deps)) + "\n\n"
        
        # Add package declaration with platforms from YAML
        package_content += f"""let package = Package(
    name: "MarvelCore",
    platforms: [
        .iOS(.v{ios_version}),
        .macOS(.v{macos_version})
    ],
    products: products,
    dependencies: packageDependencies,
    targets: [\n"""
        
        # Add targets
        for target in data['targets']:
            target_type = target.get('type', 'target')
            
            # Start target definition
            if target_type == 'testTarget':
                package_content += "        .testTarget(\n"
            else:
                package_content += "        .target(\n"
            
            package_content += f"            name: \"{target['name']}\",\n"
            
            # Add dependencies if they exist
            if 'dependencies' in target:
                package_content += "            dependencies: [\n"
                for dep in target['dependencies']:
                    # Find the custom var_name if it exists
                    custom_var = None
                    # Check in products
                    for product in data['products']:
                        if product['name'] == dep and 'var_name' in product:
                            custom_var = product['var_name']
                            break
                    # Check in dependencies
                    if not custom_var:
                        for dependency in data['dependencies']:
                            if dependency['name'].lower() in dep.lower() and 'var_name' in dependency:
                                custom_var = dependency['var_name']
                                break
                    # Use custom var if found, otherwise use camelCase
                    var_name = custom_var if custom_var else to_camel_case(dep)
                    package_content += f"                {var_name},\n"
                package_content += "            ],\n"
            
            # Add resources if they exist - using direct paths without ../
            if 'resources' in target:
                package_content += "            resources: [\n"
                for resource in target['resources']:
                    # Remove any leading ../ or ./ from resource paths
                    clean_path = re.sub(r'^(\.\./|\./)', '', resource)
                    package_content += f"                .copy(\"{clean_path}\"),\n"
                package_content += "            ],\n"
            
            # Add swiftSettings for non-test targets
            if target_type != 'testTarget':
                package_content += """            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],\n"""
            
            package_content += "        ),\n"
        
        package_content += """    ],
    swiftLanguageModes: [.v6]
)"""
        
        # Create MarvelCore directory if it doesn't exist
        package_dir.mkdir(parents=True, exist_ok=True)
        
        # Write to Package.swift
        with open(package_dir / 'Package.swift', 'w') as file:
            file.write(package_content)
        
        print(f"✅ Package.swift successfully generated with Swift {swift_version}, iOS {ios_version.replace('_', '.')}, and macOS {macos_version.replace('_', '.')}")
        return 0
    except Exception as e:
        print(f"❌ Error generating Package.swift: {str(e)}")
        return 1

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python generate_package.py Dependencies.yaml")
        sys.exit(1)
    
    sys.exit(generate_package_swift(sys.argv[1]))
