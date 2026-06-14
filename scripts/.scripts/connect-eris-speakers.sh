#!/bin/bash

set -euo pipefail

DEVICE_MAC="6A:8B:ED:3D:D4:16"
DEVICE_NAME="Eris 3.5BT"
SINK_NAME="bluez_output.6A_8B_ED_3D_D4_16.1"
WAIT_SECONDS=15

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 127
  fi
}

need_cmd bluetoothctl
need_cmd pactl

echo "Connecting to ${DEVICE_NAME}..."

bluetoothctl <<EOF
power on
agent on
default-agent
trust ${DEVICE_MAC}
connect ${DEVICE_MAC}
EOF

echo "Waiting for audio sink ${SINK_NAME}..."

for ((i = 1; i <= WAIT_SECONDS; i++)); do
  if pactl list short sinks | awk '{ print $2 }' | grep -qx "$SINK_NAME"; then
    pactl set-default-sink "$SINK_NAME"

    while read -r input _; do
      [ -n "${input:-}" ] || continue
      pactl move-sink-input "$input" "$SINK_NAME" 2>/dev/null || true
    done < <(pactl list short sink-inputs)

    echo "${DEVICE_NAME} is connected and set as the default output."
    exit 0
  fi

  sleep 1
done

echo "Connected, but the Bluetooth audio sink did not appear within ${WAIT_SECONDS}s." >&2
echo "Try turning the speaker off and on, then run this script again." >&2
exit 1
