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
log_message() {
    local label=$1
    local message=$2
    echo -e "\e[32m$label\e[0m: $message"
}

log_message "INfO" "Cloning dotfiles repository"
git clone https://github.com/helto4real/arch_dotfiles.git ~/.dotfiles

cd ~/.dotfiles
clear
source ./install.sh
