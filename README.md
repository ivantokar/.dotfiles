# My dotfiles

### OSX installation by Homebrew

- install **Oh My ZSH!** `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- install **powerlevel10k** `brew install powerlevel10k && echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc`
- install **git**, **stow**, **tree**: `brew install git stow tree`
- install **tmux** and **tmp** `brew install tmux && git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm`

### Stow

- run in dotfiles directory `stow --adopt . && exec zsh`

## Materials

### zsh

- [Zsh](https://www.zsh.org/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Nerd Fonts](https://www.nerdfonts.com/)

### tmux

- [tmux for Newbs. FREE TMUX COURSE](https://www.youtube.com/playlist?list=PLsz00TDipIfdrJDjpULKY7mQlIFi4HjdR)
- [tmux plugins manager](https://github.com/tmux-plugins/tpm)

### dotfiles

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Stow has forever changed the way I manage my dotfiles (YouTube)](https://www.youtube.com/watch?v=y6XCebnB9gs)

### neovim

- [Neovim](https://neovim.io/)
- [Neovim for Newbs. FREE NEOVIM COURSE](https://www.youtube.com/playlist?list=PLsz00TDipIffreIaUNk64KxTIkQaGguqn)

## Installation
