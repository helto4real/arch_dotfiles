#!/bin/zsh

# Function to check if ollama is running
check_ollama() {
    # Check if there is any process with "ollama" in the name
    pgrep -x "ollama" >/dev/null 2>&1
    return $?
}

# Main script execution
if check_ollama; then
   # echo "Ollama is already running."
else
    echo "Ollama is not running. Starting ollama serve..."
    # Start ollama serve in the background and disown the process
    nohup ollama serve >/dev/null 2>&1 &
    disown
    echo "Ollama serve started successfully."
fi
