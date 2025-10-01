#!/bin/bash

set -e

echo "=================================================="
echo "  Dotfiles Setup for Ubuntu/Mint"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running on Ubuntu/Mint
if [[ ! -f /etc/os-release ]]; then
    error "Cannot detect OS. Is this Ubuntu/Mint?"
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "ubuntu" && "$ID" != "linuxmint" && "$ID_LIKE" != *"ubuntu"* ]]; then
    error "This script is for Ubuntu/Mint only!"
    exit 1
fi

info "Detected: $PRETTY_NAME"

info "Updating package lists..."
sudo apt update

info "Installing essential tools..."
sudo apt install -y \
    stow \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    software-properties-common

info "Installing Neovim..."
# Add Neovim PPA for latest version
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

info "Installing tmux..."
sudo apt install -y tmux

info "Installing Zsh..."
sudo apt install -y zsh
if [[ "$SHELL" != *"zsh"* ]]; then
    info "Changing default shell to zsh..."
    chsh -s $(which zsh)
fi

info "Installing terminal tools..."
sudo apt install -y \
    ripgrep \
    fd-find \
    fzf

# Create symlinks for fd (Ubuntu/Debian package it as fdfind)
if ! command -v fd &> /dev/null; then
    sudo ln -sf $(which fdfind) /usr/local/bin/fd
fi

info "Installing zoxide..."
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

info "Installing Node.js (via nvm)..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
else
    info "nvm already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

info "Installing Ruby..."
sudo apt install -y ruby-full

info "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv pipx
pipx ensurepath

info "Installing formatters and linters..."
npm install -g neovim typescript typescript-language-server prettierd

info "Installing stylua..."
if ! command -v stylua &> /dev/null; then
    STYLUA_VERSION=$(curl -s https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)
    curl -L -o /tmp/stylua.zip "https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VERSION}/stylua-linux-x86_64.zip"
    unzip /tmp/stylua.zip -d /tmp/
    sudo mv /tmp/stylua /usr/local/bin/
    sudo chmod +x /usr/local/bin/stylua
    rm /tmp/stylua.zip
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
