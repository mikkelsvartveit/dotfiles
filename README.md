# Configuration files for macOS

A small collection of configuration files for macOS, including:

- [iTerm2](https://iterm2.com) (terminal emulator)
- [fish](https://fishshell.com) (shell)
- Git
- Neovim (complete development environment with CoC and a bunch of plugins)
- Vim (simple configuration, no plugins)
- [Karabiner](https://karabiner-elements.pqrs.org) (for [mapping CapsLock to Ctrl and Esc](https://medium.com/@pechyonkin/how-to-map-capslock-to-control-and-escape-on-mac-60523a64022b))
- Some wallpapers and custom app icons

## Setup

#### Install software

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Homebrew packages
brew install python php fish git neovim ripgrep autojump thefuck

# Install Node Version Manager and Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install --lts
nvm use --lts

# Install shell-gpt
pip3 install shell-gpt --user
```

#### Set up fish shell, oh-my-fish and plugins

```bash
fish
fish_add_path /opt/homebrew/bin
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bass
omf install https://github.com/jhillyerd/plugin-git
```

#### Clone and checkout these config files

```bash
alias conf='git --git-dir=$HOME/.myconfig.git/ --work-tree=$HOME'
echo ".myconfig.git" >> .gitignore
git clone --bare https://github.com/mikkelsvartveit/dotfiles.git $HOME/.myconfig.git
conf checkout
conf config --local status.showUntrackedFiles no
```
