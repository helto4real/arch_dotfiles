#!/bin/zsh

if [ -z "$TMUX" ]; then
  # Not in tmux
  if ! tmux has-session -t main 2>/dev/null; then
    tmux new-session -d -s main
  fi
  tmux attach-session -t main
else
  # In tmux
  if ! tmux has-session -t main 2>/dev/null; then
    tmux new-session -d -s main
  fi
  tmux switch-client -t main
fi
