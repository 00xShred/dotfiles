---
layout: default
title: Home
---

<header>
    <h1>gab's .files<span class="cursor">_</span></h1>
    <p class="subtitle">Arch Linux // Hyprland // Zsh // Pywal // Zellij</p>
    <div style="margin-top: 1.5rem;">
        <a href="https://github.com/gab-dev-7/dotfiles" class="btn">View Source</a>
    </div>
</header>

## The Setup

My daily driver on Arch + Hyprland. Everything is keyboard-driven, color-synced through Pywal, and managed with GNU Stow. Take what's useful.

## Gallery

<div class="grid">
<img src="assets/images/h2.jpg" alt="Screenshot 2" style="border-radius: 8px; border: 1px solid #1e293b;">
<img src="assets/images/h3.jpg" alt="Screenshot 3" style="border-radius: 8px; border: 1px solid #1e293b;">
<img src="assets/images/h4.jpg" alt="Screenshot 4" style="border-radius: 8px; border: 1px solid #1e293b;">
</div>

## The Stack

<div class="grid">
    <div class="card">
        <h3>Hyprland</h3>
        <p><strong>The Engine.</strong> A Wayland compositor with tiling, smooth animations, and per-monitor scaling. My window manager of choice.</p>
    </div>
    <div class="card">
        <h3>Kitty</h3>
        <p><strong>The Terminal.</strong> Low-latency GPU-rendered terminal (6ms repaint, 1ms input delay). Pywal-themed, with custom search and scroll plugins, Vim-style window/tab management, and remote control enabled for Neovim integration.</p>
    </div>
    <div class="card">
        <h3>Zellij</h3>
        <p><strong>The Multiplexer.</strong> Persistent terminal sessions with panes and tabs. Keeps long-running processes alive and layouts consistent.</p>
    </div>
    <div class="card">
        <h3>Neovim</h3>
        <p><strong>The Editor.</strong> LazyVim-based config with LSP, Treesitter, and Telescope for fuzzy finding. My main editor for everything.</p>
    </div>
    <div class="card">
        <h3>Yazi</h3>
        <p><strong>The Navigator.</strong> Terminal file manager written in Rust. Fast, with async image previews and Vim-style keybindings.</p>
    </div>
    <div class="card">
        <h3>Zathura</h3>
        <p><strong>The Document Viewer.</strong> Minimal PDF viewer with Pywal theming and SyncTeX support. Clicking a line in the PDF jumps to the corresponding source in Neovim — making it a natural part of a LaTeX compile workflow.</p>
    </div>
    <div class="card">
        <h3>Zen Browser</h3>
        <p><strong>The Daily Browser.</strong> Firefox-based browser with a clean, distraction-free UI. My go-to for general browsing, themed via pywalfox.</p>
    </div>
    <div class="card">
        <h3>Qutebrowser</h3>
        <p><strong>The Power Browser.</strong> Fully keyboard-driven with Vim-style navigation. Preferred for focused work — integrated with Bitwarden and Pywal. Falls back to Zen for sites that don't play nice.</p>
    </div>
    <div class="card">
        <h3>Waybar</h3>
        <p><strong>The Status Bar.</strong> Highly customizable bar for Hyprland, styled dynamically with Pywal colors. Monitors workspaces, media, and system resources.</p>
    </div>
    <div class="card">
        <h3>Pywal</h3>
        <p><strong>The Aesthetic.</strong> Generates a color palette from my wallpaper and applies it system-wide — Waybar, Kitty, and Dunst all stay in sync automatically.</p>
    </div>
    <div class="card">
        <h3>Kanshi</h3>
        <p><strong>The Display Manager.</strong> Automatically switches between display profiles on connect/disconnect. Configured for two setups: a docked dual-monitor layout (one rotated 90°) and a standalone laptop mode.</p>
    </div>
    <div class="card">
        <h3>OnlyOffice</h3>
        <p><strong>The Office Suite.</strong> Full-featured document, spreadsheet, and presentation editor. Configured with the night theme and GPU acceleration for a native feel on Wayland.</p>
    </div>
</div>

## Cheat Sheet

Everything runs from the keyboard, mostly through `Super`.

### Applications

| Key Combo              | Action                              |
| ---------------------- | ----------------------------------- |
| `Super + Return`       | **Terminal** (Kitty)                |
| `Super + B`            | **Browser** (Zen)                   |
| `Super + Shift + B`    | **Browser** (Qutebrowser)           |
| `Super + E`            | **File Manager** (Nemo)             |
| `Super + Y`            | **CLI Files** (Yazi)                |
| `Super + D`            | **App Launcher** (Wofi)             |
| `Super + A`            | **Email** (aerc)                    |
| `Super + T`            | **Tasks** (taskwarrior-tui)         |

### Notes

| Key Combo              | Action                              |
| ---------------------- | ----------------------------------- |
| `Super + N`            | **New Note** (Neovim float)         |
| `Super + Shift + N`    | **Search Notes** (fzf)              |
| `Super + C`            | **Clip to Scrapbook**               |

### System Controls

| Key Combo              | Action                              |
| ---------------------- | ----------------------------------- |
| `Super + W`            | **Change Wallpaper** (Pywal)        |
| `Super + S`            | **Screenshot** (Region)             |
| `Super + Shift + S`    | **Screenshot** (Full Screen)        |
| `Super + P`            | **Power Menu**                      |
| `Super + Alt + L`      | **Lock Screen** (Hyprlock)          |
| `Super + M`            | **Toggle Mute**                     |
| `Super + Shift + C`    | **Clipboard History**               |
| `Super + Shift + M`    | **Monitor Layout** (nwg-displays)   |
| `Super + R`            | **Reload Hyprland**                 |

### Window Management

| Key Combo                  | Action                          |
| -------------------------- | ------------------------------- |
| `Super + Q`                | **Close Window**                |
| `Super + F`                | **Toggle Fullscreen**           |
| `Super + V`                | **Toggle Floating**             |
| `Super + H/J/K/L`          | **Move Focus** (Vim keys)       |
| `Super + Shift + H/J/K/L`  | **Swap Windows**                |
| `Super + Ctrl + H/J/K/L`   | **Resize Window**               |
| `Super + 1-9`              | **Switch Workspace**            |
| `Super + Shift + 1-9`      | **Move to Workspace**           |
| `Super + Tab`              | **Previous Workspace**          |
| `Alt + Tab`                | **Cycle Windows**               |

## Custom Scripts

A collection of shell scripts in `~/.scripts/` that glue the environment together.

<div class="grid">
    <div class="card">
        <small>Aesthetic & Theming</small>
        <h3>wallpaper.sh</h3>
        <p>Interactive selector using <code>fzf</code> and <code>swaybg</code>. Applies a new wallpaper, regenerates Pywal colors, and reloads Waybar and Dunst.</p>
    </div>

    <div class="card">
        <small>Hardware</small>
        <h3>volume.sh & brightness.sh</h3>
        <p>Controls audio and backlight with <code>pamixer</code> and <code>brightnessctl</code>, with visual OSD feedback via Dunst.</p>
    </div>

    <div class="card">
        <small>Hardware</small>
        <h3>power_profile_waybar.sh</h3>
        <p>Cycles between Performance, Balanced, and Power Saver modes with Waybar icon integration.</p>
    </div>

    <div class="card">
        <small>Utility</small>
        <h3>clipmenu.sh</h3>
        <p>A <code>Wofi</code> frontend for <code>cliphist</code> — fuzzy-searchable clipboard history.</p>
    </div>

    <div class="card">
        <small>Utility</small>
        <h3>powermenu.sh</h3>
        <p>Wofi-based exit menu for Shutdown, Reboot, Suspend, and Lock.</p>
    </div>

    <div class="card">
        <small>Utility</small>
        <h3>disk_monitor.sh</h3>
        <p>Background daemon that sends a desktop notification if disk usage drops below 15%.</p>
    </div>

    <div class="card">
        <small>Note-taking</small>
        <h3>quick_note / qn_search / clip_to_note</h3>
        <p>A minimal note-taking system built on Neovim and <code>fzf</code>. Create numbered notes, search existing ones, or save clipboard content directly to a scrapbook file.</p>
    </div>

    <div class="card">
        <small>Utility</small>
        <h3>qutebw.sh</h3>
        <p>Launches qutebrowser with a Bitwarden unlock flow via Wofi — handles unauthenticated, locked, and unlocked vault states before opening the browser.</p>
    </div>

    <div class="card">
        <small>Hardware</small>
        <h3>toggle_power.sh</h3>
        <p>Cycles through power profiles — Power Saver, Balanced, and Performance — using <code>powerprofilesctl</code>.</p>
    </div>

</div>

## Installation Guide

> **Warning:** This script assumes a fresh Arch Linux install. It uses `GNU Stow` to manage symlinks. Back up your existing `~/.config` before proceeding.

### 1. Update & Prep

```bash
sudo pacman -Syu git
```

### 2. Clone the Repo

The folder name must be `dotfiles` for the symlinks to work.

```bash
git clone https://github.com/gab-dev-7/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

### 3. Run the Installer

Installs native and AUR packages, backs up existing configs, and stows everything.

```bash
chmod +x install.sh
./install.sh
```
