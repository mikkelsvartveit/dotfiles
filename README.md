# Configuration files for macOS and Linux

A small collection of configuration files, including:

- [fish](https://fishshell.com) (shell)
- tmux
- Git
- Neovim (complete development environment with LSP and a bunch of plugins)
- Vim (simple configuration, no plugins)
- IdeaVim (Vim emulation for JetBrains IDEs)
- [OpenCode](https://opencode.ai/) (AI coding agent)
- [Aerospace](https://github.com/nikitabobko/AeroSpace) (macOS tiling window manager)
- [iTerm2](https://iterm2.com) (macOS terminal emulator)
- [Karabiner](https://karabiner-elements.pqrs.org) (for [mapping CapsLock to Ctrl and Esc](https://medium.com/@pechyonkin/how-to-map-capslock-to-control-and-escape-on-mac-60523a64022b) on macOS)
- Some wallpapers

## macOS setup

#### Set up these config files

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Git and GNU Stow
brew install git stow

# Back up old config files (optional)
cp -r ~/.config ~/.config_old

# Clone this repository
cd ~/
git clone git@github.com:mikkelsvartveit/dotfiles.git

# Use GNU Stow to set up symlinks
stow --adopt dotfiles-common/ dotfiles-macos/
git stash -u
```

#### Install software

```bash
# Install Homebrew packages
brew install fish tmux git neovim ripgrep zoxide fzf fd

# Install pnpm, Node, and Bun
curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm env use --global lts
curl -fsSL https://bun.com/install | bash

# Install uv, Python, and Poetry
curl -LsSf https://astral.sh/uv/install.sh | sh
uv python install --default
curl -sSL https://install.python-poetry.org | python3 - --yes
```

#### Set up fish shell

```bash
fish
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install https://github.com/jhillyerd/plugin-git
```
