alias fixmouse="killall LogiMgrDaemon"
alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
alias pi="ssh pi@185.138.33.80 -p 1733"
alias zshrc="nvim ~/.zshrc"
alias fishconfig="cd ~/.config/fish && nvim config.fish && cd -"
alias nvimconfig="cd ~/.config/nvim && nvim && cd -"
alias ai="sgpt -se"

abbr x86 "arch -x86_64"
abbr v "nvim"
abbr gpf "git push --force-with-lease"
abbr ghv "gh repo view --web"
abbr pr "gh pr checkout"
abbr prc "gh pr create --web"

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

# Initialize nvm through bass
bass source ~/.nvm/nvm.sh ';'
function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

# Enable autojump
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

# Allow running pip packages
export PATH="/Users/mikkelsvartveit/Library/Python/3.9/bin:$PATH"

