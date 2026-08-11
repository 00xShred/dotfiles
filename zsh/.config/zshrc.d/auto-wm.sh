# Auto start window manager on tty1
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  mkdir -p ~/.cache
  echo "Starting window manager..."
  echo "Press 's' for Sway (fallback), otherwise dwl starts in 3 seconds..."
  
  choice=""
  if [ -n "$ZSH_VERSION" ]; then
    read -t 3 -k 1 choice
  else
    read -t 3 -n 1 choice
  fi
  echo ""

  if [ "$choice" = "s" ] || [ "$choice" = "S" ]; then
    echo "Starting Sway..."
    exec sway > ~/.cache/sway.log 2>&1
  else
    echo "Starting dwl..."
    if ! uwsm start dwl.desktop > ~/.cache/dwl.log 2>&1; then
      echo "dwl failed to start! Falling back to Sway..."
      exec sway > ~/.cache/sway.log 2>&1
    fi
  fi
fi
