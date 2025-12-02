// Toolbar-Template.swift
// macOS 26.x Native Toolbar Template
//
// Copy this template when creating toolbars for your app.
// Follows macOS 26 patterns and supports customization.

import SwiftUI

// MARK: - Basic Toolbar

struct BasicToolbarView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar {
            // Leading items (left side)
            ToolbarItem(placement: .navigation) {
                Button {
                    toggleSidebar()
                } label: {
                    Label("Toggle Sidebar", systemImage: "sidebar.left")
                }
                .help("Show or hide the sidebar")
            }

            // Trailing items (right side)
            ToolbarItem(placement: .automatic) {
                Button {
                    share()
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }

    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(
            #selector(NSSplitViewController.toggleSidebar(_:)),
            with: nil
        )
    }

    func share() {
        // Implement sharing
    }
}

// MARK: - Full-Featured Toolbar

struct FullToolbarView: View {
    @State private var viewMode: ViewMode = .split
    @State private var searchText = ""
    @State private var sortOrder: SortOrder = .name
    @State private var showInspector = false

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            DetailView()
        }
        .toolbar(id: "main") {
            // MARK: Navigation Group (Left)

            ToolbarItem(
                id: "sidebar",
                placement: .navigation,
                showsByDefault: true
            ) {
                Button {
                    toggleSidebar()
                } label: {
                    Label("Sidebar", systemImage: "sidebar.left")
                }
                .help("Toggle Sidebar (⌘⇧L)")
                .keyboardShortcut("l", modifiers: [.command, .shift])
            }

            // MARK: Principal Group (Center)

            ToolbarItem(
                id: "viewMode",
                placement: .principal,
                showsByDefault: true
            ) {
                Picker("View Mode", selection: $viewMode) {
                    Label("Edit", systemImage: "pencil")
                        .tag(ViewMode.edit)

                    Label("Preview", systemImage: "eye")
                        .tag(ViewMode.preview)

                    Label("Split", systemImage: "square.split.2x1")
                        .tag(ViewMode.split)
                }
                .pickerStyle(.segmented)
                .help("Change view mode")
            }

            // MARK: Automatic Group (Right)

            ToolbarItem(
                id: "search",
                placement: .automatic,
                showsByDefault: true
            ) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("Search", text: $searchText)
                        .textFieldStyle(.plain)
                        .frame(width: 150)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
            }

            ToolbarItem(
                id: "sort",
                placement: .automatic,
                showsByDefault: false  // Hidden by default, user can enable
            ) {
                Menu {
                    Picker("Sort", selection: $sortOrder) {
                        Label("Name", systemImage: "textformat")
                            .tag(SortOrder.name)

                        Label("Date Modified", systemImage: "clock")
                            .tag(SortOrder.date)

                        Label("Size", systemImage: "arrow.up.arrow.down")
                            .tag(SortOrder.size)
                    }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
                .help("Sort items")
            }

            ToolbarItem(
                id: "share",
                placement: .automatic,
                showsByDefault: true
            ) {
                ShareLink(item: currentDocument)
                    .help("Share document")
            }

            ToolbarItem(
                id: "inspector",
                placement: .automatic,
                showsByDefault: true
            ) {
                Button {
                    showInspector.toggle()
                } label: {
                    Label("Inspector", systemImage: "info.circle")
                }
                .help("Show Inspector (⌘⌥I)")
                .keyboardShortcut("i", modifiers: [.command, .option])
            }
        }
        .toolbarRole(.editor)  // Allows customization
    }

    var currentDocument: URL {
        // Return current document URL
        URL(string: "https://example.com")!
    }

    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(
            #selector(NSSplitViewController.toggleSidebar(_:)),
            with: nil
        )
    }
}

enum ViewMode {
    case edit, preview, split
}

enum SortOrder {
    case name, date, size
}

// MARK: - Customizable Toolbar

struct CustomizableToolbarView: View {
    var body: some View {
        ContentView()
            .toolbar(id: "main") {
                // Essential items (always visible)
                ToolbarItem(
                    id: "new",
                    placement: .automatic,
                    showsByDefault: true
                ) {
                    Button {
                        newDocument()
                    } label: {
                        Label("New", systemImage: "doc.badge.plus")
                    }
                    .help("New Document (⌘N)")
                }

                // Optional items (user can toggle)
                ToolbarItem(
                    id: "format",
                    placement: .automatic,
                    showsByDefault: false
                ) {
                    Menu {
                        Button("Bold") { formatBold() }
                        Button("Italic") { formatItalic() }
                        Button("Underline") { formatUnderline() }
                    } label: {
                        Label("Format", systemImage: "textformat")
                    }
                }

                ToolbarItem(
                    id: "export",
                    placement: .automatic,
                    showsByDefault: false
                ) {
                    Button {
                        exportPDF()
                    } label: {
                        Label("Export PDF", systemImage: "arrow.down.doc")
                    }
                }
            }
            .toolbarRole(.editor)  // Enable customization
    }

    func newDocument() {}
    func formatBold() {}
    func formatItalic() {}
    func formatUnderline() {}
    func exportPDF() {}
}

// MARK: - Toolbar with Groups

struct GroupedToolbarView: View {
    var body: some View {
        ContentView()
            .toolbar {
                // Group related actions together
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        undo()
                    } label: {
                        Label("Undo", systemImage: "arrow.uturn.backward")
                    }
                    .disabled(!canUndo)

                    Button {
                        redo()
                    } label: {
                        Label("Redo", systemImage: "arrow.uturn.forward")
                    }
                    .disabled(!canRedo)
                }

                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        cut()
                    } label: {
                        Label("Cut", systemImage: "scissors")
                    }

                    Button {
                        copy()
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }

                    Button {
                        paste()
                    } label: {
                        Label("Paste", systemImage: "doc.on.clipboard")
                    }
                }
            }
    }

    var canUndo: Bool { true }
    var canRedo: Bool { false }

    func undo() {}
    func redo() {}
    func cut() {}
    func copy() {}
    func paste() {}
}

// MARK: - Document Toolbar

struct DocumentToolbarView: View {
    @Binding var document: Document
    @State private var showExportOptions = false

    var body: some View {
        DocumentView(document: $document)
            .toolbar {
                // Document-specific actions
                ToolbarItemGroup(placement: .automatic) {
                    // Save status
                    if document.hasUnsavedChanges {
                        Text("Edited")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // Lock/unlock
                    Button {
                        document.isLocked.toggle()
                    } label: {
                        Label(
                            document.isLocked ? "Unlock" : "Lock",
                            systemImage: document.isLocked ? "lock" : "lock.open"
                        )
                    }

                    Divider()

                    // Print
                    Button {
                        print()
                    } label: {
                        Label("Print", systemImage: "printer")
                    }
                    .help("Print (⌘P)")
                    .keyboardShortcut("p")

                    // Export
                    Button {
                        showExportOptions = true
                    } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showExportOptions) {
                ExportOptionsView(document: document)
            }
    }

    func print() {
        // Implement printing
    }
}

struct Document {
    var hasUnsavedChanges: Bool = false
    var isLocked: Bool = false
}

// MARK: - Browser-Style Toolbar

struct BrowserToolbarView: View {
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var currentURL = ""

    var body: some View {
        ContentView()
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    // Back button
                    Button {
                        goBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                    .disabled(!canGoBack)
                    .help("Go Back (⌘[)")
                    .keyboardShortcut("[", modifiers: .command)

                    // Forward button
                    Button {
                        goForward()
                    } label: {
                        Label("Forward", systemImage: "chevron.right")
                    }
                    .disabled(!canGoForward)
                    .help("Go Forward (⌘])")
                    .keyboardShortcut("]", modifiers: .command)
                }

                ToolbarItem(placement: .principal) {
                    // URL/path field
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundStyle(.secondary)

                        TextField("Path", text: $currentURL)
                            .textFieldStyle(.plain)

                        Button {
                            reload()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
                }
            }
            .toolbarRole(.browser)
    }

    func goBack() {}
    func goForward() {}
    func reload() {}
}

// MARK: - Compact Toolbar

struct CompactToolbarView: View {
    var body: some View {
        ContentView()
            .toolbar {
                // Single overflow menu for compact layouts
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Button("New") { newDocument() }
                        Button("Open...") { openDocument() }
                        Button("Save") { saveDocument() }

                        Divider()

                        Button("Export PDF...") { exportPDF() }
                        Button("Share...") { share() }

                        Divider()

                        Button("Settings...") { openSettings() }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
    }

    func newDocument() {}
    func openDocument() {}
    func saveDocument() {}
    func exportPDF() {}
    func share() {}
    func openSettings() {}
}

// MARK: - Preview Helpers

struct SidebarView: View {
    var body: some View {
        List {
            Text("Sidebar")
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Detail")
    }
}

struct ContentView: View {
    var body: some View {
        Text("Content")
    }
}

struct DocumentView: View {
    @Binding var document: Document

    var body: some View {
        Text("Document")
    }
}

struct ExportOptionsView: View {
    let document: Document

    var body: some View {
        Text("Export Options")
    }
}

// MARK: - Previews

#Preview("Basic Toolbar") {
    BasicToolbarView()
        .frame(width: 800, height: 600)
}

#Preview("Full Toolbar") {
    FullToolbarView()
        .frame(width: 1000, height: 700)
}

#Preview("Browser Toolbar") {
    BrowserToolbarView()
        .frame(width: 900, height: 600)
}

// MARK: - Usage Notes

/*
TOOLBAR PLACEMENTS:

.navigation
    - Left side of toolbar
    - Typically for sidebar toggle, back/forward

.principal
    - Center of toolbar
    - Usually for document title or view mode

.automatic
    - Right side of toolbar
    - For actions, controls, search

.status
    - Right side of window title
    - macOS-specific placement

TOOLBAR ROLES:

.editor
    - Customizable toolbar
    - Shows "Customize Toolbar..." option
    - Users can add/remove/rearrange items

.browser
    - Browser-style with back/forward
    - Good for navigation-heavy apps

.automatic
    - Default behavior

CUSTOMIZATION:

toolbar(id: "unique-id") {
    ToolbarItem(
        id: "item-id",              // Required for customization
        placement: .automatic,
        showsByDefault: true        // Visible by default
    ) {
        // Content
    }
}

BEST PRACTICES:

1. Use clear, descriptive labels
2. Include keyboard shortcuts for common actions
3. Group related items together
4. Provide help text with .help()
5. Disable unavailable actions
6. Use SF Symbols for consistency
7. Keep toolbars uncluttered
8. Allow customization when appropriate
9. Show status/feedback when relevant
10. Test with different window sizes

SF SYMBOLS FOR TOOLBARS:

Common toolbar icons:
- sidebar.left - Toggle sidebar
- square.and.arrow.up - Share
- magnifyingglass - Search
- textformat - Formatting
- doc.badge.plus - New document
- folder - Open
- square.and.arrow.down - Save
- printer - Print
- gearshape - Settings
- info.circle - Info/Inspector
- ellipsis.circle - More options
- arrow.uturn.backward - Undo
- arrow.uturn.forward - Redo

KEYBOARD SHORTCUTS:

Standard shortcuts to implement:
- ⌘N - New
- ⌘O - Open
- ⌘S - Save
- ⌘P - Print
- ⌘W - Close
- ⌘⇧L - Toggle Sidebar
- ⌘⌥I - Inspector
- ⌘F - Find
- ⌘Z - Undo
- ⌘⇧Z - Redo
*/
