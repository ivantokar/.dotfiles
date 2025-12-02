# Swift Style Guide

Follow these Swift coding conventions for consistency across Swift projects.

**Swift 6+ | macOS 26.0+ (Tahoe) | Xcode 26+**

## Naming

### Variables and Constants
```swift
// Use camelCase
let userName = "John"
var itemCount = 0

// Constants should be clear and descriptive
let maxRetryAttempts = 3
let defaultTimeout: TimeInterval = 30
```

### Types
```swift
// Use PascalCase for types
struct FileItem { }
class EditorViewModel { }
enum VimMode { }
protocol Editable { }
```

### Functions and Methods
```swift
// Use camelCase, start with verb
func saveFile() { }
func convertMarkdownToHTML(_ markdown: String) -> String { }
func isValidURL(_ url: URL) -> Bool { }
```

### Enums
```swift
// Use PascalCase for cases when they are noun-like
enum SplitOrientation {
    case horizontal
    case vertical
}

// Use camelCase when they are more like properties
enum Result {
    case success(Data)
    case failure(Error)
}
```

## Code Organization

### Import Order
```swift
// System frameworks first
import Foundation
import SwiftUI
import Combine

// Third-party frameworks next
// import Alamofire

// Project imports last (if needed)
```

### Type Organization
```swift
class MyClass {
    // MARK: - Properties
    let constantProperty: String
    var variableProperty: Int

    // MARK: - Initialization
    init() { }

    // MARK: - Public Methods
    func publicMethod() { }

    // MARK: - Private Methods
    private func privateMethod() { }
}
```

## Formatting

### Spacing
```swift
// Space after colon in type declarations
let name: String
var count: Int

// Space around operators
let sum = a + b
let result = isValid ? "Yes" : "No"

// No space before opening parenthesis
func myFunction() { }

// Space after comma
let array = [1, 2, 3]
```

### Braces
```swift
// Opening brace on same line
if condition {
    // code
} else {
    // code
}

// Closing brace on new line
func myFunction() {
    // code
}
```

### Line Length
- Keep lines under 120 characters when possible
- Break long function calls across multiple lines

```swift
// Good
someObject.someMethod(
    firstParameter: value1,
    secondParameter: value2,
    thirdParameter: value3
)
```

## Swift Features

### Optionals
```swift
// Use optional binding
if let value = optionalValue {
    // use value
}

// Use guard for early return
guard let value = optionalValue else {
    return
}

// Avoid force unwrapping (!)
// Only use when absolutely certain value exists
```

### Type Inference
```swift
// Let Swift infer types when obvious
let name = "John"  // String inferred
let count = 5      // Int inferred

// Specify types when clarity needed
let timeout: TimeInterval = 30
let items: [FileItem] = []
```

### Closures
```swift
// Use trailing closure syntax
items.map { item in
    item.name
}

// Use shorthand argument names when clear
items.filter { $0.isValid }

// Use [weak self] to avoid retain cycles
someAsync { [weak self] result in
    self?.handleResult(result)
}
```

### Protocol Conformance
```swift
// Use extensions for protocol conformance
extension MyClass: Equatable {
    static func == (lhs: MyClass, rhs: MyClass) -> Bool {
        lhs.id == rhs.id
    }
}
```

## SwiftUI Specific (macOS 26 / Swift 6+)

### Property Wrappers - Modern Approach (Preferred)
```swift
// Use @Observable macro for ViewModels (Swift 6+)
@Observable
class MyViewModel {
    var currentValue: String = ""  // Auto-observed
    var isLoading: Bool = false
}

// Use @State for local view state and Observable objects
@State private var isShowing = false
@State private var viewModel = MyViewModel()

// Use @Bindable for two-way binding to Observable objects
@Bindable var item: MyItem

// Use @Environment for environment values
@Environment(\.modelContext) var modelContext
@Environment(\.dismiss) var dismiss

// Use @Query for SwiftData queries
@Query(sort: \Item.timestamp) var items: [Item]
```

### Property Wrappers - Legacy Approach (Still Supported)
```swift
// Use @StateObject for creating ObservableObject ViewModels
@StateObject private var viewModel = MyLegacyViewModel()

// Use @ObservedObject for passed ObservableObject ViewModels
@ObservedObject var viewModel: MyLegacyViewModel

// Use @EnvironmentObject for injected ObservableObject dependencies
@EnvironmentObject var appState: AppState

// Use @Published in ObservableObject ViewModels
class MyLegacyViewModel: ObservableObject {
    @Published var currentValue: String = ""
}
```

### View Body
```swift
// Keep body simple
var body: some View {
    VStack {
        HeaderView()
        ContentView()
        FooterView()
    }
}

// Extract complex views
private var complexSection: some View {
    VStack {
        // complex layout
    }
}
```

## Comments

```swift
// Use // for single-line comments
// This is a single-line comment

// Use /// for documentation
/// Converts markdown text to HTML.
///
/// - Parameter markdown: The markdown string to convert
/// - Returns: HTML string representation
func convertMarkdownToHTML(_ markdown: String) -> String {
    // implementation
}

// Use MARK: for organization
// MARK: - Public Methods
```

## Error Handling

```swift
// Use do-catch for throwing functions
do {
    try performOperation()
} catch {
    handleError(error)
}

// Use Result type for async operations
func loadData(completion: @escaping (Result<Data, Error>) -> Void) {
    // implementation
}
```

## Swift Concurrency (Swift 6+)

### Actors and MainActor
```swift
// Use @MainActor for UI-related types
@MainActor
@Observable
class MyViewModel {
    var data: String = ""

    func updateData() {
        // Runs on main thread
        self.data = "Updated"
    }
}

// Use actors for thread-safe state
actor DataManager {
    private var cache: [String: Data] = [:]

    func getData(for key: String) async -> Data? {
        return cache[key]
    }
}

// Use async/await for asynchronous operations
func loadData() async throws -> Data {
    let url = URL(string: "https://example.com")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}
```

### Sendable Protocol (Swift 6 Data Race Safety)
```swift
// Use Sendable for types shared across concurrency domains
struct MyData: Sendable {
    let id: UUID
    let name: String
}

// Actor-isolated functions
@MainActor
func updateUI(with data: MyData) {
    // Safe: MyData is Sendable
}
```

## Performance

```swift
// Use lazy for expensive properties
lazy var expensiveProperty: Type = {
    // expensive computation
    return value
}()

// Use @MainActor for UI updates
@MainActor
func updateUI() {
    // UI updates
}

// Prefer async/await over completion handlers
// Good (Swift 6+)
func fetchData() async throws -> Data {
    try await URLSession.shared.data(from: url).0
}

// Avoid (legacy)
func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, _, error in
        // ...
    }.resume()
}
```
