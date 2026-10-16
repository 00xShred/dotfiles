#!/usr/bin/env bash
# usage: theme.sh beige|black|orig  -- applies to all running zathura instances
case $1 in
  beige) l="#dfd2b5" d="#1c1a17" w="#cfc1a0" ;;
  black) l="#000000" d="#ffffff" w="#000000" ;;
  *) l= ;;
esac
for p in $(pgrep -x zathura); do
  z() { busctl --user call "org.pwmt.zathura.PID-$p" /org/pwmt/zathura org.pwmt.zathura ExecuteCommand s "$1" >/dev/null 2>&1; }
  if [ -z "$l" ]; then z "set recolor false"; continue; fi
  z "set recolor false"
  z "set recolor-lightcolor $l"; z "set recolor-darkcolor $d"; z "set default-bg $w"
  z "set recolor true"
done
