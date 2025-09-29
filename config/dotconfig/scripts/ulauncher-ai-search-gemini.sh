#!/bin/zsh

# The query passed from Ulauncher
query="$1"

hyprctl dispatch workspace 7

# Open in a new window (adjust browser if not Firefox; e.g., google-chrome --new-window). This should auto-focus the new window on Hyprland.
zen-browser -new-tab https://gemini.google.com

# Wait for the page to load (adjust sleep if your system/network is slower/faster)
sleep 3

# Small delay to ensure focus and input readiness
sleep 0.5
echo -n "$query" | wl-copy

# Simulate Ctrl+V to paste the query (assumes the chat input is auto-focused)
YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool key 29:1 47:1 47:0 29:0 # LeftCtrl down, V down, V up, LeftCtrl up

# Type the query using ydotool (assumes the chat input is auto-focused, which it typically is in such apps)
# YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool type --key-delay 50 "$query"

# Submit with Enter (keycode 28 is Return/Enter)
YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool key 28:1 28:0
