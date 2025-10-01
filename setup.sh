#!/bin/bash

set -e

echo "=================================================="
echo "  Universal Dotfiles Setup"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            ubuntu|linuxmint)
                echo "ubuntu"
                ;;
            arch|manjaro|endeavouros)
                echo "arch"
                ;;
            *)
                echo "unknown"
                ;;
        esac
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

echo ""
echo -e "${BLUE}Detected OS: ${NC}$OS"
echo ""

case "$OS" in
    macos)
        info "Running macOS setup..."
        if [ -f "$(dirname "$0")/setup-macos.sh" ]; then
            exec "$(dirname "$0")/setup-macos.sh"
        else
            error "setup-macos.sh not found!"
            exit 1
        fi
        ;;
    ubuntu)
        info "Running Ubuntu/Mint setup..."
        if [ -f "$(dirname "$0")/setup-ubuntu.sh" ]; then
            exec "$(dirname "$0")/setup-ubuntu.sh"
        else
            error "setup-ubuntu.sh not found!"
            exit 1
        fi
        ;;
    arch)
        info "Running Arch Linux setup..."
        if [ -f "$(dirname "$0")/setup-arch.sh" ]; then
            exec "$(dirname "$0")/setup-arch.sh"
        else
            error "setup-arch.sh not found!"
            exit 1
        fi
        ;;
    *)
        error "Unsupported operating system!"
        echo ""
        echo "Supported systems:"
        echo "  - macOS"
        echo "  - Ubuntu / Linux Mint"
        echo "  - Arch Linux / Manjaro / EndeavourOS"
        echo ""
        echo "Please run the appropriate setup script manually:"
        echo "  ./setup-macos.sh     # For macOS"
        echo "  ./setup-ubuntu.sh    # For Ubuntu/Mint"
        echo "  ./setup-arch.sh      # For Arch-based distros"
        exit 1
        ;;
esac
