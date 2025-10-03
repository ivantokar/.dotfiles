#!/bin/bash

set -e

echo "=================================================="
echo "  Dotfiles Setup for macOS"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is for macOS only!"
    exit 1
fi

info "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    info "Homebrew already installed"
fi

info "Installing essential tools via Homebrew..."
brew install \
    stow \
    neovim \
    tmux \
    fzf \
    ripgrep \
    fd \
    zoxide \
    git \
    node \
    ruby \
    pipx \
    coreutils \
    xcode-build-server \
    xcbeautify

info "Installing optional tools..."
brew install --cask ghostty 2>/dev/null || warn "Ghostty not available, skipping..."

info "Installing Ruby gems..."
gem install xcodeproj neovim

info "Installing Python packages..."
pipx install pymobiledevice3

info "Installing Node.js packages..."
npm install -g neovim typescript typescript-language-server

info "Installing language servers..."
npm install -g @tailwindcss/language-server @astrojs/language-server

info "Installing formatters and linters..."
npm install -g prettierd
brew install stylua

info "Setting up Zsh plugins (zinit)..."
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    info "Installing zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
else
    info "zinit already installed"
fi

info "Installing tmux plugin manager (TPM)..."
TPM_DIR="${HOME}/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    info "TPM already installed"
fi

info "Installing codelldb for Swift/iOS debugging..."
CODELLDB_DIR="${HOME}/tools/codelldb-aarch64-darwin"
if [ ! -d "$CODELLDB_DIR" ]; then
    mkdir -p ~/tools
    cd ~/tools

    # Get latest release URL
    CODELLDB_URL=$(curl -s https://api.github.com/repos/vadimcn/codelldb/releases/latest | \
        grep "browser_download_url.*darwin-arm64.vsix" | \
        cut -d '"' -f 4)

    if [ -n "$CODELLDB_URL" ]; then
        info "Downloading codelldb from $CODELLDB_URL"
        curl -L -o codelldb-darwin-arm64.vsix "$CODELLDB_URL"
        unzip -q codelldb-darwin-arm64.vsix -d codelldb-aarch64-darwin
        chmod +x codelldb-aarch64-darwin/extension/adapter/codelldb
        rm codelldb-darwin-arm64.vsix
        info "codelldb installed successfully"
    else
        warn "Could not find codelldb download URL, skipping..."
    fi

    cd - > /dev/null
else
    info "codelldb already installed"
fi

info "Creating necessary directories..."
mkdir -p ~/.vim/undodir
mkdir -p ~/.config

info "Stowing dotfiles..."
cd "$(dirname "$0")"

# Backup existing configs
if [ -f ~/.zshrc ]; then
    warn "Backing up existing .zshrc to .zshrc.backup"
    mv ~/.zshrc ~/.zshrc.backup
fi

# Stow all configs
stow -v -t ~/ .

info "Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

info "Building telescope-fzf-native..."
if [ -d ~/.local/share/nvim/lazy/telescope-fzf-native.nvim ]; then
    cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim && make
    cd - > /dev/null
fi

info "Installing tmux plugins..."
if command -v tmux &> /dev/null; then
    ~/.config/tmux/plugins/tpm/bin/install_plugins
fi

echo ""
echo "=================================================="
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo "=================================================="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Open tmux and press Prefix + I to install plugins (Prefix is Ctrl+s)"
echo "  3. Open Neovim and run :checkhealth"
echo "  4. For Swift/iOS development:"
echo "     - Install Xcode from App Store"
echo "     - Run: xcode-build-server config -project YourProject.xcodeproj -scheme YourScheme"
echo ""
