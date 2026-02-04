# Disable greeting
set fish_greeting

# Use short path for prompt
set theme_short_path yes

# Use Neovim as the default text editor
set -x EDITOR "nvim"

alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
alias mcloud-push="rsync -auzP --exclude='.*' /Volumes/mcloud/ mcloud:./"
alias mcloud-pull="rsync -auzP --exclude='.*' mcloud:./ /Volumes/mcloud/"
alias mcloud-status="mcloud-push --dry-run && mcloud-pull --dry-run"
alias mcloud-sync="mcloud-push && mcloud-pull"
alias mcloud-photos-pull="pnpm dlx icloudpd --directory '/Volumes/mcloud/Backup/iCloud Photos (all)/' --username mikkel.svartveit@gmail.com --until-found 100"
alias mcloud-developer-dump="cd ~/Developer/ && fd --type f --hidden --exclude .git --exclude node_modules | zip -@ /Volumes/mcloud/Backup/Developer/Developer-$(date +%Y-%m-%d).zip"
alias zshrc="nvim ~/.zshrc"
alias fishconfig="cd ~/.config/fish && nvim config.fish && cd -"
alias nvimconfig="cd ~/.config/nvim && nvim && cd -"
alias asconfig="cd ~/.config/aerospace && nvim aerospace.toml && cd -"

abbr e "exit"
abbr t "tmux"
abbr v "vim"
abbr n "nvim"
abbr c "claude"
abbr oc "opencode"
abbr ws "windsurf"
abbr lg "lazygit"
abbr p "pnpm"
abbr pd "pnpm dev"
abbr pdb "pnpm run db:studio" # Launch Drizzle Studio
abbr px "pnpm dlx"
abbr ns "npm start"
abbr nrs "npm run serve"
abbr nrd "npm run dev"
abbr nrw "npm run watch"
abbr venv "source .venv/bin/activate.fish"
abbr lrr "source venv/bin/activate.fish && litestar run --reload"
abbr gw "gow -e=go,mod,html run ."
abbr mw "make watch"
abbr x86 "arch -x86_64"
abbr nobrew "HOMEBREW_NO_AUTO_UPDATE=1 brew"
abbr gy "git yield"
abbr ghv "gh repo view --web"
abbr pr "gh pr checkout"
abbr prc "gh pr create --web"
abbr caf "caffeinate -d"

function ghid
    gh issue develop $argv[1] --checkout --name $argv[2]
end

# Print the directory of the top-most Finder window
function pfd
    bass "echo \"`osascript -e 'tell application \"Finder\" to POSIX path of (insertion location as alias)' end tell`\""
end

# cd to the directory of the top-most Finder window
function cdf
    cd $(pfd)
end

# Open a file with macOS Quick Look
function ql
    qlmanage -p $argv >/dev/null &
end

# Start Docker Desktop and wait to ensure the daemon is ready
function ds
    echo "Launching Docker Daemon..."
    open --hide -a "Orbstack"
    sleep 5
    echo "Docker daemon started."
end

function dq
    osascript -e 'quit app "OrbStack"'
end

# Update PATH
fish_add_path "$HOME/.local/bin"
fish_add_path "/opt/homebrew/bin" # Homebrew packages
fish_add_path "$HOME/.bun/bin" # Bun
fish_add_path "$HOME/Library/pnpm" # pnpm
fish_add_path "$HOME/go/bin" # Go
fish_add_path "$HOME/.cargo/bin" # Rust
fish_add_path "$HOME/.codeium/windsurf/bin" # Windsurf
fish_add_path "/opt/homebrew/opt/libpq/bin" # libpg (Postgres CLI tools)
fish_add_path "$HOME/.opencode/bin" # opencode
if [ -f "$HOME/Applications/google-cloud-sdk/path.fish.inc" ]; . "$HOME/Applications/google-cloud-sdk/path.fish.inc"; end # Google Cloud SDK

# Initialize pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Initialize zoxide
zoxide init fish --cmd j | source

