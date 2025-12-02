---
name: swiftui-components
description: Reusable SwiftUI component patterns, custom controls, layouts, and animations for any SwiftUI app (macOS, iOS). Use for creating custom views, animations, gestures, layout techniques, component architecture.
skill_type: user
tags: [swiftui, components, custom-controls, animations, layouts, gestures, swift6]
---

# SwiftUI Components Skill

Patterns and techniques for building reusable SwiftUI components in any application.

## When to Use

- "Create a custom control"
- "Build reusable component"
- "Add animation to view"
- "Custom layout technique"
- "Gesture handling"
- "Component library"
- "Reusable card component"
- "Custom button style"

## Component Architecture

### Basic Component Pattern

```swift
/// Reusable card component
struct Card<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(.background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
    }
}

// Usage
Card {
    VStack {
        Text("Title")
        Text("Description")
    }
}
```

### Configurable Component

```swift
struct CustomButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    var style: ButtonStyle = .primary

    enum ButtonStyle {
        case primary, secondary, destructive
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
        }
        .buttonStyle(buttonStyle(for: style))
    }

    private func buttonStyle(for style: ButtonStyle) -> some PrimitiveButtonStyle {
        switch style {
        case .primary: return .borderedProminent
        case .secondary: return .bordered
        case .destructive: return .borderedProminent  // Apply red tint separately
        }
    }
}
```

## Custom Controls

### Toggle Control

```swift
struct CustomToggle: View {
    @Binding var isOn: Bool
    let label: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isOn.toggle()
        }
    }
}

// Usage
@State private var enabled = false
CustomToggle(isOn: $enabled, label: "Enable Feature")
```

### Slider with Value Display

```swift
struct LabeledSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let label: String
    let format: String

    init(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        label: String,
        format: String = "%.0f"
    ) {
        self._value = value
        self.range = range
        self.label = label
        self.format = format
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label)
                Spacer()
                Text(String(format: format, value))
                    .foregroundStyle(.secondary)
            }
            Slider(value: $value, in: range)
        }
    }
}
```

### Segmented Picker

```swift
struct SegmentedPicker<T: Hashable>: View {
    @Binding var selection: T
    let options: [(T, String)]  // (value, label)

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(options, id: \\.0) { option in
                Text(option.1).tag(option.0)
            }
        }
        .pickerStyle(.segmented)
    }
}

// Usage
enum ViewMode { case list, grid }
@State private var mode: ViewMode = .list

SegmentedPicker(
    selection: $mode,
    options: [
        (.list, "List"),
        (.grid, "Grid")
    ]
)
```

## Layout Techniques

### Adaptive Grid

```swift
struct AdaptiveGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    let minItemWidth: CGFloat
    let spacing: CGFloat
    let itemView: (Item) -> ItemView

    init(
        items: [Item],
        minItemWidth: CGFloat = 150,
        spacing: CGFloat = 16,
        @ViewBuilder itemView: @escaping (Item) -> ItemView
    ) {
        self.items = items
        self.minItemWidth = minItemWidth
        self.spacing = spacing
        self.itemView = itemView
    }

    var body: some View {
        GeometryReader { geometry in
            let columns = max(1, Int(geometry.size.width / minItemWidth))
            let gridItems = Array(
                repeating: GridItem(.flexible(), spacing: spacing),
                count: columns
            )

            ScrollView {
                LazyVGrid(columns: gridItems, spacing: spacing) {
                    ForEach(items) { item in
                        itemView(item)
                    }
                }
                .padding(spacing)
            }
        }
    }
}
```

### Flow Layout (Tags/Pills)

```swift
struct FlowLayout<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    let spacing: CGFloat
    let itemView: (Item) -> ItemView

    @State private var totalHeight: CGFloat = 0

    init(
        items: [Item],
        spacing: CGFloat = 8,
        @ViewBuilder itemView: @escaping (Item) -> ItemView
    ) {
        self.items = items
        self.spacing = spacing
        self.itemView = itemView
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(items) { item in
                itemView(item)
                    .padding(spacing)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item.id == items.last?.id {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item.id == items.last?.id {
                            height = 0
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: ViewHeightKey.self,
                    value: geometry.size.height
                )
        }
        .onPreferenceChange(ViewHeightKey.self) { height in
            binding.wrappedValue = height
        }
    }
}

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
```

## Animations

### Spring Animation

```swift
struct BouncyButton: View {
    @State private var isPressed = false

    var body: some View {
        Button("Press Me") {
            // Action
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .pressEvents {
            isPressed = true
        } onRelease: {
            isPressed = false
        }
    }
}

// Helper for press events
extension View {
    func pressEvents(
        onPress: @escaping () -> Void,
        onRelease: @escaping () -> Void
    ) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
    }
}
```

### Transition Animation

```swift
struct ExpandableCard: View {
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Title")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                Text("Detailed content goes here...")
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(.background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
```

### Loading Spinner

```swift
struct LoadingSpinner: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.accentColor, lineWidth: 3)
            .frame(width: 30, height: 30)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 1).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
```

## Gesture Handling

### Draggable Component

```swift
struct DraggableView: View {
    @State private var offset = CGSize.zero

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.blue)
            .frame(width: 100, height: 100)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
    }
}
```

### Swipe to Delete

```swift
struct SwipeToDeleteRow<Content: View>: View {
    let content: Content
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0
    @State private var isSwiped = false

    init(
        onDelete: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onDelete = onDelete
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 80)
                    .background(Color.red)
            }

            // Content
            content
                .background(Color(nsColor: .controlBackgroundColor))
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation.width
                            if translation < 0 {
                                offset = max(translation, -80)
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if offset < -40 {
                                    offset = -80
                                    isSwiped = true
                                } else {
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
        }
        .clipShape(Rectangle())
    }
}
```

## Component Patterns

### Empty State

```swift
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .bold()

                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

### Loading State

```swift
struct LoadingView: View {
    let message: String

    init(_ message: String = "Loading...") {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

### Error State

```swift
struct ErrorView: View {
    let error: Error
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)

            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.title2)
                    .bold()

                Text(error.localizedDescription)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding(40)
    }
}
```

## Best Practices

### Component Reusability

1. **Use @ViewBuilder** for flexible content
2. **Provide defaults** for optional parameters
3. **Keep components focused** - Single responsibility
4. **Use protocols** for behavior abstraction
5. **Document usage** - Add examples in comments

### Performance

1. **Use LazyVStack/LazyHStack** for long lists
2. **Implement Equatable** for complex views
3. **Avoid expensive body calculations**
4. **Use @StateObject sparingly** - Prefer @State with @Observable
5. **Profile with Instruments** before optimizing

### Accessibility

1. **Add accessibility labels**
2. **Support VoiceOver**
3. **Keyboard navigation**
4. **Sufficient contrast**
5. **Dynamic Type support**

## Reference Material

See additional files:
- `reference/layout-techniques.md` - Advanced layouts
- `reference/animation-patterns.md` - Animation guide
- `templates/CustomControl-Minimal.swift` - Control template
- `templates/AnimatedCard-Minimal.swift` - Animation template

## Quick Patterns

### Conditional Content
```swift
@ViewBuilder
func content() -> some View {
    if condition {
        ViewA()
    } else {
        ViewB()
    }
}
```

### Optional Content
```swift
@ViewBuilder
func optionalView<T>(_ value: T?) -> some View {
    if let value {
        Text("\\(value)")
    }
}
```

### Environment Values
```swift
struct CustomKey: EnvironmentKey {
    static let defaultValue = "default"
}

extension EnvironmentValues {
    var customValue: String {
        get { self[CustomKey.self] }
        set { self[CustomKey.self] = newValue }
    }
}

// Usage
.environment(\\.customValue, "custom")
```
