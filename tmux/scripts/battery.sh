#!/bin/bash
# battery.sh — reactive battery indicator for tmux status bar
# Shows icon + percentage, turns red when ≤ 20%

get_battery_macos() {
  local info pct charging
  info=$(pmset -g batt 2>/dev/null)
  pct=$(echo "$info" | grep -o '[0-9]*%' | head -1 | tr -d '%')
  charging=$(echo "$info" | grep -q 'AC Power' && echo "yes" || echo "no")
  echo "$pct $charging"
}

get_battery_linux() {
  local bat_dir pct status
  bat_dir=$(ls /sys/class/power_supply/BAT* 2>/dev/null | head -1)
  if [ -n "$bat_dir" ]; then
    pct=$(cat "$bat_dir/capacity" 2>/dev/null)
    status=$(cat "$bat_dir/status" 2>/dev/null)
    charging=$([ "$status" = "Charging" ] && echo "yes" || echo "no")
    echo "$pct $charging"
  fi
}

# Get battery info
if [[ "$(uname)" == "Darwin" ]]; then
  read pct charging <<< $(get_battery_macos)
else
  read pct charging <<< $(get_battery_linux)
fi

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

# Reactive colour — red when ≤ 20%, yellow when ≤ 40%
if [ "$pct" -le 20 ] && [ "$charging" != "yes" ]; then
  echo "#[fg=#f38ba8,bold]${icon} ${pct}%#[default]"
elif [ "$pct" -le 40 ] && [ "$charging" != "yes" ]; then
  echo "#[fg=#f9e2af]${icon} ${pct}%#[default]"
else
  echo "#[fg=#a6e3a1]${icon} ${pct}%#[default]"
fi
