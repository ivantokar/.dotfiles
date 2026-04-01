#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
INSTALL_PACKAGES="auto"
LINK_ONLY=0
OS=""
LINUX_PKG_MANAGER=""
BACKUP_ROOT="${HOME}/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
BACKUP_CREATED=0

info() { printf '\033[0;32m[INFO]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$1"; }
error() { printf '\033[0;31m[ERROR]\033[0m %s\n' "$1" >&2; }

usage() {
  cat <<'EOF'
Usage: ./setup.sh [options]

Options:
  --dry-run            Print actions without making changes
  --install-packages   Force dependency installation (Linux/macOS)
  --skip-packages      Skip dependency installation
  --link-only          Only create symlinks (implies --skip-packages)
  -h, --help           Show this help
EOF
}

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[DRY-RUN] '
    printf '%q ' "$@"
    printf '\n'
    return 0
  fi

  "$@"
}

run_or_warn() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    run "$@"
    return 0
  fi

  if ! "$@"; then
    warn "Command failed (continuing): $*"
  fi
}

detect_os() {
  case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux) OS="linux" ;;
    *)
      error "Unsupported OS: $(uname -s)"
      exit 1
      ;;
  esac
}

detect_linux_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    LINUX_PKG_MANAGER="apt"
  elif command -v dnf >/dev/null 2>&1; then
    LINUX_PKG_MANAGER="dnf"
  elif command -v pacman >/dev/null 2>&1; then
    LINUX_PKG_MANAGER="pacman"
  else
    LINUX_PKG_MANAGER="unknown"
  fi
}

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    info "Homebrew already installed"
    return 0
  fi

  info "Installing Homebrew..."
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo '[DRY-RUN] /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    return 0
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_macos_packages() {
  install_homebrew

  info "Installing core packages (macOS)"
  run brew install \
    neovim \
    tmux \
    fzf \
    ripgrep \
    fd \
    zoxide \
    jq \
    git \
    curl \
    node \
    ruby \
    pipx \
    xcode-build-server \
    xcbeautify \
    stylua

  info "Installing optional packages (best effort)"
  run_or_warn brew install --cask ghostty
  run_or_warn gem install xcodeproj neovim
  run_or_warn pipx install --force pymobiledevice3
  run_or_warn npm install -g neovim typescript typescript-language-server
  run_or_warn npm install -g @tailwindcss/language-server @astrojs/language-server
  run_or_warn npm install -g prettierd
}

install_linux_packages() {
  detect_linux_pkg_manager
  info "Detected Linux package manager: ${LINUX_PKG_MANAGER}"

  case "$LINUX_PKG_MANAGER" in
    apt)
      run sudo apt-get update
      run sudo apt-get install -y \
        git \
        curl \
        neovim \
        tmux \
        zsh \
        fzf \
        ripgrep \
        fd-find \
        jq
      ;;
    dnf)
      run sudo dnf install -y \
        git \
        curl \
        neovim \
        tmux \
        zsh \
        fzf \
        ripgrep \
        fd-find \
        jq
      ;;
    pacman)
      run sudo pacman -Sy --noconfirm
      run sudo pacman -S --needed --noconfirm \
        git \
        curl \
        neovim \
        tmux \
        zsh \
        fzf \
        ripgrep \
        fd \
        jq
      ;;
    *)
      warn "No supported package manager detected. Skipping package installation."
      warn "Install dependencies manually: git curl neovim tmux zsh fzf ripgrep fd jq"
      ;;
  esac
}

backup_path() {
  local target="$1"
  local relative backup_target

  if [[ "$target" == "$HOME/"* ]]; then
    relative="${target#"$HOME/"}"
  elif [[ "$target" == "$HOME" ]]; then
    relative="home"
  else
    relative="$(basename "$target")"
  fi

  backup_target="${BACKUP_ROOT}/${relative}"
  run mkdir -p "$(dirname "$backup_target")"
  info "Backing up ${target} -> ${backup_target}"
  run mv "$target" "$backup_target"
  BACKUP_CREATED=1
}

ensure_symlink() {
  local source="$1"
  local target="$2"
  local source_real target_real

  if [[ ! -e "$source" && ! -L "$source" ]]; then
    error "Source path does not exist: $source"
    exit 1
  fi

  source_real="$(realpath "$source")"

  run mkdir -p "$(dirname "$target")"

  if [[ -e "$target" || -L "$target" ]]; then
    target_real="$(realpath "$target" 2>/dev/null || true)"
    if [[ -n "$target_real" && "$target_real" == "$source_real" ]]; then
      info "Already linked: ${target}"
      return 0
    fi
  fi

  if [[ -L "$target" ]]; then
    local current_link
    current_link="$(readlink "$target")"
    if [[ "$current_link" == "$source" ]]; then
      info "Already linked: ${target}"
      return 0
    fi
    backup_path "$target"
  elif [[ -e "$target" ]]; then
    backup_path "$target"
  fi

  info "Linking ${target} -> ${source}"
  run ln -sfn "$source" "$target"
}

link_dotfiles() {
  local -a mappings=(
    ".zshrc:.zshrc"
    ".config/nvim:.config/nvim"
    ".config/tmux/tmux.conf:.config/tmux/tmux.conf"
    ".config/tmux/scripts/weather.sh:.config/tmux/scripts/weather.sh"
    ".config/tmux/scripts/system_metrics.sh:.config/tmux/scripts/system_metrics.sh"
    ".config/tmux/scripts/world_clock.sh:.config/tmux/scripts/world_clock.sh"
    ".config/ghostty/config:.config/ghostty/config"
    ".config/git/ignore:.config/git/ignore"
    ".config/gh/config.yml:.config/gh/config.yml"
  )

  info "Linking dotfiles into ${HOME}"
  local mapping src_rel dst_rel src_abs dst_abs
  for mapping in "${mappings[@]}"; do
    src_rel="${mapping%%:*}"
    dst_rel="${mapping#*:}"
    src_abs="${SCRIPT_DIR}/${src_rel}"
    dst_abs="${HOME}/${dst_rel}"
    ensure_symlink "$src_abs" "$dst_abs"
  done
}

setup_zinit() {
  local zinit_home="${HOME}/.local/share/zinit/zinit.git"
  if [[ -d "$zinit_home" ]]; then
    info "zinit already installed"
    return 0
  fi

  if ! command -v git >/dev/null 2>&1; then
    warn "git not found, skipping zinit install"
    return 0
  fi

  info "Installing zinit"
  run mkdir -p "$(dirname "$zinit_home")"
  run git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
}

setup_tpm() {
  local tpm_dir="${HOME}/.config/tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    info "TPM already installed"
    return 0
  fi

  if ! command -v git >/dev/null 2>&1; then
    warn "git not found, skipping TPM install"
    return 0
  fi

  info "Installing tmux plugin manager (TPM)"
  run git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
}

setup_neovim_plugins() {
  if ! command -v nvim >/dev/null 2>&1; then
    warn "nvim not found, skipping Neovim plugin sync"
    return 0
  fi

  info "Installing Neovim plugins"
  run_or_warn nvim --headless "+Lazy! sync" +qa

  local telescope_native_dir="${HOME}/.local/share/nvim/lazy/telescope-fzf-native.nvim"
  if [[ -d "$telescope_native_dir" ]] && command -v make >/dev/null 2>&1; then
    info "Building telescope-fzf-native"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[DRY-RUN] (cd \"$telescope_native_dir\" && make)"
    else
      (cd "$telescope_native_dir" && make)
    fi
  fi
}

setup_tmux_plugins() {
  local tpm_install="${HOME}/.config/tmux/plugins/tpm/bin/install_plugins"
  if [[ -x "$tpm_install" ]] && command -v tmux >/dev/null 2>&1; then
    info "Installing tmux plugins"
    run_or_warn "$tpm_install"
  else
    warn "tmux/TPM not ready, skipping tmux plugin install"
  fi
}

run_post_setup() {
  info "Running post-setup tasks"
  run mkdir -p "${HOME}/.vim/undodir" "${HOME}/.config"
  setup_zinit
  setup_tpm
  setup_neovim_plugins
  setup_tmux_plugins
}

parse_args() {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        ;;
      --install-packages)
        INSTALL_PACKAGES="yes"
        ;;
      --skip-packages)
        INSTALL_PACKAGES="no"
        ;;
      --link-only)
        LINK_ONLY=1
        INSTALL_PACKAGES="no"
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        error "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
    shift
  done
}

main() {
  parse_args "$@"
  detect_os

  if [[ "$INSTALL_PACKAGES" == "auto" ]]; then
    if [[ "$OS" == "macos" ]]; then
      INSTALL_PACKAGES="yes"
    else
      INSTALL_PACKAGES="no"
    fi
  fi

  echo "=================================================="
  echo "  Dotfiles Bootstrap"
  echo "=================================================="
  info "Repository: ${SCRIPT_DIR}"
  info "OS: ${OS}"
  info "Dry run: ${DRY_RUN}"
  info "Install packages: ${INSTALL_PACKAGES}"
  info "Link only: ${LINK_ONLY}"

  if [[ "$INSTALL_PACKAGES" == "yes" ]]; then
    if [[ "$OS" == "macos" ]]; then
      install_macos_packages
    else
      install_linux_packages
    fi
  else
    info "Skipping package installation"
  fi

  link_dotfiles

  if [[ "$LINK_ONLY" -eq 0 ]]; then
    run_post_setup
  else
    info "Skipping post-setup tasks (--link-only)"
  fi

  if [[ "$BACKUP_CREATED" -eq 1 ]]; then
    info "Backups were saved under: ${BACKUP_ROOT}"
  else
    info "No backups were needed"
  fi

  echo ""
  echo "Done."
  echo "Next:"
  echo "  1) Restart shell: exec zsh"
  echo "  2) Open tmux and press Prefix + I"
  echo "  3) Open Neovim and run :checkhealth"
}

main "$@"
