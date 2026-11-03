#!/bin/sh
# Portable logging library with modern colors & Nerd Font icons. No emojis.
# Source in scripts: . "${0%/*}/lib/log.sh" || . "$HOME/.scripts/lib/log.sh"

_log_use_color() {
    [ -n "${FORCE_COLOR:-}" ] && return 0
    [ -n "${NO_COLOR:-}" ] && return 1
    [ "${TERM:-}" = "dumb" ] && return 1
    [ -t "$1" ]
}

# Catppuccin Mocha TrueColor palette
if _log_use_color 1; then
    _C_RESET="\033[0m"
    _C_BOLD="\033[1m"
    _C_DIM="\033[2m"
    _C_BLUE="\033[38;2;137;180;250m"
    _C_GREEN="\033[38;2;166;227;161m"
    _C_YELLOW="\033[38;2;249;226;175m"
    _C_MAUVE="\033[38;2;203;166;247m"
    _C_GRAY="\033[38;2;108;112;134m"
else
    _C_RESET="" _C_BOLD="" _C_DIM="" _C_BLUE="" _C_GREEN="" _C_YELLOW="" _C_MAUVE="" _C_GRAY=""
fi

if _log_use_color 2; then
    _C_RED="\033[38;2;243;139;168m"
else
    _C_RED=""
fi

# Nerd Font v3 glyphs
_ICON_INFO="󰋼"
_ICON_OK="󰄲"
_ICON_WARN="󰀪"
_ICON_ERR="󰅚"
_ICON_STEP="󰑮"
_ICON_DEBUG="󰃤"

log_info()  { printf "%b%s%b  %s\n" "${_C_BLUE}" "${_ICON_INFO}" "${_C_RESET}" "$*"; }
log_ok()    { printf "%b%s%b  %s\n" "${_C_GREEN}" "${_ICON_OK}" "${_C_RESET}" "$*"; }
log_warn()  { printf "%b%s%b  %s\n" "${_C_YELLOW}" "${_ICON_WARN}" "${_C_RESET}" "$*"; }
log_err()   { printf "%b%s%b  %s\n" "${_C_RED}" "${_ICON_ERR}" "${_C_RESET}" "$*" >&2; }
log_step()  { printf "%b%s%b  %b%s%b\n" "${_C_MAUVE}" "${_ICON_STEP}" "${_C_RESET}" "${_C_BOLD}" "$*" "${_C_RESET}"; }
log_debug() {
    [ -z "${DEBUG:-}" ] && [ -z "${LOG_DEBUG:-}" ] && return 0
    printf "%b%s%b  %b%s%b\n" "${_C_GRAY}" "${_ICON_DEBUG}" "${_C_RESET}" "${_C_DIM}" "$*" "${_C_RESET}";
}

# shortcut: tests inline demo only, run standalone to verify render
if [ "${0##*/}" = "log.sh" ]; then
    log_step "Initializing modern script output..."
    log_info "Reading system configuration"
    log_ok "All dotfiles synced cleanly"
    log_warn "Cache exceeds 500MB, pruning suggested"
    log_err "Failed to connect to backend server"
    DEBUG=1 log_debug "Tracing execution: payload size 42B"
fi
