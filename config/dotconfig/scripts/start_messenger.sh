#!/bin/zsh

hyprctl dispatch exec "[silent] google-chrome-stable --new-window https://www.messenger.com/"

for _ in {1..10}; do
  sleep 1
  hyprctl clients -j \
    | jq -r '.[] | select((.title // "") | test("Messenger")) | .address' \
    | while read -r address; do
      [[ -n "$address" ]] && hyprctl dispatch movetoworkspacesilent 3, "address:$address"
    done
done
