#!/bin/bash

set -e

echo "=================================================="
echo "  Dotfiles Setup for Arch Linux"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running on Arch
if [[ ! -f /etc/os-release ]]; then
    error "Cannot detect OS. Is this Arch Linux?"
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "arch" && "$ID_LIKE" != *"arch"* ]]; then
    error "This script is for Arch Linux only!"
    exit 1
fi

info "Detected: $PRETTY_NAME"

info "Updating package database..."
sudo pacman -Sy

info "Installing essential tools..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    stow \
    curl \
    wget \
    unzip

info "Installing Neovim..."
sudo pacman -S --needed --noconfirm neovim

info "Installing tmux..."
sudo pacman -S --needed --noconfirm tmux

info "Installing Zsh..."
sudo pacman -S --needed --noconfirm zsh zsh-completions
if [[ "$SHELL" != *"zsh"* ]]; then
    info "Changing default shell to zsh..."
    chsh -s $(which zsh)
fi

info "Installing terminal tools..."
sudo pacman -S --needed --noconfirm \
    ripgrep \
    fd \
    fzf \
    zoxide

info "Installing development tools..."
sudo pacman -S --needed --noconfirm \
    nodejs \
    npm \
    ruby \
    python \
    python-pip \
    python-pipx

info "Ensuring pipx path..."
pipx ensurepath

info "Installing Node.js packages..."
npm install -g neovim typescript typescript-language-server

info "Installing language servers..."
npm install -g @tailwindcss/language-server @astrojs/language-server

info "Installing formatters and linters..."
npm install -g prettierd
sudo pacman -S --needed --noconfirm stylua

info "Checking for yay (AUR helper)..."
if ! command -v yay &> /dev/null; then
    info "Installing yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
else
    info "yay already installed"
fi

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

info "Installing codelldb for debugging..."
CODELLDB_DIR="${HOME}/tools/codelldb-x86_64-linux"
if [ ! -d "$CODELLDB_DIR" ]; then
    mkdir -p ~/tools
    cd ~/tools

    # Get latest release URL
    CODELLDB_URL=$(curl -s https://api.github.com/repos/vadimcn/codelldb/releases/latest | \
        grep "browser_download_url.*linux-x86_64.vsix" | \
        cut -d '"' -f 4)

    if [ -n "$CODELLDB_URL" ]; then
        info "Downloading codelldb from $CODELLDB_URL"
        curl -L -o codelldb-linux-x86_64.vsix "$CODELLDB_URL"
        unzip -q codelldb-linux-x86_64.vsix -d codelldb-x86_64-linux
        chmod +x codelldb-x86_64-linux/extension/adapter/codelldb
        rm codelldb-linux-x86_64.vsix
        info "codelldb installed successfully"
    else
        warn "Could not find codelldb download URL, skipping..."
    fi

    cd - > /dev/null
else
    info "codelldb already installed"
fi

info "Installing optional packages from AUR..."
yay -S --needed --noconfirm ghostty-bin 2>/dev/null || warn "Ghostty not available, skipping..."

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
echo "  1. Log out and log back in (to apply shell changes)"
echo "  2. Or run: exec zsh"
echo "  3. Open tmux and press Prefix + I to install plugins (Prefix is Ctrl+s)"
echo "  4. Open Neovim and run :checkhealth"
echo ""
