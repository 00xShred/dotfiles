#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
backup_link_target() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
  fi
}
link_config() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  backup_link_target "$dest"
  [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]] || ln -sfn "$src" "$dest"
}

case "$(uname -s)" in
  Darwin)
    echo "== macOS dotfiles bootstrap =="
    if command -v brew >/dev/null 2>&1; then
      brew bundle --file="$DOTFILES_DIR/packages/Brewfile"
    elif command -v port >/dev/null 2>&1; then
      echo "Homebrew unavailable on Intel; using MacPorts."
      sudo port selfupdate
      sudo port install $(grep -vE '^[[:space:]]*(#|$)' "$DOTFILES_DIR/packages/MacPorts.txt")
    else
      echo "Install Homebrew or MacPorts, then rerun ./install.sh."
      exit 1
    fi
    # Reuse the actual shared configs; Linux-only desktop layers are intentionally skipped.
    link_config "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    link_config "$DOTFILES_DIR/zsh/.config/zshrc.d" "$HOME/.config/zshrc.d"
    link_config "$DOTFILES_DIR/nvim/.config/nvim" "$HOME/.config/nvim"
    link_config "$DOTFILES_DIR/tmux/.config/tmux" "$HOME/.config/tmux"
    link_config "$DOTFILES_DIR/yazi/.config/yazi" "$HOME/.config/yazi"
    link_config "$DOTFILES_DIR/lazygit/.config/lazygit" "$HOME/.config/lazygit"
    link_config "$DOTFILES_DIR/kitty/.config/kitty" "$HOME/.config/kitty"
    link_config "$DOTFILES_DIR/macos/.yabairc" "$HOME/.yabairc"
    link_config "$DOTFILES_DIR/macos/.skhdrc" "$HOME/.skhdrc"
    # Merge Pi's non-secret repository content without replacing auth.json or models-store.json.
    mkdir -p "$HOME/.pi/agent"
    for p in agents extensions scripts skills themes; do
      link_config "$DOTFILES_DIR/pi/.pi/agent/$p" "$HOME/.pi/agent/$p"
    done
    [[ -e "$HOME/.pi/agent/settings.json" ]] || cp "$DOTFILES_DIR/pi/.pi/agent/settings.json" "$HOME/.pi/agent/settings.json"
    # Pi extensions keep their own dependencies; install only missing node_modules.
    for pkg in "$DOTFILES_DIR/pi/.pi/agent" "$DOTFILES_DIR/pi/.pi/agent/extensions"/* "$DOTFILES_DIR/pi/.pi/agent/npm"; do
      [[ -f "$pkg/package.json" && -d "$pkg/node_modules" ]] || [[ ! -f "$pkg/package.json" ]] || (cd "$pkg" && npm install)
    done
    mkdir -p "$HOME/.cache/wal"
    [[ -e "$HOME/.cache/wal/colors-kitty.conf" ]] || cat > "$HOME/.cache/wal/colors-kitty.conf" <<'EOF'
background #0b0d10
foreground #d7d7d7
cursor #ff5f57
selection_background #3a1014
selection_foreground #ffffff
color0 #111317
color1 #e53946
color2 #8fb573
color3 #d6a657
color4 #6f8faf
color5 #c678dd
color6 #56b6c2
color7 #d7d7d7
color8 #3b4048
color9 #ff4d5a
color10 #a6c47a
color11 #f0c36a
color12 #8aa6c1
color13 #d18fea
color14 #74c7d4
color15 #ffffff
EOF
    [[ -e "$HOME/.cache/wal/colors-wal.vim" ]] || cat > "$HOME/.cache/wal/colors-wal.vim" <<'EOF'
let g:background = '#0b0d10'
let g:foreground = '#d7d7d7'
let g:cursor = '#ff5f57'
let g:color0 = '#111317'
let g:color1 = '#e53946'
let g:color2 = '#8fb573'
let g:color3 = '#d6a657'
let g:color4 = '#6f8faf'
let g:color5 = '#c678dd'
let g:color6 = '#56b6c2'
let g:color7 = '#d7d7d7'
let g:color8 = '#3b4048'
let g:color9 = '#ff4d5a'
let g:color10 = '#a6c47a'
let g:color11 = '#f0c36a'
let g:color12 = '#8aa6c1'
let g:color13 = '#d18fea'
let g:color14 = '#74c7d4'
let g:color15 = '#ffffff'
EOF
    [[ -e "$HOME/.cache/wal/colors.sh" ]] || cat > "$HOME/.cache/wal/colors.sh" <<'EOF'
background='#0b0d10'
foreground='#d7d7d7'
cursor='#ff5f57'
color0='#111317'
color1='#e53946'
color2='#8fb573'
color3='#d6a657'
color4='#6f8faf'
color5='#c678dd'
color6='#56b6c2'
color7='#d7d7d7'
color8='#3b4048'
color9='#ff4d5a'
color10='#a6c47a'
color11='#f0c36a'
color12='#8aa6c1'
color13='#d18fea'
color14='#74c7d4'
color15='#ffffff'
EOF
    # Safe, user-level developer conveniences.
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true
    killall Finder 2>/dev/null || true
    echo "macOS configuration linked. Restart the shell; yabai/skhd configs are ready."
    ;;
  Linux)
    exec "$DOTFILES_DIR/install-arch.sh" "$@"
    ;;
  *) echo "Unsupported OS: $(uname -s)"; exit 1 ;;
esac
