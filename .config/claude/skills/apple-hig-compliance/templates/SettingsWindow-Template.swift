// SettingsWindow-Template.swift
// macOS 26.x Settings Window Template
//
// Copy this template when creating a Settings window for your app.
// Follows macOS 26 Liquid Glass design and HIG patterns.

import SwiftUI

// MARK: - App Declaration

// Add this to your App struct:
/*
@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        // Settings window
        Settings {
            SettingsView()
        }
    }
}
*/

// MARK: - Settings View

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
                .tag(SettingsTab.general)

            EditorSettingsView()
                .tabItem {
                    Label("Editor", systemImage: "doc.text")
                }
                .tag(SettingsTab.editor)

            AppearanceSettingsView()
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush")
                }
                .tag(SettingsTab.appearance)

            AdvancedSettingsView()
                .tabItem {
                    Label("Advanced", systemImage: "gearshape.2")
                }
                .tag(SettingsTab.advanced)
        }
        .frame(width: 550, height: 450)
        // Note: macOS will add window chrome automatically
    }
}

enum SettingsTab {
    case general
    case editor
    case appearance
    case advanced
}

// MARK: - General Settings

struct GeneralSettingsView: View {
    @AppStorage("defaultFolder") private var defaultFolder = ""
    @AppStorage("autoSave") private var autoSave = true
    @AppStorage("confirmDelete") private var confirmDelete = true
    @AppStorage("checkUpdates") private var checkUpdates = true

    var body: some View {
        Form {
            Section {
                // Default folder
                LabeledContent("Default Folder:") {
                    HStack {
                        Text(defaultFolder.isEmpty ? "None" : defaultFolder)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)

                        Spacer()

                        Button("Choose...") {
                            chooseDefaultFolder()
                        }
                    }
                }

                Divider()

                // Auto-save toggle
                Toggle("Auto-save documents", isOn: $autoSave)
                    .help("Automatically save changes as you type")

                Toggle("Confirm before deleting", isOn: $confirmDelete)
                    .help("Show confirmation dialog before deleting items")

                Divider()

                // Updates
                Toggle("Check for updates automatically", isOn: $checkUpdates)

                HStack {
                    Spacer()

                    Button("Check Now") {
                        checkForUpdates()
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    func chooseDefaultFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            defaultFolder = panel.url?.path ?? ""
        }
    }

    func checkForUpdates() {
        // Implement update check
    }
}

// MARK: - Editor Settings

struct EditorSettingsView: View {
    @AppStorage("fontSize") private var fontSize: Double = 14
    @AppStorage("fontFamily") private var fontFamily = "SF Mono"
    @AppStorage("lineHeight") private var lineHeight: Double = 1.5
    @AppStorage("showLineNumbers") private var showLineNumbers = true
    @AppStorage("wrapText") private var wrapText = true
    @AppStorage("indentSize") private var indentSize = 4
    @AppStorage("useSpaces") private var useSpaces = true

    var body: some View {
        Form {
            Section("Font") {
                // Font family
                LabeledContent("Font:") {
                    Picker("", selection: $fontFamily) {
                        Text("SF Mono").tag("SF Mono")
                        Text("Menlo").tag("Menlo")
                        Text("Monaco").tag("Monaco")
                        Text("Courier").tag("Courier")
                    }
                    .labelsHidden()
                    .frame(width: 150)
                }

                // Font size
                LabeledContent("Size:") {
                    HStack {
                        Button {
                            fontSize = max(10, fontSize - 1)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(.borderless)
                        .help("Decrease font size")

                        Text("\(Int(fontSize))pt")
                            .frame(width: 50)
                            .monospacedDigit()

                        Button {
                            fontSize = min(24, fontSize + 1)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                        .buttonStyle(.borderless)
                        .help("Increase font size")
                    }
                }

                // Line height
                LabeledContent("Line Height:") {
                    Slider(value: $lineHeight, in: 1.0...2.0, step: 0.1)
                        .frame(width: 150)

                    Text("\(lineHeight, specifier: "%.1f")")
                        .frame(width: 40)
                        .monospacedDigit()
                }
            }

            Divider()

            Section("Editor") {
                Toggle("Show line numbers", isOn: $showLineNumbers)
                Toggle("Wrap text", isOn: $wrapText)
            }

            Divider()

            Section("Indentation") {
                Toggle("Use spaces instead of tabs", isOn: $useSpaces)

                LabeledContent("Indent size:") {
                    Stepper("\(indentSize) spaces", value: $indentSize, in: 2...8)
                        .frame(width: 150)
                }
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Appearance Settings

struct AppearanceSettingsView: View {
    @AppStorage("appearance") private var appearance: Appearance = .auto
    @AppStorage("accentColor") private var accentColor: AccentColorChoice = .blue
    @AppStorage("sidebarIconSize") private var sidebarIconSize: IconSize = .medium
    @AppStorage("showPreview") private var showPreview = true

    var body: some View {
        Form {
            Section("Theme") {
                Picker("Appearance:", selection: $appearance) {
                    Label("Light", systemImage: "sun.max")
                        .tag(Appearance.light)

                    Label("Dark", systemImage: "moon")
                        .tag(Appearance.dark)

                    Label("Auto", systemImage: "circle.lefthalf.filled")
                        .tag(Appearance.auto)
                }
                .pickerStyle(.radioGroup)
            }

            Divider()

            Section("Colors") {
                LabeledContent("Accent Color:") {
                    HStack(spacing: 8) {
                        ForEach(AccentColorChoice.allCases) { choice in
                            Button {
                                accentColor = choice
                            } label: {
                                Circle()
                                    .fill(choice.color)
                                    .frame(width: 24, height: 24)
                                    .overlay {
                                        if accentColor == choice {
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 2)
                                            Circle()
                                                .strokeBorder(.primary, lineWidth: 1)
                                                .padding(1)
                                        }
                                    }
                            }
                            .buttonStyle(.borderless)
                            .help(choice.name)
                        }
                    }
                }
            }

            Divider()

            Section("Interface") {
                LabeledContent("Sidebar Icon Size:") {
                    Picker("", selection: $sidebarIconSize) {
                        Text("Small").tag(IconSize.small)
                        Text("Medium").tag(IconSize.medium)
                        Text("Large").tag(IconSize.large)
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }

                Toggle("Show preview panel by default", isOn: $showPreview)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

enum Appearance: String {
    case light, dark, auto
}

enum AccentColorChoice: String, CaseIterable, Identifiable {
    case blue, purple, pink, red, orange, yellow, green, gray

    var id: String { rawValue }

    var name: String {
        rawValue.capitalized
    }

    var color: Color {
        switch self {
        case .blue: return .blue
        case .purple: return .purple
        case .pink: return .pink
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .gray: return .gray
        }
    }
}

enum IconSize: String {
    case small, medium, large

    var points: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        }
    }
}

// MARK: - Advanced Settings

struct AdvancedSettingsView: View {
    @AppStorage("enableVimMode") private var enableVimMode = false
    @AppStorage("enableSpellCheck") private var enableSpellCheck = true
    @AppStorage("enableAutoCorrect") private var enableAutoCorrect = false
    @AppStorage("maxUndoLevels") private var maxUndoLevels = 100
    @AppStorage("enableDebugMode") private var enableDebugMode = false

    @State private var showResetConfirmation = false

    var body: some View {
        Form {
            Section("Editor Features") {
                Toggle("Enable Vim mode", isOn: $enableVimMode)
                    .help("Use Vim-style keyboard shortcuts")

                Toggle("Enable spell checking", isOn: $enableSpellCheck)

                Toggle("Enable auto-correct", isOn: $enableAutoCorrect)
            }

            Divider()

            Section("Performance") {
                LabeledContent("Maximum undo levels:") {
                    Stepper("\(maxUndoLevels)", value: $maxUndoLevels, in: 10...500, step: 10)
                        .frame(width: 120)
                }
            }

            Divider()

            Section("Developer") {
                Toggle("Enable debug mode", isOn: $enableDebugMode)
                    .help("Show additional debugging information")

                HStack {
                    Spacer()

                    Button("Open App Support Folder") {
                        openAppSupportFolder()
                    }
                }
            }

            Divider()

            Section {
                HStack {
                    Text("Reset all settings to defaults")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button("Reset...", role: .destructive) {
                        showResetConfirmation = true
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .alert("Reset All Settings?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}

            Button("Reset", role: .destructive) {
                resetSettings()
            }
        } message: {
            Text("This will restore all settings to their default values. This action cannot be undone.")
        }
    }

    func openAppSupportFolder() {
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            NSWorkspace.shared.open(url)
        }
    }

    func resetSettings() {
        // Reset all UserDefaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}

// MARK: - Preview

#Preview("Settings") {
    SettingsView()
}

#Preview("General") {
    GeneralSettingsView()
        .frame(width: 550, height: 450)
}

#Preview("Editor") {
    EditorSettingsView()
        .frame(width: 550, height: 450)
}

#Preview("Appearance") {
    AppearanceSettingsView()
        .frame(width: 550, height: 450)
}

#Preview("Advanced") {
    AdvancedSettingsView()
        .frame(width: 550, height: 450)
}

// MARK: - Usage Notes

/*
USAGE:

1. Copy this file to your project
2. Customize the sections and settings for your app
3. Add Settings scene to your App struct
4. Connect @AppStorage to your actual app state

CUSTOMIZATION:

- Add/remove tabs as needed
- Customize settings per tab
- Use @AppStorage for persistent settings
- Add your own validation logic
- Customize window size if needed

BEST PRACTICES:

- Group related settings together
- Use clear, descriptive labels
- Provide help text for non-obvious settings
- Include reset/defaults functionality
- Validate input values
- Show current values clearly
- Use appropriate control types
- Support keyboard navigation

KEYBOARD SHORTCUTS:

The Settings window automatically supports:
- Cmd+W to close
- Cmd+, to open (add to your main app)
- Tab navigation between controls
*/
