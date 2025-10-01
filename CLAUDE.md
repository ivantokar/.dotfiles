# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository managed with GNU Stow, containing configuration files for terminal environment, shell, and development tools on macOS (Darwin). The repository follows a stow-based structure where configuration files are organized under `.config/` and are symlinked to the home directory.

## Repository Structure

```
.dotfiles/
├── .config/
│   ├── nvim/           # Neovim configuration
│   ├── tmux/           # Tmux configuration and status bar scripts
│   ├── ghostty/        # Ghostty terminal emulator config
│   ├── gh/             # GitHub CLI configuration
│   └── btop/           # btop system monitor configuration
├── .zshrc              # Zsh shell configuration
├── .stow-local-ignore  # Files to ignore when stowing
└── .gitignore          # Git ignore patterns
```

## Deployment with GNU Stow

This dotfiles setup uses GNU Stow to manage symlinks. Files in `.config/` are stowed to `~/.config/`:

```bash
# Deploy all configs
stow -d ~/.dotfiles -t ~/ .

# Deploy specific config
stow -d ~/.dotfiles -t ~/.config .config/nvim
```

The `.stow-local-ignore` file prevents README, LICENSE, version control directories, and backup files from being stowed.

## Shell Configuration (.zshrc)

### Plugin Management
- **zinit**: Modern zsh plugin manager (auto-installs to `~/.local/share/zinit/`)
- **Powerlevel10k**: Terminal prompt theme
- **Plugins**: zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions, fzf-tab
- **OMZ Snippets**: git, sudo, aws, docker, docker-compose, swiftpm, command-not-found

### Key Features
- History: 5000 entries with deduplication
- Case-insensitive completion with menu navigation
- Keybindings: Ctrl+p/n for history search, Ctrl+Alt+w for kill-region
- Integrations: fzf for fuzzy finding, zoxide for smart cd

### Aliases
- `vim` → `nvim`
- `c` → `clear`
- `rr` → `exec zsh` (reload shell)
- `ls` → `ls --color`

### Path Configuration
Includes: Homebrew (`/opt/homebrew/bin`), zinit polaris, system paths, and swiftenv if installed.

## Tmux Configuration

### Prefix Key
Control key is `C-s` (not default `C-b`)

### Key Bindings
- `C-s |`: Split window horizontally (maintains current path)
- `C-s -`: Split window vertically (maintains current path)
- `C-s r`: Reload tmux configuration
- Mouse support enabled

### Window Management
- Base index: 1 (windows start at 1, not 0)
- Auto-renumber windows on close

### Plugins (via TPM)
- tmux-sensible: Sensible defaults
- vim-tmux-navigator: Seamless vim/tmux navigation
- tmux-resurrect: Save/restore sessions
- tmux-continuum: Auto-save sessions (restore on start)

### Status Bar
- Position: Top
- Custom scripts in `.config/tmux/scripts/`:
  - `battery_status.sh`: Battery level indicator
  - `cpu_usage.sh`: CPU usage monitor
  - `boston_time.sh`: Boston timezone display
  - `weather.sh`: Weather information
- Shows: Session name (green), window list (yellow current, gray inactive), battery, CPU, date/time, Boston time, weather

### Configuration Reload
The reload binding uses absolute path: `~/.dotfiles/.config/tmux/tmux.conf`

## Ghostty Terminal Configuration

Minimal configuration in `.config/ghostty/config`:
- Theme: Rose Pine
- Background opacity: 0.98
- Custom keybind: `shift+enter` → sends escape sequence for newline

## GitHub CLI Configuration

Located in `.config/gh/config.yml`:
- Git protocol: HTTPS
- Interactive prompts: Enabled
- Alias: `co` → `pr checkout`

## Neovim Configuration

### Overview
Neovim configuration using lazy.nvim as the plugin manager. Configuration is written in Lua and follows a modular plugin structure.

### Architecture

#### Plugin Management
- **lazy.nvim**: Plugin manager initialized in `.config/nvim/init.lua`
- Plugins are lazy-loaded where possible for performance
- Plugin configurations are in individual files under `.config/nvim/lua/plugins/`
- `lazy-lock.json` locks plugin versions

#### Configuration Structure
```
.config/nvim/
├── init.lua                    # Entry point, sets up lazy.nvim
└── lua/
    ├── vim-options.lua         # Core Vim settings and keybindings
    └── plugins/
        ├── init.lua            # Core dependencies (plenary, devicons)
        └── *.lua               # Individual plugin configurations
```

#### Key Plugin Categories
- **LSP**: Mason + nvim-lspconfig for language servers (lua_ls, ts_ls, sourcekit, emmet, graphql)
- **Completion**: nvim-cmp with LuaSnip for code completion
- **Navigation**: Telescope for fuzzy finding, Neo-tree for file explorer
- **Formatting**: conform.nvim with format-on-save (stylua, prettierd, swift-format)
- **Syntax**: nvim-treesitter with auto-install enabled
- **Git**: lazygit.nvim integration, gitsigns
- **UI**: lualine, which-key, notify, indent-blankline, scrollbar

### Language Support

#### TypeScript/JavaScript
- LSP: ts_ls with inlay hints enabled
- Formatting: prettierd via conform.nvim
- Special command: `:OrganizeImports` for organizing TypeScript imports
- GraphQL support enabled in .ts/.tsx files

#### Lua
- LSP: lua_ls with inlay hints enabled
- Formatting: stylua via conform.nvim

#### Swift/iOS Development
- LSP: sourcekit-lsp for Swift, C, C++, Objective-C, Objective-C++
- Xcode integration: xcodebuild.nvim for building, running, testing, and debugging
- Formatting: Handled by sourcekit-lsp
- Root markers: Package.swift, .git, compile_commands.json, compile_flags.txt

#### Treesitter Parsers
Automatically installed: javascript, typescript, tsx, c, lua, bash, graphql, latex, markdown, vue, html, css, svelte, json, toml, yaml, scss, typst, and more.

### Key Keybindings

Leader key: `<Space>`

#### File Navigation
- `<leader>ff`: Find files (Telescope)
- `<leader>fg`: Live grep with args (Telescope)
- `<leader>fb`: Find buffers (Telescope)
- `<leader>fh`: Help tags (Telescope)
- `<leader>E`: Toggle Neo-tree (left sidebar)
- `<leader>e`: Toggle Neo-tree (floating)

#### LSP

**Built-in Neovim 0.11+ keymaps (work out of the box):**
- `grn`: Rename symbol
- `grr`: Show references
- `gri`: Go to implementation
- `grt`: Go to type definition
- `gra`: Code actions (normal and visual mode)
- `gO`: Document symbols
- `[d` / `]d`: Previous/next diagnostic
- `[D` / `]D`: First/last diagnostic
- `<C-W>d`: Show diagnostics in floating window
- `<C-S>`: Signature help (insert mode)

**Custom keymaps:**
- `K`: Show hover documentation
- `gd`: Go to definition
- `gD`: Go to declaration
- `gl`: Show diagnostics in floating window (alternative to `<C-W>d`)
- `<leader>gd`: Find definitions (Telescope)
- `<leader>gr`: Find references (Telescope)
- `<leader>gi`: Find implementations (Telescope)
- `<leader>gt`: Find type definitions (Telescope)
- `<leader>gs`: Document symbols (Telescope)
- `<leader>gS`: Workspace symbols (Telescope)
- `<leader>ca`: Code actions (also available via `gra`)
- `<leader>rn`: Rename symbol (also available via `grn`)
- `<leader>f`: Format buffer
- `<leader>th`: Toggle inlay hints

#### Completion
- `<C-Space>`: Trigger completion (insert mode)
- `<Tab>`: Next completion item / expand snippet
- `<S-Tab>`: Previous completion item / jump back in snippet
- `<CR>`: Confirm completion (insert mode)
- `<C-b>` / `<C-f>`: Scroll documentation up/down
- `<C-e>`: Abort completion

#### Git
- `<leader>lg`: Open LazyGit

#### Xcode Development (xcodebuild.nvim)
- `<leader>xb`: Build project
- `<leader>xr`: Build & run project
- `<leader>xt`: Run tests
- `<leader>xT`: Run test class
- `<leader>x.`: Repeat last test
- `<leader>xl`: Toggle logs
- `<leader>xc`: Toggle code coverage
- `<leader>xC`: Show coverage report
- `<leader>xd`: Select device
- `<leader>xp`: Select test plan
- `<leader>xs`: Select scheme
- `<leader>xq`: Quickfix line
- `<leader>xa`: Code actions
- `<leader>xX`: Clean project
- `<leader>xx`: Show all Xcode commands

#### Debugging (DAP)

**General debugging:**
- `<leader>db`: Toggle breakpoint
- `<leader>dB`: Set conditional breakpoint
- `<leader>dc`: Continue/Start debugging
- `<leader>dC`: Run to cursor
- `<leader>di`: Step into
- `<leader>do`: Step over
- `<leader>dO`: Step out
- `<leader>dq`: Terminate
- `<leader>dr`: Restart
- `<leader>du`: Toggle DAP UI
- `<leader>dh`: Hover (show variable value)
- `<leader>dp`: Preview

**Swift/iOS debugging:**
- `<leader>dd`: Build & debug (Xcode)
- `<leader>dR`: Debug without building (Xcode)
- `<leader>dt`: Debug tests (Xcode)
- `<leader>dT`: Debug class tests (Xcode)

#### Visual Mode
- `J`: Move selected lines down
- `K`: Move selected lines up
- `<leader>p`: Paste without yanking (preserves clipboard)

#### Other
- `<leader>?`: Show buffer-local keymaps (which-key)

### Modifying Neovim Configuration

#### Adding a New Plugin
1. Create a new file in `.config/nvim/lua/plugins/` (e.g., `.config/nvim/lua/plugins/my-plugin.lua`)
2. Return a table with the plugin spec following lazy.nvim format
3. lazy.nvim auto-loads all files in the `plugins/` directory
4. No need to import manually - lazy.nvim's `setup("plugins")` handles it

#### Adding a New LSP Server
1. Edit `.config/nvim/lua/plugins/lsp.lua`
2. Add server setup in the lspconfig configuration function:
   ```lua
   lspconfig.server_name.setup({
       capabilities = capabilities,
       settings = { ... }
   })
   ```
3. Install the server via Mason: `:Mason`

#### Adding a Formatter
1. Edit `.config/nvim/lua/plugins/conform.lua`
2. Add to the `formatters` table with language → formatter mapping
3. Install the formatter externally (e.g., via npm, cargo, etc.)

### Neovim Configuration Details

#### Format on Save
Enabled globally with 500ms timeout and LSP fallback via conform.nvim (.config/nvim/lua/plugins/conform.lua:17-22).

#### Window Borders
Rounded borders are configured for LSP info, hover, completion, and Neo-tree (.config/nvim/lua/plugins/lsp.lua:22-29, .config/nvim/lua/plugins/neo-tree.lua:13).

#### Undo Persistence
Undo history is saved to `~/.vim/undodir` (.config/nvim/lua/vim-options.lua:12-13).

#### Spell Checking
Enabled by default for US English (.config/nvim/lua/vim-options.lua:24-25).

#### Line Length
80-character column marker (.config/nvim/lua/vim-options.lua:21).

### Xcode/iOS Development Setup

#### Prerequisites
Before using xcodebuild.nvim, install required external tools:
```bash
brew install xcode-build-server xcbeautify ruby pipx rg jq coreutils
gem install xcodeproj
pipx install pymobiledevice3
```

#### First-time Setup
1. Open Neovim in your Xcode project root directory
2. Run `:XcodebuildSetup` to configure the project
3. Use `:XcodebuildPicker` (or `<leader>xx`) to see all available actions

#### Key Features
- Build and run iOS/macOS apps from Neovim
- Run tests (all, class, or specific tests)
- Device/simulator selection
- Code coverage reports
- Auto-open logs on build/test failures
- Integration with Telescope for pickers

### Debugging Setup (DAP)

#### TypeScript/JavaScript Debugging
The configuration uses `vscode-js-debug` via `nvim-dap-vscode-js`. It's automatically installed when you first open Neovim.

**Supported configurations:**
- Launch current file (Node.js)
- Attach to running process
- Debug Jest tests
- Debug Chrome/browser applications

**Usage:**
1. Set breakpoints with `<leader>db`
2. Start debugging with `<leader>dc`
3. DAP UI opens automatically

#### Swift/iOS Debugging

**Prerequisites:**
1. Download codelldb for macOS (aarch64-darwin) from: https://github.com/vadimcn/codelldb/releases
2. Extract to `~/tools/codelldb-aarch64-darwin/`
3. Ensure the path exists: `~/tools/codelldb-aarch64-darwin/extension/adapter/codelldb`

**Usage:**
1. Set breakpoints in your Swift code with `<leader>db`
2. Build and start debugging with `<leader>dd`
3. Or debug without rebuilding with `<leader>dR`
4. Debug tests with `<leader>dt`

**Features:**
- Full integration with xcodebuild.nvim
- Automatic app building before debugging
- iOS Simulator and device debugging support
- Virtual text showing variable values
- Interactive REPL console

## Installation

### Quick Start

Clone and run setup:
```bash
git clone https://github.com/ivantokar/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

The setup script automatically detects your OS and runs the appropriate installer.

### Manual OS-Specific Setup

- **macOS**: `./setup-macos.sh`
- **Ubuntu/Mint**: `./setup-ubuntu.sh`
- **Arch Linux**: `./setup-arch.sh`

Each script installs all dependencies, sets up tools, and stows configurations.

## Working with This Repository

### Making Changes
1. Edit files directly in `~/.dotfiles/`
2. Changes to stowed files (in `.config/`) are immediately reflected via symlinks
3. For `.zshrc` changes, reload with `rr` alias or `source ~/.zshrc`
4. For tmux changes, reload with `C-s r` inside tmux

### Adding New Configurations
1. Place new config files in appropriate `.config/` subdirectory
2. Update `.stow-local-ignore` if needed to exclude certain files
3. Re-stow to create symlinks: `stow -R -d ~/.dotfiles -t ~/ .`

### Git Workflow
- Main branch: `main`
- Ignored: btop cache, gh credentials, macOS .DS_Store files, various app configs

## Environment
- Platform: macOS (Darwin)
- Shell: zsh with zinit
- Terminal: Ghostty with tmux
- Editor: Neovim (lazy.nvim)
- Version Control: Git with GitHub CLI
