#!/usr/bin/env bash
# dev.sh — personal dev session template

PWD="$HOME/Developer/"
cd "$PWD"

tmux new-session -d -s dev
tmux rename-window -t dev:1 'edit'
tmux send-keys -t dev:1 'nvim' Enter

tmux new-window -t dev -n 'shell'
tmux new-window -t dev -n 'notes'

tmux send-keys -t dev:3 'nvim vault/jotting.md' Enter

tmux select-window -t dev:1

tmux attach-session

