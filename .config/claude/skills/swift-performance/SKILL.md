---
name: swift-performance
description: Optimize Swift 6+ performance for macOS 26.x and iOS 26.x. Use when user mentions slow performance, memory issues, high CPU usage, lag, profiling, or optimization.
skill_type: project
tags: [swift, performance, optimization, profiling, memory, instruments, macos-26, ios-26]
---

# Swift Performance Skill

Expert guidance for optimizing Swift 6+ applications on macOS 26.x (Tahoe) / iOS 26.x.

## When to Use This Skill

Activate when user mentions:
- "App is slow"
- "High memory usage"
- "CPU usage is high"
- "Scrolling is laggy"
- "How to optimize this"
- "Profile performance"
- "Memory leak"
- "App freezing"
- "Reduce battery usage"

## Performance Philosophy

### Three Pillars of Performance

1. **Measure First** - Always profile before optimizing
2. **Focus on Impact** - Optimize the bottlenecks, not everything
3. **Maintain Clarity** - Don't sacrifice readability for micro-optimizations

### When to Optimize

**✅ Do optimize when:**
- Profiling shows clear bottlenecks
- Users report performance issues
- Scrolling/animations are janky
- Memory usage is excessive
- Battery drain is high

**❌ Don't optimize when:**
- No measurable performance issue
- Would significantly reduce code clarity
- Premature optimization
- Micro-optimizations with no impact

## Quick Performance Wins

### 1. Avoid Unnecessary Work

```swift
// ❌ BAD - Recalculates every time
struct ExpensiveView: View {
    let items: [Item]

    var body: some View {
        let sorted = items.sorted { $0.name < $1.name }  // Runs on every redraw!
        ForEach(sorted) { item in
            ItemRow(item: item)
        }
    }
}

// ✅ GOOD - Calculated once
struct EfficientView: View {
    let items: [Item]

    private var sortedItems: [Item] {
        items.sorted { $0.name < $1.name }
    }

    var body: some View {
        ForEach(sortedItems) { item in
            ItemRow(item: item)
        }
    }
}

// ✅ BETTER - Cached computation
@Observable
class ViewModel {
    var items: [Item] = [] {
        didSet {
            updateSortedItems()
        }
    }

    private(set) var sortedItems: [Item] = []

    private func updateSortedItems() {
        sortedItems = items.sorted { $0.name < $1.name }
    }
}
```

### 2. Lazy Loading

```swift
// ❌ BAD - Loads everything upfront
func loadAllData() async {
    let allItems = try await fetchAllItems()  // Could be thousands!
    self.items = allItems
}

// ✅ GOOD - Load on demand
func loadData(page: Int, pageSize: Int = 50) async {
    let items = try await fetchItems(page: page, limit: pageSize)
    self.items.append(contentsOf: items)
}

// ✅ BETTER - Lazy ScrollView with pagination
struct LazyListView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.items) { item in
                    ItemRow(item: item)
                        .onAppear {
                            // Load more when approaching end
                            if item == viewModel.items.last {
                                Task {
                                    await viewModel.loadMore()
                                }
                            }
                        }
                }
            }
        }
    }
}
```

### 3. Proper Task Management

```swift
// ❌ BAD - Unmanaged tasks
class ViewModel {
    func search(_ query: String) {
        Task {
            let results = try await searchAPI(query)
            self.results = results
        }
    }
}
// Problem: Multiple searches run concurrently, wasting resources

// ✅ GOOD - Cancellable task
@Observable
class ViewModel {
    nonisolated(unsafe) private var searchTask: Task<Void, Never>?

    func search(_ query: String) {
        searchTask?.cancel()  // Cancel previous search

        searchTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(300))  // Debounce
                let results = try await searchAPI(query)
                self.results = results
            } catch is CancellationError {
                // Cancelled, do nothing
            } catch {
                self.error = error
            }
        }
    }

    deinit {
        searchTask?.cancel()
    }
}
```

### 4. Minimize View Updates

```swift
// ❌ BAD - Entire view refreshes
@Observable
class ViewModel {
    var items: [Item] = []
    var selectedItem: Item?
    var searchQuery: String = ""
    var isLoading: Bool = false
}

// Every property change refreshes all views observing this ViewModel!

// ✅ GOOD - Separate concerns
@Observable
class ItemsViewModel {
    var items: [Item] = []  // Only updates item list views
}

@Observable
class SearchViewModel {
    var query: String = ""  // Only updates search field
    var results: [Item] = []
}

@Observable
class SelectionViewModel {
    var selectedItem: Item?  // Only updates selection
}
```

## Memory Management

### Reference Cycles

```swift
// ❌ BAD - Retain cycle
class ViewModel {
    var onUpdate: (() -> Void)?

    func setup() {
        onUpdate = {
            self.refresh()  // Strong reference to self
        }
    }
}

// ✅ GOOD - Weak reference
class ViewModel {
    var onUpdate: (() -> Void)?

    func setup() {
        onUpdate = { [weak self] in
            self?.refresh()
        }
    }
}

// ✅ BETTER - Unowned if guaranteed to exist
class ViewModel {
    let service: Service  // Always exists

    func setup() {
        service.onUpdate = { [unowned self] in
            self.refresh()
        }
    }
}
```

### Memory-Efficient Data Structures

```swift
// ❌ BAD - Large structs copied everywhere
struct LargeDocument {
    var title: String
    var content: String  // Could be megabytes!
    var metadata: [String: Any]
    var images: [NSImage]
}

func processDocument(_ doc: LargeDocument) {
    // Entire document copied!
}

// ✅ GOOD - Use class for large data
class LargeDocument {
    var title: String
    var content: String
    var metadata: [String: Any]
    var images: [NSImage]

    init(title: String, content: String, metadata: [String: Any], images: [NSImage]) {
        self.title = title
        self.content = content
        self.metadata = metadata
        self.images = images
    }
}

func processDocument(_ doc: LargeDocument) {
    // Only reference copied
}

// ✅ BETTER - Lazy loading
class LazyDocument {
    let url: URL
    private var _content: String?

    var content: String {
        get {
            if let cached = _content {
                return cached
            }
            let loaded = try? String(contentsOf: url)
            _content = loaded
            return loaded ?? ""
        }
    }
}
```

### ARC Optimization

```swift
// Use value types (structs) for small, simple data
struct Point {
    var x: Double
    var y: Double
}  // ✅ No reference counting overhead

// Use classes for larger data that needs identity
class Document {
    var content: String
    var metadata: [String: Any]
}  // ✅ Reference counted, shared efficiently

// Prefer let over var when possible
class ViewModel {
    let service: Service  // ✅ Compiler can optimize
    var state: State      // ❌ Less optimization
}
```

## Swift 6 Concurrency

### Actor Isolation

```swift
// ✅ GOOD - Proper actor usage
actor ImageCache {
    private var cache: [URL: NSImage] = [:]

    func image(for url: URL) -> NSImage? {
        cache[url]
    }

    func store(_ image: NSImage, for url: URL) {
        cache[url] = image
    }
}

// Usage
let cache = ImageCache()

Task {
    if let cached = await cache.image(for: url) {
        return cached
    }

    let downloaded = await downloadImage(url)
    await cache.store(downloaded, for: url)
}
```

### MainActor Usage

```swift
// ✅ GOOD - UI updates on main actor
@MainActor
@Observable
class ViewModel {
    var items: [Item] = []

    func loadData() async {
        let data = await fetchData()  // Can run on background
        self.items = data  // Guaranteed on main thread
    }
}

// ❌ BAD - Manual main thread dispatch
@Observable
class ViewModel {
    var items: [Item] = []

    func loadData() async {
        let data = await fetchData()
        await MainActor.run {
            self.items = data
        }
    }
}
// Redundant if ViewModel is @MainActor
```

### Async Sequences

```swift
// ✅ GOOD - Efficient streaming
func processLargeFile(_ url: URL) async throws {
    let lines = url.lines  // Async sequence

    for try await line in lines {
        process(line)  // One at a time, low memory
    }
}

// ❌ BAD - Load entire file
func processLargeFile(_ url: URL) async throws {
    let content = try String(contentsOf: url)  // Loads everything!
    let lines = content.components(separatedBy: .newlines)

    for line in lines {
        process(line)
    }
}
```

## SwiftUI Performance

### List Performance

```swift
// ✅ GOOD - Lazy loading with proper IDs
struct EfficientList: View {
    let items: [Item]

    var body: some View {
        List {
            ForEach(items) { item in  // Item: Identifiable
                ItemRow(item: item)
                    .id(item.id)  // Stable identity
            }
        }
    }
}

// ❌ BAD - Index-based without stable IDs
struct InefficientList: View {
    let items: [Item]

    var body: some View {
        List {
            ForEach(items.indices, id: \.self) { index in
                ItemRow(item: items[index])
            }
        }
    }
}
// Indices change when array is modified!
```

### View Identity

```swift
// ✅ GOOD - Stable view identity
struct StableView: View {
    let item: Item

    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text(item.date)
        }
        .id(item.id)  // Stable identity across updates
    }
}

// ❌ BAD - View recreated unnecessarily
struct UnstableView: View {
    let item: Item

    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text(item.date)
        }
        .id(UUID())  // New identity every time!
    }
}
```

### Avoid Unnecessary Rendering

```swift
// ✅ GOOD - Equatable to prevent unnecessary updates
struct ExpensiveView: View, Equatable {
    let data: [Item]

    var body: some View {
        // Complex rendering
    }

    static func == (lhs: ExpensiveView, rhs: ExpensiveView) -> Bool {
        lhs.data.count == rhs.data.count &&
        lhs.data.first?.id == rhs.data.first?.id &&
        lhs.data.last?.id == rhs.data.last?.id
    }
}

// Usage
ExpensiveView(data: items)
    .equatable()  // Only updates when equality check changes
```

## Profiling with Instruments

### Time Profiler

```swift
// Find CPU bottlenecks

1. Product → Profile (⌘I)
2. Choose "Time Profiler"
3. Record while using the app
4. Look for:
   - High % Self time
   - Frequent call counts
   - Long-running operations

// Common issues to find:
// - Expensive computations in View.body
// - Synchronous file I/O
// - Inefficient algorithms
// - Excessive object allocation
```

### Allocations

```swift
// Find memory issues

1. Product → Profile (⌘I)
2. Choose "Allocations"
3. Record and use the app
4. Look for:
   - Growing heaps
   - Leaked memory
   - Excessive allocations

// Common issues:
// - Retain cycles
// - Unbounded caches
// - Large temporary allocations
// - Image memory leaks
```

### Leaks

```swift
// Find memory leaks

1. Product → Profile (⌘I)
2. Choose "Leaks"
3. Record and use the app
4. Look for red leak indicators

// Fix by:
// - Adding [weak self] to closures
// - Breaking retain cycles
// - Properly disposing resources
```

## Best Practices

### Algorithms and Data Structures

```swift
// ✅ Choose the right data structure
var usersByID: [UUID: User] = [:]  // O(1) lookup
var users: [User] = []              // O(n) lookup

// Finding by ID
let user = usersByID[id]  // ✅ Fast
let user = users.first { $0.id == id }  // ❌ Slow for large arrays

// ✅ Use Set for membership tests
var selectedIDs: Set<UUID> = []
if selectedIDs.contains(id) { }  // O(1)

var selectedIDs: [UUID] = []
if selectedIDs.contains(id) { }  // O(n)
```

### String Performance

```swift
// ❌ BAD - Repeated string concatenation
var result = ""
for item in items {
    result += item.description + "\n"  // Creates new string each time
}

// ✅ GOOD - Use array join
let result = items.map(\.description).joined(separator: "\n")

// ✅ BETTER - Use StringBuilder pattern
var result = ""
result.reserveCapacity(items.count * 50)  // Pre-allocate
for item in items {
    result += item.description
    result += "\n"
}
```

### Image Performance

```swift
// ❌ BAD - Full-size images everywhere
Image(nsImage: fullSizeImage)
    .frame(width: 100, height: 100)
// Still decodes and holds full image in memory!

// ✅ GOOD - Downsample images
func downsample(imageAt url: URL, to size: CGSize) -> NSImage? {
    let options: [CFString: Any] = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
    ]

    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
        return nil
    }

    return NSImage(cgImage: cgImage, size: size)
}

// ✅ Use downsampled images
AsyncImage(url: url) { image in
    image.resizable()
        .aspectRatio(contentMode: .fit)
} placeholder: {
    ProgressView()
}
.frame(width: 100, height: 100)
```

## Reference Material

See additional files:
- `reference/instruments-guide.md` - Complete Instruments profiling guide
- `reference/memory-management.md` - Deep dive into ARC and memory
- `templates/AsyncOperation-Template.swift` - Async/await patterns
- `scripts/profile-app.sh` - Launch Instruments script

## Performance Checklist

Before shipping:

**Code Review:**
- [ ] No expensive work in View.body
- [ ] Proper use of lazy loading
- [ ] Tasks are cancellable
- [ ] No retain cycles in closures
- [ ] Appropriate data structures
- [ ] Images are downsampled

**Profiling:**
- [ ] Time Profiler shows no hot spots
- [ ] Allocations shows reasonable memory use
- [ ] No memory leaks detected
- [ ] Scrolling is smooth (60 FPS)
- [ ] App launch is fast (< 2s)

**Testing:**
- [ ] Test with large datasets
- [ ] Test on older hardware
- [ ] Monitor battery usage
- [ ] Check thermal performance
- [ ] Test with poor network

## Quick Reference

**Common Optimizations:**
1. Use lazy loading for large lists
2. Debounce search and rapid updates
3. Cancel tasks when no longer needed
4. Cache expensive computations
5. Use value types for small data
6. Downsample images to display size
7. Use `@MainActor` for UI ViewModels
8. Avoid work in View.body
9. Use proper data structures (Dict, Set)
10. Profile before optimizing

**Memory Management:**
- Use `[weak self]` in closures
- Break retain cycles
- Dispose resources in deinit
- Use `nonisolated(unsafe)` for cleanup
- Prefer value types when appropriate

**Concurrency:**
- Use `async/await` over callbacks
- Actors for shared mutable state
- `@MainActor` for UI updates
- Task cancellation
- Async sequences for streaming

---

Remember: **Measure, optimize, verify.** Always profile before and after optimization to ensure improvements.
