# Configuration files for macOS

A small collection of configuration files for macOS, including:

- iTerm2 (terminal emulator)
- fish (shell)
- Git
- Neovim (complete development environment with CoC and a bunch of plugins)
- Vim (simple configuration, no plugins)
- Some wallpapers and custom app icons

## Setup

```bash
# Clone this repo as a bare repo
alias conf='git --git-dir=$HOME/.myconfig.git/ --work-tree=$HOME'
echo ".myconfig.git" >> .gitignore
git clone --bare https://github.com/mikkelsvartveit/dotfiles.git $HOME/.myconfig.git
conf checkout
conf config --local status.showUntrackedFiles no

# Install Homebrew packages
brew install python php fish git neovim ripgrep autojump thefuck

# Install Node Version Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Install shell-gpt
pip install shell-gpt --user

# Set up fish shell, oh-my-fish and plugins
fish
fish_add_path /opt/homebrew/bin
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bass
omf install https://github.com/jhillyerd/plugin-git

# Install latest LTS version of Node.js
nvm install --lts
nvm use --lts
```
