#!/bin/zsh

# File to store the previous workspace number
PREV_WS_FILE="$HOME/.cache/prev_workspace"

# Get current workspace from Hyprland using hyprctl with error handling
current_workspace=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null)

# Check if we got a valid workspace number
if [[ -z "$current_workspace" || ! "$current_workspace" =~ ^[0-9]+$ ]]; then
    notify-send "Workspace Toggle" "Error: Could not determine current workspace" -t 2000
    exit 1
fi

# Check if we're currently on workspace 7
if [[ "$current_workspace" -eq 7 ]]; then
    # If we're on workspace 7, go to the previously saved workspace
    if [[ -f "$PREV_WS_FILE" ]]; then
        prev_workspace=$(cat "$PREV_WS_FILE")
        # Only switch if previous workspace was saved and is not 7
        if [[ -n "$prev_workspace" && "$prev_workspace" -ne 7 ]]; then
            hyprctl dispatch workspace "$prev_workspace"
        else
            # Fallback to workspace 1 if no valid previous workspace
            hyprctl dispatch workspace 1
        fi
    else
        # If no previous workspace saved, default to workspace 1
        hyprctl dispatch workspace 1
    fi
else
    # If we're not on workspace 7, save current workspace and switch to 7
    echo "$current_workspace" > "$PREV_WS_FILE"
    hyprctl dispatch workspace 7
fi

