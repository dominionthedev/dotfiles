#!/bin/bash
# cpu.sh — CPU usage percentage for tmux status bar
# Reactive: yellow >70%, red >90%

if [[ "$(uname)" == "Darwin" ]]; then
  # macOS: use top for a quick 1-sample CPU read
  pct=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
else
  # Linux: read from /proc/stat
  read cpu user nice sys idle rest < /proc/stat
  total=$((user+nice+sys+idle))
  used=$((total-idle))
  pct=$((used*100/total))
fi

pct=${pct:-0}
# Strip decimal if present
pct=${pct%%.*}

if [ "$pct" -ge 90 ]; then
  echo "#[fg=#{@red},bold]󰻠 ${pct}%#[default]"
elif [ "$pct" -ge 70 ]; then
  echo "#[fg=#{@yellow}]󰻠 ${pct}%"
else
  echo "#[fg=#{@green}]󰻠 ${pct}%"
fi
