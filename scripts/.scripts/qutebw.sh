#!/bin/bash

# 1. Get the current status from Bitwarden as JSON
STATUS_JSON=$(bw status)
STATUS=$(echo "$STATUS_JSON" | jq -r '.status')

# 2. Logic Check
if [ "$STATUS" == "unauthenticated" ]; then
    EMAIL=$(wofi --dmenu -p "Bitwarden Email:")
    [ -z "$EMAIL" ] && exit 1
    BW_SESSION=$(wofi --dmenu -p "Master Password:" --password | bw login "$EMAIL" --raw)
    export BW_SESSION

elif [ "$STATUS" == "locked" ]; then
    BW_PASS=$(wofi --dmenu -p "Vault Locked. Master Password:" --password)
    [ -z "$BW_PASS" ] && exit 1

    BW_SESSION=$(echo "$BW_PASS" | bw unlock --raw)
    export BW_SESSION

else
    echo "Bitwarden is already unlocked. Launching qutebrowser..."
fi

# 3. Launch qutebrowser
exec qutebrowser "$@"
