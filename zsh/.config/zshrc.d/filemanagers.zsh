# ==============================================================================
# Terminal File Managers Integration (lf, nnn, joshuto)
# ==============================================================================

# Ensure environment defaults
export TERMINAL="${TERMINAL:-foot}"
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# ------------------------------------------------------------------------------
# 1. lf (cd-on-quit)
# ------------------------------------------------------------------------------
lfcd() {
    tmp="$(mktemp)"
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
alias lf="lfcd"

# ------------------------------------------------------------------------------
# 2. nnn (env + cd-on-quit wrapper)
# ------------------------------------------------------------------------------
[ -f "$HOME/.config/nnn/nnn.env" ] && source "$HOME/.config/nnn/nnn.env"
alias nnn="n"

# ------------------------------------------------------------------------------
# 3. joshuto (cd-on-quit)
# ------------------------------------------------------------------------------
joshutocd() {
    local tmp="$(mktemp -t "joshuto-cwd.XXXXXX")"
    command joshuto --change-directory --output-file "$tmp" "$@"
    local exit_code=$?
    if [ -s "$tmp" ]; then
        local output_cwd="$(cat -- "$tmp")"
        if [ -d "$output_cwd" ] && [ "$output_cwd" != "$PWD" ]; then
            cd -- "$output_cwd"
        fi
    fi
    rm -f -- "$tmp"
    return $exit_code
}
alias joshuto="joshutocd"
alias jj="joshutocd"
