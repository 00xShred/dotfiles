#!/bin/bash

set -euo pipefail

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

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
    EMAIL=$(fuzzel --dmenu --prompt "󰌆  Email: ")
    [ -z "$EMAIL" ] && { log_warn "Authentication cancelled"; exit 1; }
    BW_SESSION=$(fuzzel --dmenu --prompt "󰌾  Password: " --password | bw login "$EMAIL" --raw)
    export BW_SESSION
    cache_session
    log_ok "Authenticated Bitwarden session"

elif [ "$STATUS" == "locked" ]; then
    BW_PASS=$(fuzzel --dmenu --prompt "󰌾  Password: " --password)
    [ -z "$BW_PASS" ] && { log_warn "Vault unlock cancelled"; exit 1; }

    BW_SESSION=$(echo "$BW_PASS" | bw unlock --raw)
    export BW_SESSION
    cache_session
    log_ok "Vault unlocked"

else
    log_info "Bitwarden already unlocked. Launching qutebrowser..."
fi

# 3. Launch qutebrowser
exec qutebrowser "$@"
