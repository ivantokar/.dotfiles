# Observation Framework Deep Dive (macOS 26+ / Swift 6+)

## Overview

The Observation framework is the modern replacement for Combine's `ObservableObject` protocol. It provides automatic, fine-grained observation of property changes.

## Key Concepts

### @Observable Macro

The `@Observable` macro automatically makes a class observable:

```swift
import Observation

@Observable
class Counter {
    var count: Int = 0
    var name: String = "Counter"
}
```

**What it generates:**
- Automatic property observation
- Fine-grained dependency tracking
- Integration with SwiftUI
- No manual `@Published` needed

### How It Works

```swift
// You write:
@Observable
class Model {
    var value: Int = 0
}

// Macro expands to (approximately):
@MainActor
class Model {
    @ObservationTracked
    var value: Int = 0 {
        willSet {
            _$observationRegistrar.willSet(self, keyPath: \\.value)
        }
        didSet {
            _$observationRegistrar.didSet(self, keyPath: \\.value)
        }
    }

    private let _$observationRegistrar = ObservationRegistrar()
}
```

## Property Wrappers in SwiftUI

### @Environment (Modern)

**Purpose:** Inject dependencies into view hierarchy

```swift
// 1. Define observable model
@Observable
class AppModel {
    var username: String = ""
}

// 2. Inject at root
@main
struct MyApp: App {
    @State private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }
    }
}

// 3. Read in any view
struct ContentView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        Text("Hello, \\(model.username)")
    }
}
```

**Key points:**
- Observes only accessed properties (fine-grained)
- Automatic invalidation when dependencies change
- No manual subscription needed

### @State (Modern)

**Purpose:** View-local state

```swift
struct CounterView: View {
    @State private var count = 0
    @State private var viewModel = CounterViewModel()  // ✅ NEW in Swift 6

    var body: some View {
        VStack {
            Text("Count: \\(count)")
            Text("VM: \\(viewModel.data)")

            Button("Increment") {
                count += 1
                viewModel.increment()
            }
        }
    }
}
```

**Modern usage:**
- Can hold @Observable objects directly
- Replaces @StateObject in most cases
- Simpler, more consistent API

### @Bindable

**Purpose:** Create two-way bindings from @Observable objects

```swift
struct SettingsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        @Bindable var model = model  // ← Create bindable wrapper

        Form {
            TextField("Username", text: $model.username)  // ← Two-way binding
            Toggle("Dark Mode", isOn: $model.darkMode)
        }
    }
}
```

**When to use:**
- Need $ (binding) to observable property
- Works with @Environment or @State
- Local to the view (doesn't propagate)

## Migration from ObservableObject

### Before (Legacy - Don't use)

```swift
import Combine

class ViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var count: Int = 0

    private var cancellables = Set<AnyCancellable>()

    init() {
        $text
            .sink { newValue in
                print("Text changed: \\(newValue)")
            }
            .store(in: &cancellables)
    }
}

struct MyView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        TextField("Text", text: $viewModel.text)
    }
}
```

### After (Modern - Use this)

```swift
import Observation

@MainActor
@Observable
class ViewModel {
    var text: String = "" {
        didSet {
            print("Text changed: \\(text)")
        }
    }
    var count: Int = 0
}

struct MyView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        TextField("Text", text: $vm.text)
    }
}
```

## Actor Isolation

### @MainActor on Classes

**Best practice:** Mark ViewModels as @MainActor

```swift
@MainActor
@Observable
class ViewModel {
    var data: String = ""

    func updateData(_ newData: String) {
        self.data = newData  // Guaranteed on main thread
    }

    func fetchData() async {
        let result = await networkRequest()
        self.data = result  // Already on main actor
    }
}
```

**Benefits:**
- All methods run on main thread
- Safe UI updates
- No need for `await MainActor.run {}`
- Caught at compile time

### nonisolated(unsafe) for Cleanup

**Pattern for deinit:**

```swift
@MainActor
@Observable
class ViewModel {
    nonisolated(unsafe) private var task: Task<Void, Never>?
    //              ↑
    //              This warning is EXPECTED and CORRECT

    func start() {
        task = Task {
            // Long-running work
        }
    }

    deinit {
        task?.cancel()
        // deinit is not isolated, needs nonisolated(unsafe)
    }
}
```

**Why unsafe:**
- `deinit` runs when object is being destroyed
- No risk of race condition
- Compiler warning is informational

## Performance Characteristics

### Fine-Grained Observation

```swift
@Observable
class Model {
    var name: String = ""
    var age: Int = 0
}

struct NameView: View {
    @Environment(Model.self) private var model

    var body: some View {
        Text(model.name)  // Only observes 'name'
    }
}

struct AgeView: View {
    @Environment(Model.self) private var model

    var body: some View {
        Text("\\(model.age)")  // Only observes 'age'
    }
}
```

**Result:**
- Changing `name` only updates NameView
- Changing `age` only updates AgeView
- More efficient than ObservableObject (which updates all observers)

### Computed Properties

```swift
@Observable
class Model {
    var firstName: String = ""
    var lastName: String = ""

    var fullName: String {
        "\\(firstName) \\(lastName)"
    }
}

struct MyView: View {
    @Environment(Model.self) private var model

    var body: some View {
        Text(model.fullName)  // Observes firstName AND lastName
    }
}
```

**Smart tracking:**
- Automatically tracks dependencies
- Updates when firstName OR lastName changes
- No manual dependency declaration

## Common Patterns

### 1. App-Wide State

```swift
@Observable
class AppState {
    var user: User?
    var settings: Settings = Settings()
    var isLoading: Bool = false
}

@main
struct MyApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
    }
}
```

### 2. Feature-Specific State

```swift
struct FeatureView: View {
    @State private var viewModel = FeatureViewModel()

    var body: some View {
        // View implementation
            .environment(viewModel)  // Available to child views
    }
}
```

### 3. Mixed Dependencies

```swift
struct MyView: View {
    @Environment(AppState.self) private var appState  // Global
    @State private var localModel = LocalModel()      // Local

    var body: some View {
        VStack {
            Text(appState.user?.name ?? "Guest")
            Text(localModel.temporaryData)
        }
    }
}
```

## Debugging

### Check if Observation is Working

```swift
@Observable
class DebugModel {
    var value: Int = 0 {
        willSet {
            print("Will set value to \\(newValue)")
        }
        didSet {
            print("Did set value from \\(oldValue) to \\(value)")
        }
    }
}
```

### View Update Debugging

```swift
struct DebugView: View {
    @Environment(Model.self) private var model

    var body: some View {
        let _ = print("Body evaluated at \\(Date())")

        Text(model.value)
    }
}
```

### Memory Debugging

```swift
@Observable
class ViewModel {
    init() {
        print("ViewModel created")
    }

    deinit {
        print("ViewModel destroyed")
    }
}
```

## Best Practices

1. **Always use @MainActor for UI ViewModels**
   ```swift
   @MainActor
   @Observable
   class UIViewModel { }
   ```

2. **Use @State for @Observable objects**
   ```swift
   @State private var viewModel = ViewModel()
   ```

3. **Use @Environment for dependency injection**
   ```swift
   @Environment(AppState.self) private var appState
   ```

4. **Use @Bindable for two-way bindings**
   ```swift
   @Bindable var vm = viewModel
   TextField("", text: $vm.text)
   ```

5. **Accept nonisolated(unsafe) warnings for deinit**
   ```swift
   nonisolated(unsafe) private var task: Task<Void, Never>?
   deinit { task?.cancel() }
   ```

## Resources

- [Swift Evolution SE-0395](https://github.com/apple/swift-evolution/blob/main/proposals/0395-observability.md)
- [WWDC 2023: Discover Observation in SwiftUI](https://developer.apple.com/videos/play/wwdc2023/10149/)
- [Observation Documentation](https://developer.apple.com/documentation/observation)
