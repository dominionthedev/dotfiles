#!/bin/bash
# temp.sh — reactive temperature indicator for tmux status bar
# Shows icon + temp, turns red when ≥ 80°C, yellow when ≥ 60°C

raw=$(temp 2>/dev/null)
# Extract the integer part for bash comparisons (e.g., "63" from "63.0°C")
t_int=$(echo "$raw" | grep -Eo '[0-9]+' | head -1)
raw="${t_int}°C"

# No temp data — show nothing
[ -z "$t_int" ] && exit 0

# Choose icon (Nerd Font Thermometers)
if [ "$t_int" -ge 85 ]; then
  icon=""
elif [ "$t_int" -ge 70 ]; then
  icon=""
elif [ "$t_int" -ge 50 ]; then
  icon=""
elif [ "$t_int" -ge 40 ]; then
  icon=""
else
  icon=""
fi

# Reactive colour — red when ≥ 80, yellow when ≥ 60, cyan otherwise
if [ "$t_int" -ge 80 ]; then
  echo "#[fg=#{@red}]#[bg=#{@red},fg=#{@base}]${icon} #[fg=#{@red},bg=#{@surface0},bold] ${raw}"
elif [ "$t_int" -ge 60 ]; then
  echo "#[fg=#{@yellow}]#[bg=#{@yellow},fg=#{@base}]${icon} #[fg=#{@yellow},bg=#{@surface0}] ${raw}"
else
  echo "#[fg=#{@cyan}]#[bg=#{@cyan},fg=#{@base}]${icon} #[fg=#{@cyan},bg=#{@surface0}] ${raw}"
fi
