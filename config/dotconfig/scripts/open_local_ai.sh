#!/bin/zsh

# Start ollama if not allready running
source ~/.config/scripts/start_ollama.sh

aichat "$@"
