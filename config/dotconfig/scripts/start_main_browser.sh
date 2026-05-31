#!/bin/zsh

hyprctl dispatch exec "[silent] google-chrome-stable --new-window https://google.com/"

for _ in {1..10}; do
  sleep 1
  hyprctl clients -j \
    | jq -r '.[] | select(.class == "google-chrome" and ((.title // "") | test("^Google - Google Chrome$"))) | .address' \
    | while read -r address; do
      [[ -n "$address" ]] && hyprctl dispatch movetoworkspacesilent 2, "address:$address"
    done
done
