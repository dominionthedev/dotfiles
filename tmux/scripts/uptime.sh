#!/bin/bash
# uptime.sh — macOS uptime for the status bar: HH:MM, or "Nd HH:MM" once past a day.
boot=$(sysctl -n kern.boottime | sed -E 's/^\{ sec = ([0-9]+),.*/\1/')
[ -z "$boot" ] && exit 0
s=$(( $(date +%s) - boot ))
d=$(( s / 86400 )); h=$(( s % 86400 / 3600 )); m=$(( s % 3600 / 60 ))
if [ "$d" -gt 0 ]; then printf '↑%dd %02d:%02d' "$d" "$h" "$m"
else printf '↑%02d:%02d' "$h" "$m"; fi
