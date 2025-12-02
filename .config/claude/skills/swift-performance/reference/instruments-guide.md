# Instruments Profiling Guide - macOS 26.x

Complete guide to profiling Swift applications using Instruments.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Time Profiler](#time-profiler)
3. [Allocations](#allocations)
4. [Leaks](#leaks)
5. [System Trace](#system-trace)
6. [Animation Hitches](#animation-hitches)
7. [Network](#network)
8. [File Activity](#file-activity)
9. [Interpreting Results](#interpreting-results)

## Getting Started

### Launching Instruments

```bash
# From Xcode
Product → Profile (⌘I)

# From command line
instruments -t "Time Profiler" YourApp.app

# List available templates
instruments -s templates
```

### Preparing for Profiling

```swift
// 1. Build in Release mode
// Product → Scheme → Edit Scheme → Profile → Build Configuration → Release

// 2. Disable optimization only for debugging symbols
// Build Settings → Debug Information Format → DWARF with dSYM

// 3. Clean build folder
// Product → Clean Build Folder (⌘⇧K)
```

## Time Profiler

**Purpose:** Find CPU bottlenecks and expensive operations.

### Recording a Profile

1. Launch Instruments with Time Profiler
2. Select your app as target
3. Click Record (⌘R)
4. Perform the actions you want to profile
5. Stop recording

### Reading the Results

**Call Tree View:**
- **Self**: Time spent in this function (not callees)
- **Total**: Time spent including callees
- **Count**: Number of times called

**Focus on:**
- Functions with high "Self" time
- Frequently called functions
- Long-running operations

### Example Analysis

```
Symbol Name                           Self    Total   Count
─────────────────────────────────────────────────────────────
main                                   0ms    5000ms     1
├─ ContentView.body                   500ms   2000ms   100
│  ├─ ExpensiveComputation          1500ms   1500ms   100  ← Problem!
│  └─ RenderView                       0ms    500ms   100
└─ NetworkRequest                      0ms   3000ms     5
```

**Issue Found:** `ExpensiveComputation` takes 1500ms and is called 100 times.

**Solution:**
```swift
// ❌ BAD - Computed every time body is called
struct MyView: View {
    let items: [Item]

    var body: some View {
        let sorted = items.sorted()  // 15ms × 100 calls = 1500ms
        List(sorted) { item in
            Text(item.name)
        }
    }
}

// ✅ GOOD - Cached
struct MyView: View {
    let items: [Item]

    private var sortedItems: [Item] {
        items.sorted()  // Called once
    }

    var body: some View {
        List(sortedItems) { item in
            Text(item.name)
        }
    }
}
```

### Time Profiler Options

**Call Tree Options:**
- ☑ Separate by Thread - See per-thread performance
- ☑ Invert Call Tree - Bottom-up view
- ☑ Hide System Libraries - Focus on your code
- ☑ Flatten Recursion - Combine recursive calls

### Common Bottlenecks

**1. Synchronous File I/O:**
```swift
// ❌ BAD - Blocks main thread
let content = try String(contentsOf: url)

// ✅ GOOD - Async
let content = try await String(contentsOf: url)
```

**2. Expensive Computations in body:**
```swift
// ❌ BAD
var body: some View {
    let filtered = items.filter { $0.isVisible }  // Every redraw!
    List(filtered) { item in
        ItemRow(item: item)
    }
}

// ✅ GOOD
private var visibleItems: [Item] {
    items.filter { $0.isVisible }
}

var body: some View {
    List(visibleItems) { item in
        ItemRow(item: item)
    }
}
```

**3. N+1 Database Queries:**
```swift
// ❌ BAD
for item in items {
    let details = try await fetchDetails(for: item.id)  // N queries!
}

// ✅ GOOD
let ids = items.map(\.id)
let allDetails = try await fetchDetails(for: ids)  // 1 query
```

## Allocations

**Purpose:** Find memory usage and allocation patterns.

### What to Look For

1. **Growing Heaps** - Memory that keeps increasing
2. **Excessive Allocations** - Too many objects created
3. **Large Allocations** - Individual large objects
4. **Leaks** - Memory not freed

### Recording Allocations

1. Launch Instruments with Allocations template
2. Record while using the app
3. Snapshot at different points
4. Compare snapshots to find growth

### Analysis Example

**Scenario:** App memory grows from 50MB to 500MB over time.

**Steps:**
1. Take snapshot after launch (50MB)
2. Use the app for 5 minutes
3. Take snapshot again (500MB)
4. Click "Statistics" → "Growth"
5. Look for categories with large growth

**Common Issues:**

**1. Unbounded Cache:**
```swift
// ❌ BAD - Cache grows forever
class ImageCache {
    private var cache: [URL: NSImage] = [:]

    func image(for url: URL) -> NSImage? {
        if let cached = cache[url] {
            return cached
        }

        let image = loadImage(url)
        cache[url] = image  // Never removed!
        return image
    }
}

// ✅ GOOD - LRU cache with limit
class ImageCache {
    private let maxSize = 100
    private var cache: [URL: CacheEntry] = [:]
    private var accessOrder: [URL] = []

    struct CacheEntry {
        let image: NSImage
        var lastAccess: Date
    }

    func image(for url: URL) -> NSImage? {
        if let entry = cache[url] {
            cache[url]?.lastAccess = Date()
            return entry.image
        }

        let image = loadImage(url)
        addToCache(image, for: url)
        return image
    }

    private func addToCache(_ image: NSImage, for url: URL) {
        if cache.count >= maxSize {
            evictLRU()
        }

        cache[url] = CacheEntry(image: image, lastAccess: Date())
    }

    private func evictLRU() {
        guard let oldest = cache.min(by: { $0.value.lastAccess < $1.value.lastAccess }) else {
            return
        }
        cache.removeValue(forKey: oldest.key)
    }
}
```

**2. Large Temporary Allocations:**
```swift
// ❌ BAD - Creates large intermediate array
let result = items
    .map { transform($0) }        // Large array
    .filter { $0.isValid }        // Large array
    .sorted { $0.name < $1.name } // Large array

// ✅ GOOD - Lazy evaluation
let result = items
    .lazy
    .map { transform($0) }
    .filter { $0.isValid }
    .sorted { $0.name < $1.name }
```

### Allocation Stack Traces

Enable "Record Reference Counts" to see:
- Where objects are allocated
- Where they're retained
- Where they're released

**Finding Leaks:**
1. Look for objects with retain count that never reaches 0
2. View stack trace of retains
3. Identify the retain cycle

## Leaks

**Purpose:** Find memory that's allocated but never freed.

### How Leaks Happen

**1. Retain Cycles:**
```swift
// ❌ BAD - Retain cycle
class ViewController {
    var completion: (() -> Void)?

    func setup() {
        completion = {
            self.doSomething()  // self → completion → self
        }
    }
}

// ✅ GOOD - Break cycle
class ViewController {
    var completion: (() -> Void)?

    func setup() {
        completion = { [weak self] in
            self?.doSomething()
        }
    }
}
```

**2. Circular References:**
```swift
// ❌ BAD
class Parent {
    var child: Child?
}

class Child {
    var parent: Parent?  // Strong reference
}

// Parent → Child → Parent = cycle

// ✅ GOOD
class Child {
    weak var parent: Parent?  // Weak reference
}
```

### Finding Leaks

1. Run Leaks instrument
2. Red bars indicate leaks
3. Click leak to see:
   - Type of leaked object
   - Allocation stack trace
   - Retain/release history

### Common Leak Patterns

**Timers:**
```swift
// ❌ BAD - Timer retains target
class ViewModel {
    var timer: Timer?

    func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { _ in
            self.update()  // Retain cycle
        }
    }
}

// ✅ GOOD - Invalidate timer
class ViewModel {
    var timer: Timer?

    func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] _ in
            self?.update()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
```

**Delegates:**
```swift
// ❌ BAD - Strong delegate
protocol MyDelegate: AnyObject {
    func didUpdate()
}

class Service {
    var delegate: MyDelegate?  // Strong!
}

// ✅ GOOD - Weak delegate
class Service {
    weak var delegate: MyDelegate?
}
```

## System Trace

**Purpose:** Understand system-level performance and thread activity.

### What It Shows

- Thread activity
- CPU core usage
- System calls
- Virtual memory activity
- File I/O
- Network activity

### Common Issues

**1. Main Thread Blocking:**
```
Main Thread: ████████████_____________████████
             ^ Blocked for 500ms!

Background:  ___________████████████_________
                       ^ Doing work
```

**Fix:**
```swift
// ❌ BAD - Blocks main thread
@MainActor
func loadData() {
    let data = parseHugeFile()  // 500ms on main thread!
    self.items = data
}

// ✅ GOOD - Work on background
@MainActor
func loadData() async {
    let data = await Task.detached {
        parseHugeFile()  // On background thread
    }.value

    self.items = data  // On main thread
}
```

**2. Thread Explosion:**
```
Thread 1: ██████████████
Thread 2: ██████████████
Thread 3: ██████████████
Thread 4: ██████████████
Thread 5: ██████████████
... 50 more threads!
```

**Fix:**
```swift
// ❌ BAD - Creates many threads
for item in items {
    Task.detached {
        await process(item)
    }
}

// ✅ GOOD - Use Task Group
await withTaskGroup(of: Void.self) { group in
    for item in items {
        group.addTask {
            await process(item)
        }
    }
}
```

## Animation Hitches

**Purpose:** Find dropped frames and janky animations.

### Metrics

- **Hitch Time** - Duration of dropped frames
- **Hitch Ratio** - Percentage of time spent in hitches
- **Target:** < 5ms per hitch, < 5% hitch ratio

### Common Causes

**1. Work on Main Thread:**
```swift
// ❌ BAD - Expensive work during animation
.onChange(of: selectedItem) { _, newItem in
    let processed = processData(newItem)  // 50ms!
    self.processedData = processed
}

// ✅ GOOD - Defer expensive work
.onChange(of: selectedItem) { _, newItem in
    Task {
        let processed = await processData(newItem)
        self.processedData = processed
    }
}
```

**2. Complex View Hierarchies:**
```swift
// ❌ BAD - Deep nesting
VStack {
    ForEach(items) { item in
        HStack {
            VStack {
                HStack {
                    // 5 levels deep!
                }
            }
        }
    }
}

// ✅ GOOD - Extract subviews
VStack {
    ForEach(items) { item in
        ItemRow(item: item)  // Flatter hierarchy
    }
}
```

## Network

**Purpose:** Analyze network requests and data transfer.

### Metrics

- Request duration
- Data transferred
- Number of requests
- HTTP errors

### Optimization Tips

**1. Batch Requests:**
```swift
// ❌ BAD - N requests
for id in ids {
    let item = try await fetch(id)
}

// ✅ GOOD - 1 request
let items = try await fetchBatch(ids)
```

**2. Compression:**
```swift
// Enable compression
var request = URLRequest(url: url)
request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
```

**3. Caching:**
```swift
var request = URLRequest(url: url)
request.cachePolicy = .returnCacheDataElseLoad
```

## File Activity

**Purpose:** Monitor file I/O operations.

### Common Issues

**1. Synchronous I/O:**
```swift
// ❌ BAD - Blocks thread
let content = try String(contentsOf: url)

// ✅ GOOD - Async
let content = try await String(contentsOf: url)
```

**2. Excessive Writes:**
```swift
// ❌ BAD - Writes on every change
func updateSetting(_ key: String, value: String) {
    settings[key] = value
    saveSettings()  // Writes file!
}

// ✅ GOOD - Debounced writes
func updateSetting(_ key: String, value: String) {
    settings[key] = value
    scheduleSave()  // Delayed, coalesced write
}
```

## Interpreting Results

### Workflow

1. **Identify bottleneck** - Which instrument shows the issue?
2. **Narrow scope** - When does it occur?
3. **Find root cause** - What code is responsible?
4. **Fix** - Implement optimization
5. **Verify** - Profile again to confirm improvement

### Before/After Example

**Before:**
```
Time Profiler:
MyView.body: 250ms (called 60 times/sec)
Total CPU: 15 seconds of work

Allocations:
Memory: 500MB
Allocations: 10,000/sec
```

**After Optimization:**
```
Time Profiler:
MyView.body: 2ms (called 60 times/sec)
Total CPU: 0.12 seconds of work

Allocations:
Memory: 50MB
Allocations: 100/sec
```

**Improvement:**
- 125x faster rendering
- 10x less memory
- 100x fewer allocations

## Best Practices

1. **Profile in Release mode** - Optimizations enabled
2. **Profile on real devices** - Simulator is faster than reality
3. **Profile realistic scenarios** - Use real data sizes
4. **Focus on user-visible issues** - Optimize what matters
5. **Measure before and after** - Verify improvements
6. **Keep historical profiles** - Track performance over time
7. **Profile regularly** - Catch regressions early

## Quick Reference

| Instrument | Use Case | Key Metric |
|------------|----------|------------|
| Time Profiler | CPU usage | Self time |
| Allocations | Memory usage | Heap size |
| Leaks | Memory leaks | Leak count |
| System Trace | Thread activity | Main thread blocks |
| Animation Hitches | Dropped frames | Hitch ratio |
| Network | API calls | Request count/size |
| File Activity | Disk I/O | Read/write counts |

---

Regular profiling is essential for maintaining performance. Make it part of your development workflow.
