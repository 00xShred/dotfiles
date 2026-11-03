#!/bin/sh
# Non-systemd (Void/runit): start the PipeWire stack. No-op under systemd (user units do it).
# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

if [ -d /run/systemd/system ]; then
    log_debug "systemd detected; audio managed by user units"
    exit 0
fi

if pgrep -x pipewire >/dev/null; then
    log_info "PipeWire already active"
else
    pipewire >/dev/null 2>&1 &
    log_ok "PipeWire spawned"
fi
