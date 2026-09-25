# Disable greeting
set fish_greeting

# Use vim mode
fish_vi_key_bindings

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
alias zshrc="nvim ~/.zshrc"
alias fishconfig="cd ~/.config/fish && nvim config.fish && cd -"
alias nvimconfig="cd ~/.config/nvim && nvim && cd -"
alias asconfig="cd ~/.config/aerospace && nvim aerospace.toml && cd -"

abbr e "exit"
abbr v "vim"
abbr n "nvim"
abbr s "ssh"
abbr t "tmux"
abbr ta "tmux a"
abbr tn 'tmux new -s $(pwd | xargs basename)'
abbr tl "tmux attach \; choose-tree -Zs"
abbr cc "claude"
abbr ccr "claude --resume"
abbr oc "opencode"
abbr occ "opencode --continue"
abbr ocr "opencode run"
abbr lg "lazygit"
abbr p "pnpm"
abbr pd "pnpm dev"
abbr pdb "pnpm run db:studio" # Launch Drizzle Studio
abbr py "python"
abbr venv "source .venv/bin/activate.fish"
abbr cvenv "python -m venv .venv"
abbr nobrew "HOMEBREW_NO_AUTO_UPDATE=1 brew"
abbr gy "git yield"
abbr ghv "gh repo view --web"
abbr pr "gh pr checkout"
abbr prc "gh pr create --web"
abbr prv "gh pr view --web"
abbr ghs "gh stack"
abbr caf "caffeinate -d"

# Open a file with macOS Quick Look
function ql
    qlmanage -p $argv >/dev/null &
end

# Start Orbstack and wait to ensure the daemon is ready
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

    # 2. Loop through each URL passed as an argument, allowing common separators in one argument
    set -l urls
    for arg in $argv
        set -a urls (string match -ar '[^[:space:],;]+' -- $arg)
    end

    for url in $urls
        # Run wget for the specific URL
        if wget --content-disposition --retry-on-http-error=429 -P "$tmp_dir" "$url"
            # 3. Atomic move to current directory immediately after this specific download finishes
            mv "$tmp_dir"/* .
            echo "Success: File(s) from $url moved to current directory."
        else
            echo "Error: Download failed for $url."
        end
    end

    # 4. Cleanup: Remove the temp dir
    rm -r "$tmp_dir"

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

function dotnet-user-secrets --description "Open a .NET project's user-secrets file (Rider-style)"
    set -l proj $argv[1]
    test -z "$proj"; and set proj (find . -maxdepth 2 -name '*.csproj' | head -1)
    test -z "$proj"; and echo "No .csproj found"; and return 1

    set -l id (string replace -rf '.*<UserSecretsId>(.*)</UserSecretsId>.*' '$1' < $proj)
    if test -z "$id"
        echo "No UserSecretsId in $proj — run: dotnet user-secrets init --project $proj"
        return 1
    end

    set -l dir ~/.microsoft/usersecrets/$id
    mkdir -p $dir
    test -f $dir/secrets.json; or printf '{}\n' > $dir/secrets.json
    echo $dir/secrets.json
    nvim $dir/secrets.json
end

# Update PATH
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.local/bin/nvim-macos-arm64/bin" # Neovim
fish_add_path "/opt/homebrew/bin" # Homebrew packages
fish_add_path "$HOME/.bun/bin" # Bun
fish_add_path "$HOME/Library/pnpm/bin" # pnpm (binary)
fish_add_path "$HOME/Library/pnpm" # pnpm (packages)
fish_add_path "$HOME/go/bin" # Go
fish_add_path "$HOME/.cargo/bin" # Rust
fish_add_path "$HOME/.codeium/windsurf/bin" # Windsurf
fish_add_path "$HOME/.opencode/bin" # OpenCode
fish_add_path "/opt/homebrew/opt/libpq/bin" # libpg (Postgres CLI tools)
fish_add_path "$HOME/.lmstudio/bin" # LM Studio
if [ -f "$HOME/Applications/google-cloud-sdk/path.fish.inc" ]; . "$HOME/Applications/google-cloud-sdk/path.fish.inc"; end # Google Cloud SDK

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Initialize zoxide
zoxide init fish --cmd j | source
