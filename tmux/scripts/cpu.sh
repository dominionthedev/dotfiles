#!/bin/bash
# cpu.sh — CPU usage percentage for tmux status bar
# Reactive: yellow >70%, red >90%

pct=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%')

pct=${pct:-0}
# Strip decimal if present
pct=${pct%%.*}

if [ "$pct" -ge 90 ]; then
  echo "#[fg=#{@red}]#[bg=#{@red},fg=#{@base}]󰻠 #[bg=#{@surface0},fg=#{@red},bold] ${pct}%"
elif [ "$pct" -ge 70 ]; then
  echo "#[fg=#{@yellow}]#[bg=#{@yellow},fg=#{@base}]󰻠 #[bg=#{@surface0},fg=#{@yellow}] ${pct}%"
else
  echo "#[fg=#{@sky}]#[bg=#{@sky},fg=#{@base}]󰻠 #[bg=#{@surface0},fg=#{@sky}] ${pct}%"
fi
