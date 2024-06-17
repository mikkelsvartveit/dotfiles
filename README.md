# Configuration files for macOS

A small collection of configuration files for macOS, including:

- [iTerm2](https://iterm2.com) (terminal emulator)
- [fish](https://fishshell.com) (shell)
- Git
- Neovim (complete development environment with Coc and a bunch of plugins)
- Vim (simple configuration, no plugins)
- IdeaVim (Vim emulation for JetBrains IDEs)
- [Karabiner](https://karabiner-elements.pqrs.org) (for [mapping CapsLock to Ctrl and Esc](https://medium.com/@pechyonkin/how-to-map-capslock-to-control-and-escape-on-mac-60523a64022b))
- Some wallpapers and custom app icons

## Setup

#### Set up these config files

```bash
# Back up old config files (optional)
cp -r ~/.config ~/.config_old

# Set up this repository
cd ~/.config
git init
git branch -m main
git remote add origin git@github.com:mikkelsvartveit/dotfiles.git
git fetch
git reset --hard origin/main
git branch --set-upstream-to=origin/main

# Tell Vim and IdeaVim to source from the right file
echo "source ~/.config/vim/.vimrc" > .vimrc
echo "source ~/.config/ideavim/.ideavimrc" > .ideavimrc
```

#### Install software

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Homebrew packages
brew install fish pyenv git neovim ripgrep autojump

# Install pnpm and Node
curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm env use --global lts

# Install pyenv and Python
pyenv install 3.11
pyenv global 3.11
```

#### Set up fish shell, oh-my-fish and plugins

```bash
fish
fish_add_path /opt/homebrew/bin # Skip this on Intel Macs
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bass
omf install https://github.com/jhillyerd/plugin-git
```
