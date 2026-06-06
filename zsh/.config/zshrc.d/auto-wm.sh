# Auto start window manager on tty1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  mkdir -p ~/.cache
  echo "Starting window manager..."
  echo "Press 'h' for Hyprland (fallback), otherwise dwl starts in 3 seconds..."
  
  choice=""
  if [ -n "$ZSH_VERSION" ]; then
    read -t 3 -k 1 choice
  else
    read -t 3 -n 1 choice
  fi
  echo ""

  if [ "$choice" = "h" ] || [ "$choice" = "H" ]; then
    echo "Starting Hyprland..."
    exec uwsm start hyprland-uwsm.desktop > ~/.cache/hyprland.log 2>&1
  else
    echo "Starting dwl..."
    if ! uwsm start dwl.desktop > ~/.cache/dwl.log 2>&1; then
      echo "dwl failed to start! Falling back to Hyprland..."
      exec uwsm start hyprland-uwsm.desktop > ~/.cache/hyprland.log 2>&1
    fi
  fi
fi
