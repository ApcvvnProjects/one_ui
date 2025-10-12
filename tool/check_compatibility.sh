#!/bin/bash

# Compatibility Check Script for One UI Flutter Package
# This script checks for deprecated APIs, breaking changes, and compatibility issues

set -e

echo "🔍 Starting compatibility checks for One UI Flutter package..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check if flutter is available
if ! command -v flutter &> /dev/null; then
    print_error "Flutter SDK not found. Please install Flutter first."
    exit 1
fi

# Get current Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
print_status "Using Flutter version: $FLUTTER_VERSION"

# Run flutter analyze with detailed output
print_status "Running flutter analyze..."
ANALYZE_OUTPUT=$(flutter analyze --fatal-infos 2>&1)
ANALYZE_EXIT_CODE=$?

if [ $ANALYZE_EXIT_CODE -eq 0 ]; then
    print_success "No critical analysis issues found"
else
    print_warning "Analysis issues detected:"
    echo "$ANALYZE_OUTPUT"
fi

# Check for deprecated APIs
print_status "Checking for deprecated APIs..."
DEPRECATED_PATTERNS=(
    "@deprecated"
    "is deprecated"
    "deprecated since"
)

DEPRECATED_FOUND=false
for pattern in "${DEPRECATED_PATTERNS[@]}"; do
    if grep -r "$pattern" lib/ --include="*.dart" > /dev/null 2>&1; then
        print_warning "Found deprecated pattern: $pattern"
        DEPRECATED_FOUND=true
    fi
done

if [ "$DEPRECATED_FOUND" = false ]; then
    print_success "No deprecated API usage found in source code"
fi

# Check for breaking changes in pubspec
print_status "Checking pubspec.yaml for compatibility..."
if [ -f "pubspec.yaml" ]; then
    # Check Flutter SDK constraint
    FLUTTER_CONSTRAINT=$(grep -E "^\s*flutter:" pubspec.yaml | head -n 1)
    if [[ $FLUTTER_CONSTRAINT == *"any"* ]]; then
        print_warning "Flutter constraint uses 'any' - consider specifying a minimum version"
    fi

    # Check for overly restrictive constraints
    if grep -q ">=" pubspec.yaml; then
        print_status "Found version constraints with '>=' - ensure they allow for backward compatibility"
    fi
else
    print_error "pubspec.yaml not found"
fi

# Check for outdated dependencies
print_status "Checking for outdated dependencies..."
if flutter pub outdated --json > /dev/null 2>&1; then
    OUTDATED_COUNT=$(flutter pub outdated --json | jq '.packages | length' 2>/dev/null || echo "0")
    if [ "$OUTDATED_COUNT" -gt 0 ]; then
        print_warning "Found $OUTDATED_COUNT outdated dependencies"
        flutter pub outdated
    else
        print_success "All dependencies are up to date"
    fi
else
    print_warning "Could not check for outdated dependencies"
fi

# Check for platform-specific issues
print_status "Checking platform compatibility..."
if [ -d "ios" ] || [ -d "android" ]; then
    print_status "Native platform directories found - ensure native code is compatible"
fi

# Check for breaking API changes by running tests
print_status "Running tests to detect breaking changes..."
if flutter test > /dev/null 2>&1; then
    print_success "All tests passed"
else
    print_error "Tests failed - check for breaking changes"
    flutter test 2>&1 | head -20
fi

# Clean up
rm -f test_output.json

# Check for Flutter version compatibility
print_status "Checking Flutter version compatibility..."
MIN_FLUTTER_VERSION=$(grep -E "flutter:\s*\">=" pubspec.yaml | sed 's/.*">=\([0-9.]*\)".*/\1/' || echo "")

if [ -n "$MIN_FLUTTER_VERSION" ]; then
    # Simple version comparison (basic check)
    if [[ "$FLUTTER_VERSION" =~ ^[0-9]+\.[0-9]+ ]]; then
        print_status "Minimum Flutter version required: $MIN_FLUTTER_VERSION"
        print_status "Current Flutter version: $FLUTTER_VERSION"
    fi
fi

# Final summary
echo
print_status "Compatibility check completed!"
echo "📋 Summary:"
echo "   - Flutter version: $FLUTTER_VERSION"
echo "   - Analysis: $([ $ANALYZE_EXIT_CODE -eq 0 ] && echo "✅ Passed" || echo "⚠️  Issues found")"
echo "   - Deprecated APIs: $([ "$DEPRECATED_FOUND" = false ] && echo "✅ None found" || echo "⚠️  Found some")"
echo "   - Dependencies: Check output above"
echo "   - Tests: Check output above"

echo
print_status "For detailed Flutter release information, visit: https://flutter.dev/docs/development/tools/sdk/releases"
print_status "To check breaking changes between versions, visit: https://flutter.dev/docs/release/breaking-changes"