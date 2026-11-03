#!/bin/bash

set -euo pipefail

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

DEVICE_MAC="6A:8B:ED:3D:D4:16"
DEVICE_NAME="Eris 3.5BT"
SINK_NAME="bluez_output.6A_8B_ED_3D_D4_16.1"
WAIT_SECONDS=15

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log_err "Missing required command: $1"
    exit 127
  fi
}

need_cmd bluetoothctl
need_cmd pactl

log_step "Connecting to ${DEVICE_NAME} (${DEVICE_MAC})..."

bluetoothctl <<EOF
power on
agent on
default-agent
trust ${DEVICE_MAC}
connect ${DEVICE_MAC}
EOF

log_info "Waiting for audio sink ${SINK_NAME}..."

for ((i = 1; i <= WAIT_SECONDS; i++)); do
  if pactl list short sinks | awk '{ print $2 }' | grep -qx "$SINK_NAME"; then
    pactl set-default-sink "$SINK_NAME"

    while read -r input _; do
      [ -n "${input:-}" ] || continue
      pactl move-sink-input "$input" "$SINK_NAME" 2>/dev/null || true
    done < <(pactl list short sink-inputs)

    log_ok "${DEVICE_NAME} connected and set as default output."
    exit 0
  fi

  sleep 1
done

log_err "Bluetooth audio sink failed to appear within ${WAIT_SECONDS}s."
log_warn "Cycle speaker power (off/on) and retry."
exit 1
