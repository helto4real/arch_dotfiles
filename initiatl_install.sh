# Post install steps
# Upgrade all packages
sudo packman -Syu
# Install some basic packages
sudp pacman -Sy intel-ucode wget ntfs-3g neofetch lsusb usbutils

# Desktop environment
# This is the gnome/i3 combination
sudo pacman -Sy --noconfirm xorg xinit i3 picom gnome dmenu rofi polybar gnome-tweaks feh flameshot

# First install yay, google it
# Update system with

# 1. First install yay package manager
sudo pacman -S --needed git base-devel linux-headers nano
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install nvidia drivers, see https://github.com/korvahannu/arch-nvidia-drivers-installation-guide
#Enable multilib repository
sudo nano /etc/pacman.conf
# Uncomment the following lines by removing the # -character at the start them
#        [multilib]
#        Include = /etc/pacman.d/mirrorlist
# Save the file with CTRL+S and close nano with CTRL+X
# Run yay -Syu, to update the system package databasep
yay -Syu
yay -S nvidia-470xx-dkms nvidia-utils lib32-nvidia-utils

# Done installing nvidia drivers

# Fonts
yay -Sy --noconfirm ttf-iosevka-nerd ttf-meslo-nerd ttf-noto-nerd noto-fonts-emoji noto-fonts-cjk 
# Essential general packages for the os and utilities
yay -Sy --noconfirm jq stow fzf ripgrep fd eza zoxide xclip firefox alacritty ghostty pavucontrol toilet imagemagick ffmpeg
# Essential programming packages
yay -Sy --noconfirm neovim tmux rustup nodejs npm bat sesh docker go python python-pip python-pynvim python-pipenv ansible github-cli bpytop lazygit
rustup default stable
yay -Sy --noconfirm dotnet-sdk-9.0 dotnet-runtime-8.0

yay -Sy --noconfirm yubikey-personalization-gui pcsc-tools libu2f-host yubikey-manager

yay -Sy also-scarlet-gui

# Clone dotfiles

git clone https://github.com/helto4real/arch_dotfiles.git ~/.dotfiles

# oh-my-bash
source ~/.dotfiles/files/oh-my-bash/oh-my-bash.sh
yay -Sy --noconfirm oh-my-bash-git

# Apps, discord, facebook messenger (caprine)
yay -Sy --noconfirm discord caprine obsidian 1password

# set ip address
# nmcli con mod "Wired connection 1" ipv4.addresses "[ip]/24"
# nmcli con mod "Wired connection 1" ipv4.gateway "[ip]"
# nmcli con mod "Wired connection 1" ipv4.dns "[ip]"
# nmcli con mod "Wired connection 1" ipv4.method "manual"
# nmcli con up "Wired connection 1"

# Decrypt and add fstab file from this repo
# Decrypt and add the pasword files in ~/
# run sudo mount -a to mount the drives

# Import gpg public key to make signing with yubikey possible
# gpg --armor --import /mnt/win-d/key.pub




