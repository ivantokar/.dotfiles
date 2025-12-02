#!/bin/bash

# profile-app.sh
# Launch Instruments for profiling macOS apps

set -e

echo "📊 Instruments Profiling Launcher"
echo "=================================="
echo ""

# Configuration
APP_NAME="${1:-Argute}"
TEMPLATE="${2:-Time Profiler}"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Check if Instruments is available
if ! command -v instruments &> /dev/null; then
    echo "Error: Instruments not found. Install Xcode command line tools."
    exit 1
fi

print_success "Instruments found"

# Show available templates
echo ""
echo "Available profiling templates:"
echo "────────────────────────────────"
instruments -s templates | grep -v "Known Templates:" | while read -r line; do
    echo "  • $line"
done

echo ""
print_info "Selected template: ${TEMPLATE}"
print_info "App: ${APP_NAME}"

# Find the app
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)"
APP_PATH=$(find "${PROJECT_DIR}/.build" -name "${APP_NAME}.app" -type d 2>/dev/null | head -n 1)

if [ -z "$APP_PATH" ]; then
    # Try to build
    print_info "App not found, building..."
    xcodebuild -scheme "${APP_NAME}" -configuration Release build

    APP_PATH=$(find "${PROJECT_DIR}/.build" -name "${APP_NAME}.app" -type d | head -n 1)

    if [ -z "$APP_PATH" ]; then
        echo "Error: Could not find ${APP_NAME}.app"
        exit 1
    fi
fi

print_success "App found: ${APP_PATH}"

# Create output directory
OUTPUT_DIR="${PROJECT_DIR}/profiling"
mkdir -p "${OUTPUT_DIR}"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${OUTPUT_DIR}/${APP_NAME}_${TEMPLATE// /_}_${TIMESTAMP}.trace"

echo ""
print_info "Output will be saved to:"
echo "  ${OUTPUT_FILE}"
echo ""

# Launch Instruments
echo "Launching Instruments..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Instructions:"
echo "  1. Click 'Record' (⌘R) to start profiling"
echo "  2. Use the app to reproduce the issue"
echo "  3. Click 'Stop' when done"
echo "  4. Analyze the results"
echo ""
echo "Common templates:"
echo "  • Time Profiler    - CPU bottlenecks"
echo "  • Allocations      - Memory usage"
echo "  • Leaks            - Memory leaks"
echo "  • System Trace     - System-level view"
echo "  • Animation Hitches - Dropped frames"
echo ""

# Launch Instruments GUI
open -a "Instruments" --args \
    -t "${TEMPLATE}" \
    "${APP_PATH}"

print_success "Instruments launched!"

echo ""
echo "Pro tips:"
echo "  • Profile in Release configuration"
echo "  • Use realistic data sets"
echo "  • Focus on one issue at a time"
echo "  • Compare before/after profiles"
echo ""
