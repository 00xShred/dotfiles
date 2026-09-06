<div align="center">

# .files

### A minimal, keyboard-centric Sway experience.

[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793d1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Sway](https://img.shields.io/badge/Sway-WM-3a5aa7?style=for-the-badge&logo=linux&logoColor=white)](https://swaywm.org/)
[![Zsh](https://img.shields.io/badge/Shell-Zsh-orange?style=for-the-badge&logo=zsh&logoColor=white)](https://zsh.org)

<br />

</div>

## About

My daily driver on Arch + Sway. Everything is keyboard-driven, color-synced through Pywal, and managed with GNU Stow. Take what's useful.

## Stack

- **WM:** [Sway](https://swaywm.org/)
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/) — GPU-accelerated, Pywal-themed
- **Multiplexers:** [Zellij](https://zellij.dev/) & [Tmux](https://github.com/tmux/tmux) — persistent sessions and workspace layouts
- **Shell:** Zsh + [Starship](https://starship.rs/) prompt
- **Editor & Agent:** [Neovim](https://neovim.io/) (LazyVim config with LSP and Treesitter) + [Pi](https://github.com/badlogic/pi-mono) coding agent
- **Files:** [Thunar](https://docs.xfce.org/xfce/thunar/start) (GUI) / [Yazi](https://yazi-rs.github.io/) (terminal file manager with image previews)
- **Documents:** [Zathura](https://pwmt.org/projects/zathura/) — PDF viewer with SyncTeX + Neovim integration
- **Browser:** [Qutebrowser](https://qutebrowser.org/) (keyboard-driven daily) / [Zen Browser](https://zen-browser.app/)
- **Bar:** swaybar with custom JSON status (`swaybar_status.sh`)
- **Theming:** [Pywal](https://github.com/dylanaraps/pywal) (pywal16) — wallpaper-based system-wide color sync
- **Display:** [Kanshi](https://git.sr.ht/~emersion/kanshi) — automatic monitor profile switching + [nwg-displays](https://github.com/nwg-piotr/nwg-displays)
- **Notifications:** [Dunst](https://dunst-project.org/) — Pywal-themed notification daemon
- **Launcher:** [wmenu](https://codeberg.org/adnano/wmenu) / [Fuzzel](https://codeberg.org/dnkl/fuzzel) / [Wofi](https://hg.sr.ht/~scoopta/wofi)
- **Locker:** [swaylock](https://github.com/jeffmhubbard/swaylock)
- **Git:** [lazygit](https://github.com/jesseduffield/lazygit)
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

| Key Combo                 | Action                                      |
| ------------------------- | ------------------------------------------- |
| `Super + Return`          | Terminal (Kitty)                            |
| `Super + B`               | Browser (Qutebrowser)                       |
| `Super + Shift + B`       | Browser (Zen Browser)                       |
| `Super + Alt + B`         | Qutebrowser (Bitwarden session unlock)      |
| `Super + D`               | App Launcher (wmenu)                        |
| `Super + Shift + D`       | App Launcher (Fuzzel)                       |
| `Super + E`               | File Manager (Thunar)                       |
| `Super + Alt + D`         | Display Settings (nwg-displays)             |
| `Super + W`               | Change Wallpaper (fzf preview + Pywal)      |
| `Super + P`               | Power Menu (Wofi)                           |
| `Super + N`               | New Quick Note (floating Neovim)            |
| `Super + Shift + N`       | Search Quick Notes (fzf + Neovim)           |
| `Super + C`               | Clip Selection to Note Scraps               |
| `Super + Shift + C`       | Clipboard History (cliphist + Wofi)         |
| `Super + M`               | Toggle Audio Mute                           |
| `Super + O`               | Toggle Window Opacity (0.95 / 1.0)          |
| `Super + S`               | Screenshot Region (Copy to clipboard)       |
| `Super + Shift + S`       | Screenshot Region (Edit in Swappy)          |
| `Super + R`               | Reload Sway & Wallpaper                     |
| `Super + Alt + L`         | Lock Screen (Swaylock)                      |
| `Super + Alt + K`         | Toggle Temporary Keyboard Lock              |
| `Super + Shift + E`       | Exit Sway (swaynag prompt)                  |
| `Super + Q`               | Close Window                                |
| `Super + F`               | Toggle Fullscreen                           |
| `Super + V`               | Toggle Floating                             |
| `Alt + Tab` / `Shift+Tab` | Next / Previous Window Focus                |
| `Super + H/J/K/L`         | Move Focus (Left/Down/Up/Right)             |
| `Super + Shift + H/J/K/L` | Move Window (Left/Down/Up/Right)            |
| `Super + Ctrl + H/J/K/L`  | Resize Window                               |
| `Super + 1-9`             | Switch Workspace                            |
| `Super + Shift + 1-9`     | Move Window to Workspace                    |
| `Super + Tab`             | Previous Workspace (back and forth)         |

## Folder Structure

```
$HOME/dotfiles
├── btop/          # System monitor config & themes
├── cava/          # Audio visualizer config
├── dunst/         # Notification daemon config
├── gtk/           # GTK-3.0 and GTK-4.0 settings
├── kanshi/        # Display profile auto-switching
├── kitty/         # GPU-accelerated terminal
├── lazygit/       # Terminal UI for git
├── nvim/          # LazyVim Neovim configuration
├── nwg/           # nwg-displays and nwg-look settings
├── obs-studio/    # OBS Studio profiles and scenes
├── onlyoffice/    # Document editor config
├── pi/            # Pi coding agent extensions, skills, settings
├── qt/            # Qt5ct and Qt6ct style settings
├── qutebrowser/   # Keyboard-driven browser config & quickmarks
├── rofi/          # Rofi theme config
├── scripts/       # Custom shell & Wayland scripts (~/.scripts)
├── starship/      # Starship prompt configuration
├── sway/          # Sway window manager configuration
├── swaylock/      # Lock screen config
├── tmux/          # Tmux configuration
├── wal/           # Pywal templates & color themes
├── wofi/          # Wofi launcher styling
├── wpg/           # Wpgtk color scheme templates
├── yazi/          # Terminal file manager configuration
├── zathura/       # PDF / document viewer configuration
├── zellij/        # Zellij multiplexer layouts & settings
├── zen-browser/   # Zen browser integration
├── zsh/           # Zsh shell configs (.zshrc, zshrc.d)
└── install.sh     # System bootstrap and stow setup script
```
