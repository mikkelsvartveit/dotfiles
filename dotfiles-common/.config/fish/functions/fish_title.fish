# Show only the running command (e.g. "nvim"), or the dir when idle
function fish_title
    set -q argv[1]; or set argv (status current-command)
    if test "$argv[1]" = fish
        prompt_pwd -d 1 -D 1
    else
        string sub -l 20 -- $argv[1]
    end
end
