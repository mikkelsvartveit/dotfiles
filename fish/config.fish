# Disable greeting
set fish_greeting

alias fixmouse="killall LogiMgrDaemon"
alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
alias pi="ssh pi@pi.misva.me -p 1733"
alias gcp="ssh mikkelsvartveit@gcp.misva.me"
alias cloud="ssh ubuntu@cloud.misva.me"
alias cloud-status="rsync -auzPn --exclude=.DS_Store '/Volumes/Samsung T7/misvaCloud/' ubuntu@cloud.misva.me:~/misvaCloud/ && rsync -auzPn --exclude=.DS_Store ubuntu@cloud.misva.me:~/misvaCloud/ '/Volumes/Samsung T7/misvaCloud/'" 
alias cloud-sync="rsync -auzP --exclude=.DS_Store '/Volumes/Samsung T7/misvaCloud/' ubuntu@cloud.misva.me:~/misvaCloud/ && rsync -auzP --exclude=.DS_Store ubuntu@cloud.misva.me:~/misvaCloud/ '/Volumes/Samsung T7/misvaCloud/'" 
alias zshrc="nvim ~/.zshrc"
alias fishconfig="cd ~/.config/fish && nvim config.fish && cd -"
alias nvimconfig="cd ~/.config/nvim && nvim && cd -"
alias ai="sgpt -se"

abbr x86 "arch -x86_64"
abbr v "nvim"
abbr p "pnpm"
abbr pd "pnpm dev"
abbr px "pnpm dlx"
abbr lg "lazygit"
abbr ns "npm start"
abbr nrs "npm run serve"
abbr nrd "npm run dev"
abbr nrw "npm run watch"
abbr venv "source .venv/bin/activate.fish"
abbr lrr "source venv/bin/activate.fish && litestar run --reload"
abbr gw "gow -e=go,mod,html run ."
abbr mw "make watch"
abbr nobrew "HOMEBREW_NO_AUTO_UPDATE=1 brew"
abbr ghv "gh repo view --web"
abbr pr "gh pr checkout"
abbr prc "gh pr create --web"
abbr gli "nvim (git rev-parse --show-toplevel)/.git/info/exclude"
abbr cloud-push "rsync -auzP --exclude=.DS_Store '/Volumes/Samsung T7/misvaCloud/' ubuntu@cloud.misva.me:~/misvaCloud/"
abbr cloud-pull "rsync -auzP --exclude=.DS_Store ubuntu@cloud.misva.me:~/misvaCloud/ '/Volumes/Samsung T7/misvaCloud/'"
abbr cloud-purge "rsync -auzP --exclude=.DS_Store '/Volumes/Samsung T7/misvaCloud/' ubuntu@cloud.misva.me:~/misvaCloud/ --delete --dry-run"
abbr 164 "ssh cs164-aiu@eda-3.eecs.berkeley.edu"
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
    open -a "Docker"
    sleep 15
    echo "Docker daemon started."
end

function dq
    osascript -e 'quit app "Docker Desktop"'
end

# Enable autojump
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

# opam (OCaml package manager) configuration
source /Users/mikkelsvartveit/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# Update PATH
fish_add_path "$HOME/.local/bin" # Lingua Franca
fish_add_path "$HOME/.bun/bin" # Bun
fish_add_path "$HOME/.pyenv/bin" # pyenv
fish_add_path "$HOME/Library/pnpm" # pnpm
fish_add_path "$HOME/go/bin" # Go
fish_add_path "$HOME/.cargo/bin" # Rust
if [ -f "$HOME/Applications/google-cloud-sdk/path.fish.inc" ]; . "$HOME/Applications/google-cloud-sdk/path.fish.inc"; end # Google Cloud SDK

# Initialize pnpm
set -gx PNPM_HOME "/Users/mikkelsvartveit/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

# Initialize pyenv
pyenv init - | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
