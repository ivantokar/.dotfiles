# Dotfiles

Personal dotfiles for daily development, optimized for fast setup on a new machine.

## What is configured

- `zsh` (`.zshrc`)
- `neovim` (`.config/nvim`)
- `tmux` (`.config/tmux/tmux.conf` + status scripts)
- `ghostty` (`.config/ghostty/config`)
- `git` global ignore defaults (`.config/git/ignore`)
- `gh` defaults (`.config/gh/config.yml`)

## Bootstrap

### New machine (one command)

```bash
git clone https://github.com/ivantokar/.dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./setup.sh
```

### Linux note

On Linux, `setup.sh` links dotfiles by default. To also install packages:

```bash
./setup.sh --install-packages
```

## Setup script behavior

`setup.sh` is the single entry point.

It will:

1. Detect OS (`macOS` / `Linux`)
2. Optionally install dependencies
3. Create symlinks into `$HOME`
4. Backup existing conflicting files into `~/dotfiles_backup/<timestamp>/`
5. Run post-setup steps (zinit, TPM, Neovim plugins)

## Safe modes

```bash
# Preview only (no changes)
./setup.sh --dry-run

# Link dotfiles only, skip package install + post-setup
./setup.sh --link-only

# Skip dependency installation
./setup.sh --skip-packages
```

## Update on an existing machine

```bash
cd ~/.dotfiles
git pull
./setup.sh --skip-packages
```

## Manual post-install checks

```bash
exec zsh
tmux   # then press Prefix + I (Prefix is Ctrl+s)
nvim +checkhealth
```

For Swift/iOS workflows (macOS):

- Install Xcode from App Store
- Configure build metadata per project:

```bash
xcode-build-server config -project YourProject.xcodeproj -scheme YourScheme
```

## Validation (CI)

GitHub Actions runs on push/PR and checks:

- shell syntax (`bash -n` on `*.sh`)
- optional formatting checks when tools are available (`shfmt`, `stylua`)

Workflow file:

- `.github/workflows/validate.yml`

## Repo layout

```text
.dotfiles/
├── setup.sh
├── .zshrc
├── .config/
│   ├── nvim/
│   ├── tmux/
│   ├── ghostty/
│   ├── git/
│   └── gh/
└── .github/workflows/validate.yml
```
