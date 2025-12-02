import Foundation
import Observation

/// Template for creating ViewModels in SwiftUI apps (macOS 26+ / iOS 26+ / Swift 6+)
///
/// Usage:
/// 1. Copy this template
/// 2. Rename to YourFeatureViewModel
/// 3. Add your properties and business logic
/// 4. Inject dependencies via init
/// 5. Use @State in App, @Environment in Views

@MainActor
@Observable
class TemplateViewModel {
    // MARK: - Observable Properties

    /// Example observable property - automatically triggers UI updates
    var data: String = ""

    /// Example loading state
    var isLoading: Bool = false

    /// Example error state
    var errorMessage: String?

    // MARK: - Private Properties

    /// For async task cleanup in deinit
    /// Note: nonisolated(unsafe) warning is expected and correct
    nonisolated(unsafe) private var loadTask: Task<Void, Never>?

    // MARK: - Dependencies

    /// Inject services via initializer
    private let service: YourService

    // MARK: - Initialization

    init(service: YourService = YourService()) {
        self.service = service
    }

    // MARK: - Public Methods

    /// Example async method
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await service.fetchData()
            self.data = result  // Already on MainActor
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }

    /// Example sync method
    func updateData(_ newData: String) {
        self.data = newData  // Triggers UI update
    }

    /// Example method with background work
    func processData() {
        loadTask = Task {
            // Simulate long-running work
            try? await Task.sleep(for: .seconds(2))

            // Check cancellation
            guard !Task.isCancelled else { return }

            // Update UI (already on MainActor)
            self.data = "Processed"
        }
    }

    // MARK: - Cleanup

    deinit {
        // Cancel ongoing tasks
        loadTask?.cancel()
    }
}

// MARK: - Example Service

/// Example service for dependency injection
protocol YourService {
    func fetchData() async throws -> String
}

class YourServiceImpl: YourService {
    func fetchData() async throws -> String {
        // Network/file/database operation
        try await Task.sleep(for: .seconds(1))
        return "Sample data"
    }
}

// MARK: - Usage Example

/*
 // 1. In App - Create and inject
 @main
 struct MyApp: App {
     @State private var viewModel = TemplateViewModel()

     var body: some Scene {
         WindowGroup {
             TemplateView()
                 .environment(viewModel)
         }
     }
 }

 // 2. In View - Read only
 struct TemplateView: View {
     @Environment(TemplateViewModel.self) private var viewModel

     var body: some View {
         VStack {
             if viewModel.isLoading {
                 ProgressView()
             } else {
                 Text(viewModel.data)
             }

             if let error = viewModel.errorMessage {
                 Text(error).foregroundStyle(.red)
             }
         }
         .task {
             await viewModel.loadData()
         }
     }
 }

 // 3. In View - With bindings
 struct EditTemplateView: View {
     @Environment(TemplateViewModel.self) private var viewModel

     var body: some View {
         @Bindable var vm = viewModel

         Form {
             TextField("Data", text: $vm.data)
             Button("Process") {
                 viewModel.processData()
             }
         }
     }
 }
 */
