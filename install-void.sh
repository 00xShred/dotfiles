#!/bin/bash
set -euo pipefail
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
STOW_FOLDERS="btop cava dunst environment foot fuzzel gtk herdr joshuto kanshi kitty lazygit lf nwg obs-studio onlyoffice pi qt qutebrowser rofi scripts starship sway swaylock wal wpg zathura zen-browser zsh"
SERVICES="dbus elogind polkitd NetworkManager bluetoothd zramen crond chronyd cupsd avahi-daemon tailscaled ufw docker libvirtd virtlogd virtlockd power-profiles-daemon input-remapper"
GROUPS_="wheel audio video input network bluetooth docker libvirt kvm lp scanner"

echo "== packages =="
sudo xbps-install -Syu xbps
sudo xbps-install -Sy $(grep -vE '^[[:space:]]*(#|$)' "$DOTFILES_DIR/packages/void.txt" | tr '\n' ' ')

echo "== services (skipped if /etc/sv entry missing) =="
for s in $SERVICES; do
    if [ ! -d "/etc/sv/$s" ]; then
        echo "  no /etc/sv/$s, skipping"
        continue
    fi
    [ -e "/var/service/$s" ] || sudo ln -s "/etc/sv/$s" /var/service/
done
for g in $GROUPS_; do getent group "$g" >/dev/null && sudo usermod -aG "$g" "$USER" || echo "  no group $g"; done

echo "== pipewire (runit: started from WM via ~/.scripts/start_audio.sh) =="
sudo mkdir -p /etc/pipewire/pipewire.conf.d /etc/alsa/conf.d
ln_sys() { [ -e "$1" ] && sudo ln -sf "$1" "$2" || echo "  missing $1"; }
ln_sys /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/10-wireplumber.conf
ln_sys /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/20-pipewire-pulse.conf
ln_sys /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d/50-pipewire.conf
ln_sys /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d/99-pipewire-default.conf

echo "== flatpak =="
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "== rust =="
command -v rustc >/dev/null || rustup default stable

echo "== stow =="
mkdir -p "$HOME/.config"
cd "$DOTFILES_DIR"
for f in $STOW_FOLDERS; do
    echo "  $f"
    stow -v "$f" || echo "  CONFLICT in $f: move the existing file(s) away and rerun"
done

[ "$SHELL" = /usr/bin/zsh ] || chsh -s /usr/bin/zsh
cat <<'M'
Done. Manual: build dwl (needs wlroots0.19-devel), install fonts not in repo, flatpaks, cargo/npm/pipx tools
(see ~/void-migration.md sections 6-8). Log out/in for groups to apply.
M
