#!/bin/zsh

hyprctl dispatch exec "[silent] google-chrome-stable --new-window https://chatgpt.com/ https://gemini.google.com/ https://grok.com/"

for _ in {1..10}; do
  sleep 1
  hyprctl clients -j \
    | jq -r '.[] | select(.class == "google-chrome" and ((.title // "") | test("ChatGPT|Gemini|Grok"))) | .address' \
    | while read -r address; do
      [[ -n "$address" ]] && hyprctl dispatch movetoworkspacesilent 7, "address:$address"
    done
done
