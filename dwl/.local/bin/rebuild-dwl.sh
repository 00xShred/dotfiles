#!/bin/sh
set -e

SRC="$HOME/builds/dwl"

if [ ! -f "$SRC/config.h" ]; then
    echo "ERROR: $SRC/config.h not found." >&2
    exit 1
fi

cd "$SRC"
make
sudo make install
echo "dwl rebuilt and installed. Restarting..."
pkill -x dwl || true
