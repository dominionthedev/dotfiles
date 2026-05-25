#!/usr/bin/env tmux source-file
# Run: tmux source-file $TERMBOX_HOME/config/tmux/templates/monitor.tmux

new-session -d -s monitor -x 220 -y 50
rename-window -t monitor:0 'top'
send-keys -t monitor:0 'htop' Enter

new-window -t monitor -n 'logs'
send-keys -t monitor:1 'tail -f /var/log/system.log 2>/dev/null || journalctl -f' Enter

new-window -t monitor -n 'disk'
send-keys -t monitor:2 'watch -n5 df -h' Enter

select-window -t monitor:0
