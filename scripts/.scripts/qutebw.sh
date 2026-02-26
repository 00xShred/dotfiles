#!/bin/bash
# Check if session is already set and valid
if ! bw status | grep -q "unlocked"; then
    # If not, unlock and capture the session key
    BW_SESSION=$(bw unlock --raw)
    export BW_SESSION
fi
# Launch qutebrowser with the environment variable set
exec qutebrowser "$@"
