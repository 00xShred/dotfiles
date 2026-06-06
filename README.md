<div align="center">

# .files

### A minimal, keyboard-centric dwl experience.

[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793d1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![dwl](https://img.shields.io/badge/dwl-WM-3a5aa7?style=for-the-badge&logo=linux&logoColor=white)](https://github.com/djpohly/dwl)
[![Zsh](https://img.shields.io/badge/Shell-Zsh-orange?style=for-the-badge&logo=zsh&logoColor=white)](https://zsh.org)

<br />

</div>

## About

My daily driver on Arch + dwl (with Hyprland configured as a fallback). Everything is keyboard-driven, color-synced through Pywal, and managed with GNU Stow. Take what's useful.

## Stack

- **WM:** [dwl](https://codeberg.org/dwl/dwl) (Primary) / [Hyprland](https://hyprland.org/) (Fallback)
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/) — GPU-accelerated, Pywal-themed
- **Multiplexer:** [Zellij](https://zellij.dev/) — persistent sessions and layouts
- **Shell:** Zsh + [Starship](https://starship.rs/) prompt
- **Editor:** [Neovim](https://neovim.io/) — LazyVim config with LSP and Treesitter
- **Files:** [Yazi](https://yazi-rs.github.io/) — terminal file manager with image previews
- **Documents:** [Zathura](https://pwmt.org/projects/zathura/) — PDF viewer with SyncTeX + Neovim integration
- **Browser:** [Zen Browser](https://zen-browser.app/) (daily) / [Qutebrowser](https://qutebrowser.org/) (keyboard-driven)
- **Bar:** [somebar](https://github.com/raphi/somebar) (for dwl) / [Waybar](https://github.com/Alexays/Waybar) (for Hyprland)
- **Theming:** [Pywal](https://github.com/dylanaraps/pywal) — wallpaper-based system-wide color sync
- **Display:** [Kanshi](https://git.sr.ht/~emersion/kanshi) — automatic monitor profile switching
- **Notifications:** [Dunst](https://dunst-project.org/) — Pywal-themed notification daemon
- **Launcher:** [fuzzel](https://codeberg.org/dnkl/fuzzel) & [wmenu](https://codeberg.org/adnano/wmenu) (for dwl) / [Wofi](https://hg.sr.ht/~scoopta/wofi) (for Hyprland)
- **Locker:** [swaylock](https://github.com/jeffmhubbard/swaylock) (for dwl) / [hyprlock](https://github.com/hyprwm/hyprlock) (for Hyprland)
- **Office:** [OnlyOffice](https://www.onlyoffice.com/) — document, spreadsheet, and presentation editor

## Installation

> **Warning:** This script assumes a fresh Arch Linux install. It uses `GNU Stow` to manage symlinks. Back up your existing `~/.config` before proceeding.

```bash
# 1. Update & install git
sudo pacman -Syu git

# 2. Clone the repo (must be named 'dotfiles' for symlinks to work)
git clone https://github.com/gab-dev-7/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"

# 3. Run the installer
chmod +x install.sh
./install.sh
```

## Key Bindings

| Key Combo                 | Action                            |
| ------------------------- | --------------------------------- |
| `Super + Return`          | Terminal (Kitty)                  |
| `Super + B`               | Browser (Zen)                     |
| `Super + Shift + B`       | Browser (Qutebrowser)             |
| `Super + E`               | File Manager (Nemo)               |
| `Super + Y`               | CLI Files (Yazi)                  |
| `Super + D`               | App Launcher (Fuzzel / Wofi)      |
| `Super + A`               | Email (aerc)                      |
| `Super + T`               | Tasks (taskwarrior-tui)           |
| `Super + N`               | New Note                          |
| `Super + Shift + N`       | Search Notes                      |
| `Super + C`               | Clip to Scrapbook                 |
| `Super + W`               | Change Wallpaper (Pywal)          |
| `Super + S`               | Screenshot (Region)               |
| `Super + Shift + S`       | Screenshot (Full Screen)          |
| `Super + P`               | Power Menu                        |
| `Super + Alt + L`         | Lock Screen (Swaylock / Hyprlock) |
| `Super + M`               | Toggle Mute                       |
| `Super + Shift + C`       | Clipboard History                 |
| `Super + Q`               | Close Window                      |
| `Super + F`               | Toggle Fullscreen                 |
| `Super + V`               | Toggle Floating                   |
| `Super + H/J/K/L`         | Move Focus                        |
| `Super + Shift + H/J/K/L` | Swap Windows                      |
| `Super + Ctrl + H/J/K/L`  | Resize Window                     |
| `Super + 1-9`             | Switch Workspace / Tag            |
| `Super + Shift + 1-9`     | Move to Workspace / Tag           |
| `Super + Tab`             | Previous Workspace / Tag          |

## Folder Structure

```
$HOME/dotfiles
├── dwl/           # Primary Window manager
├── hypr/          # Fallback Window manager
├── kitty/         # Terminal
├── zellij/        # Multiplexer
├── nvim/          # Editor (LazyVim)
├── waybar/        # Status bar (Hyprland)
├── zsh/           # Shell
├── yazi/          # Terminal file manager
├── zathura/       # Document viewer
├── qutebrowser/   # Keyboard-driven browser
├── zen-browser/   # Daily browser
├── dunst/         # Notifications
├── wofi/          # App launcher (Hyprland fallback)
├── kanshi/        # Display profiles
├── wal/           # Pywal templates
├── scripts/       # Custom shell scripts
└── install.sh     # Setup script
```
