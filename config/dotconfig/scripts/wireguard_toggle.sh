#!/bin/zsh

# If wireguard is running, stop it else start it
if pgrep -x "wg-quick" >/dev/null 2>&1; then
    echo "Wireguard is running. Stopping wireguard..."
    sudo wg-quick down /home/thhel/.config/.secrets/wireguard/sdl85.conf
    echo "Wireguard stopped successfully."
else
    echo "Wireguard is not running. Starting wireguard..."
    sudo wg-quick up /home/thhel/.config/.secrets/wireguard/sdl85.conf
    echo "Wireguard started successfully."
fi
