# Liquid Glass Design System - macOS 26.x (Tahoe)

Complete guide to implementing Apple's Liquid Glass design language in macOS 26.x applications.

## Table of Contents

1. [Overview](#overview)
2. [Core Principles](#core-principles)
3. [Materials and Translucency](#materials-and-translucency)
4. [Depth and Elevation](#depth-and-elevation)
5. [Color System](#color-system)
6. [Typography](#typography)
7. [Spacing and Layout](#spacing-and-layout)
8. [Animation and Motion](#animation-and-motion)
9. [Component Patterns](#component-patterns)
10. [Implementation Examples](#implementation-examples)

## Overview

Liquid Glass is Apple's design language for macOS 26 (Tahoe), emphasizing:
- **Translucent materials** with adaptive blur
- **Depth hierarchy** through elevation
- **Fluid motion** with physics-based animation
- **Spatial awareness** responding to context
- **Seamless integration** with system UI

### Key Differentiators from Previous macOS Versions

**macOS 26 (Liquid Glass):**
- Translucent materials everywhere
- Physics-based spring animations
- Adaptive blur and vibrancy
- Contextual depth

**macOS 25 and earlier:**
- Flat or subtle gradients
- Simple opacity transitions
- Static backgrounds
- Minimal depth cues

## Core Principles

### 1. Depth and Materiality

Create visual hierarchy through layering and translucency:

```swift
// ✅ Proper depth hierarchy
struct LayeredInterface: View {
    var body: some View {
        ZStack {
            // Level 0: Base background
            Color.background
                .ignoresSafeArea()

            // Level 1: Primary content
            ScrollView {
                ContentView()
            }
            .background(.background)

            // Level 2: Floating panels
            VStack {
                SidebarPanel()
                    .background(.regularMaterial)  // Translucent
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 10, y: 4)
            }

            // Level 3: Overlays and popovers
            if showInspector {
                InspectorPanel()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 20, y: 10)
            }

            // Level 4: Modals and dialogs
            if showModal {
                ModalDialog()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 30, y: 15)
            }
        }
    }
}
```

**Depth levels:**
- **Level 0:** Window background (solid)
- **Level 1:** Primary content (solid or thin material)
- **Level 2:** Secondary panels (regular material)
- **Level 3:** Floating panels (ultra-thin material)
- **Level 4:** Modals (regular material + heavy shadow)

### 2. Fluid Motion

All animations should feel natural and physics-based:

```swift
// ✅ Liquid Glass motion
struct FluidAnimation: View {
    @State private var isExpanded = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue)
            .frame(height: isExpanded ? 300 : 100)
            // Spring animation with natural bounce
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: isExpanded)
            .onTapGesture {
                isExpanded.toggle()
            }
    }
}
```

**Animation timing:**
- **Quick (0.2s):** Hover states, highlights
- **Standard (0.3-0.4s):** Most interactions
- **Deliberate (0.5s):** Major state changes
- **Slow (0.8s+):** Page transitions

**Spring parameters:**
```swift
// Bouncy (energetic feel)
.spring(response: 0.3, dampingFraction: 0.6)

// Smooth (polished feel)
.spring(response: 0.4, dampingFraction: 0.75)

// Gentle (subtle feel)
.spring(response: 0.5, dampingFraction: 0.85)

// Slow (deliberate feel)
.spring(response: 0.8, dampingFraction: 0.9)
```

### 3. Contextual Hierarchy

UI elements should adapt to their context:

```swift
// ✅ Contextual styling
struct ContextualCard: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered = false
    @State private var isPressed = false

    var body: some View {
        VStack {
            // Content
        }
        .padding()
        .background(material)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: shadowColor, radius: shadowRadius, y: shadowY)
        .scaleEffect(isPressed ? 0.98 : isHovered ? 1.02 : 1.0)
        .onHover { isHovered = $0 }
    }

    var material: Material {
        switch (isHovered, colorScheme) {
        case (true, .dark): return .regularMaterial
        case (true, .light): return .regularMaterial
        case (false, _): return .thinMaterial
        }
    }

    var shadowColor: Color {
        colorScheme == .dark
            ? .white.opacity(0.05)
            : .black.opacity(0.1)
    }

    var shadowRadius: CGFloat {
        isHovered ? 20 : 10
    }

    var shadowY: CGFloat {
        isHovered ? 8 : 4
    }
}
```

### 4. Adaptive Color

Colors adapt to light/dark mode and context:

```swift
// ✅ Adaptive color usage
struct AdaptiveColors: View {
    var body: some View {
        VStack(spacing: 16) {
            // Semantic colors (auto-adapt)
            Text("Primary")
                .foregroundStyle(.primary)

            Text("Secondary")
                .foregroundStyle(.secondary)

            Text("Tertiary")
                .foregroundStyle(.tertiary)

            // Background hierarchy
            Rectangle()
                .fill(.background)              // Level 0

            Rectangle()
                .fill(.secondaryBackground)     // Level 1

            Rectangle()
                .fill(.tertiaryBackground)      // Level 2

            // Accent colors
            Button("Action") {}
                .buttonStyle(.borderedProminent)  // Uses accent color
        }
    }
}
```

### 5. Spatial Awareness

UI responds to mouse position, focus, and state:

```swift
// ✅ Spatially aware component
struct AwareButton: View {
    @State private var isHovered = false
    @State private var mouseLocation: CGPoint = .zero

    var body: some View {
        GeometryReader { geometry in
            Button("Interactive") {
                action()
            }
            .buttonStyle(.borderless)
            .padding()
            .background {
                // Gradient follows mouse
                RadialGradient(
                    colors: [
                        .blue.opacity(0.3),
                        .blue.opacity(0.0)
                    ],
                    center: UnitPoint(
                        x: mouseLocation.x / geometry.size.width,
                        y: mouseLocation.y / geometry.size.height
                    ),
                    startRadius: 0,
                    endRadius: 100
                )
                .opacity(isHovered ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: mouseLocation)
            }
            .onContinuousHover { phase in
                switch phase {
                case .active(let location):
                    mouseLocation = location
                    isHovered = true
                case .ended:
                    isHovered = false
                }
            }
        }
    }
}
```

## Materials and Translucency

### Material Types

```swift
// macOS 26 material hierarchy
enum MaterialUsage {
    case ultraThin    // Floating popovers, tooltips
    case thin         // Secondary panels
    case regular      // Primary sidebars, toolbars
    case thick        // Heavy emphasis panels
    case bar          // Navigation bars
}

struct MaterialExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Ultra-thin: Most transparent
            Text("Ultra Thin Material")
                .padding()
                .background(.ultraThinMaterial)

            // Thin: Light translucency
            Text("Thin Material")
                .padding()
                .background(.thinMaterial)

            // Regular: Standard translucency
            Text("Regular Material")
                .padding()
                .background(.regularMaterial)

            // Thick: Heavier, more opaque
            Text("Thick Material")
                .padding()
                .background(.thickMaterial)

            // Bar: Optimized for toolbars
            Text("Bar Material")
                .padding()
                .background(.bar)
        }
    }
}
```

### Vibrancy

Vibrancy adjusts content color to work with underlying materials:

```swift
// ✅ Proper vibrancy usage
struct VibrantUI: View {
    var body: some View {
        ZStack {
            // Complex background
            Image("photo")
                .resizable()
                .aspectRatio(contentMode: .fill)

            // Vibrant overlay
            VStack {
                Text("Title")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Subtitle")
                    .font(.title3)
            }
            .padding(32)
            .background(.regularMaterial)
            .foregroundStyle(.primary)  // Vibrancy adjusts this
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
```

### Glass Effects

Create sophisticated glass panels:

```swift
// ✅ Complete glass panel
struct GlassPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.blue)

                Text("Information")
                    .font(.headline)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.borderless)
            }

            Text("This is a glass panel with proper translucency, borders, and shadows.")
                .font(.body)
                .foregroundStyle(.secondary)

            Divider()

            HStack {
                Button("Cancel") { }
                    .buttonStyle(.bordered)

                Spacer()

                Button("Confirm") { }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        // Subtle border
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        // Depth shadow
        .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        // Outer glow (light mode)
        .shadow(color: .white.opacity(0.05), radius: 1, y: -1)
    }
}
```

## Depth and Elevation

### Shadow System

```swift
// Standardized shadow levels
extension View {
    func elevationShadow(level: Int, isHovered: Bool = false) -> some View {
        let config = ShadowConfig.config(for: level, isHovered: isHovered)
        return self
            .shadow(color: config.color, radius: config.radius, y: config.y)
    }
}

struct ShadowConfig {
    let color: Color
    let radius: CGFloat
    let y: CGFloat

    static func config(for level: Int, isHovered: Bool) -> ShadowConfig {
        let multiplier: CGFloat = isHovered ? 1.5 : 1.0

        switch level {
        case 0:  // Base (no shadow)
            return ShadowConfig(color: .clear, radius: 0, y: 0)

        case 1:  // Slight elevation
            return ShadowConfig(
                color: .black.opacity(0.05),
                radius: 10 * multiplier,
                y: 4 * multiplier
            )

        case 2:  // Card elevation
            return ShadowConfig(
                color: .black.opacity(0.08),
                radius: 15 * multiplier,
                y: 6 * multiplier
            )

        case 3:  // Panel elevation
            return ShadowConfig(
                color: .black.opacity(0.1),
                radius: 20 * multiplier,
                y: 10 * multiplier
            )

        case 4:  // Modal elevation
            return ShadowConfig(
                color: .black.opacity(0.15),
                radius: 30 * multiplier,
                y: 15 * multiplier
            )

        default:
            return ShadowConfig(color: .clear, radius: 0, y: 0)
        }
    }
}

// Usage
struct ElevatedCard: View {
    @State private var isHovered = false

    var body: some View {
        VStack {
            // Content
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .elevationShadow(level: 2, isHovered: isHovered)
        .onHover { isHovered = $0 }
    }
}
```

### Layering Order

```swift
// ✅ Proper Z-index hierarchy
struct LayeredApp: View {
    var body: some View {
        ZStack {
            // Layer 0: Background (z: 0)
            BackgroundView()
                .zIndex(0)

            // Layer 1: Main content (z: 1)
            MainContentView()
                .zIndex(1)

            // Layer 2: Sidebars (z: 2)
            HStack {
                Sidebar()
                Spacer()
                InspectorSidebar()
            }
            .zIndex(2)

            // Layer 3: Floating panels (z: 3)
            if showFloatingPanel {
                FloatingPanel()
                    .zIndex(3)
            }

            // Layer 4: Overlays (z: 4)
            if showOverlay {
                OverlayView()
                    .zIndex(4)
            }

            // Layer 5: Modals (z: 5)
            if showModal {
                ModalDialog()
                    .zIndex(5)
            }

            // Layer 6: Tooltips (z: 6)
            TooltipView()
                .zIndex(6)
        }
    }
}
```

## Color System

### Semantic Colors

```swift
// macOS 26 semantic color palette
struct SemanticColors {
    // Text colors
    static let textPrimary = Color.primary         // Main text
    static let textSecondary = Color.secondary     // Supporting text
    static let textTertiary = Color.tertiary       // Subtle text
    static let textPlaceholder = Color.gray.opacity(0.5)

    // Background colors
    static let background = Color.background                    // Level 0
    static let backgroundSecondary = Color.secondaryBackground  // Level 1
    static let backgroundTertiary = Color.tertiaryBackground    // Level 2

    // Interactive colors
    static let accentColor = Color.accentColor     // Primary actions
    static let linkColor = Color.blue              // Links
    static let selectionColor = Color.accentColor.opacity(0.2)

    // System colors
    static let successColor = Color.green
    static let warningColor = Color.orange
    static let errorColor = Color.red
    static let infoColor = Color.blue
}

// Usage
Text("Primary text")
    .foregroundStyle(SemanticColors.textPrimary)

Rectangle()
    .fill(SemanticColors.background)
```

### Custom Color Palettes

```swift
// Define in Assets.xcassets for automatic dark mode
extension Color {
    // Brand colors
    static let brandPrimary = Color("BrandPrimary")
    static let brandSecondary = Color("BrandSecondary")

    // UI colors
    static let cardBackground = Color("CardBackground")
    static let cardBorder = Color("CardBorder")

    // Custom semantic
    static let codeBackground = Color("CodeBackground")
    static let codeForeground = Color("CodeForeground")
}

// In Assets.xcassets, define both appearances:
// BrandPrimary:
//   - Any Appearance: #007AFF
//   - Dark Appearance: #0A84FF
```

### Gradient System

```swift
// Liquid Glass gradients
struct GlassGradients {
    // Subtle background gradient
    static let subtle = LinearGradient(
        colors: [
            .white.opacity(0.1),
            .white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Accent gradient
    static let accent = LinearGradient(
        colors: [
            .blue.opacity(0.8),
            .purple.opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Shimmer effect
    static func shimmer(phase: CGFloat) -> LinearGradient {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: .white.opacity(0.3), location: phase),
                .init(color: .clear, location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// Usage
struct GradientCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(GlassGradients.subtle)
            .background(.regularMaterial)
    }
}
```

## Typography

### Type Scale

```swift
// macOS 26 type scale
struct Typography {
    // Display styles
    static let largeTitle = Font.largeTitle      // 26pt
    static let title1 = Font.title               // 22pt
    static let title2 = Font.title2              // 17pt
    static let title3 = Font.title3              // 15pt

    // Body styles
    static let headline = Font.headline          // 13pt semibold
    static let body = Font.body                  // 13pt
    static let callout = Font.callout            // 12pt
    static let subheadline = Font.subheadline    // 11pt

    // Small styles
    static let footnote = Font.footnote          // 10pt
    static let caption1 = Font.caption           // 10pt
    static let caption2 = Font.caption2          // 9pt
}
```

### Typography Hierarchy

```swift
// ✅ Proper hierarchy
struct TypeHierarchy: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Page title
            Text("Document Title")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            // Section title
            Text("Section Heading")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.top, 16)

            // Subsection
            Text("Subsection")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.top, 8)

            // Body text
            Text("This is body text with proper line spacing and readable contrast.")
                .font(.body)
                .foregroundStyle(.primary)
                .lineSpacing(4)

            // Supporting text
            Text("Additional information or metadata")
                .font(.callout)
                .foregroundStyle(.secondary)

            // Fine print
            Text("Last updated 2 hours ago")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
}
```

### Custom Fonts

```swift
// Register custom fonts
extension Font {
    static let customLargeTitle = Font.custom("YourFont-Bold", size: 26)
    static let customTitle = Font.custom("YourFont-Semibold", size: 22)
    static let customBody = Font.custom("YourFont-Regular", size: 13)

    // With dynamic type support
    static func customScaledFont(_ name: String, size: CGFloat) -> Font {
        Font.custom(name, size: size, relativeTo: .body)
    }
}

// Usage with fallback
Text("Custom Typography")
    .font(.custom("SF Mono", size: 13, relativeTo: .body))
```

## Spacing and Layout

### 8-Point Grid

```swift
// Standard spacing units (all multiples of 8)
enum Spacing {
    static let xxxs: CGFloat = 2   // Rare, very tight
    static let xxs: CGFloat = 4    // Half grid
    static let xs: CGFloat = 8     // Tight
    static let sm: CGFloat = 12    // Small (1.5× grid)
    static let md: CGFloat = 16    // Comfortable (2× grid)
    static let lg: CGFloat = 24    // Loose (3× grid)
    static let xl: CGFloat = 32    // Section spacing (4× grid)
    static let xxl: CGFloat = 48   // Large gaps (6× grid)
    static let xxxl: CGFloat = 64  // Major sections (8× grid)
}

// Usage
VStack(spacing: Spacing.md) {
    Text("Title")
        .padding(.bottom, Spacing.xs)

    Text("Content")
        .padding(.horizontal, Spacing.lg)

    Divider()
        .padding(.vertical, Spacing.xl)
}
```

### Layout Patterns

```swift
// ✅ Standard layout template
struct StandardLayout: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView()
                .padding(Spacing.lg)
                .background(.bar)

            Divider()

            // Content
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // Sections with 32pt spacing
                    ForEach(sections) { section in
                        SectionView(section: section)
                            .padding(.horizontal, Spacing.lg)
                    }
                }
                .padding(.vertical, Spacing.lg)
            }

            Divider()

            // Footer
            FooterView()
                .padding(Spacing.md)
                .background(.bar)
        }
    }
}
```

### Responsive Layout

```swift
// Adaptive layout based on window size
struct ResponsiveLayout: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        Group {
            if sizeClass == .compact {
                // Single column for narrow windows
                VStack(spacing: Spacing.md) {
                    Sidebar()
                    DetailView()
                }
            } else {
                // Side-by-side for wide windows
                HStack(spacing: 0) {
                    Sidebar()
                        .frame(width: 250)

                    Divider()

                    DetailView()
                }
            }
        }
    }
}
```

## Animation and Motion

### Spring Animations

```swift
// Predefined spring curves
extension Animation {
    // Quick, bouncy
    static let liquidQuick = Animation.spring(
        response: 0.3,
        dampingFraction: 0.6,
        blendDuration: 0
    )

    // Smooth, polished
    static let liquidSmooth = Animation.spring(
        response: 0.4,
        dampingFraction: 0.75,
        blendDuration: 0
    )

    // Gentle, subtle
    static let liquidGentle = Animation.spring(
        response: 0.5,
        dampingFraction: 0.85,
        blendDuration: 0
    )

    // Slow, deliberate
    static let liquidSlow = Animation.spring(
        response: 0.8,
        dampingFraction: 0.9,
        blendDuration: 0
    )
}

// Usage
struct AnimatedElement: View {
    @State private var isExpanded = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(height: isExpanded ? 300 : 100)
            .animation(.liquidSmooth, value: isExpanded)
    }
}
```

### Transition Effects

```swift
// Liquid Glass transitions
struct TransitionExample: View {
    @State private var showDetail = false

    var body: some View {
        VStack {
            if showDetail {
                DetailView()
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9)
                            .combined(with: .opacity)
                            .combined(with: .move(edge: .top)),
                        removal: .scale(scale: 0.95)
                            .combined(with: .opacity)
                    ))
            }
        }
        .animation(.liquidSmooth, value: showDetail)
    }
}
```

### Interactive Animations

```swift
// Gesture-driven animation
struct DraggableCard: View {
    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.blue)
            .frame(width: 200, height: 300)
            .offset(offset)
            .scaleEffect(isDragging ? 1.05 : 1.0)
            .shadow(
                color: .black.opacity(isDragging ? 0.2 : 0.1),
                radius: isDragging ? 30 : 20,
                y: isDragging ? 15 : 10
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                        isDragging = true
                    }
                    .onEnded { _ in
                        withAnimation(.liquidSmooth) {
                            offset = .zero
                            isDragging = false
                        }
                    }
            )
    }
}
```

## Component Patterns

### Cards

```swift
// ✅ Liquid Glass card component
struct GlassCard<Content: View>: View {
    let content: Content
    @State private var isHovered = false

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.lg)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(
                color: .black.opacity(isHovered ? 0.15 : 0.08),
                radius: isHovered ? 20 : 15,
                y: isHovered ? 8 : 6
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.liquidSmooth, value: isHovered)
            .onHover { isHovered = $0 }
    }
}

// Usage
GlassCard {
    VStack(alignment: .leading, spacing: Spacing.sm) {
        Text("Card Title")
            .font(.headline)

        Text("Card content goes here")
            .font(.body)
            .foregroundStyle(.secondary)
    }
}
```

### Buttons

```swift
// ✅ Liquid Glass button styles
struct GlassButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.regularMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.liquidQuick, value: configuration.isPressed)
    }
}

// Usage
Button("Glass Button") {
    action()
}
.buttonStyle(GlassButton())
```

### Lists

```swift
// ✅ Liquid Glass list
struct GlassList<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xs) {
                ForEach(items) { item in
                    GlassListRow {
                        content(item)
                    }
                }
            }
            .padding(Spacing.sm)
        }
    }
}

struct GlassListRow<Content: View>: View {
    let content: Content
    @State private var isHovered = false

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovered ? .regularMaterial : .clear)
            )
            .onHover { isHovered = $0 }
    }
}
```

## Implementation Examples

### Full Glass Window

```swift
// Complete example: Main app window with Liquid Glass
struct GlassMainWindow: View {
    @State private var selectedTab: Tab = .editor
    @State private var showSidebar = true

    var body: some View {
        NavigationSplitView(columnVisibility: $showSidebar ? .all : .detailOnly) {
            // Sidebar
            SidebarView(selectedTab: $selectedTab)
                .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        } detail: {
            // Main content
            TabView(selection: $selectedTab) {
                EditorView()
                    .tag(Tab.editor)

                PreviewView()
                    .tag(Tab.preview)

                SettingsView()
                    .tag(Tab.settings)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    withAnimation(.liquidSmooth) {
                        showSidebar.toggle()
                    }
                } label: {
                    Label("Toggle Sidebar", systemImage: "sidebar.left")
                }
            }
        }
    }
}

struct SidebarView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        List(selection: $selectedTab) {
            Section("Content") {
                Label("Editor", systemImage: "doc.text")
                    .tag(Tab.editor)

                Label("Preview", systemImage: "eye")
                    .tag(Tab.preview)
            }

            Section("Settings") {
                Label("Preferences", systemImage: "gearshape")
                    .tag(Tab.settings)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Argute")
    }
}
```

### Floating Panels

```swift
// Inspector panel with glass effect
struct InspectorPanel: View {
    @State private var selectedSection: InspectorSection = .properties

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Inspector")
                    .font(.headline)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.borderless)
            }
            .padding(Spacing.md)

            Divider()

            // Tabs
            Picker("Section", selection: $selectedSection) {
                Text("Properties").tag(InspectorSection.properties)
                Text("Metadata").tag(InspectorSection.metadata)
            }
            .pickerStyle(.segmented)
            .padding(Spacing.md)

            // Content
            ScrollView {
                Group {
                    switch selectedSection {
                    case .properties:
                        PropertiesView()
                    case .metadata:
                        MetadataView()
                    }
                }
                .padding(Spacing.md)
            }
        }
        .frame(width: 300, height: 500)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
    }
}
```

## Best Practices

### Do's ✅

1. **Use materials for depth**
   - Apply `.regularMaterial` to floating panels
   - Use `.ultraThinMaterial` for overlays
   - Let system materials adapt to dark mode

2. **Animate with springs**
   - All interactions should feel fluid
   - Use `.liquidSmooth` for most animations
   - Respect reduced motion preferences

3. **Layer with elevation**
   - Create clear visual hierarchy
   - Use consistent shadow system
   - Increase shadow on hover

4. **Respect context**
   - Adapt to dark mode automatically
   - Scale with Dynamic Type
   - Respond to system preferences

5. **Polish interactions**
   - Add hover states
   - Provide immediate feedback
   - Use spatial awareness

### Don'ts ❌

1. **Don't use flat designs**
   - Avoid purely solid backgrounds
   - Don't skip shadow and depth
   - Don't ignore translucency

2. **Don't use harsh animations**
   - Avoid linear timing
   - Don't use abrupt transitions
   - Don't forget spring physics

3. **Don't break the grid**
   - All spacing must be 8pt multiples
   - Don't use arbitrary values
   - Maintain alignment

4. **Don't ignore dark mode**
   - Test both appearances
   - Use semantic colors
   - Verify contrast ratios

5. **Don't overcomplicate**
   - Keep it simple and native
   - Use system components when possible
   - Don't add unnecessary flourishes

## Testing Checklist

Before shipping:

- [ ] All materials blur correctly
- [ ] Shadows render at proper elevations
- [ ] Animations feel natural and fluid
- [ ] Spacing follows 8pt grid
- [ ] Dark mode looks polished
- [ ] Hover states work smoothly
- [ ] Focus indicators are visible
- [ ] Accessibility is maintained
- [ ] Performance is smooth
- [ ] Works with reduced motion
- [ ] Respects system preferences
- [ ] Feels native to macOS 26

---

This completes the Liquid Glass Design System guide. Use these patterns and principles to create polished, native-feeling macOS 26 applications.
