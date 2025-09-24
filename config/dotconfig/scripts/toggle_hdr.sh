#!/usr/bin/env zsh

# A script to toggle HDR for a specific monitor in Hyprland.
#
# Dependencies:
# - jq: For parsing JSON output from hyprctl.
# - libnotify: For sending desktop notifications (optional but recommended).

# --- Configuration ---
# Set your monitor's description and base configuration here.
# You can get the description from `hyprctl monitors`.
MONITOR_DESC="ASUSTek COMPUTER INC XG32UCWMG T7LMQS113050"
BASE_CONFIG="3840x2160@240.02,auto,1.25"
# ---------------------

# Construct the full monitor string for hyprctl commands
MONITOR_STRING="desc:${MONITOR_DESC},${BASE_CONFIG}"

# Get the current state of all monitors in JSON format.
# We use jq to parse this and find the specific monitor we want to control.
local monitor_info
monitor_info=$(hyprctl monitors -j | jq --arg desc "$MONITOR_DESC" '.[] | select(.description == $desc)')

# Check if the monitor was found. If not, exit with an error.
if [[ -z "$monitor_info" ]]; then
  notify-send -u critical "HDR Toggle Error" "Monitor with description '${MONITOR_DESC}' not found."
  exit 1
fi

# Check if HDR is currently enabled by reading the 'hdr' boolean from the JSON info.
IS_HDR_ON=$(echo "$monitor_info" | jq '.hdr')

echo "Current HDR state for monitor '${MONITOR_DESC}': $IS_HDR_ON"

# Define a path for the state file in the temporary directory.
# This file will store whether HDR is currently 'on' or 'off'.
# The filename is sanitized to be valid.
SANITIZED_DESC=$(echo "$MONITOR_DESC" | tr -c 'a-zA-Z0-9' '_')
STATE_FILE="/tmp/hypr_hdr_state_${SANITIZED_DESC}"

# Check the state file to decide whether to turn HDR on or off.
# If the file exists and its content is "on", it means HDR is currently enabled.
if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "on" ]]; then
  # If HDR is on, turn it off and update the state file.
  hyprctl keyword monitor "${MONITOR_STRING}"
  echo "off" >"$STATE_FILE"
  notify-send "HDR Disabled" "HDR has been turned off." -i display-brightness-off-symbolic
  echo "HDR has been disabled."
else
  # If HDR is off (or the state file doesn't exist), turn it on and update the state file.
  hyprctl keyword monitor "${MONITOR_STRING},bitdepth,10,cm,hdr,sdrbrightness,1.2,sdrsaturation,0.98"
  echo "on" >"$STATE_FILE"
  notify-send "HDR Enabled" "HDR has been turned on." -i display-brightness-high-symbolic
  echo "HDR has been enabled."
fi
