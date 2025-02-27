#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Script: edit_daily_note.sh
# Description: Creates and opens a daily note in Obsidian using tmux and neovim
# ------------------------------------------------------------------------------

set -e # Exit immediately if a command exits with non-zero status

# Configuration variables
MAIN_NOTE_DIR="/home/thhel/Documents/Obsidian/Personal/Tomas/daily_notes"
HYPRLAND_WORKSPACE=1

# Log function for better debugging
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Function to check if necessary tools are available
check_dependencies() {
  local missing_deps=()
  
  for cmd in tmux nvim hyprctl; do
    if ! command -v "$cmd" &>/dev/null; then
      missing_deps+=("$cmd")
    fi
  done
  
  if [ ${#missing_deps[@]} -ne 0 ]; then
    log_message "Error: The following required dependencies are missing: ${missing_deps[*]}"
    exit 1
  fi
}

# Function to create directory if it doesn't exist
create_directory() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1" || { log_message "Error: Failed to create directory $1"; exit 1; }
    log_message "Created directory: $1"
  fi
}

# Function to create a new daily note with template
create_daily_note() {
  local file_path="$1"
  
  if [ ! -f "$file_path" ]; then
    cat <<EOF >"$file_path"
# Contents

<!-- toc -->

- [Daily note](#daily-note)

<!-- tocstop -->

## Daily note
EOF
    log_message "Created new daily note: $file_path"
  else
    log_message "Using existing daily note: $file_path"
  fi
}

# Function to manage tmux session
manage_tmux_session() {
  local session_name="$1"
  local note_dir="$2"
  local file_path="$3"
  
  # Check if we're already in tmux
  if [ -z "$TMUX" ]; then
    log_message "Warning: Not running within a tmux session. Some functionalities might not work."
  fi
  
  # Check if session exists
  if ! tmux has-session -t="$session_name" 2>/dev/null; then
    log_message "Creating new tmux session: $session_name"
    tmux new-session -d -s "$session_name" -c "$note_dir" "nvim +norm\\ Go +startinsert $file_path"
  else
    log_message "Session already exists: $session_name"
  fi
  
  # Ensure neovim is running in the session
  if ! tmux list-panes -t "$session_name" -F "#{pane_current_command}" | grep -q "nvim"; then
    log_message "Starting neovim in session"
    tmux send-keys -t "$session_name" "nvim +norm\\ Go +startinsert $file_path" C-m
  fi
  
  # Switch to the session
  tmux switch-client -t "$session_name" || { 
    log_message "Error: Failed to switch to tmux session. Attempting to attach instead."
    tmux attach-session -t "$session_name"
  }
}

# Main execution
main() {
  # Check if required tools are available
  check_dependencies
  
  # Get current date components
  local current_year=$(date +"%Y")
  local current_month_num=$(date +"%m")
  local current_month_abbr=$(date +"%b")
  local current_day=$(date +"%d")
  local current_weekday=$(date +"%A")
  
  # Construct paths and names
  local note_dir="${MAIN_NOTE_DIR}/${current_year}/${current_month_num}-${current_month_abbr}"
  local note_name="${current_year}-${current_month_num}-${current_day}-${current_weekday}"
  local full_path="${note_dir}/${note_name}.md"
  local tmux_session_name="${note_name}"
  
  log_message "Starting daily note process for: $note_name"
  
  # Create directory structure if needed
  create_directory "$note_dir"
  
  # Create daily note if it doesn't exist
  create_daily_note "$full_path"
  
  # Manage tmux session
  manage_tmux_session "$tmux_session_name" "$note_dir" "$full_path"
  
  # Switch hyprland to the workspace with the daily note
  if command -v hyprctl &>/dev/null; then
    hyprctl dispatch workspace $HYPRLAND_WORKSPACE
    log_message "Switched to Hyprland workspace $HYPRLAND_WORKSPACE"
  fi
  
  log_message "Daily note process completed successfully"
}

# Execute the main function
main "$@"
