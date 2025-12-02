#!/bin/bash

# check-accessibility.sh
# Accessibility testing script for macOS 26.x apps
# Runs automated accessibility checks and launches testing tools

set -e

echo "🔍 Accessibility Checker for macOS 26.x"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCHEME="${1:-Argute}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)"
BUILD_DIR="${PROJECT_DIR}/.build"

echo "Project: ${SCHEME}"
echo "Directory: ${PROJECT_DIR}"
echo ""

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    print_error "Xcode is not installed or xcodebuild is not in PATH"
    exit 1
fi

print_success "Xcode found"

# Check if Accessibility Inspector is available
if ! [ -d "/Applications/Xcode.app/Contents/Applications/Accessibility Inspector.app" ]; then
    print_warning "Accessibility Inspector not found"
    print_info "Install from: Xcode → Open Developer Tool → Accessibility Inspector"
else
    print_success "Accessibility Inspector available"
fi

echo ""
echo "📋 Running Accessibility Checks"
echo "================================"
echo ""

# 1. Build the app
print_info "Building ${SCHEME}..."
if xcodebuild \
    -scheme "${SCHEME}" \
    -configuration Debug \
    -derivedDataPath "${BUILD_DIR}" \
    build 2>&1 | grep -q "BUILD SUCCEEDED"; then
    print_success "Build successful"
else
    print_error "Build failed"
    exit 1
fi

echo ""

# 2. Find the built app
APP_PATH=$(find "${BUILD_DIR}" -name "${SCHEME}.app" -type d | head -n 1)

if [ -z "$APP_PATH" ]; then
    print_error "Could not find ${SCHEME}.app"
    exit 1
fi

print_success "App found at: ${APP_PATH}"
echo ""

# 3. Run accessibility audit using command line
print_info "Running static accessibility analysis..."
echo ""

# Create audit script
AUDIT_SCRIPT=$(cat <<'EOF'
#!/bin/bash

# Accessibility checks
checks_passed=0
checks_failed=0
checks_warned=0

check_pass() {
    ((checks_passed++))
    echo -e "\033[0;32m✓\033[0m $1"
}

check_fail() {
    ((checks_failed++))
    echo -e "\033[0;31m✗\033[0m $1"
}

check_warn() {
    ((checks_warned++))
    echo -e "\033[1;33m⚠\033[0m $1"
}

# Check for accessibility labels
echo "Checking source files for accessibility issues..."
echo ""

# Check for images without labels
if grep -r "Image(systemName:" . --include="*.swift" | grep -v "accessibilityLabel" > /dev/null; then
    check_warn "Found images that might be missing accessibility labels"
else
    check_pass "All system images appear to have accessibility considerations"
fi

# Check for buttons without labels
if grep -r "Button {" . --include="*.swift" | grep -v "label:" | grep -v "accessibilityLabel" | wc -l | grep -v "^0" > /dev/null; then
    check_warn "Found buttons that might be missing labels"
else
    check_pass "Button labels look good"
fi

# Check for color-only indicators
if grep -r "\.foregroundColor\|\.foregroundStyle" . --include="*.swift" > /dev/null; then
    check_warn "Using colors - ensure information isn't conveyed by color alone"
else
    check_pass "No obvious color-only indicators"
fi

# Check for animations respecting reduce motion
if grep -r "\.animation\|withAnimation" . --include="*.swift" > /dev/null; then
    if grep -r "accessibilityReduceMotion" . --include="*.swift" > /dev/null; then
        check_pass "Found reduce motion support"
    else
        check_warn "Found animations - ensure reduce motion is supported"
    fi
fi

# Check for keyboard shortcuts
if grep -r "keyboardShortcut" . --include="*.swift" > /dev/null; then
    check_pass "Keyboard shortcuts implemented"
else
    check_warn "No keyboard shortcuts found - consider adding them"
fi

# Check for VoiceOver support
if grep -r "accessibilityLabel\|accessibilityHint\|accessibilityValue" . --include="*.swift" > /dev/null; then
    check_pass "VoiceOver labels found"
else
    check_warn "No VoiceOver labels found - add accessibility labels"
fi

# Check for Dynamic Type support
if grep -r "\.font(\.custom" . --include="*.swift" | grep -v "relativeTo" > /dev/null; then
    check_warn "Custom fonts found - ensure they support Dynamic Type"
else
    check_pass "Font scaling looks good"
fi

# Summary
echo ""
echo "================================"
echo "Summary:"
echo "  ✓ Passed: $checks_passed"
echo "  ⚠ Warnings: $checks_warned"
echo "  ✗ Failed: $checks_failed"
echo "================================"

if [ $checks_failed -gt 0 ]; then
    exit 1
fi
EOF
)

# Run audit in project directory
cd "${PROJECT_DIR}"
eval "$AUDIT_SCRIPT"

echo ""

# 4. Manual testing instructions
echo ""
echo "🧪 Manual Testing Guide"
echo "======================="
echo ""

print_info "VoiceOver Testing:"
echo "  1. Enable VoiceOver: Cmd + F5"
echo "  2. Navigate: VO + → (next) / VO + ← (previous)"
echo "     (VO = Control + Option)"
echo "  3. Activate: VO + Space"
echo "  4. Check all labels are descriptive"
echo ""

print_info "Keyboard Navigation:"
echo "  1. Unplug mouse"
echo "  2. Use Tab to navigate"
echo "  3. Use Space/Enter to activate"
echo "  4. Use Escape to dismiss modals"
echo "  5. Verify all functionality is accessible"
echo ""

print_info "Visual Checks:"
echo "  1. Test in Dark Mode (Cmd + Shift + A)"
echo "  2. Test with Increased Contrast"
echo "  3. Test with larger text sizes"
echo "  4. Verify color contrast ratios"
echo ""

print_info "Motion and Animation:"
echo "  1. Enable Reduce Motion in System Settings"
echo "  2. Verify animations are reduced/removed"
echo "  3. Check that essential information isn't lost"
echo ""

# 5. Launch testing tools
echo ""
echo "🛠  Launching Testing Tools"
echo "==========================="
echo ""

# Launch Accessibility Inspector
if [ -d "/Applications/Xcode.app/Contents/Applications/Accessibility Inspector.app" ]; then
    print_info "Launching Accessibility Inspector..."
    open -a "Accessibility Inspector"
    print_success "Accessibility Inspector launched"
    echo ""
    echo "In Accessibility Inspector:"
    echo "  1. Click 'Target' → Choose ${SCHEME}"
    echo "  2. Click 'Inspection' tab"
    echo "  3. Hover over UI elements to inspect"
    echo "  4. Click 'Audit' tab to run automated checks"
    echo "  5. Review and fix any issues found"
    echo ""
else
    print_warning "Accessibility Inspector not available"
fi

# Optionally launch the app
echo ""
read -p "Launch ${SCHEME}.app for manual testing? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Launching ${SCHEME}..."
    open "${APP_PATH}"
    print_success "App launched"
fi

echo ""

# 6. Checklist
echo "📝 Accessibility Checklist"
echo "=========================="
echo ""

cat << 'CHECKLIST'
VoiceOver:
  [ ] All interactive elements have labels
  [ ] Labels are descriptive and concise
  [ ] Hints explain what will happen
  [ ] Decorative images are hidden
  [ ] Related elements are grouped
  [ ] Custom controls have proper traits
  [ ] Dynamic content announces changes

Keyboard:
  [ ] All functionality accessible via keyboard
  [ ] Tab order is logical
  [ ] Focus indicators are visible
  [ ] Escape dismisses modals
  [ ] Standard shortcuts implemented
  [ ] No keyboard traps

Visual:
  [ ] Text contrast meets 4.5:1 (AA)
  [ ] Large text contrast meets 3:1
  [ ] UI components meet 3:1 contrast
  [ ] Information not conveyed by color alone
  [ ] Dark mode fully supported
  [ ] Dynamic Type supported
  [ ] Layout adapts to large text

Motor:
  [ ] Touch targets are 44×44pt minimum
  [ ] Reduce Motion preference respected
  [ ] No rapid clicking required
  [ ] Alternatives to complex gestures

Cognitive:
  [ ] Language is clear and simple
  [ ] Consistent UI patterns
  [ ] Destructive actions require confirmation
  [ ] Loading states show progress
  [ ] Error messages are helpful
  [ ] Changes can be undone
CHECKLIST

echo ""

# 7. Resources
echo "📚 Additional Resources"
echo "======================"
echo ""
echo "Apple Documentation:"
echo "  • https://developer.apple.com/accessibility/macos/"
echo ""
echo "Testing Tools:"
echo "  • Accessibility Inspector (Xcode → Open Developer Tool)"
echo "  • VoiceOver (Cmd + F5)"
echo "  • Xcode's Debug → View Debugging → Accessibility"
echo ""
echo "Standards:"
echo "  • WCAG 2.2: https://www.w3.org/TR/WCAG22/"
echo "  • HIG Accessibility: https://developer.apple.com/design/human-interface-guidelines/accessibility"
echo ""

# 8. Generate report
REPORT_FILE="${PROJECT_DIR}/accessibility-report.txt"
cat > "${REPORT_FILE}" << REPORT
Accessibility Test Report
=========================
Date: $(date)
Project: ${SCHEME}

Status: Review Required

Next Steps:
1. Review Accessibility Inspector findings
2. Test with VoiceOver
3. Test keyboard navigation
4. Verify color contrast
5. Test with Reduce Motion
6. Complete manual checklist

Tools Used:
- Static code analysis
- Accessibility Inspector
- Manual testing

For detailed checklist, see:
${PROJECT_DIR}/.claude/skills/apple-hig-compliance/reference/accessibility-checklist.md
REPORT

print_success "Report saved to: ${REPORT_FILE}"

echo ""
print_success "Accessibility check complete!"
echo ""
