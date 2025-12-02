---
name: swift-testing
description: Testing Swift and SwiftUI applications with XCTest and Swift Testing framework. Use for unit tests, UI tests, async testing, test organization, mocking, code coverage, TDD, test best practices.
skill_type: user
tags: [testing, xctest, swift-testing, unit-tests, ui-tests, tdd, swift6]
---

# Swift Testing Skill

Comprehensive testing guidance for Swift 6+ applications using both XCTest and the new Swift Testing framework.

## When to Use

- "How do I test this?"
- "Write unit tests for ViewModel"
- "Create UI tests"
- "Test async code"
- "Mock dependencies"
- "Improve test coverage"
- "Set up TDD workflow"
- "Test @Observable objects"

## Testing Frameworks

### Swift Testing (New in Swift 6)

✅ **Use for new tests:**
```swift
import Testing

@Test("User can login with valid credentials")
func userLogin() async throws {
    let user = User(email: "test@example.com")
    let result = await user.login(password: "password123")
    #expect(result == .success)
}

@Test("Input validation", arguments: ["", "a", "ab"])
func validateMinLength(input: String) {
    #expect(!isValid(input))
}
```

**Benefits:**
- Modern Swift syntax
- Better error messages
- Parameterized tests built-in
- Async/await native
- Less boilerplate

### XCTest (Traditional)

✅ **Use for existing tests:**
```swift
import XCTest

final class UserTests: XCTestCase {
    func testUserLogin() async throws {
        let user = User(email: "test@example.com")
        let result = await user.login(password: "password123")
        XCTAssertEqual(result, .success)
    }
}
```

## Testing @Observable ViewModels (Swift 6)

### Basic ViewModel Test

```swift
import Testing
import Observation

@Test("ViewModel updates data correctly")
@MainActor
func viewModelUpdateData() async {
    // Arrange
    let viewModel = MyViewModel()

    // Act
    await viewModel.loadData()

    // Assert
    #expect(viewModel.isLoading == false)
    #expect(!viewModel.data.isEmpty)
}
```

### Testing State Changes

```swift
@Test("ViewModel state transitions")
@MainActor
func viewModelStateTransitions() async {
    let viewModel = MyViewModel()

    // Initial state
    #expect(viewModel.isLoading == false)
    #expect(viewModel.data.isEmpty)

    // Start loading
    let loadTask = Task { await viewModel.loadData() }

    // Loading state (might need small delay)
    try? await Task.sleep(for: .milliseconds(10))
    #expect(viewModel.isLoading == true)

    // Wait for completion
    await loadTask.value
    #expect(viewModel.isLoading == false)
    #expect(!viewModel.data.isEmpty)
}
```

### Dependency Injection for Testing

```swift
// Protocol for dependency
protocol DataService {
    func fetchData() async throws -> [Item]
}

// ViewModel with injected dependency
@MainActor
@Observable
class ViewModel {
    var items: [Item] = []
    private let service: DataService

    init(service: DataService) {
        self.service = service
    }

    func loadItems() async {
        items = (try? await service.fetchData()) ?? []
    }
}

// Mock for testing
class MockDataService: DataService {
    var shouldFail = false
    var mockData: [Item] = []

    func fetchData() async throws -> [Item] {
        if shouldFail {
            throw NSError(domain: "test", code: -1)
        }
        return mockData
    }
}

// Test with mock
@Test("ViewModel loads items from service")
@MainActor
func viewModelLoadsItems() async {
    // Arrange
    let mock = MockDataService()
    mock.mockData = [Item(id: "1", name: "Test")]
    let viewModel = ViewModel(service: mock)

    // Act
    await viewModel.loadItems()

    // Assert
    #expect(viewModel.items.count == 1)
    #expect(viewModel.items.first?.name == "Test")
}
```

## Testing SwiftUI Views

### Snapshot Testing (Conceptual)

```swift
@Test("Settings view renders correctly")
@MainActor
func settingsViewSnapshot() {
    let view = SettingsView()
    let controller = UIHostingController(rootView: view)

    // Verify view exists
    #expect(controller.view != nil)

    // For actual snapshot testing, use third-party libraries
    // like SnapshotTesting or swift-snapshot-testing
}
```

### UI Tests with XCTest

```swift
import XCTest

final class ArguteUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testOpenFile() {
        // Find and tap "Open" button
        let openButton = app.buttons["Open"]
        XCTAssertTrue(openButton.exists)
        openButton.tap()

        // Verify file picker appears
        let filePicker = app.dialogs["Open"]
        XCTAssertTrue(filePicker.waitForExistence(timeout: 2))
    }

    func testVimModeToggle() {
        // Toggle Vim mode
        app.menuBars.menuBarItems["Edit"].click()
        app.menuItems["Toggle Vim Mode"].click()

        // Verify mode indicator
        let vimIndicator = app.staticTexts["NORMAL"]
        XCTAssertTrue(vimIndicator.exists)
    }
}
```

## Async Testing Patterns

### Testing Async Functions

```swift
@Test("Async function completes successfully")
func asyncOperation() async throws {
    let result = await performAsyncWork()
    #expect(result.isSuccess)
}

@Test("Async function handles errors")
func asyncErrorHandling() async {
    await #expect(throws: NetworkError.self) {
        try await failingAsyncOperation()
    }
}
```

### Testing with Timeouts

```swift
@Test("Operation completes within timeout")
func operationTimeout() async throws {
    let task = Task {
        await slowOperation()
    }

    try await Task.sleep(for: .seconds(5))

    if !task.isCancelled {
        task.cancel()
        Issue.record("Operation took too long")
    }
}
```

## Parameterized Tests

### Swift Testing (Built-in)

```swift
@Test("Email validation", arguments: [
    ("valid@email.com", true),
    ("invalid.email", false),
    ("@nodomain.com", false),
    ("user@domain.co.uk", true)
])
func validateEmail(email: String, expected: Bool) {
    #expect(isValidEmail(email) == expected)
}
```

### XCTest (Manual)

```swift
func testEmailValidation() {
    let testCases = [
        ("valid@email.com", true),
        ("invalid.email", false),
        ("@nodomain.com", false)
    ]

    for (email, expected) in testCases {
        XCTAssertEqual(isValidEmail(email), expected, "Failed for: \\(email)")
    }
}
```

## Test Organization

### Suite Organization (Swift Testing)

```swift
@Suite("User Authentication")
struct AuthenticationTests {
    @Test("Login with valid credentials")
    func validLogin() async { }

    @Test("Login with invalid credentials")
    func invalidLogin() async { }

    @Test("Logout clears session")
    func logout() async { }
}

@Suite("Data Persistence")
struct PersistenceTests {
    @Test("Save document")
    func saveDocument() { }

    @Test("Load document")
    func loadDocument() { }
}
```

### File Organization

```
Tests/
├── UnitTests/
│   ├── ViewModels/
│   │   ├── EditorViewModelTests.swift
│   │   └── PreviewViewModelTests.swift
│   ├── Services/
│   │   ├── MarkdownServiceTests.swift
│   │   └── FileServiceTests.swift
│   └── Models/
│       └── DocumentTests.swift
├── IntegrationTests/
│   ├── FileOperationsTests.swift
│   └── MarkdownRenderingTests.swift
└── UITests/
    ├── NavigationTests.swift
    └── EditingTests.swift
```

## Code Coverage

### Enable Coverage in Xcode

1. Edit Scheme (⌘<)
2. Test → Options
3. Check "Gather coverage for all targets"
4. Run tests (⌘U)
5. View coverage: Report Navigator → Coverage

### Coverage Goals

- **Critical paths:** 90%+ (ViewModels, Services)
- **UI code:** 70%+ (Views, Controllers)
- **Utilities:** 85%+ (Helpers, Extensions)
- **Overall:** 80%+

### Exclude from Coverage

```swift
// Code that doesn't need testing
func debugHelper() {
    // Test coverage: disable
    print("Debug info")
    // Test coverage: enable
}
```

## Mocking and Stubbing

### Protocol-Based Mocking

```swift
// 1. Define protocol
protocol NetworkService {
    func fetch<T: Decodable>(_ endpoint: String) async throws -> T
}

// 2. Production implementation
class RealNetworkService: NetworkService {
    func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
        // Real network call
    }
}

// 3. Mock for testing
class MockNetworkService: NetworkService {
    var mockResponse: Any?
    var shouldThrow = false

    func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
        if shouldThrow {
            throw URLError(.badServerResponse)
        }
        return mockResponse as! T
    }
}

// 4. Use in tests
@Test("Service handles network response")
@MainActor
func serviceHandlesResponse() async {
    let mock = MockNetworkService()
    mock.mockResponse = User(id: "1", name: "Test")
    let service = UserService(network: mock)

    let user = try? await service.loadUser()
    #expect(user?.name == "Test")
}
```

## Performance Testing

### XCTest Performance

```swift
func testMarkdownParsingPerformance() {
    let largeDocument = String(repeating: "# Header\\n", count: 1000)

    measure {
        _ = parseMarkdown(largeDocument)
    }
}

func testRenderingPerformance() {
    let options = XCTMeasureOptions()
    options.iterationCount = 10

    measure(options: options) {
        renderPreview(markdown: testDocument)
    }
}
```

## Test Best Practices

### DO ✅

1. **Follow AAA pattern** - Arrange, Act, Assert
2. **One assertion per test** (when possible)
3. **Test behavior, not implementation**
4. **Use descriptive names** - `testUserCannotLoginWithInvalidPassword`
5. **Keep tests independent** - No shared state
6. **Use dependency injection** - Easy to mock
7. **Test edge cases** - Empty, nil, boundaries
8. **Run tests frequently** - CI/CD integration

### DON'T ❌

1. **Don't test private methods** - Test public API
2. **Don't use real network/file system** - Use mocks
3. **Don't share state between tests**
4. **Don't test framework code** - Trust SwiftUI/Foundation
5. **Don't ignore failing tests**
6. **Don't make tests dependent on order**
7. **Don't use sleep() for timing** - Use expectations

## TDD Workflow

### Red-Green-Refactor

```swift
// 1. RED - Write failing test
@Test("User validation requires email")
func userValidation() {
    let user = User(name: "John")  // No email
    #expect(!user.isValid())  // FAILS - not implemented yet
}

// 2. GREEN - Make it pass (minimal code)
struct User {
    let name: String
    var email: String?

    func isValid() -> Bool {
        email != nil
    }
}

// 3. REFACTOR - Improve code
struct User {
    let name: String
    var email: String?

    func isValid() -> Bool {
        guard let email = email, !email.isEmpty else {
            return false
        }
        return email.contains("@")
    }
}

// 4. Add more tests
@Test("User validation checks email format")
func emailFormat() {
    let user = User(name: "John", email: "invalid")
    #expect(!user.isValid())
}
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: |
          xcodebuild test \
            -project MyApp.xcodeproj \
            -scheme MyApp \
            -destination 'platform=macOS' \
            -enableCodeCoverage YES
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

## Reference Material

See additional files:
- `reference/xctest-patterns.md` - Complete XCTest guide
- `reference/swift-testing.md` - Swift Testing framework
- `templates/UnitTest-Minimal.swift` - Unit test template
- `templates/UITest-Minimal.swift` - UI test template
- `scripts/run-tests.sh` - Test automation script

## Quick Commands

```bash
# Run all tests
xcodebuild test -scheme MyApp

# Run specific test
xcodebuild test -scheme MyApp -only-testing:MyAppTests/MyTest

# Run with coverage
xcodebuild test -scheme MyApp -enableCodeCoverage YES

# View coverage report
open DerivedData/.../Coverage/index.html
```

## Common Issues

### Issue: Tests fail randomly
**Solution:** Tests have shared state. Make independent.

### Issue: Async tests hang
**Solution:** Use proper async/await, check for infinite loops.

### Issue: UI tests can't find elements
**Solution:** Add accessibility identifiers:
```swift
Button("Save").accessibilityIdentifier("saveButton")
```

### Issue: Mock not working
**Solution:** Ensure protocol conformance and dependency injection.

## Testing Checklist

- [ ] All ViewModels have unit tests
- [ ] All Services have unit tests
- [ ] Critical user flows have UI tests
- [ ] Edge cases covered (empty, nil, max)
- [ ] Error handling tested
- [ ] Async operations tested
- [ ] Code coverage >80%
- [ ] Tests run in CI/CD
- [ ] Tests are fast (<10s total)
- [ ] No flaky tests
