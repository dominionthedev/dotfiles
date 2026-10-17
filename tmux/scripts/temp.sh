#!/bin/bash
# temp.sh — reactive temperature indicator for tmux status bar
# Shows icon + temp, turns red when ≥ 80°C, yellow when ≥ 60°C
raw=$(osx-cpu-temp)

# Extract the integer part for bash comparisons (e.g., "63" from "63.0°C")
t_int=$(echo "$raw" | grep -Eo '[0-9]+' | head -1)

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

if [ "$t_int" -ge 80 ]; then
  echo "#[fg=#{@thm_red},bold]${icon} ${raw}#[none]"
elif [ "$t_int" -ge 60 ]; then
  echo "#[fg=#{@thm_yellow}]${icon} ${raw}"
else
  echo "#[fg=#{@thm_teal}]${icon} ${raw}"
fi
