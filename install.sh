#!/bin/bash

########################################################
#
# Setup script for Arch Linux with Nvidia drivers
# This script will configure a Hyprland configuration with nvidia drivers for modern cards, change the script according to your setup
#
# Prerequisites:
#   1. Refresh keys if needed and delete using fdisk all current partitions on disk if existing
#   2. Install arch linux using the archinstall with the following settings
#       1. Language: Your choice
#       2. Disk: Manual, use recommended and dbrfs
#       3. Mirrors: Closest to your location
#       4. Boot: grub
#       5. Profile: Minimal
#       6. Audio: Pipewire
#       7. Network: NetworkManager
#       8. Additional packages: git, vim, wget
#   3. run wget https://raw.githubusercontent.com/helto4real/arch_dotfiles/main/setup.sh
#   4. run the downloaded script: wget https://raw.githubusercontent.com/helto4real/arch_dotfiles/main/setup.sh && bash setup.sh
#
#######################################################

## Functions
# log message where it takes two argumetns, one is the label that will be written logged in green text and the text that will be written in white
_log_message() {
    local label=$1
    local message=$2
    echo -e "\n\e[32m$label:\e[0m $message"
}

# Check if package is installed
_isInstalled() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}
# Check if package is installed
_isYayInstalled() {
    package="$1";
    check="$(sudo yay -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Check if command exists
_checkCommandExists() {
    package="$1";
	if ! command -v $package > /dev/null; then
        return 1
    else
        return 0
    fi
}

# Install required packages
_installPackages() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            _log_message ":::" "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]]; then
        return;
    fi;
    _log_message "INFO" "Installing the packages (${toInstall[@]})";
    sudo pacman --needed --noconfirm -S "${toInstall[@]}";
}

_installYayPackages() {
    toInstall=();
    for pkg; do
        if [[ $(_isYayInstalled "${pkg}") == 0 ]]; then
            _log_message ":::" "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]]; then
        return;
    fi;
    _log_message "INFO" "Installing the packages with yay (${toInstall[@]})";
    yay --needed --noconfirm -S "${toInstall[@]}";
}

# install yay if needed
_installYay() {
    # Install yay if needed
    if _checkCommandExists "yay"; then
        _log_message ":::" "Yay is already installed"
        return;
    fi

    _log_message ":::" "The installer requires yay. yay will be installed now"

    SCRIPT=$(realpath "$0")
    temp_path=$(dirname "$SCRIPT")
    git clone https://aur.archlinux.org/yay.git ~/Downloads/yay
    cd ~/Downloads/yay
    makepkg -si
    cd $temp_path

    # remove comment multilib in the file /etc/pacman.conf if exists
    sudo sed -i '/#\[multilib\]/s/^#//' /etc/pacman.conf
    sudo sed -i '/\[multilib\]/{n;s/^#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf
    yay -Syu
    _log_message "INFO" "yay has been installed successfully."
}

_install_hyprland() {

    # Install hyprland if needed
    if _checkCommandExists "hyprland --help"; then
        _log_message ":::" "hyprland is already installed"
        return;
    fi

    _log_message "INFO" "Stowing the hyprland dotfiles"
    stow hyprland

    _log_message "INFO" "Installing Hyprland packages"
    packages=(
        "hyprland"
        "hyprpaper"
        "hyprlock"
        "hypridle"
        "grim"
        "slurp"
        "xdg-desktop-portal-hyprland" 
        "libnotify" 
        "dunst"
        "waybar"
        "hyprland-qtutils"
        "qt5-wayland" 
        "qt6-wayland"
    );
    _installPackages "${packages[@]}";
}

_install_desktop_utilities() {

    _log_message "INFO" "Installing desktop utilities"
    packages=(
        "thunar"
        "thunar-volman"
        "thunar-archive-plugin"
        "gvfs"
        "ark"
    );
    _installYayPackages "${packages[@]}";
}

_install_fonts() {

    _log_message "INFO" "Installing fonts"
    packages=(
        "ttf-iosevka-nerd"
        "ttf-meslo-nerd"
        "ttf-noto-nerd"
        "ttf-noto-emoji"
        "ttf-noto-cjk"
    );
    _installYayPackages "${packages[@]}";
}

# _install_nvidia_drivers() {
#     _log_message "INFO" "Installing nvidia drivers"
#     packages=(
#         "nvidia-470xx-dkms"
#         "nvidia-utils"
#         "lib32-nvidia-utils"
#     );
#     _installYayPackages "${packages[@]}";
# }

_install_bash_config() {

    _log_message "INFO" "Installing oh-my-bash"
    rm -r ~/.oh-my-bash
    bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)" --unattended
    # stow oh-my-bash
    _installYayPackages oh-my-bash-git
    _log_message "INFO" "Installing oh-my-bash theme"
    mkdir -p $HOME/.oh-my-bash/themes/axin
    # copy the theme to the themes directory
    cp -f ~/.dotfiles/files/oh-my-bash/themes/axin.theme.sh $HOME/.oh-my-bash/themes/axin/axin.theme.sh
    
    _log_message "INFO" "Stowing bash"
    rm ~/.bashrc
    stow bash
}

_install_essensial_utilities() {

    _log_message "INFO" "Stowing essential utilities"
    stow ghostty

    _log_message "INFO" "Installing essential utilities"
    packages=(
        "jq"
        "fzf"
        "ripgrep"
        "fd"
        "eza"
        "zoxide"
        "xclip"
        "ghostty"
        "pavucontrol"
        "toilet"
        "imagemagick"
        "ffmpeg"
        "wl-clipboard"
        "luarocks"
        "lua51"
    );
    
    _installYayPackages "${packages[@]}";
}

_install_dev_tools() {

    _log_message "INFO" "Stowing devtools"
    stow bat
    stow ghostty
    stow nvim
    stow tmux
    stow lazygit
    stow bpytop

    _log_message "INFO" "Installing dev tools"
    packages=(
        "neovim"
        "tmux"
        "rustup"
        "nodejs"
        "npm"
        "bat"
        "sesh"
        "docker"
        "go"
        "python"
        "python-pip"
        "python-pynvim"
        "python-pipenv"
        "ansible"
        "github-cli"
        "bpytop"
        "lazygit"
        "dotnet-sdk-9.0"
        "dotnet-runtime-8.0"
    );
    
    _installYayPackages "${packages[@]}";

    _log_message "INFO" "Installing rust"
    rustup default stable
}

# Add Yubikey support, rermember to stow config
_install_yubikey() {

    _log_message "INFO" "Installing Yubikey support"

    packages=(
        "yuibikey-personalization-gui"
        "pcsc-tools"
        # "libu2f-host"
        "yubikey-manager"
    );
    
    _installYayPackages "${packages[@]}";
}

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Main 
echo -e -"${GREEN}"
cat <<"EOF"

                          $$\   $$\ $$$$$$$$\ $$\   $$$$$$$$\  $$$$$$\                          
                          $$ |  $$ |$$  _____|$$ |  \__$$  __|$$  __$$\                         
                          $$ |  $$ |$$ |      $$ |     $$ |   $$ /  $$ |                        
                          $$$$$$$$ |$$$$$\    $$ |     $$ |   $$ |  $$ |                        
                          $$  __$$ |$$  __|   $$ |     $$ |   $$ |  $$ |                        
                          $$ |  $$ |$$ |      $$ |     $$ |   $$ |  $$ |                        
                          $$ |  $$ |$$$$$$$$\ $$$$$$$$\$$ |    $$$$$$  |                        
                          \__|  \__|\________|\________\__|    \______/                         
 $$$$$$\                      $$\             $$\                      $$\              $$\ $$\ 
$$  __$$\                     $$ |            \__|                     $$ |             $$ |$$ |
$$ /  $$ | $$$$$$\   $$$$$$$\ $$$$$$$\        $$\ $$$$$$$\   $$$$$$$\$$$$$$\   $$$$$$\  $$ |$$ |
$$$$$$$$ |$$  __$$\ $$  _____|$$  __$$\       $$ |$$  __$$\ $$  _____\_$$  _|  \____$$\ $$ |$$ |
$$  __$$ |$$ |  \__|$$ /      $$ |  $$ |      $$ |$$ |  $$ |\$$$$$$\   $$ |    $$$$$$$ |$$ |$$ |
$$ |  $$ |$$ |      $$ |      $$ |  $$ |      $$ |$$ |  $$ | \____$$\  $$ |$$\$$  __$$ |$$ |$$ |
$$ |  $$ |$$ |      \$$$$$$$\ $$ |  $$ |      $$ |$$ |  $$ |$$$$$$$  | \$$$$  \$$$$$$$ |$$ |$$ |
\__|  \__|\__|       \_______|\__|  \__|      \__|\__|  \__|\_______/   \____/ \_______|\__|\__|
                                                                                                
EOF
echo "helto4real Dotfiles for Hyprland"
echo -e "${NONE}"
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            _log_message "INFO" "Starting installation"
        break;;
        [Nn]* ) 
            _log_message "INFO" "Exiting installation"
            exit;
        break;;
        * ) 
            _log_message "ERROR" "Please answer yes or no."
        ;;
    esac
done

_log_message "INFO" "Syncronizing package databases"
sudo pacman -Sy

_log_message "INFO" "Installing essensial packages"

essensial_packages=(
    "ntfs-3g"
    "stow"
    "fastfetch"
    "usbutils"
    "base-devel"
    "linux-headers"
)


_installPackages "${essensial_packages[@]}";

_installYay
_install_hyprland
_install_desktop_utilities
_install_fonts
_install_essensial_utilities
_install_dev_tools
_install_yubikey
_install_bash_config
