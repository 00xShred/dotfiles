# Quickshell can generate terminal OSC color escape sequences, but Kitty already
# loads its palette from ~/.cache/wal/colors-kitty.conf.
if [[ "$DOTS_APPLY_QUICKSHELL_TERMINAL_COLORS" = 1 ]] &&
   [[ -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt ]]; then
    command cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
fi
