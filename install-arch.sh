#!/bin/bash
set -e

# --- CONFIGURATION ---
DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/install_log.txt"

# Folders to be stowed
STOW_FOLDERS="btop cava dunst environment foot fuzzel gtk joshuto kanshi kitty lazygit lf nnn nwg obs-studio onlyoffice pi qt qutebrowser rofi scripts starship sway swaylock tmux wal wpg zathura zellij zen-browser zsh"

# 1. Official Arch Packages
NATIVE_PKGS="7zip adobe-source-code-pro-fonts alsa-utils amd-ucode base base-devel bat bc blackarch-mirrorlist blackarch-officials blueman bluez bluez-qt bluez-utils breeze-gtk breeze-plus brightnessctl btop chafa cliphist cmake cppdap cups cups-pdf deno direnv discord docker dosfstools dunst edk2-ovmf efibootmgr eza fastfetch fcft fd ffmpegthumbnailer flatpak foomatic-db-engine foomatic-db-nonfree foomatic-db-ppds foot fuzzel fzf gammastep gdb geoclue git git-delta github-cli glow go go-yq gobject-introspection greetd greetd-tuigreet grim grub gst-plugin-pipewire gutenprint gvfs gvfs-mtp htop iwd jq k9s kanshi kgamma kitty kitty-shell-integration kitty-terminfo kvantum kvantum-qt5 lazygit leptonica lf libdbusmenu-qt5 libportal libportal-gtk4 libpulse librsync libspng libvirt linux linux-firmware linux-zen linux-zen-headers loupe man-db man-pages mpv mtools nano navi ncdu neovim network-manager-applet networkmanager-openconnect nmap nnn noto-fonts noto-fonts-cjk noto-fonts-emoji npm nwg-displays nwg-look obs-studio onlyoffice-bin openconnect openssh-askpass os-prober otf-font-awesome pacman-contrib papirus-icon-theme pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse power-profiles-daemon psmisc python-markdown python-pip python-pipx python-poetry python-pyquery python-requests python-toml qemu-desktop qt5-declarative qt5-graphicaleffects qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-speech qt5-wayland qt5ct qt6ct qutebrowser rhash rust slurp smartmontools sof-firmware spotify-launcher starship stow swappy sway swaybg swayidle swaylock system-config-printer tailscale tealdeer tesseract tesseract-data-eng tesseract-data-osd thunar timeshift tmux translate-shell ttf-fira-code ttf-jetbrains-mono-nerd ttf-victor-mono ufw umockdev unrar unzip uv uwsm vim virt-manager vulkan-radeon wev wf-recorder wireless_tools wireplumber wl-clipboard wlr-randr wmenu wtype xclip xdg-utils xf86-video-amdgpu xf86-video-ati xorg-xinit ydotool zellij zoxide zram-generator zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting"

# 2. AUR Packages
AUR_PKGS="bibata-cursor-theme bitwarden-cli breeze-plus darkly-bin dragon-drop epson-inkjet-printer-escpr input-remapper-git joshuto-bin neovim-remote onedriver ookla-speedtest-bin otf-space-grotesk python-pywal16 python-pywalfox timeshift-autosnap ttf-gabarito-git ttf-material-symbols-variable-git ttf-readex-pro ttf-roboto-flex ttf-rubik-vf wlogout yay-bin zathura-git zathura-pdf-mupdf-git zen-browser-bin"

echo "### Arch Dotfiles Installer ###" | tee -a "$LOG_FILE"

# 1. Update System
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git base-devel stow

# 2. Install Yay
if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm && cd - && rm -rf /tmp/yay-bin
fi

# 3. Install All Packages
sudo pacman -S --needed --noconfirm $NATIVE_PKGS
yay -S --needed --noconfirm $AUR_PKGS

# 4. Stow Dotfiles
echo "-> Stowing Dotfiles..."
mkdir -p "$HOME/.config"
cd "$DOTFILES_DIR"

for folder in $STOW_FOLDERS; do
    echo "   Processing $folder..."

    # Backup existing non-link configs to avoid Stow conflicts
    case "$folder" in
        gtk)
            for d in gtk-3.0 gtk-4.0; do
                [ -e "$HOME/.config/$d" ] && [ ! -L "$HOME/.config/$d" ] && mv "$HOME/.config/$d" "$HOME/.config/${d}.bak"
            done
            ;;
        nwg)
            for d in nwg-displays nwg-look; do
                [ -e "$HOME/.config/$d" ] && [ ! -L "$HOME/.config/$d" ] && mv "$HOME/.config/$d" "$HOME/.config/${d}.bak"
            done
            ;;
        qt)
            for d in qt5ct qt6ct; do
                [ -e "$HOME/.config/$d" ] && [ ! -L "$HOME/.config/$d" ] && mv "$HOME/.config/$d" "$HOME/.config/${d}.bak"
            done
            ;;
        starship)
            [ -e "$HOME/.config/starship.toml" ] && [ ! -L "$HOME/.config/starship.toml" ] && mv "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak"
            ;;
        pi)
            [ -e "$HOME/.pi/agent" ] && [ ! -L "$HOME/.pi/agent" ] && mv "$HOME/.pi/agent" "$HOME/.pi/agent.bak"
            ;;
        environment)
            [ -e "$HOME/.config/environment.d" ] && [ ! -L "$HOME/.config/environment.d" ] && mv "$HOME/.config/environment.d" "$HOME/.config/environment.d.bak"
            ;;
        zsh)
            [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
            [ -e "$HOME/.zshenv" ] && [ ! -L "$HOME/.zshenv" ] && mv "$HOME/.zshenv" "$HOME/.zshenv.bak"
            [ -e "$HOME/.config/zshrc.d" ] && [ ! -L "$HOME/.config/zshrc.d" ] && mv "$HOME/.config/zshrc.d" "$HOME/.config/zshrc.d.bak"
            ;;
        scripts)
            [ -e "$HOME/.scripts" ] && [ ! -L "$HOME/.scripts" ] && mv "$HOME/.scripts" "$HOME/.scripts.bak"
            ;;
        *)
            [ -e "$HOME/.config/$folder" ] && [ ! -L "$HOME/.config/$folder" ] && mv "$HOME/.config/$folder" "$HOME/.config/${folder}.bak"
            ;;
    esac

    stow -v $folder
done

# 5. Finalize
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
fi

echo "### DONE! Please reboot. ###"
