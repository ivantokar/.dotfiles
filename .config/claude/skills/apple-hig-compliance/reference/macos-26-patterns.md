# macOS 26.x UI Patterns

Platform-specific patterns and components for macOS 26 (Tahoe) applications.

## Table of Contents

1. [Window Management](#window-management)
2. [Toolbars](#toolbars)
3. [Sidebars and Split Views](#sidebars-and-split-views)
4. [Menus](#menus)
5. [Sheets and Popovers](#sheets-and-popovers)
6. [Controls](#controls)
7. [Lists and Tables](#lists-and-tables)
8. [Document-Based Apps](#document-based-apps)

## Window Management

### Multiple Windows

```swift
@main
struct ArguteApp: App {
    var body: some Scene {
        // Main document window
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 1200, height: 800)
        .defaultPosition(.center)
        .commands {
            // Add window commands
            CommandGroup(replacing: .newItem) {
                Button("New Document") {
                    NSDocumentController.shared.newDocument(nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
        }

        // Settings window
        Settings {
            SettingsView()
        }

        // Auxiliary window
        Window("Inspector", id: "inspector") {
            InspectorView()
        }
        .keyboardShortcut("i", modifiers: [.command, .option])
        .defaultSize(width: 300, height: 600)
        .windowResizability(.contentSize)
    }
}
```

### Window Restoration

```swift
struct ContentView: View {
    @SceneStorage("selectedTab") private var selectedTab: String?
    @SceneStorage("scrollPosition") private var scrollPosition: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            EditorView()
                .tag("editor")

            PreviewView()
                .tag("preview")
        }
    }
}
```

### Window Sizing

```swift
// Minimum/maximum window size
.windowResizability(.contentSize)
.windowResizability(.contentMinSize)

// Fixed size window
.windowResizability(.fixed)

// Flexible sizing with constraints
.windowStyle(.automatic)
.defaultSize(width: 1200, height: 800)
.defaultSize(CGSize(width: 1200, height: 800))
```

### Full Screen

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            // Content
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    toggleFullScreen()
                } label: {
                    Label("Toggle Full Screen", systemImage: "arrow.up.left.and.arrow.down.right")
                }
            }
        }
    }

    func toggleFullScreen() {
        NSApp.keyWindow?.toggleFullScreen(nil)
    }
}
```

## Toolbars

### Standard Toolbar

```swift
struct ToolbarExample: View {
    @State private var viewMode: ViewMode = .split

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar(id: "main") {
            // Leading items
            ToolbarItem(id: "sidebar", placement: .navigation) {
                Button {
                    toggleSidebar()
                } label: {
                    Label("Toggle Sidebar", systemImage: "sidebar.left")
                }
            }

            // Center items
            ToolbarItem(id: "viewMode", placement: .principal) {
                Picker("View Mode", selection: $viewMode) {
                    Label("Edit", systemImage: "pencil")
                        .tag(ViewMode.edit)
                    Label("Preview", systemImage: "eye")
                        .tag(ViewMode.preview)
                    Label("Split", systemImage: "square.split.2x1")
                        .tag(ViewMode.split)
                }
                .pickerStyle(.segmented)
            }

            // Trailing items
            ToolbarItem(id: "share", placement: .automatic) {
                ShareLink(item: document.url)
            }

            ToolbarItem(id: "settings", placement: .automatic) {
                Button {
                    openSettings()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .toolbarRole(.editor)
    }
}
```

### Toolbar Customization

```swift
.toolbar(id: "main") {
    ToolbarItem(id: "action1", placement: .automatic, showsByDefault: true) {
        Button("Action 1") {}
    }

    ToolbarItem(id: "action2", placement: .automatic, showsByDefault: false) {
        Button("Action 2") {}
    }
}
// Users can right-click toolbar to customize
```

### Toolbar Roles

```swift
// Editor toolbar (with show/hide items)
.toolbarRole(.editor)

// Automatic (default)
.toolbarRole(.automatic)

// Navigation browser (back/forward)
.toolbarRole(.browser)

// No customization
.toolbarRole(.navigationStack)
```

### Toolbar Item Groups

```swift
.toolbar {
    ToolbarItemGroup(placement: .automatic) {
        Button("Action 1") {}
        Button("Action 2") {}
        Button("Action 3") {}
    }
}
```

## Sidebars and Split Views

### Three-Column Layout

```swift
struct ThreeColumnLayout: View {
    @State private var selectedFolder: Folder?
    @State private var selectedItem: Item?

    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(folders, selection: $selectedFolder) { folder in
                Label(folder.name, systemImage: folder.icon)
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        } content: {
            // Content list
            if let folder = selectedFolder {
                List(folder.items, selection: $selectedItem) { item in
                    ItemRow(item: item)
                }
            }
            .navigationSplitViewColumnWidth(min: 300, ideal: 400, max: 500)
        } detail: {
            // Detail view
            if let item = selectedItem {
                ItemDetailView(item: item)
            } else {
                Text("Select an item")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
```

### Collapsible Sidebar

```swift
struct CollapsibleSidebar: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    toggleSidebar()
                } label: {
                    Label("Toggle Sidebar", systemImage: "sidebar.left")
                }
            }
        }
    }

    func toggleSidebar() {
        columnVisibility = columnVisibility == .all ? .detailOnly : .all
    }
}
```

### Sidebar Style

```swift
List {
    Section("Documents") {
        Label("Recent", systemImage: "clock")
        Label("Favorites", systemImage: "star")
    }

    Section("Folders") {
        ForEach(folders) { folder in
            Label(folder.name, systemImage: "folder")
        }
    }
}
.listStyle(.sidebar)  // macOS sidebar style
.navigationTitle("Library")
```

## Menus

### Menu Bar

```swift
@main
struct ArguteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            // Replace existing menu
            CommandGroup(replacing: .newItem) {
                Button("New Document") {
                    newDocument()
                }
                .keyboardShortcut("n")
            }

            // Add to existing menu
            CommandGroup(after: .newItem) {
                Button("Import...") {
                    importDocument()
                }
                .keyboardShortcut("i", modifiers: [.command, .shift])
            }

            // Custom menu
            CommandMenu("Tools") {
                Button("Markdown Preview") {
                    showPreview()
                }
                .keyboardShortcut("p", modifiers: [.command, .shift])

                Divider()

                Button("Export PDF...") {
                    exportPDF()
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])
            }

            // Add to View menu
            CommandGroup(after: .toolbar) {
                Toggle("Show Inspector", isOn: $showInspector)
                    .keyboardShortcut("i", modifiers: [.command, .option])
            }
        }
    }
}
```

### Context Menu

```swift
struct ContextMenuExample: View {
    var body: some View {
        Text("Right-click me")
            .contextMenu {
                Button("Copy") {
                    copy()
                }

                Button("Paste") {
                    paste()
                }

                Divider()

                Menu("Share") {
                    Button("Email") { shareViaEmail() }
                    Button("Messages") { shareViaMessages() }
                }

                Divider()

                Button("Delete", role: .destructive) {
                    delete()
                }
            }
    }
}
```

### Pull-Down Button Menu

```swift
Menu {
    Button("New Document") { newDocument() }
    Button("Open...") { openDocument() }

    Divider()

    Menu("Recent Documents") {
        ForEach(recentDocs) { doc in
            Button(doc.name) {
                openDocument(doc)
            }
        }
    }
} label: {
    Label("File", systemImage: "doc")
}
.menuStyle(.borderlessButton)
```

## Sheets and Popovers

### Sheet (Modal)

```swift
struct SheetExample: View {
    @State private var showSheet = false

    var body: some View {
        Button("Show Sheet") {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            SheetContentView()
                .frame(width: 500, height: 400)
        }
    }
}

struct SheetContentView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Text("Sheet Title")
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
            .padding()

            Divider()

            // Content
            ScrollView {
                // Sheet content
            }
            .padding()

            Divider()

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.escape)

                Spacer()

                Button("Done") {
                    save()
                    dismiss()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
```

### Popover

```swift
struct PopoverExample: View {
    @State private var showPopover = false

    var body: some View {
        Button("Show Popover") {
            showPopover = true
        }
        .popover(isPresented: $showPopover) {
            PopoverContentView()
                .frame(width: 300, height: 200)
        }
    }
}

struct PopoverContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Popover Title")
                .font(.headline)

            Text("Popover content here")
                .font(.body)

            Button("Action") {
                performAction()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

### Alert

```swift
struct AlertExample: View {
    @State private var showAlert = false

    var body: some View {
        Button("Delete") {
            showAlert = true
        }
        .alert("Delete Document?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {}

            Button("Delete", role: .destructive) {
                deleteDocument()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
```

### Confirmation Dialog

```swift
struct ConfirmationExample: View {
    @State private var showConfirmation = false

    var body: some View {
        Button("Options") {
            showConfirmation = true
        }
        .confirmationDialog("Choose an option", isPresented: $showConfirmation) {
            Button("Export PDF") {
                exportPDF()
            }

            Button("Export HTML") {
                exportHTML()
            }

            Button("Export Markdown") {
                exportMarkdown()
            }

            Button("Cancel", role: .cancel) {}
        }
    }
}
```

## Controls

### Pickers

```swift
// Menu picker
Picker("Format", selection: $format) {
    Text("Markdown").tag(Format.markdown)
    Text("Plain Text").tag(Format.plainText)
    Text("Rich Text").tag(Format.richText)
}
.pickerStyle(.menu)

// Segmented picker
Picker("View", selection: $viewMode) {
    Label("Edit", systemImage: "pencil").tag(ViewMode.edit)
    Label("Preview", systemImage: "eye").tag(ViewMode.preview)
    Label("Split", systemImage: "square.split.2x1").tag(ViewMode.split)
}
.pickerStyle(.segmented)

// Radio buttons
Picker("Theme", selection: $theme) {
    Text("Light").tag(Theme.light)
    Text("Dark").tag(Theme.dark)
    Text("Auto").tag(Theme.auto)
}
.pickerStyle(.radioGroup)
```

### Toggles and Checkboxes

```swift
// Toggle (switch)
Toggle("Dark Mode", isOn: $isDarkMode)
    .toggleStyle(.switch)

// Checkbox
Toggle("Show line numbers", isOn: $showLineNumbers)
    .toggleStyle(.checkbox)

// Custom styled toggle
Toggle(isOn: $isEnabled) {
    VStack(alignment: .leading) {
        Text("Feature Name")
            .font(.headline)
        Text("Feature description")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
```

### Sliders

```swift
// Basic slider
Slider(value: $volume, in: 0...100)
    .accessibilityLabel("Volume")
    .accessibilityValue("\(Int(volume))%")

// Slider with labels
VStack {
    Slider(value: $fontSize, in: 10...24, step: 1)

    HStack {
        Text("10pt")
            .font(.caption)
            .foregroundStyle(.secondary)

        Spacer()

        Text("\(Int(fontSize))pt")
            .font(.body)

        Spacer()

        Text("24pt")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
```

### Steppers

```swift
Stepper("Columns: \(columns)", value: $columns, in: 1...4)

// Custom stepper
HStack {
    Text("Font Size")

    Spacer()

    Button {
        fontSize = max(10, fontSize - 1)
    } label: {
        Image(systemName: "minus.circle")
    }
    .buttonStyle(.borderless)

    Text("\(Int(fontSize))pt")
        .frame(width: 50)

    Button {
        fontSize = min(24, fontSize + 1)
    } label: {
        Image(systemName: "plus.circle")
    }
    .buttonStyle(.borderless)
}
```

### Color Picker

```swift
// macOS color picker
ColorPicker("Highlight Color", selection: $highlightColor)

// With opacity control
ColorPicker("Background", selection: $backgroundColor, supportsOpacity: true)
```

## Lists and Tables

### List with Selection

```swift
struct SelectableList: View {
    @State private var selection = Set<Item.ID>()

    var body: some View {
        List(items, selection: $selection) { item in
            ItemRow(item: item)
        }
        .contextMenu(forSelectionType: Item.ID.self) { items in
            if items.isEmpty {
                Button("New Item") { newItem() }
            } else if items.count == 1 {
                Button("Open") { open(items.first!) }
                Button("Rename") { rename(items.first!) }
                Divider()
                Button("Delete", role: .destructive) { delete(items) }
            } else {
                Button("Delete \(items.count) Items", role: .destructive) {
                    delete(items)
                }
            }
        }
    }
}
```

### Table

```swift
struct TableExample: View {
    @State private var documents: [Document]
    @State private var selection = Set<Document.ID>()
    @State private var sortOrder = [KeyPathComparator(\Document.name)]

    var body: some View {
        Table(documents, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name) { doc in
                Label(doc.name, systemImage: doc.icon)
            }

            TableColumn("Modified", value: \.modified) { doc in
                Text(doc.modified, style: .date)
            }

            TableColumn("Size", value: \.size) { doc in
                Text(doc.formattedSize)
            }
        }
        .onChange(of: sortOrder) {
            documents.sort(using: sortOrder)
        }
    }
}
```

### Outline/Disclosure Groups

```swift
struct OutlineExample: View {
    var body: some View {
        List {
            DisclosureGroup("Section 1") {
                Text("Item 1.1")
                Text("Item 1.2")
            }

            DisclosureGroup("Section 2") {
                Text("Item 2.1")

                DisclosureGroup("Nested") {
                    Text("Item 2.2.1")
                    Text("Item 2.2.2")
                }
            }
        }
    }
}
```

## Document-Based Apps

### Document App Structure

```swift
@main
struct ArguteApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ArguteDocument()) { file in
            ContentView(document: file.$document)
        }
        .commands {
            CommandGroup(after: .importExport) {
                Button("Export PDF...") {
                    exportPDF()
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])
            }
        }
    }
}

struct ArguteDocument: FileDocument {
    static var readableContentTypes = [UTType.plainText]

    var text: String

    init(text: String = "") {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
```

### Document Picker

```swift
struct DocumentPickerView: View {
    @State private var showFilePicker = false

    var body: some View {
        Button("Open Document") {
            showFilePicker = true
        }
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.plainText, .markdown],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                openDocument(urls.first!)
            case .failure(let error):
                print(error)
            }
        }
    }
}
```

### Autosave and Versions

```swift
struct ContentView: View {
    @Binding var document: ArguteDocument

    var body: some View {
        TextEditor(text: $document.text)
        // Changes automatically saved by DocumentGroup
    }
}

// Access versions
Button("Browse Versions") {
    NSDocumentController.shared.currentDocument?.browseVersions(nil)
}
```

## Best Practices

### Window Management
- Default to sensible window sizes
- Save and restore window state
- Support full screen mode
- Handle multiple windows gracefully

### Toolbars
- Keep essential actions visible
- Group related actions
- Allow toolbar customization
- Use clear, recognizable icons

### Sidebars
- Keep sidebar widths reasonable (200-300pt)
- Allow collapsing/expanding
- Show visual feedback for selection
- Support keyboard navigation

### Menus
- Follow standard menu organization
- Include keyboard shortcuts
- Keep menu items up to date
- Disable unavailable actions

### Sheets and Modals
- Use for focused tasks only
- Provide clear way to dismiss
- Save state if appropriate
- Don't nest modals deeply

### Controls
- Use native controls when possible
- Provide keyboard alternatives
- Show validation feedback
- Disable when unavailable

---

These patterns create familiar, native-feeling macOS applications that users will find intuitive and enjoyable to use.
