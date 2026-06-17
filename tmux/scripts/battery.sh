#!/bin/bash
# battery.sh — reactive battery indicator for tmux status bar
# Shows icon + percentage, turns red when ≤ 20%

info=$(pmset -g batt 2>/dev/null)
pct=$(echo "$info" | grep -o '[0-9]*%' | head -1 | tr -d '%')
charging=$(echo "$info" | grep -q 'AC Power' && echo "yes" || echo "no")

# No battery (desktop) — show nothing
[ -z "$pct" ] && exit 0

# Choose icon
if [ "$charging" = "yes" ]; then
  icon="󰂄"
elif [ "$pct" -ge 90 ]; then
  icon="󰁹"
elif [ "$pct" -ge 75 ]; then
  icon="󰂁"
elif [ "$pct" -ge 50 ]; then
  icon="󰁾"
elif [ "$pct" -ge 25 ]; then
  icon="󰁻"
else
  icon="󰁺"
fi

# Reactive colour — red when ≤ 10%, yellow when ≤ 50%
if [ "$pct" -le 10 ] && [ "$charging" != "yes" ]; then
  echo "#[fg=#{@red}]#[bg=#{@red},fg=#{@base}]${icon} #[fg=#{@red},bg=#{@surface0},bold] ${pct}%#[default]"
elif [ "$pct" -le 50 ] && [ "$charging" != "yes" ]; then
  echo "#[fg=#{@yellow}]#[bg=#{@yellow},fg=#{@base}]${icon} #[fg=#{@yellow},bg=#{@surface0}] ${pct}%"
else
  echo "#[fg=#{@sapphire}]#[bg=#{@sapphire},fg=#{@base}]${icon} #[fg=#{@sapphire},bg=#{@surface0}] ${pct}%"
fi
