#!/bin/zsh
#
sleep 2
# Start the main browser on workspace 2
hyprctl dispatch  exec "[silent] zen-browser google.com"
sleep 2
hyprctl dispatch  exec "[silent] zen-browser --new-window https://gemini.google.com"
sleep 2
hyprctl dispatch  exec "[silent] zen-browser https://grok.com"

# Wait one second
sleep 2
# move the grok browser to workspace 7
hyprctl dispatch movetoworkspacesilent 7, "title:^(.*Grok.*)"
sleep 2
hyprctl dispatch movetoworkspacesilent 7, "title:^(.*Gemini.*)"
