# Dotfiles

Personal macOS-first dotfiles for daily development. The setup is terminal-centric and built around two kinds of work:

- **Apple platforms** — Swift, iOS and macOS apps built from Neovim with [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim), [sourcekit-lsp](https://github.com/swiftlang/sourcekit-lsp) and `xcode-build-server`, without opening Xcode for everyday editing.
- **Web and backend** — TypeScript, React, Astro, MDX, GraphQL and Tailwind, plus server-side Swift (Vapor).

One command bootstraps a new machine, and everything is symlinked from this repo so the live config is always the tracked config.

**Theme:** [Rosé Pine](https://rosepinetheme.com) in Kitty and Neovim. **Font:** [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads).

## Contents

- [The stack](#the-stack)
- [Bootstrap](#bootstrap)
- [Neovim](#neovim)
- [Swift and Xcode workflow](#swift-and-xcode-workflow)
- [Keymaps](#keymaps)
- [tmux](#tmux)
- [Shell](#shell)
- [Kitty](#kitty)
- [Window management](#window-management)
- [Voice dictation](#voice-dictation)
- [AI tooling](#ai-tooling)
- [Secrets](#secrets)
- [Repo layout](#repo-layout)
- [CI](#ci)

## The stack

| Area | Tool | Config |
| --- | --- | --- |
| Terminal | [Kitty](https://sw.kovidgoyal.net/kitty/) | `.config/kitty/` |
| Multiplexer | [tmux](https://github.com/tmux/tmux) + [TPM](https://github.com/tmux-plugins/tpm) | `.config/tmux/` |
| Shell | [zsh](https://www.zsh.org/) + [zinit](https://github.com/zdharma-continuum/zinit) + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | `.zshrc`, `.p10k.zsh` |
| Shell history | [Atuin](https://atuin.sh) | `.config/atuin/config.toml` |
| Fuzzy find / jump | [fzf](https://github.com/junegunn/fzf), [fzf-tab](https://github.com/Aloxaf/fzf-tab), [zoxide](https://github.com/ajeetdsouza/zoxide) | `.zshrc` |
| Editor | [Neovim](https://neovim.io) 0.12+ with [lazy.nvim](https://github.com/folke/lazy.nvim) | `.config/nvim/` |
| Secondary editor | [Zed](https://zed.dev) | `.config/zed/settings.json` |
| Git | [git](https://git-scm.com), [GitHub CLI](https://cli.github.com), [LazyGit](https://github.com/jesseduffield/lazygit), [git-lfs](https://git-lfs.com) | `.gitconfig`, `.config/git/`, `.config/gh/` |
| Diff viewer | [Hunk](https://www.npmjs.com/package/hunkdiff) | `.config/hunk/config.toml` |
| Tiling window manager | [AeroSpace](https://github.com/nikitabobko/AeroSpace) | `.config/aerospace/aerospace.toml` |
| Window borders | [JankyBorders](https://github.com/FelixKratz/JankyBorders) | `.config/borders/bordersrc` |
| Voice dictation | [open-wispr](https://github.com/human37/open-wispr) | `.config/open-wispr/config.json` |
| AI agents | [Claude Code](https://github.com/anthropics/claude-code), [Codex](https://github.com/openai/codex) | `.config/claude/` |
| Packages | [Homebrew](https://brew.sh) | `Brewfile` |

Search and file tooling used by the editor and shell: [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd), [jq](https://github.com/jqlang/jq), [ImageMagick](https://imagemagick.org).

## Bootstrap

```bash
git clone https://github.com/ivantokar/.dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./setup.sh
```

`setup.sh` is the single entry point. It detects the OS, installs packages (Homebrew on macOS), symlinks every config into `$HOME`, backs up conflicting files to `~/dotfiles_backup/<timestamp>/`, and runs post-setup steps (zinit, TPM, Neovim and tmux plugins).

```bash
./setup.sh --dry-run          # preview, no changes
./setup.sh --link-only        # symlinks only, skip packages and post-setup
./setup.sh --skip-packages    # skip dependency installation
./setup.sh --install-packages # Linux: also install packages (links only by default)
```

Update an existing machine:

```bash
cd ~/.dotfiles && git pull && ./setup.sh --skip-packages
```

Manual checks afterwards:

```bash
exec zsh
nvim +checkhealth
```

`Brewfile` holds the full list of formulae, casks and global npm packages (`brew bundle --file Brewfile`). Apps installed outside Homebrew (Kitty, Zed) are not in it.

## Neovim

A standalone [lazy.nvim](https://github.com/folke/lazy.nvim) config (no distribution) for **Neovim 0.12+**. It uses native `vim.lsp`, Mason-managed language servers and the current Tree-sitter parser/query API. Four-space indentation, relative line numbers, no swap files, persistent undo, 80-column ruler. Leader is `<Space>`.

Every plugin lives in its own file under `lua/plugins/`.

### Plugins

| Category | Plugins |
| --- | --- |
| Theme | [rose-pine/neovim](https://github.com/rose-pine/neovim) |
| UI | [lualine](https://github.com/nvim-lualine/lualine.nvim), [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim), [nvim-notify](https://github.com/rcarriga/nvim-notify), [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar), [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim), [which-key](https://github.com/folke/which-key.nvim), [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) |
| Navigation | [Telescope](https://github.com/nvim-telescope/telescope.nvim) (+ [ui-select](https://github.com/nvim-telescope/telescope-ui-select.nvim)), [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim), [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator), [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) |
| LSP | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), [mason.nvim](https://github.com/williamboman/mason.nvim), [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim), [sense.nvim](https://github.com/boltlessengineer/sense.nvim) (off-screen diagnostics) |
| Completion | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with LSP, buffer, path and cmdline sources, [LuaSnip](https://github.com/L3MON4D3/LuaSnip), [lspkind](https://github.com/onsails/lspkind.nvim), [Supermaven](https://github.com/supermaven-inc/supermaven-nvim) in the completion menu |
| Syntax | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch), [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag), [ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) |
| Editing | [conform.nvim](https://github.com/stevearc/conform.nvim), [nvim-autopairs](https://github.com/windwp/nvim-autopairs), [Comment.nvim](https://github.com/numToStr/Comment.nvim), [vim-visual-multi](https://github.com/mg979/vim-visual-multi) |
| Git | [gitsigns](https://github.com/lewis6991/gitsigns.nvim), [diffview](https://github.com/sindrets/diffview.nvim), [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) |
| Diagnostics | [trouble.nvim](https://github.com/folke/trouble.nvim) |
| Debugging | [nvim-dap](https://github.com/mfussenegger/nvim-dap), [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui), [virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text), [nvim-dap-vscode-js](https://github.com/mxsdev/nvim-dap-vscode-js) + [vscode-js-debug](https://github.com/microsoft/vscode-js-debug) |
| Apple platforms | [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) |
| Images | [snacks.nvim](https://github.com/folke/snacks.nvim) (inline images over the kitty graphics protocol, also through tmux) |
| Code map | [xmap.nvim](https://github.com/ivantokar/xmap.nvim), my own minimap plugin |

### Languages

| Language | Server | Formatter |
| --- | --- | --- |
| Swift, C, Obj-C | `sourcekit-lsp` | xcodebuild.nvim / sourcekit-lsp; [swift-format](https://github.com/swiftlang/swift-format) and [SwiftLint](https://github.com/realm/SwiftLint) installed |
| TypeScript / JavaScript / TSX / JSX | `ts_ls` | [prettierd](https://github.com/fsouza/prettierd) |
| Astro | `astro` ([language-tools](https://github.com/withastro/language-tools)) | — |
| MDX | Tree-sitter markdown | prettierd |
| Tailwind CSS | `tailwindcss` | — |
| HTML / CSS (Emmet) | `emmet_language_server` | — |
| GraphQL | `graphql` | — |
| Lua | `lua_ls` | [StyLua](https://github.com/JohnnyMorganz/StyLua) |

Servers installed by Mason: `astro`, `emmet_language_server`, `graphql`, `lua_ls`, `tailwindcss`, `ts_ls`. Formatting runs on save (500 ms timeout, LSP fallback). Tree-sitter parsers install in the background and include `astro`, `swift`, `tsx`, `markdown`, `latex`, `graphql`, plus a custom `stencil` parser from [ivantokar/tree-sitter-stencil](https://github.com/ivantokar/tree-sitter-stencil).

Inline images need Kitty (or another kitty-graphics terminal) and `magick`; PDF, LaTeX math and Mermaid rendering use `gs`, `tectonic` and `mmdc`.

## Swift and Xcode workflow

This editor config exists mainly so iOS and macOS work does not require living in Xcode. It uses [xcodebuild.nvim](https://github.com/wojciech-kulik/xcodebuild.nvim) for building, running, testing and debugging, with `sourcekit-lsp` for code intelligence.

Requirements (macOS): Xcode from the App Store, then `xcode-build-server` and `xcbeautify` (both are in the `Brewfile`).

Per-project setup:

```bash
# once per project: generate build server metadata for sourcekit-lsp
xcode-build-server config -project YourProject.xcodeproj -scheme YourScheme
```

Then in Neovim:

1. `<leader>Xi` sets the project up (scheme, device, test plan).
2. `<leader>Xr` builds and runs; `<leader>Xb` only builds.
3. `<leader>Xl` toggles the build/test log; failed builds and tests open it automatically.
4. `<leader>Xt` / `<leader>XT` run tests or the current test class; `<leader>X.` repeats the last test.
5. `<leader>dd` builds and starts the debugger; breakpoints use the standard `<leader>d` DAP keys below.
6. `<leader>Xx` opens a picker with every Xcode command.

Notes:

- The last scheme, device and test plan are restored on start (`restore_on_start`).
- Simulators and macOS need nothing extra. Physical devices are optional and need [pymobiledevice3](https://github.com/doronz88/pymobiledevice3) (`pipx install pymobiledevice3`) plus enabling the integration in `lua/plugins/xcodebuild.lua`.
- Xcode 16+ no longer needs codelldb for debugging.
- Code coverage is off by default; `<leader>Xc` toggles it.

## Keymaps

### Neovim (leader = `Space`)

**General**

| Keys | Action |
| --- | --- |
| `J` / `K` (visual) | Move selected lines down / up |
| `<leader>p` (visual) | Paste without overwriting the register |
| `[q` / `]q` | Previous / next quickfix entry |
| `[d` / `]d` | Previous / next diagnostic |
| `gcc`, `gc`, `gb` | Comment line / selection / block |
| `<C-n>` | Multi-cursor on the word ([vim-visual-multi](https://github.com/mg979/vim-visual-multi)) |
| `Ctrl-h/j/k/l` | Move between Neovim splits and tmux panes |

**Files and search (Telescope)**

| Keys | Action |
| --- | --- |
| `<leader>ff` / `<leader>fa` | Find files / all files |
| `<leader>fg` / `<leader>fw` | Live grep / grep word under cursor |
| `<leader>fb` / `<leader>fr` | Buffers / recent files |
| `<leader>fc` / `<leader>fk` / `<leader>fh` | Commands / keymaps / help tags |
| `<leader>fd` / `<leader>fo` | Diagnostics / resume last picker |
| `<C-q>` (in picker) | Send results to the quickfix list |
| `<leader>e` / `<leader>E` | File explorer (float / left sidebar) |
| `<leader>b` / `<leader>B` | Buffer explorer (float / left sidebar) |

**LSP**

| Keys | Action |
| --- | --- |
| `K` | Hover documentation |
| `gd` / `gD` | Definition / declaration |
| `gl` | Line diagnostics |
| `<leader>gd` / `gr` / `gi` / `gt` | Definitions / references / implementations / type definitions (Telescope) |
| `<leader>gs` | Document symbols |
| `gra` / `grn` / `grr` / `gri` | Code action / rename / references / implementation (Neovim defaults) |
| `<leader>th` | Toggle inlay hints |
| `<leader>io` / `ia` / `iu` | TypeScript: organize / add missing / remove unused imports |

**Git**

| Keys | Action |
| --- | --- |
| `<leader>lg` | LazyGit |
| `]c` / `[c` | Next / previous hunk |
| `<leader>hs` / `hr` / `hu` | Stage / reset / undo-stage hunk |
| `<leader>hS` / `hR` | Stage / reset buffer |
| `<leader>hp` / `hd` | Preview hunk / diff this |
| `<leader>htb` / `htd` | Toggle line blame / deleted lines |
| `<leader>gdo` / `gdc` | Open / close Diffview |
| `<leader>gdh` / `gdH` | Branch file history / current file history |
| `<leader>gdf` / `gdr` | Toggle file panel / refresh |

**Diagnostics (Trouble)**

| Keys | Action |
| --- | --- |
| `<leader>tt` | Toggle Trouble |
| `<leader>tw` / `td` | Workspace / document diagnostics |
| `<leader>tq` / `tl` | Quickfix / location list |

**Xcode** (`<leader>X`)

| Keys | Action |
| --- | --- |
| `Xi` | Set up project |
| `Xb` / `Xr` | Build / build and run |
| `Xt` / `XT` / `X.` | Run tests / test class / repeat |
| `Xl` | Toggle logs |
| `Xs` / `Xd` / `Xp` | Select scheme / device / test plan |
| `Xc` / `XC` | Toggle coverage / coverage report |
| `Xa` / `Xq` | Code actions / quickfix line |
| `XX` | Clean project |
| `Xx` | Show all commands |

**Debugging** (`<leader>d`)

| Keys | Action |
| --- | --- |
| `db` / `dB` | Toggle / conditional breakpoint |
| `dc` / `dC` | Continue / run to cursor |
| `di` / `do` / `dO` | Step into / over / out |
| `dr` / `dq` | Restart / terminate |
| `du` / `dh` / `dp` | Toggle UI / hover / preview |
| `dd` / `dR` | Xcode: build and debug / debug without building |
| `dt` / `dT` | Xcode: debug tests / debug class tests |

**Code map**

| Keys | Action |
| --- | --- |
| `<leader>mm` / `<leader>mf` | Toggle / focus the xmap minimap |
| `<leader>R` | Reload xmap.nvim |

Press `<leader>` and wait, or `<leader>fk`, for the live which-key / Telescope listing of every mapping.

### tmux (prefix = `Ctrl-s`)

| Keys | Action |
| --- | --- |
| `prefix \|` / `prefix -` | Split horizontally / vertically in the current directory |
| `prefix r` | Reload config |
| `prefix e` / `prefix E` | Agent sidebar for this window / for every window |
| `prefix I` | Install TPM plugins |
| `Ctrl-h/j/k/l` | Move between panes (and Neovim splits) |

### Shell

| Keys | Action |
| --- | --- |
| `Ctrl-p` / `Ctrl-n` | History search backward / forward |
| `Ctrl-r` | Atuin history search |
| `Alt-w` | Kill region |
| `vim` | Alias for `nvim` |
| `c` / `rr` | `clear` / `exec zsh` |

### Window manager (AeroSpace, `Alt` = modifier)

| Keys | Action |
| --- | --- |
| `Alt-h/j/k/l` | Focus left / down / up / right |
| `Alt-Shift-h/j/k/l` | Move window |
| `Alt-1`…`9` | Switch to workspace |
| `Alt-Shift-1`…`9` | Move window to workspace |
| `Alt-/` / `Alt-,` | Tiles / accordion layout |
| `Alt--` / `Alt-=` | Resize smaller / larger |

Letter workspaces (`Alt-a`…`Alt-z`) are bound as well. AeroSpace starts at login with nine persistent workspaces.

### Voice dictation (open-wispr)

Hold **Right Cmd** to record, release to type the transcription at the cursor.

## tmux

Config in `.config/tmux/tmux.conf`. Mouse on, windows start at 1 and renumber, panes open in the current directory, and the status bar sits on top.

Plugins (via [TPM](https://github.com/tmux-plugins/tpm)):

- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) — sane defaults
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) — seamless `Ctrl-hjkl` between tmux and Neovim
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) + [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) — save and auto-restore sessions
- [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key) — discoverable key menu
- [tmux-agent-sidebar](https://github.com/hiroppy/tmux-agent-sidebar) — one sidebar for every Claude Code and Codex pane

The right side of the status bar runs three small scripts from `.config/tmux/scripts/`: `weather.sh` (needs `OPENWEATHER_API_KEY`, see [Secrets](#secrets)), `world_clock.sh` and `system_metrics.sh`. `allow-passthrough` is on so inline images from Neovim work inside tmux.

## Shell

zsh managed by [zinit](https://github.com/zdharma-continuum/zinit):

- Prompt: [Powerlevel10k](https://github.com/romkatv/powerlevel10k) (instant prompt, config in `.p10k.zsh`)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [fzf-tab](https://github.com/Aloxaf/fzf-tab) with directory previews
- Oh My Zsh snippets: `git`, `sudo`, `aws`, `docker`, `docker-compose`, `swiftpm`, `command-not-found`
- [zoxide](https://github.com/ajeetdsouza/zoxide) for `z`, [fzf](https://github.com/junegunn/fzf) key bindings
- [Atuin](https://atuin.sh) for history (daemon, fuzzy search, Enter accepts)
- 5000-line shared history with duplicate erasure

Machine-local settings (API keys, extra PATH) go in `~/.zshrc.local`, which is sourced but never tracked.

## Kitty

`.config/kitty/kitty.conf` sets JetBrainsMono Nerd Font at 11.5 with 110% line height, a 92% translucent blurred background, a hidden title bar, 10 px padding, a beam cursor and a tab bar that only appears with two or more tabs. `Option` works as `Alt` so tmux and Neovim shortcuts behave.

The theme is managed with Kitty's built-in `kitten themes`, so the colors are the official ones rather than hand-written:

```bash
kitten themes                          # interactive picker with live preview
kitten themes "Rosé Pine"              # apply by name
kitten themes --dump-theme "Rosé Pine" # print without changing anything
```

The kitten writes `current-theme.conf` (tracked here) and adds an `include current-theme.conf` block to `kitty.conf`.

## Window management

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is an i3-style tiling window manager (4 px gaps, none at the top) and [JankyBorders](https://github.com/FelixKratz/JankyBorders) draws a faint white border around the active window only. Borders run as a Homebrew service:

```bash
brew services restart borders
aerospace reload-config
```

## Voice dictation

[open-wispr](https://github.com/human37/open-wispr) is on-device push-to-talk dictation using Whisper (`large-v3-turbo`, Ukrainian). It runs as a Homebrew service.

Known issue in v0.46.0: the idle voice-processing audio unit ducks system playback while the app is running. The fix is merged upstream and ships in the next release; update with `brew upgrade open-wispr` when it lands.

## AI tooling

- [Claude Code](https://github.com/anthropics/claude-code): `.config/claude/settings.json` and a custom `statusline-command.sh` (directory, git branch and dirty state, model, context usage), linked into `~/.claude/`.
- [Codex](https://github.com/openai/codex): CLI for agent work; hooks are registered by the tmux sidebar plugin.
- [tmux-agent-sidebar](https://github.com/hiroppy/tmux-agent-sidebar): tracks every agent pane across sessions. For Claude Code it is installed as a plugin from the local TPM checkout; for Codex it registers hooks in `~/.codex/hooks.json`.
- [Supermaven](https://github.com/supermaven-inc/supermaven-nvim): AI completion in the Neovim completion menu.

## Secrets

Nothing sensitive is tracked. API keys live in `~/.zshrc.local` (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `OPENWEATHER_API_KEY`). GitHub CLI credentials, `.env*`, `*.pem` and app state are git-ignored. CI runs [gitleaks](https://github.com/gitleaks/gitleaks) on every push and pull request.

## Repo layout

```text
.dotfiles/
├── setup.sh              # bootstrap: packages, symlinks, post-setup
├── Brewfile              # Homebrew formulae, casks, npm globals
├── .zshrc
├── .p10k.zsh
├── .gitconfig
├── .config/
│   ├── aerospace/        # tiling window manager
│   ├── atuin/            # shell history
│   ├── borders/          # JankyBorders
│   ├── claude/           # Claude Code settings + statusline
│   ├── gh/               # GitHub CLI defaults
│   ├── git/              # global gitignore
│   ├── hunk/             # diff viewer
│   ├── kitty/            # terminal + theme
│   ├── nvim/             # editor (lua/plugins, queries, spell)
│   ├── open-wispr/       # voice dictation
│   ├── tmux/             # tmux.conf + status scripts
│   └── zed/              # Zed settings
└── .github/workflows/validate.yml
```

## CI

`.github/workflows/validate.yml` runs on push to `main` and on pull requests:

- `bash -n` on every shell script, plus `shfmt` and `stylua` checks when installed
- a [gitleaks](https://github.com/gitleaks/gitleaks) secret scan over the full history
- JSON and TOML syntax validation for tracked config files (Zed's JSONC settings are skipped)
