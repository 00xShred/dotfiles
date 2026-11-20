#!/bin/bash
# Linux-only bootstrap; macOS layer removed from the repo.
set -euo pipefail
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
if [[ "$(uname -s)" != "Linux" ]]; then
  echo "Unsupported OS: $(uname -s)"; exit 1
fi
exec "$DOTFILES_DIR/install-arch.sh" "$@"
