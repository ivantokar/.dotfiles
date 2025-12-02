---
name: apple-hig-compliance
description: Ensure UI follows Apple Human Interface Guidelines for macOS 26.x (Tahoe) and iOS 26.x, including Liquid Glass design system, accessibility, VoiceOver, keyboard navigation, and native patterns.
skill_type: project
tags: [macos-26, ios-26, hig, accessibility, liquid-glass, design-system, voiceover, keyboard-nav]
---

# Apple HIG Compliance Skill

Expert guidance for creating macOS 26.x (Tahoe) and iOS 26.x applications that follow Apple's Human Interface Guidelines, including the new Liquid Glass design system.

## When to Use This Skill

Activate when user mentions:
- "Does this follow HIG?"
- "Is this accessible?"
- "VoiceOver support"
- "Keyboard navigation"
- "Liquid Glass design"
- "macOS 26 native UI"
- "8pt grid system"
- "SF Symbols"
- "Color contrast"
- "Dark mode support"
- "Native macOS look and feel"

## macOS 26.x Liquid Glass Design System

### Core Principles

1. **Depth and Materiality** - Use translucent backgrounds with blur effects
2. **Fluid Motion** - Smooth, physics-based animations
3. **Contextual Hierarchy** - Clear visual hierarchy with elevation
4. **Adaptive Color** - Semantic colors that adapt to light/dark mode
5. **Spatial Awareness** - UI that responds to context and focus

### Liquid Glass Materials

```swift
// ✅ CORRECT - macOS 26 Liquid Glass materials
import SwiftUI

struct ModernWindow: View {
    var body: some View {
        VStack {
            // Primary content area
            ContentView()
                .background(.background)  // Adaptive background

            // Secondary panels
            SidebarView()
                .background(.regularMaterial)  // Translucent material

            // Floating panels
            FloatingPanel()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        }
    }
}
```

**Available Materials (macOS 26+):**
- `.regularMaterial` - Standard translucent background
- `.thinMaterial` - More transparent
- `.ultraThinMaterial` - Very transparent, for overlays
- `.thickMaterial` - Less transparent, more solid
- `.bar` - Navigation bars and toolbars
- `.background` - Adaptive solid background

### 8-Point Grid System

**All spacing must be multiples of 8:**

```swift
// ✅ CORRECT spacing
VStack(spacing: 8) {      // 8pt
    Text("Title")
        .padding(.bottom, 16)  // 16pt (2 × 8)

    Text("Subtitle")
        .padding(.horizontal, 24)  // 24pt (3 × 8)

    Divider()
        .padding(.vertical, 32)  // 32pt (4 × 8)
}

// ❌ WRONG - Non-standard spacing
VStack(spacing: 10) {     // Not a multiple of 8!
    Text("Title")
        .padding(.bottom, 15)  // Not a multiple of 8!
}
```

**Standard spacing values:**
- `4pt` - Minimum spacing (half grid)
- `8pt` - Tight spacing
- `16pt` - Comfortable spacing
- `24pt` - Loose spacing
- `32pt` - Section spacing
- `48pt` - Large gaps
- `64pt` - Major sections

### Typography Hierarchy

```swift
// macOS 26 dynamic type styles
Text("Large Title")
    .font(.largeTitle)        // 26pt

Text("Title 1")
    .font(.title)             // 22pt

Text("Title 2")
    .font(.title2)            // 17pt

Text("Title 3")
    .font(.title3)            // 15pt

Text("Headline")
    .font(.headline)          // 13pt semibold

Text("Body")
    .font(.body)              // 13pt

Text("Callout")
    .font(.callout)           // 12pt

Text("Subheadline")
    .font(.subheadline)       // 11pt

Text("Footnote")
    .font(.footnote)          // 10pt

Text("Caption")
    .font(.caption)           // 10pt

Text("Caption 2")
    .font(.caption2)          // 9pt
```

## Native macOS Patterns

### Windows

```swift
// ✅ macOS 26 native window structure
import SwiftUI

@main
struct ArguteApp: App {
    var body: some Scene {
        // Main document window
        WindowGroup {
            ContentView()
        }
        .windowStyle(.automatic)  // Native window chrome
        .defaultSize(width: 1200, height: 800)
        .defaultPosition(.center)

        // Settings window
        Settings {
            SettingsView()
        }

        // Auxiliary windows
        Window("Inspector", id: "inspector") {
            InspectorView()
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 300, height: 600)
    }
}
```

### Toolbars

```swift
// ✅ Native macOS 26 toolbar
struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar {
            // Leading items
            ToolbarItemGroup(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Label("Toggle Sidebar", systemImage: "sidebar.left")
                }
            }

            // Center items
            ToolbarItemGroup(placement: .principal) {
                Picker("View Mode", selection: $viewMode) {
                    Label("Edit", systemImage: "pencil").tag(ViewMode.edit)
                    Label("Preview", systemImage: "eye").tag(ViewMode.preview)
                    Label("Split", systemImage: "square.split.2x1").tag(ViewMode.split)
                }
                .pickerStyle(.segmented)
            }

            // Trailing items
            ToolbarItemGroup(placement: .automatic) {
                Button(action: share) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }

                Button(action: settings) {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .toolbarRole(.editor)
    }
}
```

### SF Symbols

```swift
// ✅ Proper SF Symbols usage
Image(systemName: "doc.text")
    .symbolRenderingMode(.hierarchical)  // Depth effect
    .imageScale(.medium)

Image(systemName: "folder.badge.plus")
    .symbolRenderingMode(.multicolor)    // Color-coded parts
    .symbolVariant(.fill)                // Filled variant

// Variable symbols (animate fill level)
Image(systemName: "speaker.wave.3")
    .symbolEffect(.variableColor.iterative)

// SF Symbols sizing
Image(systemName: "star.fill")
    .font(.title)                        // Matches text size
```

**Symbol best practices:**
- Use `.hierarchical` for single-color depth
- Use `.multicolor` for color-coded symbols
- Use `.palette` for custom color schemes
- Match symbol size to adjacent text
- Use `.symbolVariant()` for states

## Accessibility Requirements

### VoiceOver Support

```swift
// ✅ Proper VoiceOver labels
Button(action: save) {
    Image(systemName: "square.and.arrow.down")
}
.accessibilityLabel("Save Document")
.accessibilityHint("Saves the current document to disk")
.accessibilityAddTraits(.isButton)

// Custom controls need proper semantics
CustomSlider(value: $volume)
    .accessibilityLabel("Volume")
    .accessibilityValue("\(Int(volume))%")
    .accessibilityAdjustableAction { direction in
        switch direction {
        case .increment: volume = min(100, volume + 10)
        case .decrement: volume = max(0, volume - 10)
        @unknown default: break
        }
    }

// Group related elements
VStack {
    Text("John Doe")
    Text("Software Engineer")
    Text("San Francisco, CA")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("John Doe, Software Engineer, San Francisco, CA")

// Hide decorative elements
Image("decorative-pattern")
    .accessibilityHidden(true)
```

**VoiceOver checklist:**
- [ ] All interactive elements have labels
- [ ] Labels are concise and descriptive
- [ ] Hints explain what will happen
- [ ] Decorative images are hidden
- [ ] Related elements are grouped
- [ ] Custom controls have proper traits
- [ ] Dynamic content announces changes

### Keyboard Navigation

```swift
// ✅ Full keyboard support
struct DocumentView: View {
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case title, content, tags
    }

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .focused($focusedField, equals: .title)

            TextEditor(text: $content)
                .focused($focusedField, equals: .content)

            TextField("Tags", text: $tags)
                .focused($focusedField, equals: .tags)
        }
        // Tab cycles through fields
        .focusedValue(\.focusedField, $focusedField)

        // Custom keyboard shortcuts
        .onKeyPress(.tab) {
            focusNextField()
            return .handled
        }
        .onKeyPress(.escape) {
            focusedField = nil
            return .handled
        }

        // Standard shortcuts
        .keyboardShortcut("s", modifiers: .command)  // Save
        .keyboardShortcut("w", modifiers: .command)  // Close
    }
}
```

**Standard keyboard shortcuts:**
- `⌘S` - Save
- `⌘W` - Close window
- `⌘N` - New document
- `⌘O` - Open
- `⌘P` - Print
- `⌘Z` - Undo
- `⌘⇧Z` - Redo
- `⌘,` - Settings
- `⌘Q` - Quit
- `⌘?` - Help

### Color Contrast

```swift
// ✅ Accessible color contrast
struct AccessibleText: View {
    var body: some View {
        // WCAG AA: Minimum 4.5:1 for normal text
        // WCAG AAA: Minimum 7:1 for normal text

        Text("Important Message")
            .foregroundStyle(.primary)      // Maximum contrast

        Text("Secondary Info")
            .foregroundStyle(.secondary)    // Still readable

        Text("Tertiary")
            .foregroundStyle(.tertiary)     // Minimum readable

        // Custom colors - ensure contrast
        Text("Warning")
            .foregroundColor(.orange)       // 4.5:1 on white
            .background(Color.black.opacity(0.1))
    }
}
```

**Contrast requirements:**
- **Normal text (13pt+):** 4.5:1 minimum (AA), 7:1 preferred (AAA)
- **Large text (18pt+):** 3:1 minimum (AA), 4.5:1 preferred (AAA)
- **UI components:** 3:1 minimum
- **Graphical objects:** 3:1 minimum

**Test your colors:**
```swift
// Use Xcode's Accessibility Inspector
// Cmd + Run → Accessibility Inspector → Color Contrast Calculator
```

### Reduced Motion

```swift
// ✅ Respect reduced motion preference
import SwiftUI

struct AnimatedView: View {
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

## Dark Mode Support

```swift
// ✅ Adaptive colors for dark mode
struct AdaptiveUI: View {
    var body: some View {
        VStack {
            // Semantic colors (automatically adapt)
            Text("Title")
                .foregroundStyle(.primary)

            Rectangle()
                .fill(.background)

            // Custom colors with dark mode variants
            Text("Custom")
                .foregroundColor(Color("CustomText"))

            // Asset catalog colors automatically adapt
        }
    }
}

// In Assets.xcassets:
// CustomText:
//   - Any Appearance: #1C1C1E
//   - Dark Appearance: #EBEBF5
```

**Semantic colors (auto-adapt):**
- `.primary` - Main text
- `.secondary` - Secondary text
- `.tertiary` - Tertiary text
- `.background` - Window background
- `.secondaryBackground` - Secondary panels
- `.tertiaryBackground` - Tertiary areas

## Layout Guidelines

### Safe Areas and Margins

```swift
// ✅ Respect safe areas
struct SafeLayout: View {
    var body: some View {
        VStack {
            // Content automatically respects safe area
            Text("Content")
        }
        .padding()  // Additional padding inside safe area

        // Extend beyond safe area (backgrounds)
        Color.blue
            .ignoresSafeArea()  // Full bleed
            .overlay {
                Text("Full Width")
                    .padding()  // Still inset from edges
            }
    }
}
```

**Standard margins:**
- **Window edges:** 20pt
- **Content padding:** 16pt
- **Between sections:** 32pt
- **List items:** 8pt vertical, 16pt horizontal

### Minimum Sizes

**Clickable targets:**
- **macOS:** 28×28pt minimum (44×44pt preferred)
- **iOS:** 44×44pt minimum

```swift
// ✅ Adequate touch targets
Button("Click Me") {
    action()
}
.frame(minWidth: 44, minHeight: 44)
.contentShape(Rectangle())  // Entire frame is tappable
```

## Liquid Glass Effects

### Translucency

```swift
// ✅ Liquid Glass translucent panels
struct GlassPanel: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Floating Panel")
                .font(.headline)

            Text("Content with depth")
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
        )
    }
}
```

### Depth and Elevation

```swift
// ✅ Visual hierarchy with elevation
struct ElevatedCard: View {
    @State private var isHovered = false

    var body: some View {
        VStack {
            // Content
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: .black.opacity(isHovered ? 0.15 : 0.05),
            radius: isHovered ? 20 : 10,
            y: isHovered ? 8 : 4
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { isHovered = $0 }
    }
}
```

**Elevation levels:**
- **Level 0:** Base content (no shadow)
- **Level 1:** Slight depth (radius 10, y 4, opacity 0.05)
- **Level 2:** Cards (radius 15, y 6, opacity 0.08)
- **Level 3:** Floating panels (radius 20, y 10, opacity 0.1)
- **Level 4:** Modals (radius 30, y 15, opacity 0.15)

## Settings Window Pattern

```swift
// ✅ macOS 26 Settings window (See template for full version)
struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            EditorSettingsView()
                .tabItem {
                    Label("Editor", systemImage: "doc.text")
                }

            AppearanceSettingsView()
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush")
                }
        }
        .frame(width: 500, height: 400)
    }
}
```

## Reference Material

See additional files:
- `reference/liquid-glass-design.md` - Complete Liquid Glass design system
- `reference/accessibility-checklist.md` - Full accessibility requirements
- `reference/macos-26-patterns.md` - macOS 26 specific UI patterns
- `templates/SettingsWindow-Template.swift` - Settings window template
- `templates/Toolbar-Template.swift` - Native toolbar template
- `scripts/check-accessibility.sh` - Run Accessibility Inspector

## HIG Compliance Checklist

When reviewing UI:

**Visual Design:**
- [ ] Uses 8pt grid system
- [ ] Proper SF Symbols usage
- [ ] Liquid Glass materials for depth
- [ ] Consistent spacing and padding
- [ ] Typography hierarchy
- [ ] Adaptive colors for dark mode

**Accessibility:**
- [ ] VoiceOver labels on all interactive elements
- [ ] Keyboard navigation works completely
- [ ] Color contrast meets WCAG AA (4.5:1)
- [ ] Touch targets are 44×44pt minimum
- [ ] Respects reduced motion preference
- [ ] Dynamic type support

**Native Patterns:**
- [ ] Standard keyboard shortcuts
- [ ] Native window chrome
- [ ] Proper toolbar structure
- [ ] Settings window if needed
- [ ] File menu commands
- [ ] Help menu

**Polish:**
- [ ] Smooth animations (0.3-0.5s spring)
- [ ] Hover states on interactive elements
- [ ] Focus indicators visible
- [ ] Loading states
- [ ] Error states
- [ ] Empty states

## Testing Tools

```bash
# Run accessibility inspector
/scripts/check-accessibility.sh

# Manual testing:
# 1. Enable VoiceOver (Cmd + F5)
# 2. Navigate with Tab key
# 3. Test in Dark Mode
# 4. Enable Reduce Motion
# 5. Test with Increase Contrast
# 6. Test with larger Dynamic Type
```

## Next Steps

When ensuring HIG compliance:
1. Read `reference/liquid-glass-design.md` for visual guidelines
2. Check `reference/accessibility-checklist.md` for requirements
3. Use templates for common patterns
4. Run accessibility inspector
5. Test with VoiceOver enabled
6. Verify keyboard navigation
7. Test in both light and dark mode
