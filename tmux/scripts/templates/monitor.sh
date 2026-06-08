#!/usr/bin/env bash
# monitor.sh — system monitoring session

PWD="$HOME/Developer/"
cd "$PWD"

tmux new-session -d -s monitor -x 220 -y 50
tmux rename-window -t monitor:1 'top'
tmux send-keys -t monitor:1 ' htop' Enter

tmux new-window -t monitor -n 'logs'
tmux send-keys -t monitor:2 ' tail -f /var/log/system.log 2>/dev/null || journalctl -f' Enter

tmux select-window -t monitor:1

tmux attach-session

