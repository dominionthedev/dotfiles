#!/usr/bin/env tmux source-file
# Run: tmux source-file $TERMBOX_HOME/config/tmux/templates/dev.tmux

new-session -d -s dev
rename-window -t dev:0 'edit'
send-keys -t dev:0 'nvim .' Enter

new-window -t dev -n 'shell'
new-window -t dev -n 'git'
send-keys -t dev:2 'git log --oneline -20' Enter

select-window -t dev:0
