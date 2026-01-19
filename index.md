---
layout: default
title: Home
---

<header>
    <h1>gab's .files</h1>
    <p class="subtitle">Arch Linux // Hyprland // Zsh // Wpgtk // Zellij</p>
    <div style="margin-top: 1.5rem;">
        <a href="https://github.com/gab-dev-7/dotfiles" class="btn">View Source</a>
    </div>
</header>

## The Philosophy

This is not just a collection of config files; it is a cohesive **environment**.

If you are coming from Windows or macOS, this setup replaces the "floating window" chaos with a strict **Tiling Window Manager**. Windows automatically snap into a grid, maximizing screen real estate and allowing you to navigate your entire OS without ever touching a mouse.

---

## The Stack

<div class="grid">
    <div class="card">
        <h3>Hyprland</h3>
        <p><strong>The Engine.</strong> A modern Wayland compositor. Offers buttery smooth animations, rounded corners, and blur effects that make the desktop feel alive.</p>
    </div>
    <div class="card">
        <h3>Zellij</h3>
        <p><strong>The Multiplexer.</strong> Beyond just a terminal; it's a workspace manager. It handles panes and tabs with a built-in UI, allowing persistent sessions and complex layouts.</p>
    </div>
    <div class="card">
        <h3>Neovim</h3>
        <p><strong>The Editor.</strong> A Lua-based IDE experience using LazyVim. Features LSP for smart completions, Treesitter for syntax, and Telescope for fuzzy finding.</p>
    </div>
    <div class="card">
        <h3>Wpgtk</h3>
        <p><strong>The Aesthetic.</strong> A powerful wrapper for Pywal. It extracts colors from wallpapers and applies them to templates system-wide, ensuring Waybar, Kitty, and your WM stay in sync.</p>
    </div>
    <div class="card">
        <h3>Yazi</h3>
        <p><strong>The Navigator.</strong> A blazingly fast terminal file manager written in Rust. It features asynchronous image previews and a Vim-like intuitive control scheme.</p>
    </div>
    <div class="card">
        <h3>Waybar</h3>
        <p><strong>The Status Bar.</strong> A highly customizable status bar styled dynamically. It monitors system resources, media, and workspaces in real-time.</p>
    </div>
</div>

---

## Installation Guide

> **Warning:** This script assumes a fresh Arch Linux install. It uses `GNU Stow` to manage symlinks. Back up your existing `~/.config` before proceeding.

### 1. Update & Prep

Ensure your system core is up to date and you have Git installed.

```bash
sudo pacman -Syu git
```

### 2. Download the Configs

Clone this repository to your home folder. The folder name _must_ be `dotfiles` for the symlinks to work correctly.

```bash
git clone [https://github.com/gab-dev-7/dotfiles.git](https://github.com/gab-dev-7/dotfiles.git) "$HOME/dotfiles"
cd "$HOME/dotfiles"

```

### 3. Automated Install

Run the included installer. This will install all native and AUR packages,move existing configs to `.bak`, and stow the new files.

```bash
chmod +x install.sh
./install.sh

```

---

## Cheat Sheet

The workflow is keyboard-centric, utilizing the `Super` (Windows) key for almost everything.

### 🚀 Applications

| Key Combo        | Action                    |
| ---------------- | ------------------------- |
| `Super + Return` | **Terminal** (Kitty)      |
| `Super + B`      | **Browser** (Zen Browser) |
| `Super + E`      | **GUI Files** (Thunar)    |
| `Super + Y`      | **CLI Files** (Yazi)      |
| `Super + D`      | **App Launcher** (Wofi)   |

### ⚙️ System Controls

Custom scripts are stored in `~/.scripts/` and linked via Stow for easy access.

| Key Combo           | Action                               |
| ------------------- | ------------------------------------ |
| `Super + W`         | **Change Wallpaper** (Wpgtk / Pywal) |
| `Super + Shift + S` | **Screenshot** (Grimblast)           |
| `Super + P`         | **Power Menu** (Wlogout)             |
| `Super + L`         | **Lock Screen** (Hyprlock)           |
| `Super + Shift + C` | **Clipboard History** (Cliphist)     |

### 🪟 Window Management

| Key Combo         | Action                    |
| ----------------- | ------------------------- |
| `Super + Q`       | **Close Active Window**   |
| `Super + F`       | **Toggle Fullscreen**     |
| `Super + V`       | **Toggle Floating Mode**  |
| `Super + H/J/K/L` | **Move Focus** (Vim keys) |
| `Alt + Tab`       | **Cycle Windows**         |

---

## Gallery

<div class="grid">
<img src="assets/images/h2.jpg" alt="Screenshot 2" style="border-radius: 8px; border: 1px solid #1e293b;">
<img src="assets/images/h3.jpg" alt="Screenshot 3" style="border-radius: 8px; border: 1px solid #1e293b;">
<img src="assets/images/h4.jpg" alt="Screenshot 4" style="border-radius: 8px; border: 1px solid #1e293b;">
</div>
