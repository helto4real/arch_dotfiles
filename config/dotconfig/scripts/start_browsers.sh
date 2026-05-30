#!/bin/zsh
#
sleep 2
# Start the main browser on workspace 2
hyprctl dispatch  exec "[silent] google-chrome-stable google.com"
sleep 2
/home/thhel/.config/scripts/start_ai.sh
sleep 2
/home/thhel/.config/scripts/start_messenger.sh
