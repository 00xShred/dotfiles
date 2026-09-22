#!/bin/sh
file="$1"
w="$2"
h="$3"
x="$4"
y="$5"

case "$(file -Lb --mime-type "$file")" in
    image/*)
        if command -v chafa >/dev/null 2>&1; then
            chafa -f sixel -s "${w}x${h}" "$file"
        elif command -v magick >/dev/null 2>&1; then
            # Convert terminal cell counts (w x h) to pixel dimensions (~11px wide, ~22px tall)
            pw=$(( w * 11 ))
            ph=$(( h * 22 ))
            magick "$file" -resize "${pw}x${ph}" sixel:-
        fi
        exit 1
        ;;
    *)
        cat "$file"
        ;;
esac
