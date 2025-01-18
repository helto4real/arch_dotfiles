#!/usr/bin/env bash
tmux split-window -hl 30 >/dev/null
tmux select-pane -t :.+ >/dev/null
