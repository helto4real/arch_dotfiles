#!/bin/zsh
#
sleep 1
# Start the main browser on workspace 2
hyprctl dispatch  exec "[silent] zen-browser google.com"
sleep 1
hyprctl dispatch  exec "[silent] zen-browser --new-window https://grok.com"

# Wait one second
sleep 1
# move the grok browser to workspace 7
hyprctl dispatch movetoworkspacesilent 7, "title:^(.*Grok.*)"
