# Makefile for project automation
# Usage: make <target>

.PHONY: onBoarding lint lintReport build test snapshotTest clean help

# Default target
.DEFAULT_GOAL := help
# Env
VENV := .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

# Onboarding - runs first setup
onBoarding:
	@echo "Running onboarding process..."
	@chmod +x onboarding.sh
	@./onboarding.sh

# Linting
lint:
	@echo "Running SwiftLint..."
	@swiftlint --fix --config .swiftlint.yml
	@echo "👨🏻‍🔧 SwiftLint completed with auto-fix. ✅"

# Lint report generation
lintReport:
	@echo "Generating SwiftLint report..."
	@mkdir -p reports
	@swiftlint --config .swiftlint.yml --reporter html > swiftlint_report.html
	@echo "📨 SwiftLint report generated in Root. ✅"

# Build the main app
build:
	@echo "Building project..."
	@xcodebuild build \
		-project WallaMarvel.xcodeproj \
		-scheme WallaMarvel \
		-configuration Debug \
		-destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5'
	@echo "🏗️ Build completed. ✅"

# Run unit tests
test:
	@echo "Running unit tests..."
	@xcodebuild test \
		-project WallaMarvel.xcodeproj \
		-scheme MarvelCoreTests \
		-configuration Debug \
		-destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5'
	@echo "🧪 Unit tests completed. ✅"

# Run snapshot tests
snapshotTest:
	@echo "Running snapshot tests..."
	@xcodebuild test \
		-project WallaMarvel.xcodeproj \
		-scheme MarvelSnapshotTests \
		-configuration Debug \
		-destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5'
	@echo "🧪 Snapshot tests completed. ✅"
# Resolve Swift Package dependencies
resolve:
	@echo "Resolving Swift Package Manager dependencies..."
	@xcodebuild -resolvePackageDependencies \
		-project WallaMarvel.xcodeproj \
		-scheme WallaMarvel
	@echo "📦 Package resolution completed.✅"
# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf dist/
	@rm -rf build/
	@rm -rf reports/
	@rm -rf node_modules/.cache/
	@echo "Clean completed."
# Inject Dependencies
generatePackage: $(PYTHON)
	@echo "📥 Injecting dependencies from Dependencies.yaml into Package.swift..."
	@python3 ./scripts/generate_package.py ./Package.yaml
	@swiftlint --fix --config .swiftlint.yml
	@echo "✅ Dependency injection completed."
# Help target
help:
	@echo "Available targets:"
	@echo "  onBoarding         - Run onboarding setup (should be run first)"
	@echo "  lint               - Run SwiftLint with autofix"
	@echo "  lintReport         - Generate SwiftLint HTML report"
	@echo "  build              - Build the WallaMarvel app"
	@echo "  test               - Run MarvelCoreTests"
	@echo "  snapshotTest       - Run MarvelSnapshotTests"
	@echo "  clean              - Clean build and cache artifacts"
	@echo "  resolve            - Reset and resolve Swift packages in MarvelCore"
	@echo "  generatePackage    - Inject Package.yaml into Package.swift"
	@echo "  help               - Show this help message"
