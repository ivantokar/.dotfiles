import Testing
import Foundation

/// Minimal unit test template for Swift Testing framework
///
/// Usage:
/// 1. Copy this template
/// 2. Rename to YourFeatureTests.swift
/// 3. Import your module
/// 4. Add your test cases

// MARK: - Basic Test Structure

@Test("Description of what this tests")
func testBasicExample() {
    // Arrange - Set up test data
    let value = 42

    // Act - Perform the action
    let result = value * 2

    // Assert - Verify the result
    #expect(result == 84)
}

// MARK: - Testing @Observable ViewModels

@Test("ViewModel state changes correctly")
@MainActor  // Required for @MainActor ViewModels
func testViewModelStateChange() async {
    // Arrange
    let viewModel = YourViewModel()

    // Act
    await viewModel.performAction()

    // Assert
    #expect(viewModel.someProperty == expectedValue)
    #expect(viewModel.isLoading == false)
}

// MARK: - Parameterized Tests

@Test("Validate input", arguments: [
    ("valid input", true),
    ("", false),
    ("invalid", false)
])
func testValidation(input: String, expected: Bool) {
    let result = validate(input)
    #expect(result == expected)
}

// MARK: - Async Testing

@Test("Async operation completes")
func testAsyncOperation() async throws {
    let result = await performAsyncWork()
    #expect(result.isSuccess)
}

// MARK: - Error Testing

@Test("Function throws expected error")
func testErrorThrown() async {
    await #expect(throws: YourError.self) {
        try await functionThatShouldThrow()
    }
}

// MARK: - Test Suite Organization

@Suite("Feature Name Tests")
struct FeatureTests {
    @Test("First test in suite")
    func test1() {
        #expect(true)
    }

    @Test("Second test in suite")
    func test2() {
        #expect(true)
    }
}

// MARK: - Setup/Teardown Pattern

@Suite("Tests with setup")
struct TestsWithSetup {
    let sharedResource: String

    init() {
        // Setup before all tests in suite
        sharedResource = "initialized"
    }

    @Test("Uses shared resource")
    func testWithResource() {
        #expect(sharedResource == "initialized")
    }
}

// MARK: - Testing with Mocks

@Test("Service uses mock dependency")
func testWithMock() async {
    // Create mock
    let mockService = MockDataService()
    mockService.mockData = testData

    // Inject mock
    let sut = SystemUnderTest(service: mockService)

    // Test
    await sut.loadData()

    #expect(sut.data.count > 0)
}

// MARK: - Example Mock

class MockDataService: DataServiceProtocol {
    var mockData: [Item] = []
    var shouldFail = false

    func fetchData() async throws -> [Item] {
        if shouldFail {
            throw TestError.mockError
        }
        return mockData
    }
}

// MARK: - Test Helpers

enum TestError: Error {
    case mockError
}

// Helper function for creating test data
func makeTestData() -> [Item] {
    return [
        Item(id: "1", name: "Test 1"),
        Item(id: "2", name: "Test 2")
    ]
}
