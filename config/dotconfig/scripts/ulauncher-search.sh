#!/bin/sh
query=$(echo "$1" | sed 's/ /%20/g' | sed 's/"/%22/g' | sed "s/'/%27/g")

url="https://www.google.com/search?q=$query"

# First we focus on the correct workspace
hyprctl dispatch workspace 2
# launch zen-browser with a new tab using the url
zen-browser --new-tab "$url"
