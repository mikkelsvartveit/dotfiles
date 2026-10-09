# AGENTS.md

## Layout

| Directory           | Scope                                                                      |
| ------------------- | -------------------------------------------------------------------------- |
| `dotfiles-common/`  | Shared across all machines (nvim, fish, tmux, git, ghostty, opencode, ...) |
| `dotfiles-macos/`   | macOS only (aerospace, karabiner, ...)                                     |
| `dotfiles-linux/`   | Linux only                                                                 |
| `dotfiles-omarchy/` | Omarchy (Arch + Hyprland) only                                             |
| `exports/`          | Application export files (Raycast, BetterMouse, ...)                       |
| `wallpapers/`       | Wallpapers                                                                 |

Path mapping: `dotfiles-<pkg>/.config/foo/bar` maps to `~/.config/foo/bar`, and
`dotfiles-<pkg>/<file>` (e.g. `.vimrc`) maps to `~/<file>`.

## Golden rule: edit files in this repo, not in the home directory

This repository is managed with [GNU Stow](https://www.gnu.org/software/stow/). Each
top-level package directory mirrors the home directory layout, and Stow symlinks its
contents into `~`. For example:

```
dotfiles/dotfiles-common/.config/nvim/init.vim  <->  ~/.config/nvim/init.vim
```

Because of these symlinks, the repo and `~` are always in sync. Therefore:

- **Always create, edit, and delete files inside this repository.** Changes apply
  immediately to the home directory through the symlinks.
- **Never edit files through their home-directory paths** (`~/.config/...`, `~/.vimrc`,
  `~/.tmux.conf`, etc.). Editing through a symlink may work, but it makes it easy to
  accidentally write outside the repo, break a symlink, or lose changes from version
  control. If you are given a `~` path, translate it to the repo path and edit that.
