<div align="center">

# .files

### A minimal, keyboard-centric Hyprland experience.

[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793d1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-WM-00f0ff?style=for-the-badge&logo=linux&logoColor=black)](https://hyprland.org)
[![Zsh](https://img.shields.io/badge/Shell-Zsh-orange?style=for-the-badge&logo=zsh&logoColor=white)](https://zsh.org)
[![Pywal](https://img.shields.io/badge/Theme-Pywal-ff0055?style=for-the-badge&logo=python&logoColor=white)](https://github.com/dylanaraps/pywal)

<br />

</div>

## About

My daily driver on Arch + Hyprland. Everything is keyboard-driven, color-synced through Pywal, and managed with GNU Stow. Take what's useful.

## Stack

- **WM:** [Hyprland](https://hyprland.org/) — Wayland compositor with tiling and smooth animations
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/) — GPU-accelerated, Pywal-themed
- **Multiplexer:** [Zellij](https://zellij.dev/) — persistent sessions and layouts
- **Shell:** Zsh + [Starship](https://starship.rs/) prompt
- **Editor:** [Neovim](https://neovim.io/) — LazyVim config with LSP and Treesitter
- **Files:** [Yazi](https://yazi-rs.github.io/) — terminal file manager with image previews
- **Documents:** [Zathura](https://pwmt.org/projects/zathura/) — PDF viewer with SyncTeX + Neovim integration
- **Browser:** [Zen Browser](https://zen-browser.app/) (daily) / [Qutebrowser](https://qutebrowser.org/) (keyboard-driven)
- **Bar:** [Waybar](https://github.com/Alexays/Waybar) — Pywal-styled status bar
- **Theming:** [Pywal](https://github.com/dylanaraps/pywal) — wallpaper-based system-wide color sync
- **Display:** [Kanshi](https://git.sr.ht/~emersion/kanshi) — automatic monitor profile switching
- **Notifications:** [Dunst](https://dunst-project.org/) — Pywal-themed notification daemon
- **Launcher:** [Wofi](https://hg.sr.ht/~scoopta/wofi) — Wayland app launcher
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

| Key Combo             | Action                          |
| --------------------- | ------------------------------- |
| `Super + Return`      | Terminal (Kitty)                |
| `Super + B`           | Browser (Zen)                   |
| `Super + Shift + B`   | Browser (Qutebrowser)           |
| `Super + E`           | File Manager (Nemo)             |
| `Super + Y`           | CLI Files (Yazi)                |
| `Super + D`           | App Launcher (Wofi)             |
| `Super + A`           | Email (aerc)                    |
| `Super + T`           | Tasks (taskwarrior-tui)         |
| `Super + N`           | New Note                        |
| `Super + Shift + N`   | Search Notes                    |
| `Super + C`           | Clip to Scrapbook               |
| `Super + W`           | Change Wallpaper (Pywal)        |
| `Super + S`           | Screenshot (Region)             |
| `Super + Shift + S`   | Screenshot (Full Screen)        |
| `Super + P`           | Power Menu                      |
| `Super + Alt + L`     | Lock Screen (Hyprlock)          |
| `Super + M`           | Toggle Mute                     |
| `Super + Shift + C`   | Clipboard History               |
| `Super + Q`           | Close Window                    |
| `Super + F`           | Toggle Fullscreen               |
| `Super + V`           | Toggle Floating                 |
| `Super + H/J/K/L`     | Move Focus                      |
| `Super + Shift + H/J/K/L` | Swap Windows               |
| `Super + Ctrl + H/J/K/L`  | Resize Window              |
| `Super + 1-9`         | Switch Workspace                |
| `Super + Shift + 1-9` | Move to Workspace               |
| `Super + Tab`         | Previous Workspace              |

## Folder Structure

```
$HOME/dotfiles
├── hypr/          # Window manager
├── kitty/         # Terminal
├── zellij/        # Multiplexer
├── nvim/          # Editor (LazyVim)
├── waybar/        # Status bar
├── zsh/           # Shell
├── yazi/          # Terminal file manager
├── zathura/       # Document viewer
├── qutebrowser/   # Keyboard-driven browser
├── zen-browser/   # Daily browser
├── dunst/         # Notifications
├── wofi/          # App launcher
├── kanshi/        # Display profiles
├── wal/           # Pywal templates
├── scripts/       # Custom shell scripts
└── install.sh     # Setup script
```
