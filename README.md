# Dotfiles

Personal dotfiles for macOS and Linux (Ubuntu/Mint/Arch), featuring Neovim, Tmux, Zsh, and more.

## ✨ Features

- **Neovim**: Fully configured with LSP, DAP, Treesitter, and lazy.nvim
- **AI Assistant**: Avante.nvim for Cursor-like AI coding experience
- **Tmux**: Custom configuration with plugins (TPM, resurrect, continuum)
- **Zsh**: Enhanced shell with zinit, Powerlevel10k, and useful plugins
- **Terminal**: Ghostty configuration with Rose Pine theme
- **Development**: Support for TypeScript/JavaScript, Lua, Swift/iOS, Tailwind CSS, Astro, and more

## 🚀 Quick Start

### One-Line Install

```bash
git clone https://github.com/ivantokar/.dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./setup.sh
```

### Manual Install

1. Clone the repository:

   ```bash
   git clone https://github.com/ivantokar/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the setup script:
   ```bash
   ./setup.sh
   ```

The setup script will automatically detect your OS and run the appropriate installation.

### OS-Specific Installation

If you prefer to run the OS-specific script directly:

**macOS:**

```bash
./setup-macos.sh
```

**Ubuntu/Linux Mint:**

```bash
./setup-ubuntu.sh
```

**Arch Linux:**

```bash
./setup-arch.sh
```

## 📦 What Gets Installed

### Core Tools

- **Neovim** (0.11+) - Modern text editor
- **Tmux** - Terminal multiplexer
- **Zsh** - Shell with zinit plugin manager
- **Stow** - Dotfiles symlink manager

### Terminal Utilities

- **fzf** - Fuzzy finder
- **ripgrep** - Fast grep alternative
- **fd** - Fast find alternative
- **zoxide** - Smart cd replacement

### Development Tools

- **Node.js** - JavaScript runtime
- **Ruby** - For gem packages
- **Python** - For pip packages
- **Git** - Version control

### Language Servers & Formatters

- **typescript-language-server** - TypeScript/JavaScript LSP
- **lua-language-server** - Lua LSP
- **tailwindcss-language-server** - Tailwind CSS LSP
- **astro-language-server** - Astro framework LSP
- **sourcekit-lsp** - Swift/iOS LSP (macOS only)
- **prettierd** - Fast Prettier formatter
- **stylua** - Lua formatter

### Debugging

- **codelldb** - LLDB-based debugger for Swift/C/C++/Rust
- **vscode-js-debug** - JavaScript/TypeScript debugger (auto-installed)

## 🎨 Neovim Configuration

### Keybindings

**Leader key:** `Space`

#### File Navigation

- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep with args (Telescope)
- `<leader>fb` - Find buffers (Telescope)
- `<leader>fh` - Help tags (Telescope)
- `<leader>E` - Toggle file explorer (sidebar, Neo-tree)
- `<leader>e` - Toggle file explorer (floating, Neo-tree)

#### LSP Navigation & Actions

**Built-in Neovim 0.11+ keymaps:**

- `grn` - Rename symbol
- `grr` - Show references
- `gri` - Go to implementation
- `grt` - Go to type definition
- `gra` - Code actions (normal and visual mode)
- `gO` - Document symbols
- `[d` / `]d` - Previous/next diagnostic
- `[D` / `]D` - First/last diagnostic
- `<C-W>d` - Show diagnostics in floating window

**Custom LSP keymaps:**

- `K` - Hover documentation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gl` - Show diagnostics in floating window
- `<leader>gd` - Find definitions (Telescope)
- `<leader>gr` - Find references (Telescope)
- `<leader>gi` - Find implementations (Telescope)
- `<leader>gt` - Find type definitions (Telescope)
- `<leader>gs` - Document symbols (Telescope)
- `<leader>gS` - Workspace symbols (Telescope)
- `<leader>ca` - Code actions (also `gra`)
- `<leader>rn` - Rename symbol (also `grn`)
- `<leader>f` - Format buffer
- `<leader>th` - Toggle inlay hints

#### Completion (Insert Mode)

- `<C-Space>` - Trigger completion
- `<Tab>` - Next completion item / expand snippet
- `<S-Tab>` - Previous completion item / jump back in snippet
- `<CR>` - Confirm completion
- `<C-b>` / `<C-f>` - Scroll documentation up/down
- `<C-e>` - Abort completion

#### Debugging (DAP)

**General debugging:**

- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dc` - Continue/Start debugging
- `<leader>dC` - Run to cursor
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dq` - Terminate
- `<leader>dr` - Restart
- `<leader>du` - Toggle DAP UI
- `<leader>dh` - Hover (show variable value)
- `<leader>dp` - Preview variable

**Swift/iOS debugging (macOS only):**

- `<leader>dd` - Build & debug (Xcode)
- `<leader>dR` - Debug without building (Xcode)
- `<leader>dt` - Debug tests (Xcode)
- `<leader>dT` - Debug class tests (Xcode)

#### Git

**LazyGit:**
- `<leader>lg` - Open LazyGit

**Diffview:**
- `<leader>gdo` - Open diff view (uncommitted changes)
- `<leader>gdc` - Close diff view
- `<leader>gdh` - File history (all files)
- `<leader>gdH` - Current file history
- `<leader>gdf` - Toggle file panel
- `<leader>gdr` - Refresh diff

**Gitsigns (Hunk operations):**
- `]c` - Next hunk
- `[c` - Previous hunk
- `<leader>hp` - Preview hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage buffer
- `<leader>hR` - Reset buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hb` - Blame line
- `<leader>htb` - Toggle line blame
- `<leader>hd` - Diff this file
- `<leader>htd` - Toggle deleted lines

#### Trouble (Diagnostics)

- `<leader>tt` - Toggle Trouble
- `<leader>tw` - Workspace diagnostics
- `<leader>td` - Document diagnostics
- `<leader>tl` - Location list
- `<leader>tq` - Quickfix list
- `gR` - LSP references (Trouble)

#### Xcode/iOS Development (macOS only)

- `<leader>xb` - Build project
- `<leader>xr` - Build & run project
- `<leader>xt` - Run tests
- `<leader>xT` - Run test class
- `<leader>x.` - Repeat last test
- `<leader>xl` - Toggle logs
- `<leader>xc` - Toggle code coverage
- `<leader>xC` - Show coverage report
- `<leader>xd` - Select device
- `<leader>xp` - Select test plan
- `<leader>xs` - Select scheme
- `<leader>xq` - Quickfix line
- `<leader>xa` - Code actions
- `<leader>xX` - Clean project
- `<leader>xx` - Show all Xcode commands

#### AI Assistant (Avante.nvim)

**Chat & Code Generation:**
- Open any file and Avante will be available in the sidebar
- `<CR>` - Submit prompt (Normal mode)
- `<C-s>` - Submit prompt (Insert mode)

**Diff Navigation:**
- `]]` / `[[` - Next/Previous suggestion
- `]x` / `[x` - Next/Previous conflict

**Apply Changes:**
- `a` - Apply suggestion at cursor
- `A` - Apply all suggestions
- `co` - Choose ours (in conflict)
- `ct` - Choose theirs (in conflict)
- `ca` - Choose all theirs
- `cb` - Choose both
- `cc` - Choose at cursor

**Window Management:**
- `<Tab>` - Switch windows
- `<S-Tab>` - Reverse switch windows

**Auto-suggestions (experimental):**
- `<M-l>` - Accept suggestion
- `<M-]>` - Next suggestion
- `<M-[>` - Previous suggestion
- `<C-]>` - Dismiss suggestion

#### Visual Mode

- `J` - Move selected lines down
- `K` - Move selected lines up
- `<leader>p` - Paste without yanking (preserves clipboard)

## 🔧 Tmux Configuration

**Prefix key:** `Ctrl+s` (not default Ctrl+b)

### Key Bindings

- `Ctrl+s |` - Split horizontally
- `Ctrl+s -` - Split vertically
- `Ctrl+s r` - Reload configuration

### Plugins

- **vim-tmux-navigator** - Seamless Vim/Tmux navigation
- **tmux-resurrect** - Save/restore sessions
- **tmux-continuum** - Auto-save sessions

## 🐚 Shell Configuration

### Zsh Plugins (via zinit)

- **Powerlevel10k** - Beautiful prompt
- **zsh-syntax-highlighting** - Command syntax highlighting
- **zsh-autosuggestions** - Fish-like autosuggestions
- **fzf-tab** - Tab completion with fzf

### Aliases

- `vim` → `nvim`
- `c` → `clear`
- `rr` → `exec zsh` (reload shell)

## 📋 Prerequisites

### macOS

- macOS 14+ (earlier versions may work but untested)
- Xcode Command Line Tools: `xcode-select --install`

### Ubuntu/Mint

- Ubuntu 20.04+ or Linux Mint 20+
- `sudo` access

### Arch Linux

- Arch Linux, Manjaro, or EndeavourOS
- `sudo` access

## 🔍 Post-Installation

1. **Restart your terminal** or run: `exec zsh`

2. **Configure Powerlevel10k** (first run):

   ```bash
   p10k configure
   ```

3. **Install tmux plugins**:
   - Open tmux: `tmux`
   - Press `Ctrl+s` then `I` (capital i)

4. **Check Neovim health**:

   ```bash
   nvim +checkhealth
   ```

5. **Configure AI Assistant (Avante.nvim)** (optional):

   Edit `~/.zshrc.local` and add your OpenAI API key:
   ```bash
   export OPENAI_API_KEY="sk-your-key-here"
   ```

   Then reload your shell:
   ```bash
   source ~/.zshrc
   ```

   Get your API key from: https://platform.openai.com/api-keys

6. **For Swift/iOS development** (macOS only):
   - Install Xcode from App Store
   - Configure your project:
     ```bash
     cd /path/to/your/xcode-project
     xcode-build-server config -project YourProject.xcodeproj -scheme YourScheme
     ```

## 🛠️ Customization

All configurations are in `~/.dotfiles/.config/`:

- **Neovim**: `.config/nvim/`
- **Tmux**: `.config/tmux/tmux.conf`
- **Zsh**: `.zshrc`
- **Ghostty**: `.config/ghostty/config`

After making changes:

- Zsh: Run `rr` or `exec zsh`
- Tmux: Press `Ctrl+s` then `r`
- Neovim: Restart or `:source $MYVIMRC`

## 📚 Documentation

- **Plugin docs**: Use `:help <plugin-name>` in Neovim
- **Keybindings**: Press `<leader>?` or `:Telescope keymaps` in Neovim

## 🗂️ Structure

```
.dotfiles/
├── .config/
│   ├── nvim/          # Neovim configuration
│   ├── tmux/          # Tmux configuration
│   ├── ghostty/       # Ghostty terminal config
│   └── gh/            # GitHub CLI config (gitignored)
├── .zshrc             # Zsh configuration
├── setup.sh           # Universal setup script
├── setup-macos.sh     # macOS-specific setup
├── setup-ubuntu.sh    # Ubuntu/Mint setup
├── setup-arch.sh      # Arch Linux setup
└── README.md          # This file
```

## 🔒 Privacy

This repository contains no API keys, tokens, or personal credentials. The following are excluded via `.gitignore`:

- **Local secrets** (`.zshrc.local`) - For API keys and machine-specific settings
- **GitHub CLI authentication** (`.config/gh/`)
- **System-specific configs** (`.config/btop/`)
- **Tmux plugins** (`.config/tmux/plugins/`)
- **Environment files** (`.env*`, `*.pem`, `*.key`)
- **Secrets and credentials** (`*secret*`, `*credential*`)

### Adding API Keys

For AI tools (Avante.nvim, etc.), create a `~/.zshrc.local` file in your **home directory** (not in `.dotfiles/`):

```bash
# Create the file in your HOME directory
touch ~/.zshrc.local

# Edit it and add your API keys
vim ~/.zshrc.local
```

Add your keys:
```bash
# ~/.zshrc.local
export OPENAI_API_KEY="sk-your-key-here"
export ANTHROPIC_API_KEY="sk-ant-your-key-here"
```

**Important:**
- The file must be at `~/.zshrc.local` (in your home directory)
- **NOT** at `~/.dotfiles/.zshrc.local` (don't put it inside the dotfiles repo)
- This file is automatically sourced by `.zshrc` but never committed to git

## 🤝 Contributing

Feel free to fork and customize for your own use!

## 📄 License

MIT License - feel free to use and modify as you wish.

## 🙏 Acknowledgments

Built with these amazing tools:

- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [tmux](https://github.com/tmux/tmux)
- [zinit](https://github.com/zdharma-continuum/zinit)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim)
- [my R2-D2](https://claude.ai/code)

And many more plugins and tools!
