#!/bin/bash
set -e

# --- CONFIGURATION ---
DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/install_log.txt"

# Folders to be stowed
STOW_FOLDERS="btop dunst hypr kitty nvim rofi waybar wofi gtk thunar yazi wal wpg zsh kanshi zellij scripts qt lazygit cava nwg onlyoffice obs-studio zathura zen-browser qutebrowser qt5ct"

# 1. Official Arch Packages
NATIVE_PKGS="7zip adobe-source-code-pro-fonts adobe-source-han-sans-jp-fonts adobe-source-han-serif-jp-fonts alsa-utils amd-ucode baloo-widgets base base-devel bat bc blackarch-mirrorlist blackarch-officials bluedevil blueman bluez bluez-qt bluez-utils breeze-gtk breeze-plus breeze-plymouth brightnessctl btop caligula cliphist cmake cppdap cups cups-pdf deno direnv discord discover dnsmasq dolphin dosfstools drkonqi dunst edk2-ovmf efibootmgr eza fastfetch fcft fd ffmpegthumbnailer firefox fish flatpak flatpak-kcm foomatic-db-engine foomatic-db-nonfree foomatic-db-ppds frameworkintegration5 fuzzel fzf gammastep gdb geoclue git git-delta github-cli glow gnome-system-monitor go gobject-introspection go-yq greetd greetd-tuigreet grub gst-plugin-pipewire gutenprint gvfs gvfs-mtp htop hyprcursor hyprgraphics hypridle hyprland hyprland-guiutils hyprland-qt-support hyprlang hyprlock hyprpaper hyprpicker hyprpolkitagent hyprshot hyprutils hyprwayland-scanner inxi iwd k9s kanshi karchive5 kauth5 kbookmarks5 kcmutils5 kcodecs5 kcompletion5 kconfig5 kconfigwidgets5 kcoreaddons5 kcrash5 kdbusaddons5 kdeclarative5 kded5 kde-gtk-config kdeplasma-addons kgamma kglobalaccel5 kguiaddons5 ki18n5 kiconthemes5 kinfocenter kio5 kirigami2 kitemviews5 kitty kitty-shell-integration kitty-terminfo kjobwidgets5 kmenuedit knotifications5 kpackage5 krdp kscreen kservice5 ksshaskpass ktextwidgets5 kvantum kvantum-qt5 kwallet5 kwallet-pam kwidgetsaddons5 kwindowsystem5 kwin-x11 kwrited kxmlgui5 lazygit leptonica libdbusmenu-qt5 libportal libportal-gtk4 libpulse librsync libspng libvirt linux linux-firmware linux-zen linux-zen-headers loupe lsd ly man-db man-pages mercurial mtools myrepos nano navi ncdu nemo nemo-fileroller neovim network-manager-applet networkmanager-openconnect nmap noto-fonts noto-fonts-cjk noto-fonts-emoji npm nwg-displays nwg-look onlyoffice-bin openconnect openssh-askpass os-prober otf-font-awesome otf-ipafont oxygen oxygen-sounds pacman-contrib pamixer pandoc-cli papirus-icon-theme pavucontrol pavucontrol-qt pipewire pipewire-alsa pipewire-jack plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-pa plasma-sdk plasma-systemmonitor plasma-thunderbolt plasma-vault plasma-welcome plasma-workspace-wallpapers plymouth-kcm polkit-qt5 powerdevil power-profiles-daemon print-manager python-markdown python-pip python-pipx python-poetry python-pyquery python-requests python-toml qemu-desktop qt5ct qt5-declarative qt5-graphicaleffects qt5-multimedia qt5-quickcontrols qt5-quickcontrols2 qt5-speech qt5-wayland qt6ct quickshell rhash rocm-opencl-runtime sddm sddm-kcm smartmontools sof-firmware solid5 songrec sonnet5 spectacle spotify-launcher starship stow swappy swaybg swww system-config-printer tailscale tealdeer tesseract tesseract-data-eng tesseract-data-osd thefuck timeshift translate-shell ttf-droid ttf-fantasque-nerd ttf-fira-code ttf-hanazono ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-victor-mono ufw umockdev unrar unzip uv uwsm vim virt-manager vulkan-radeon wacomtablet waybar wev wf-recorder wireless_tools wl-clipboard wlr-randr wofi wtype xclip xdg-desktop-portal-hyprland xdg-utils xf86-video-amdgpu xf86-video-ati xorg-server xorg-xinit yad yazi ydotool zellij zoxide zram-generator zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting python-toml qemu-desktop qutebrowser qt5ct"

# 2. AUR Packages
AUR_PKGS="adw-gtk-theme-git ani-cli arduino-ide-bin bibata-cursor-theme breeze-plus darkly-bin dragon-drop epson-inkjet-printer-escpr flat-remix-gtk grimblast-git illogical-impulse-microtex-git input-remapper-git jetbrains-toolbox matugen-bin neovim-remote onedriver ookla-speedtest-bin otf-space-grotesk python-pywal16 slack-desktop timeshift-autosnap ttf-gabarito-git ttf-material-symbols-variable-git ttf-readex-pro ttf-roboto-flex ttf-rubik-vf ttf-twemoji tuxagotchi wdisplays wlogout wpgtk yay-bin zen-browser-bin onedriver-debug"

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
cd "$DOTFILES_DIR"

for folder in $STOW_FOLDERS; do
    echo "   Processing $folder..."

    # Backup existing non-link configs to avoid Stow conflicts

    # Check ~/.config/folder
    if [ -d "$HOME/.config/$folder" ] && [ ! -L "$HOME/.config/$folder" ]; then
        mv "$HOME/.config/$folder" "$HOME/.config/${folder}.bak"
    fi

    # Special Check for Zsh
    if [ "$folder" == "zsh" ] && [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    fi

    # Special Check for Scripts
    if [ "$folder" == "scripts" ] && [ -d "$HOME/.scripts" ] && [ ! -L "$HOME/.scripts" ]; then
        mv "$HOME/.scripts" "$HOME/.scripts.bak"
    fi

    stow -v $folder
done

# 5. Finalize
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
fi

echo "### DONE! Please reboot. ###"
