# Accessibility Checklist - macOS 26.x / iOS 26.x

Comprehensive accessibility requirements for Apple platforms, ensuring your app works for everyone.

## Table of Contents

1. [VoiceOver Support](#voiceover-support)
2. [Keyboard Navigation](#keyboard-navigation)
3. [Visual Accessibility](#visual-accessibility)
4. [Motor Accessibility](#motor-accessibility)
5. [Cognitive Accessibility](#cognitive-accessibility)
6. [Testing Tools](#testing-tools)
7. [WCAG 2.2 Compliance](#wcag-22-compliance)

## VoiceOver Support

VoiceOver is Apple's screen reader. Every interactive element must be accessible.

### Accessibility Labels

**Rule:** Every interactive element needs a descriptive label.

```swift
// ❌ BAD - No label
Button {
    save()
} label: {
    Image(systemName: "square.and.arrow.down")
}

// ✅ GOOD - Proper label
Button {
    save()
} label: {
    Image(systemName: "square.and.arrow.down")
}
.accessibilityLabel("Save Document")
```

**Label Guidelines:**
- **Be descriptive:** "Save Document" not "Save"
- **Be concise:** 2-4 words maximum
- **Skip "button":** VoiceOver adds this automatically
- **Use sentence case:** "Open file" not "Open File"
- **Describe action:** "Delete item" not "Trash icon"

### Accessibility Hints

**Rule:** Add hints to explain what will happen.

```swift
Button("Delete") {
    deleteItem()
}
.accessibilityLabel("Delete")
.accessibilityHint("Permanently removes this item")

TextField("Search", text: $query)
    .accessibilityLabel("Search field")
    .accessibilityHint("Enter keywords to search documents")
```

**Hint Guidelines:**
- **Explain outcome:** What happens when activated
- **Be brief:** One short sentence
- **Start with verb:** "Opens", "Deletes", "Saves"
- **Don't repeat label:** Hint adds new information
- **Optional for obvious actions:** Submit button doesn't need hint

### Accessibility Values

**Rule:** Provide current state or value.

```swift
// Slider
Slider(value: $volume, in: 0...100)
    .accessibilityLabel("Volume")
    .accessibilityValue("\(Int(volume)) percent")

// Toggle
Toggle("Dark Mode", isOn: $isDarkMode)
    .accessibilityValue(isDarkMode ? "On" : "Off")

// Progress
ProgressView(value: progress)
    .accessibilityLabel("Upload progress")
    .accessibilityValue("\(Int(progress * 100)) percent complete")
```

### Accessibility Traits

**Rule:** Assign appropriate traits to custom controls.

```swift
// Button trait
CustomButton()
    .accessibilityAddTraits(.isButton)

// Header trait
Text("Section Title")
    .font(.headline)
    .accessibilityAddTraits(.isHeader)

// Selected state
ListItem(isSelected: true)
    .accessibilityAddTraits(.isSelected)

// Disabled state
Button("Action") {}
    .disabled(true)
    .accessibilityRemoveTraits(.isButton)
    .accessibilityAddTraits(.isStaticText)
```

**Available Traits:**
- `.isButton` - Button control
- `.isLink` - Link to navigate
- `.isHeader` - Section header
- `.isSelected` - Currently selected
- `.isImage` - Image element
- `.playsSound` - Plays audio
- `.startsMediaSession` - Starts video/audio
- `.updatesFrequently` - Live content
- `.allowsDirectInteraction` - Touch-through
- `.causesPageTurn` - Page navigation

### Grouping Elements

**Rule:** Group related elements to reduce verbosity.

```swift
// ✅ GOOD - Grouped contact card
VStack(alignment: .leading) {
    Text("John Doe")
        .font(.headline)

    Text("Software Engineer")
        .font(.subheadline)

    Text("San Francisco, CA")
        .font(.caption)
        .foregroundStyle(.secondary)
}
.accessibilityElement(children: .combine)
.accessibilityLabel("John Doe, Software Engineer, San Francisco, California")

// ✅ GOOD - Grouped stats
HStack(spacing: 20) {
    StatView(value: 1234, label: "Followers")
    StatView(value: 567, label: "Following")
    StatView(value: 89, label: "Posts")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("1,234 followers, 567 following, 89 posts")
```

### Hiding Decorative Elements

**Rule:** Hide purely decorative images and spacers.

```swift
// ✅ Hide decorative image
Image("decorative-pattern")
    .accessibilityHidden(true)

// ✅ Hide spacer
Spacer()
    .accessibilityHidden(true)

// ✅ Hide background shapes
Circle()
    .fill(.blue.opacity(0.1))
    .accessibilityHidden(true)
```

### Custom Controls

**Rule:** Implement `accessibilityAdjustableAction` for custom sliders/steppers.

```swift
struct CustomSlider: View {
    @Binding var value: Double

    var body: some View {
        // Custom slider UI
        GeometryReader { geometry in
            // Implementation...
        }
        .accessibilityLabel("Volume")
        .accessibilityValue("\(Int(value)) percent")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value = min(100, value + 10)
            case .decrement:
                value = max(0, value - 10)
            @unknown default:
                break
            }
        }
    }
}
```

### Dynamic Content

**Rule:** Announce changes to live content.

```swift
struct LiveScore: View {
    @State private var score = 0

    var body: some View {
        Text("Score: \(score)")
            .accessibilityLabel("Current score")
            .accessibilityValue("\(score) points")
            .accessibilityRespondsToUserInteraction(true)
            .onChange(of: score) { oldValue, newValue in
                // Announce change
                AccessibilityNotification.Announcement(
                    "Score updated to \(newValue)"
                )
                .post()
            }
    }
}
```

### VoiceOver Checklist

- [ ] All buttons have descriptive labels
- [ ] All images have labels (unless decorative)
- [ ] All form fields have labels
- [ ] Custom controls have appropriate traits
- [ ] Current values are announced
- [ ] Hints explain non-obvious actions
- [ ] Related elements are grouped
- [ ] Decorative elements are hidden
- [ ] Dynamic content announces changes
- [ ] Navigation structure is clear
- [ ] Focus order is logical
- [ ] Modal dialogs are properly announced

**Test with VoiceOver:**
```bash
# Enable VoiceOver
Cmd + F5

# Or use Accessibility Inspector
Xcode → Open Developer Tool → Accessibility Inspector
```

## Keyboard Navigation

All functionality must be accessible via keyboard alone.

### Focus Management

**Rule:** Support keyboard focus on all interactive elements.

```swift
struct KeyboardAccessibleForm: View {
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case firstName, lastName, email, phone
    }

    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .focused($focusedField, equals: .firstName)

            TextField("Last Name", text: $lastName)
                .focused($focusedField, equals: .lastName)

            TextField("Email", text: $email)
                .focused($focusedField, equals: .email)

            TextField("Phone", text: $phone)
                .focused($focusedField, equals: .phone)
        }
        .onAppear {
            focusedField = .firstName  // Focus first field
        }
    }
}
```

### Keyboard Shortcuts

**Rule:** Implement standard shortcuts and document custom ones.

```swift
struct ShortcutView: View {
    var body: some View {
        VStack {
            // Standard shortcuts
            Button("Save") { save() }
                .keyboardShortcut("s", modifiers: .command)

            Button("Open") { open() }
                .keyboardShortcut("o", modifiers: .command)

            Button("Close") { close() }
                .keyboardShortcut("w", modifiers: .command)

            // Custom shortcuts with labels
            Button("Export PDF") { exportPDF() }
                .keyboardShortcut("e", modifiers: [.command, .shift])
        }
        .commands {
            // Add to menu bar
            CommandGroup(after: .newItem) {
                Button("Export PDF") { exportPDF() }
                    .keyboardShortcut("e", modifiers: [.command, .shift])
            }
        }
    }
}
```

**Standard macOS Shortcuts:**

| Action | Shortcut | Description |
|--------|----------|-------------|
| New | `⌘N` | New document |
| Open | `⌘O` | Open file |
| Save | `⌘S` | Save document |
| Save As | `⌘⇧S` | Save as new file |
| Close | `⌘W` | Close window |
| Quit | `⌘Q` | Quit application |
| Undo | `⌘Z` | Undo last action |
| Redo | `⌘⇧Z` | Redo action |
| Cut | `⌘X` | Cut selection |
| Copy | `⌘C` | Copy selection |
| Paste | `⌘V` | Paste clipboard |
| Select All | `⌘A` | Select all |
| Find | `⌘F` | Find in document |
| Print | `⌘P` | Print document |
| Preferences | `⌘,` | Open settings |
| Hide | `⌘H` | Hide window |
| Minimize | `⌘M` | Minimize window |
| Help | `⌘?` | Open help |

### Tab Navigation

**Rule:** Tab key cycles through all interactive elements.

```swift
struct TabNavigationView: View {
    @FocusState private var focusedElement: Element?

    enum Element: Hashable {
        case button1, button2, textField, slider
    }

    var body: some View {
        VStack {
            Button("First Button") {}
                .focused($focusedElement, equals: .button1)

            Button("Second Button") {}
                .focused($focusedElement, equals: .button2)

            TextField("Input", text: $text)
                .focused($focusedElement, equals: .textField)

            Slider(value: $value)
                .focused($focusedElement, equals: .slider)
        }
        .focusable(true)
        .onKeyPress(.tab) {
            // Custom tab handling if needed
            focusNextElement()
            return .handled
        }
    }

    func focusNextElement() {
        switch focusedElement {
        case .button1: focusedElement = .button2
        case .button2: focusedElement = .textField
        case .textField: focusedElement = .slider
        case .slider: focusedElement = .button1
        default: focusedElement = .button1
        }
    }
}
```

### Focus Indicators

**Rule:** Visible focus indicators on all interactive elements.

```swift
struct FocusIndicatorButton: View {
    @FocusState private var isFocused: Bool

    var body: some View {
        Button("Action") {
            performAction()
        }
        .buttonStyle(.bordered)
        .focused($isFocused)
        .overlay {
            if isFocused {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.blue, lineWidth: 2)
                    .padding(-2)
            }
        }
    }
}
```

### Escape Key

**Rule:** Escape dismisses modals and cancels operations.

```swift
struct DismissibleModal: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            // Modal content
        }
        .onKeyPress(.escape) {
            dismiss()
            return .handled
        }
    }
}
```

### Keyboard Navigation Checklist

- [ ] All interactive elements are keyboard accessible
- [ ] Tab key cycles through elements logically
- [ ] Focus indicators are clearly visible
- [ ] Escape dismisses modals and popovers
- [ ] Enter activates focused button
- [ ] Space toggles checkboxes and switches
- [ ] Arrow keys navigate lists and menus
- [ ] Standard shortcuts are implemented
- [ ] Custom shortcuts are documented
- [ ] Keyboard-only users can access all features
- [ ] Focus doesn't get trapped
- [ ] Focus order matches visual order

## Visual Accessibility

### Color Contrast

**Rule:** Maintain WCAG 2.2 AA minimum contrast ratios.

**Requirements:**
- **Normal text (< 18pt):** 4.5:1 minimum
- **Large text (≥ 18pt):** 3:1 minimum
- **UI components:** 3:1 minimum
- **Graphical objects:** 3:1 minimum

```swift
// ✅ GOOD - High contrast
Text("Important Message")
    .foregroundColor(.primary)  // Black on white = 21:1
    .background(.background)

// ✅ GOOD - Meets 4.5:1
Text("Body Text")
    .foregroundColor(Color(red: 0.33, green: 0.33, blue: 0.33))  // #545454
    .background(.white)  // 9.74:1 ratio

// ❌ BAD - Low contrast
Text("Hard to Read")
    .foregroundColor(.gray.opacity(0.4))  // < 4.5:1
    .background(.white)
```

**Test contrast:**
- Use Xcode Accessibility Inspector
- Color Contrast Calculator tab
- Input foreground and background colors
- Verify ratio meets requirements

### Increase Contrast

**Rule:** Respect user's "Increase Contrast" preference.

```swift
struct ContrastAwareView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency

    var body: some View {
        VStack {
            Text("Content")
                .foregroundStyle(differentiateWithoutColor ? .primary : .blue)

            Rectangle()
                .fill(reduceTransparency ? .blue : .blue.opacity(0.5))
        }
    }
}
```

### Color Blindness

**Rule:** Don't rely on color alone to convey information.

```swift
// ❌ BAD - Color only
HStack {
    Circle().fill(.green)  // Success
    Circle().fill(.red)    // Error
}

// ✅ GOOD - Color + shape + label
HStack {
    Label("Success", systemImage: "checkmark.circle.fill")
        .foregroundStyle(.green)

    Label("Error", systemImage: "xmark.circle.fill")
        .foregroundStyle(.red)
}

// ✅ GOOD - Color + pattern
Rectangle()
    .fill(
        status == .success
            ? .green
            : LinearGradient(
                colors: [.red, .red.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
    )
```

### Dynamic Type

**Rule:** Support Dynamic Type for text scaling.

```swift
// ✅ Supports Dynamic Type
Text("This text scales")
    .font(.body)  // System font scales automatically

// ✅ Custom font with scaling
Text("Custom but scalable")
    .font(.custom("MyFont", size: 16, relativeTo: .body))

// ❌ Fixed size (avoid)
Text("Fixed size")
    .font(.system(size: 16))  // Won't scale with Dynamic Type
```

**Handle large text:**

```swift
struct ScalableLayout: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        if dynamicTypeSize >= .xxLarge {
            // Vertical layout for large text
            VStack(alignment: .leading) {
                Text("Label")
                Text("Value")
            }
        } else {
            // Horizontal layout for normal text
            HStack {
                Text("Label")
                Spacer()
                Text("Value")
            }
        }
    }
}
```

### Dark Mode

**Rule:** Support both light and dark appearances.

```swift
// ✅ Semantic colors (auto-adapt)
Text("Adaptive")
    .foregroundStyle(.primary)
    .background(.background)

// ✅ Asset catalog colors
Text("Custom")
    .foregroundColor(Color("BrandPrimary"))

// Define in Assets.xcassets:
// BrandPrimary
//   - Any Appearance: #007AFF
//   - Dark Appearance: #0A84FF
```

**Test dark mode:**
- Appearance panel in Xcode
- Cmd + Shift + A to toggle
- Test all UI states
- Verify contrast in both modes

### Visual Accessibility Checklist

- [ ] All text meets 4.5:1 contrast (normal text)
- [ ] Large text meets 3:1 contrast
- [ ] UI components meet 3:1 contrast
- [ ] Information isn't conveyed by color alone
- [ ] Icons/shapes supplement color coding
- [ ] Dynamic Type is supported
- [ ] Layout adapts to large text sizes
- [ ] Dark mode is fully supported
- [ ] Increase Contrast preference is respected
- [ ] Reduce Transparency preference is respected
- [ ] All states are distinguishable
- [ ] Error states are clearly marked

## Motor Accessibility

### Touch Target Size

**Rule:** Minimum 44×44pt touch targets.

```swift
// ✅ GOOD - Adequate size
Button("Action") {
    performAction()
}
.frame(minWidth: 44, minHeight: 44)
.contentShape(Rectangle())  // Entire frame is tappable

// ❌ BAD - Too small
Button {
    action()
} label: {
    Image(systemName: "plus")
        .font(.system(size: 12))
}
// Icon is only ~12×12pt
```

**Expand hit area:**

```swift
struct ExpandedHitArea: View {
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .font(.caption)
        }
        .buttonStyle(.borderless)
        .padding(16)  // Expand tappable area
        .contentShape(Rectangle())
    }
}
```

### Reduce Motion

**Rule:** Respect "Reduce Motion" preference.

```swift
struct MotionAwareView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .scaleEffect(isAnimating ? 1.5 : 1.0)
            .animation(
                reduceMotion ? .none : .spring(duration: 0.5),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
```

**Alternative for essential motion:**

```swift
// If animation conveys important information
struct EssentialAnimation: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        if reduceMotion {
            // Instant transition
            view
                .opacity(isVisible ? 1 : 0)
        } else {
            // Animated transition
            view
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(), value: isVisible)
        }
    }
}
```

### Shake to Undo

**Rule:** Provide alternative to shake gestures.

```swift
// Always provide undo button
Button("Undo") {
    undoManager.undo()
}
.keyboardShortcut("z", modifiers: .command)

// Don't rely solely on shake gesture
```

### Motor Accessibility Checklist

- [ ] All touch targets are 44×44pt minimum
- [ ] Adequate spacing between interactive elements
- [ ] Reduce Motion preference is respected
- [ ] Alternatives to shake gestures exist
- [ ] Drag gestures have alternatives
- [ ] Multi-finger gestures have alternatives
- [ ] Timed interactions can be disabled
- [ ] No rapid clicking required
- [ ] Hover states work with assistive tech
- [ ] Voice Control compatible

## Cognitive Accessibility

### Clear Language

**Rule:** Use simple, clear, consistent language.

```swift
// ✅ GOOD - Clear and direct
Button("Delete Photo") {
    deletePhoto()
}
.confirmationDialog(
    "Delete this photo?",
    isPresented: $showConfirmation
) {
    Button("Delete Photo", role: .destructive) {
        confirmDelete()
    }
    Button("Cancel", role: .cancel) {}
}

// ❌ BAD - Vague and technical
Button("Remove Asset") {
    performDeletion()
}
.confirmationDialog(
    "Confirm asset removal?",
    isPresented: $showConfirmation
) {
    Button("Execute", role: .destructive) {}
    Button("Abort", role: .cancel) {}
}
```

### Consistent UI

**Rule:** Maintain consistent patterns throughout.

```swift
// ✅ GOOD - Consistent confirmation pattern
func deleteItem() {
    showConfirmation = true  // Always confirm destructive actions
}

func saveChanges() {
    save()  // Never confirm save actions
}

// Consistent button placement
HStack {
    Button("Cancel", role: .cancel) {}  // Always left
    Spacer()
    Button("Save") {}  // Always right
}
```

### Error Prevention

**Rule:** Prevent errors and make recovery easy.

```swift
// ✅ GOOD - Validation and helpful messages
struct ValidatedForm: View {
    @State private var email = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()

            if let error = errorMessage {
                Label(error, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
            }

            Button("Submit") {
                validateAndSubmit()
            }
            .disabled(!isValidEmail(email))
        }
    }

    func validateAndSubmit() {
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address"
        } else {
            submit()
        }
    }
}
```

### Loading States

**Rule:** Show progress and provide feedback.

```swift
struct ProgressFeedback: View {
    @State private var isLoading = false
    @State private var progress: Double = 0

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...", value: progress, total: 1.0)
                    .padding()

                Text("\(Int(progress * 100))% complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Button("Load Data") {
                    loadData()
                }
            }
        }
    }
}
```

### Cognitive Accessibility Checklist

- [ ] Language is clear and simple
- [ ] Instructions are concise
- [ ] Error messages are helpful
- [ ] Consistent UI patterns throughout
- [ ] Destructive actions require confirmation
- [ ] Loading states show progress
- [ ] Timeouts are avoided or configurable
- [ ] Focus isn't stolen unexpectedly
- [ ] Changes can be undone
- [ ] Forms have inline validation
- [ ] Success confirmations are shown
- [ ] Complex tasks broken into steps

## Testing Tools

### Xcode Accessibility Inspector

```bash
# Launch Accessibility Inspector
Xcode → Open Developer Tool → Accessibility Inspector

# Features:
# - Inspect element hierarchy
# - View accessibility properties
# - Test VoiceOver announcements
# - Check color contrast
# - Audit accessibility issues
# - Run automated tests
```

**Inspection:**
1. Enable inspector
2. Hover over UI elements
3. Review accessibility properties
4. Fix any warnings

**Audit:**
1. Click "Audit" button
2. Review issues by severity
3. Fix critical issues first
4. Verify fixes

### VoiceOver Testing

```bash
# Enable VoiceOver
Cmd + F5

# Navigation:
# - VO + →: Next element
# - VO + ←: Previous element
# - VO + Space: Activate element
# - VO + Shift + ↓: Enter container
# - VO + Shift + ↑: Exit container

# Where VO = Control + Option
```

**Testing checklist:**
1. Turn on VoiceOver
2. Navigate entire app with keyboard only
3. Verify all labels are descriptive
4. Check reading order is logical
5. Test all interactive elements
6. Verify state changes are announced
7. Test forms and validation

### Keyboard Testing

**Full keyboard test:**
1. Unplug mouse
2. Navigate using Tab key only
3. Activate with Enter/Space
4. Dismiss with Escape
5. Test all shortcuts
6. Verify focus indicators
7. Check focus doesn't get trapped

### Environment Testing

**Test with preferences enabled:**

```swift
// In Preview
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Normal
            MyView()

            // Large text
            MyView()
                .environment(\.dynamicTypeSize, .xxxLarge)

            // Dark mode
            MyView()
                .preferredColorScheme(.dark)

            // Reduce motion
            MyView()
                .environment(\.accessibilityReduceMotion, true)

            // Increase contrast
            MyView()
                .environment(\.accessibilityDifferentiateWithoutColor, true)

            // Reduce transparency
            MyView()
                .environment(\.accessibilityReduceTransparency, true)
        }
    }
}
```

## WCAG 2.2 Compliance

### Conformance Levels

**Level A (Minimum):**
- Alternative text for images
- Keyboard accessible
- Color not sole indicator
- Consistent navigation

**Level AA (Target):**
- 4.5:1 contrast ratio
- Resizable text
- Multiple navigation methods
- Focus visible

**Level AAA (Enhanced):**
- 7:1 contrast ratio
- No time limits
- Sign language
- Extended audio descriptions

### WCAG 2.2 Checklist

**Perceivable:**
- [ ] Text alternatives for non-text content
- [ ] Captions for audio
- [ ] Audio descriptions for video
- [ ] Content adaptable to different presentations
- [ ] Sufficient color contrast
- [ ] User control of audio

**Operable:**
- [ ] All functionality via keyboard
- [ ] No keyboard traps
- [ ] Adjustable time limits
- [ ] Pause/stop/hide moving content
- [ ] No content causes seizures (flash limit)
- [ ] Skip navigation mechanisms
- [ ] Descriptive page titles
- [ ] Focus order is logical
- [ ] Link purpose clear from context
- [ ] Multiple navigation methods
- [ ] Descriptive headings and labels
- [ ] Focus visible
- [ ] Touch target size 44×44pt minimum

**Understandable:**
- [ ] Language of page identified
- [ ] Language changes identified
- [ ] Predictable navigation
- [ ] Consistent identification
- [ ] Error identification
- [ ] Labels and instructions provided
- [ ] Error suggestions provided
- [ ] Error prevention for critical actions

**Robust:**
- [ ] Valid HTML/code
- [ ] Name, role, value for components
- [ ] Status messages programmatically determined

## Accessibility Audit Script

Save this as `/scripts/check-accessibility.sh`:

```bash
#!/bin/bash

echo "Running Accessibility Audit..."

# Build for testing
xcodebuild -scheme Argute -destination 'platform=macOS' build-for-testing

# Run UI tests with accessibility audit
xcodebuild test-without-building \
    -scheme Argute \
    -destination 'platform=macOS' \
    -only-testing:ArguteUITests/AccessibilityTests

# Open Accessibility Inspector
open -a "Accessibility Inspector"

echo "Audit complete. Review results in Accessibility Inspector."
```

## Resources

**Apple Documentation:**
- [Accessibility for macOS](https://developer.apple.com/accessibility/macos/)
- [VoiceOver Testing Guide](https://developer.apple.com/design/human-interface-guidelines/accessibility)
- [Color and Contrast](https://developer.apple.com/design/human-interface-guidelines/color)

**Testing Tools:**
- Xcode Accessibility Inspector
- VoiceOver (Cmd + F5)
- Accessibility Keyboard Viewer
- Color Contrast Analyzer

**Standards:**
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [Section 508](https://www.section508.gov/)
- [EN 301 549](https://www.etsi.org/deliver/etsi_en/301500_301599/301549/03.02.01_60/en_301549v030201p.pdf)

---

Making your app accessible isn't just good practice—it's essential for reaching all users. Follow this checklist to ensure everyone can use your app effectively.
