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
    ID="$$"
    mkdir -p "/tmp/$USER" 2>/dev/null
    OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
    command joshuto --output-file "$OUTPUT_FILE" "$@"
    exit_code=$?
    if [ -f "$OUTPUT_FILE" ]; then
        OUTPUT_CWD=$(cat "$OUTPUT_FILE")
        rm -f "$OUTPUT_FILE"
        if [ -d "$OUTPUT_CWD" ] && [ "$OUTPUT_CWD" != "$PWD" ]; then
            cd "$OUTPUT_CWD"
        fi
    fi
    return $exit_code
}
alias joshuto="joshutocd"
alias jj="joshutocd"
