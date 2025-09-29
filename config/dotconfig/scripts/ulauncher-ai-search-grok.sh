#!/bin/zsh

# The query passed from Ulauncher
query="$1"

hyprctl dispatch workspace 7

# Open grok in a new tab on correct workspace
zen-browser -new-tab https://grok.com

# Wait for the page to load (adjust sleep if your system/network is slower/faster)
sleep 3

# Small delay to ensure focus and input readiness
sleep 0.5
echo -n "$query" | wl-copy

# Simulate Ctrl+V to paste the query (assumes the chat input is auto-focused)
YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool key 29:1 47:1 47:0 29:0 # LeftCtrl down, V down, V up, LeftCtrl up

# Submit with Enter (keycode 28 is Return/Enter)
YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool key 28:1 28:0


# Requires the ydotool to run as a service of the user
#
# Allow user to access input
# sudo usermod -aG input $USER
#
# Add the rules
# sudo nvim /etc/udev/rules.d/80-uinput.rules
#
# Add the following line:
# KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
#
# Reload udev rules
# sudo udevadm control --reload-rules
# sudo udevadm trigger
#
# Create the service file
# mkdir -p ~/.config/systemd/user
# nano ~/.config/systemd/user/ydotool.service
#
# Add service as follows:
#
# [Unit]
# Description=ydotool Daemon
# 
# [Service]
# Type=simple
# Restart=always
# RestartSec=5
# ExecStart=/usr/bin/ydotoold --socket-path=%h/.ydotool_socket
# 
# [Install]
# WantedBy=default.target
