# Auto start window manager on tty1
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  mkdir -p ~/.cache
  # Arch/systemd: uwsm. Void/runit: wrap in dbus-run-session.
  UWSM_OK=; WM_RUN=
  if command -v uwsm >/dev/null 2>&1 && [ -d /run/systemd/system ]; then UWSM_OK=1; else WM_RUN="dbus-run-session"; fi
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
    exec $WM_RUN sway > ~/.cache/sway.log 2>&1
  else
    echo "Starting dwl..."
    if [ -n "$UWSM_OK" ]; then
      uwsm start dwl.desktop > ~/.cache/dwl.log 2>&1
    else
      XDG_CURRENT_DESKTOP=dwl $WM_RUN sh -c '~/.scripts/start_audio.sh; exec dwl' > ~/.cache/dwl.log 2>&1
    fi
    if [ $? -ne 0 ]; then
      echo "dwl failed to start! Falling back to Sway..."
      exec $WM_RUN sway > ~/.cache/sway.log 2>&1
    fi
  fi
fi
