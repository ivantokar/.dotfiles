---
name: swiftui-debug
description: Debug SwiftUI view and state management issues in any SwiftUI app (macOS, iOS, watchOS, tvOS). Use for @Observable, property wrappers, view updates, memory leaks, retain cycles, performance problems, threading issues.
skill_type: user
tags: [swiftui, debugging, observable, state-management, swift6, memory-leaks]
---

# SwiftUI Debugging Skill

Universal SwiftUI debugging guidance for macOS 26+ / iOS 26+ with Swift 6+. Works for **any SwiftUI application**.

## When to Use

- "View isn't updating"
- "State changes not reflecting"
- "@Observable not working"
- "Memory leak in SwiftUI"
- "Retain cycle warning"
- "View performance issues"
- "@StateObject vs @ObservedObject confusion"
- "Threading/actor isolation errors"

## Quick Diagnostic Checklist

### View Not Updating?
1. ✓ ViewModel uses `@Observable` macro
2. ✓ Properties are `var` (not `let`)
3. ✓ ViewModel injected via `.environment()`
4. ✓ View reads via `@Environment`
5. ✓ Updates happen on `@MainActor`

### Memory Issues?
1. ✓ Check closures use `[weak self]`
2. ✓ Verify delegate references are `weak`
3. ✓ Use Memory Graph Debugger
4. ✓ Check `deinit` is called

### Performance Slow?
1. ✓ Profile with Instruments
2. ✓ Check for expensive body calculations
3. ✓ Use `Equatable` on views
4. ✓ Verify list performance (LazyVStack)

## Modern SwiftUI Architecture (Swift 6+)

### ✅ CORRECT - Modern Pattern

```swift
// 1. ViewModel with @Observable
import Observation

@MainActor
@Observable
class ViewModel {
    var data: String = ""
    var isLoading: Bool = false

    // For cleanup - nonisolated(unsafe) is correct here
    nonisolated(unsafe) private var task: Task<Void, Never>?

    func load() async {
        isLoading = true
        // Your async work
        isLoading = false
    }

    deinit {
        task?.cancel()
    }
}

// 2. App - Create with @State
@main
struct MyApp: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}

// 3. View - Read-only access
struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        Text(viewModel.data)
        Button("Load") {
            Task { await viewModel.load() }
        }
    }
}

// 4. View - Two-way binding
struct EditView: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        @Bindable var vm = viewModel
        TextField("Data", text: $vm.data)
    }
}
```

### ❌ WRONG - Legacy Pattern (Don't Use)

```swift
// OLD - Don't use in new code
import Combine

class LegacyViewModel: ObservableObject {
    @Published var data: String = ""
}

@StateObject private var viewModel = VM()
@ObservedObject var viewModel: VM
@EnvironmentObject var shared: SharedVM
.environmentObject(vm)
```

## Common Issues & Solutions

### Issue 1: View Not Updating

**Symptom:** Change property but view doesn't update

**Causes:**
- Missing `@Observable` macro
- Using `let` instead of `var`
- Not injected via `.environment()`
- Background thread update

**Solution:**
```swift
// Check 1: @Observable present
@Observable  // ← Must have this
class Model {
    var value: Int = 0  // ← Must be var
}

// Check 2: Proper injection
.environment(model)  // ← Must inject

// Check 3: View usage
@Environment(Model.self) private var model  // ← Must use @Environment
Text("\\(model.value)")  // ← Reading observed property

// Check 4: Main thread
@MainActor  // ← Add to class
@Observable
class Model { }
```

### Issue 2: Retain Cycles

**Symptom:** Memory keeps growing, deinit not called

**Detection:**
```swift
// Add print in deinit
deinit {
    print("\\(Self.self) deallocated")  // Should print when done
}
```

**Common causes:**
```swift
// ❌ BAD - Strong capture
class Model {
    var closure: (() -> Void)?

    func setup() {
        closure = {
            self.doWork()  // Strong reference!
        }
    }
}

// ✅ GOOD - Weak capture
class Model {
    var closure: (() -> Void)?

    func setup() {
        closure = { [weak self] in
            self?.doWork()
        }
    }
}
```

**Using Memory Graph:**
1. Run app in Xcode
2. Click Debug Memory Graph button
3. Look for purple ! icons
4. Fix strong references

### Issue 3: nonisolated(unsafe) Warning

**This is CORRECT for @Observable + deinit:**

```swift
@MainActor
@Observable
class Model {
    // This warning is expected and safe
    nonisolated(unsafe) private var task: Task<Void, Never>?

    deinit {
        task?.cancel()  // Needs nonisolated(unsafe) to access
    }
}
```

**Why:** `deinit` isn't isolated to any actor, but the property is `@MainActor` isolated. This is the correct Swift 6 pattern for cleanup.

### Issue 4: ForEach Not Updating

**Problem:**
```swift
// ❌ Items change but list doesn't update
ForEach(items) { item in
    Text(item.name)
}
```

**Solutions:**
```swift
// ✅ Option 1: Make Item Identifiable
struct Item: Identifiable {
    let id: UUID
    var name: String
}
ForEach(items) { item in
    Text(item.name)
}

// ✅ Option 2: Use explicit id
ForEach(items, id: \\.name) { item in
    Text(item.name)
}

// ✅ Option 3: Force refresh
ForEach(items) { item in
    Text(item.name)
}
.id(items.map(\\.id))
```

### Issue 5: Threading Errors

**Problem:** Updates from background thread

```swift
// ❌ BAD - Might be on background thread
Task {
    let data = await fetchData()
    viewModel.data = data  // Runtime crash!
}

// ✅ GOOD - Explicit main actor
Task {
    let data = await fetchData()
    await MainActor.run {
        viewModel.data = data
    }
}

// ✅ BETTER - ViewModel is @MainActor
@MainActor
@Observable
class ViewModel {
    func load() async {
        let data = await fetchData()
        self.data = data  // Already on MainActor!
    }
}
```

## Performance Debugging

### Expensive Body Calculations

```swift
// ❌ BAD - Runs every body evaluation
struct MyView: View {
    let items: [Item]

    var body: some View {
        let sorted = items.sorted()  // Expensive!
        ForEach(sorted) { item in
            Text(item.name)
        }
    }
}

// ✅ GOOD - Cached
struct MyView: View {
    let items: [Item]

    private var sortedItems: [Item] {
        items.sorted()
    }

    var body: some View {
        ForEach(sortedItems) { item in
            Text(item.name)
        }
    }
}

// ✅ BETTER - With Equatable
struct MyView: View, Equatable {
    let items: [Item]

    var body: some View {
        ForEach(items) { item in
            Text(item.name)
        }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.items.count == rhs.items.count
    }
}
```

### Profile with Instruments

1. Product → Profile (⌘I)
2. Choose "SwiftUI" or "Time Profiler"
3. Record interaction
4. Look for:
   - Frequent `body` calls
   - Expensive operations
   - Long frames (>16ms)

## Debugging Workflow

1. **Identify symptom** - What exactly isn't working?
2. **Check basics** - @Observable, @MainActor, injection
3. **Add prints** - Debug where values change
4. **Use breakpoints** - Step through code
5. **Profile if slow** - Use Instruments
6. **Check memory** - Memory Graph for leaks
7. **Test fix** - Verify in light and dark mode

## Tools

- **Xcode Debugger** - Breakpoints, variable inspection
- **Memory Graph** - Detect retain cycles (⌘⇧M)
- **Instruments** - Performance profiling (⌘I)
- **Console** - System warnings, errors
- **View Debugger** - 3D view hierarchy (⌘⌥V)

## Reference Material

See additional files:
- `reference/observation-framework.md` - @Observable deep dive
- `reference/property-wrappers.md` - Complete wrapper guide
- `reference/common-issues.md` - Known problems and fixes
- `templates/ViewModel-Minimal.swift` - Minimal ViewModel template
- `templates/View-Minimal.swift` - Minimal View template

## Best Practices

1. Always use `@MainActor` for UI ViewModels
2. Use `@Observable` (not ObservableObject)
3. Use `@State` for @Observable objects (not @StateObject)
4. Use `[weak self]` in closures
5. Accept `nonisolated(unsafe)` warnings in deinit
6. Test in both light and dark mode
7. Profile before optimizing
8. Use Memory Graph to find leaks

## Quick Reference

| Task | Tool | Shortcut |
|------|------|----------|
| Memory Graph | Debug Navigator | ⌘⇧M |
| View Hierarchy | Debug Menu | ⌘⌥V |
| Profile | Product Menu | ⌘I |
| Console | Debug Area | ⌘⇧Y |
| Breakpoint | Click gutter | ⌘\\ |
