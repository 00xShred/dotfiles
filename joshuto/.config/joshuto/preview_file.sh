#!/usr/bin/env bash
set -e

FILE_PATH=""
PREVIEW_WIDTH=80
PREVIEW_HEIGHT=40
XPOS=0
YPOS=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        "--path")
            shift
            FILE_PATH="$1"
            ;;
        "--preview-width")
            shift
            PREVIEW_WIDTH="$1"
            ;;
        "--preview-height")
            shift
            PREVIEW_HEIGHT="$1"
            ;;
        "--xpos")
            shift
            XPOS="$1"
            ;;
        "--ypos")
            shift
            YPOS="$1"
            ;;
    esac
    shift
done

[ -r "$FILE_PATH" ] || exit 1

MIMETYPE="$(file --dereference --brief --mime-type -- "$FILE_PATH" 2>/dev/null || true)"
EXT="${FILE_PATH##*.}"
EXT="$(echo "$EXT" | tr '[:upper:]' '[:lower:]')"

# 1. Markdown preview via leaf
if [ "$EXT" = "md" ] || [ "$EXT" = "markdown" ] || [ "$MIMETYPE" = "text/markdown" ]; then
    if command -v leaf >/dev/null 2>&1; then
        leaf --inline "ansi:$PREVIEW_WIDTH" "$FILE_PATH" && exit 0
    elif [ -x "$HOME/.cargo/bin/leaf" ]; then
        "$HOME/.cargo/bin/leaf" --inline "ansi:$PREVIEW_WIDTH" "$FILE_PATH" && exit 0
    elif command -v bat >/dev/null 2>&1; then
        bat --color=always --paging=never --style=numbers,changes --terminal-width="$PREVIEW_WIDTH" "$FILE_PATH" && exit 0
    fi
fi

case "$MIMETYPE" in
    text/* | application/json | application/javascript | application/x-yaml | application/toml | application/xml)
        if command -v bat >/dev/null 2>&1; then
            bat --color=always --paging=never --style=numbers,changes --terminal-width="$PREVIEW_WIDTH" "$FILE_PATH" && exit 0
        else
            head -n "$PREVIEW_HEIGHT" "$FILE_PATH" && exit 0
        fi
        ;;
    inode/directory)
        if command -v eza >/dev/null 2>&1; then
            eza -la --icons --color=always --group-directories-first "$FILE_PATH" && exit 0
        else
            ls -lh --color=always "$FILE_PATH" && exit 0
        fi
        ;;
    application/zip | application/x-tar | application/x-7z-compressed | application/x-rar | application/gzip | application/x-bzip2 | application/x-xz)
        if command -v 7z >/dev/null 2>&1; then
            7z l "$FILE_PATH" && exit 0
        elif command -v tar >/dev/null 2>&1; then
            tar -tvf "$FILE_PATH" 2>/dev/null && exit 0
        fi
        ;;
    image/*)
        if command -v chafa >/dev/null 2>&1; then
            chafa -s "${PREVIEW_WIDTH}x${PREVIEW_HEIGHT}" "$FILE_PATH" && exit 0
        fi
        echo "=== Image ==="
        file -b "$FILE_PATH"
        exit 0
        ;;
    video/*)
        cache="/tmp/joshuto-thumb-$(echo "$FILE_PATH" | md5sum | awk '{print $1}').png"
        if [ ! -f "$cache" ]; then
            ffmpegthumbnailer -i "$FILE_PATH" -o "$cache" -s 0 -q 5 2>/dev/null || true
        fi
        if [ -f "$cache" ] && command -v chafa >/dev/null 2>&1; then
            chafa -s "${PREVIEW_WIDTH}x${PREVIEW_HEIGHT}" "$cache" && exit 0
        fi
        echo "=== Video ==="
        file -b "$FILE_PATH"
        exit 0
        ;;
    application/pdf)
        cache="/tmp/joshuto-pdf-$(echo "$FILE_PATH" | md5sum | awk '{print $1}')"
        if [ ! -f "${cache}-1.png" ]; then
            pdftoppm -png -f 1 -l 1 "$FILE_PATH" "$cache" 2>/dev/null || true
        fi
        if [ -f "${cache}-1.png" ] && command -v chafa >/dev/null 2>&1; then
            chafa -s "${PREVIEW_WIDTH}x${PREVIEW_HEIGHT}" "${cache}-1.png" && exit 0
        fi
        echo "=== PDF Document ==="
        file -b "$FILE_PATH"
        exit 0
        ;;
esac

# Fallback
if file -b --mime-encoding "$FILE_PATH" | grep -q 'binary'; then
    echo "=== Binary File ==="
    file -b "$FILE_PATH"
    ls -lh "$FILE_PATH" | awk '{print "Size: " $5 ", Permissions: " $1}'
else
    if command -v bat >/dev/null 2>&1; then
        bat --color=always --paging=never --style=numbers,changes --terminal-width="$PREVIEW_WIDTH" "$FILE_PATH" 2>/dev/null || head -n "$PREVIEW_HEIGHT" "$FILE_PATH"
    else
        head -n "$PREVIEW_HEIGHT" "$FILE_PATH"
    fi
fi
exit 0
