#!/usr/bin/env zsh

# A script to toggle the ComfyUI Docker Compose service.
#
# Dependencies:
# - docker-compose: For managing the Docker containers.

# --- Configuration ---
COMPOSE_FILE="/home/thhel/git/comfy_docker/docker-compose.yaml"
COMPOSE_DIR=$(dirname "$COMPOSE_FILE")
# ---------------------

# Change to the compose directory
cd "$COMPOSE_DIR" || { echo "Failed to change to directory $COMPOSE_DIR"; exit 1; }

# Check if the service is running
if docker-compose ps | grep -q "Up"; then
  notify-send "ComfyUI Toggle" "ComfyUI is running. Stopping..."
  docker-compose stop
  notify-send "ComfyUI Toggle" "ComfyUI stopped."
else
  notify-send "ComfyUI Toggle" "ComfyUI is not running. Starting..."
  docker-compose up -d
  notify-send "ComfyUI Toggle" "ComfyUI started."
fi
