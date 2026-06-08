#!/bin/bash

set -euo pipefail

cache_session() {
    [ -n "${BW_SESSION:-}" ] || return 0
    command -v keyctl >/dev/null 2>&1 || return 0
    keyctl purge user bw_session >/dev/null 2>&1 || true
    keyctl add user bw_session "$BW_SESSION" @u >/dev/null 2>&1 || true
}

# 1. Get the current status from Bitwarden as JSON
STATUS_JSON=$(bw status)
STATUS=$(echo "$STATUS_JSON" | jq -r '.status')

# 2. Logic Check
if [ "$STATUS" == "unauthenticated" ]; then
    EMAIL=$(wofi --dmenu -p "Bitwarden Email:")
    [ -z "$EMAIL" ] && exit 1
    BW_SESSION=$(wofi --dmenu -p "Master Password:" --password | bw login "$EMAIL" --raw)
    export BW_SESSION
    cache_session

elif [ "$STATUS" == "locked" ]; then
    BW_PASS=$(wofi --dmenu -p "Vault Locked. Master Password:" --password)
    [ -z "$BW_PASS" ] && exit 1

    BW_SESSION=$(echo "$BW_PASS" | bw unlock --raw)
    export BW_SESSION
    cache_session

else
    echo "Bitwarden is already unlocked. Launching qutebrowser..."
fi

# 3. Launch qutebrowser
exec qutebrowser "$@"
