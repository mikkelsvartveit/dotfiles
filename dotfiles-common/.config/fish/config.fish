# Disable greeting
set fish_greeting

# Use short path for prompt
set theme_short_path yes

# Use Neovim as the default text editor
set -x EDITOR "nvim"

export XDG_CONFIG_HOME="$HOME/.config"

alias icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs"
alias mcloud-push="rsync -auzP --exclude='.*' /Volumes/mcloud/ mcloud:./"
alias mcloud-pull="rsync -auzP --exclude='.*' mcloud:./ /Volumes/mcloud/"
alias mcloud-status="mcloud-push --dry-run && mcloud-pull --dry-run"
alias mcloud-sync="mcloud-push && mcloud-pull"
alias mcloud-photos-pull="pnpm dlx icloudpd --directory '/Volumes/mcloud/Backup/iCloud Photos (all)/' --username mikkel.svartveit@gmail.com --until-found 100"
alias mcloud-developer-dump="cd ~/Developer/ && fd --type f --hidden --exclude .git --exclude node_modules | zip -@ /Volumes/mcloud/Backup/Developer/Developer-$(date +%Y-%m-%d).zip"
alias mcloud-openclaw-dump='set f openclaw-(date +%F).tar.gz; ssh edvin "tar -czf /tmp/$f -C ~ .openclaw"; and scp "edvin:/tmp/$f" "/Volumes/mcloud/Backup/OpenClaw/"; and ssh edvin "rm /tmp/$f"'
alias zshrc="nvim ~/.zshrc"
alias fishconfig="cd ~/.config/fish && nvim config.fish && cd -"
alias nvimconfig="cd ~/.config/nvim && nvim && cd -"
alias asconfig="cd ~/.config/aerospace && nvim aerospace.toml && cd -"

abbr e "exit"
abbr t "tmux"
abbr v "vim"
abbr n "nvim"
abbr s "ssh"
abbr cc "claude"
abbr oc "opencode"
abbr occ "opencode --continue"
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

# Function for downloading with wget with staging area
function dl
    # 1. Create a unique, hidden temp dir in the current directory
    set -l tmp_dir (mktemp -d -p . ".wget_staging_XXXXXX")

    # Check if directory creation succeeded
    if test $status -ne 0
        echo "Error: Could not create temporary directory."
        return 1
    end

    echo "Downloading to hidden staging area: $tmp_dir"

    # 2. Loop through each URL passed as an argument
    for url in $argv
        # Run wget for the specific URL
        if wget --content-disposition -P "$tmp_dir" $url
            # 3. Atomic move to current directory immediately after this specific download finishes
            # Check if there are files to move to avoid errors if wget succeeded but wrote no file
            if count "$tmp_dir"/* > /dev/null
                mv "$tmp_dir"/* .
                echo "Success: File(s) from $url moved to current directory."
            end
        else
            echo "Error: Download failed for $url."
        end
    end

    # 4. Cleanup: Remove the temp dir
    rm -rf "$tmp_dir"

    # 5. Quit tmux session
    exit
end

function mp3combine --description "Combine all MP3 files in the current directory into one MP3"
    set -l output "combined.mp3"

    if test (count $argv) -ge 1
        set output $argv[1]
    end

    set -l files *.mp3

    if test "$files" = "*.mp3"
        echo "No MP3 files found in the current directory."
        return 1
    end

    if not command -sq ffmpeg
        echo "ffmpeg is required but not installed."
        return 1
    end

    set -l listfile (mktemp)

    for file in $files
        printf "file '%s'\n" (string replace -a "'" "'\\''" -- "$file") >> $listfile
    end

    ffmpeg -f concat -safe 0 -i $listfile -c copy $output

    set -l status_code $status
    rm -f $listfile
    return $status_code
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

# pnpm
set -gx PNPM_HOME "/Users/mikkelsvartveit/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
