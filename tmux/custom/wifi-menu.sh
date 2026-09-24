#!/usr/bin/env bash
# Wi-Fi control menu.
#
# Base list is always your KNOWN (preferred/Keychain) networks — unconditional,
# doesn't depend on scanning or being in range. Click the currently-connected
# one to disconnect; click any other to connect.
#
# `airport -s` is a SUPPORTIVE addition: anything nearby that ISN'T already
# known gets listed too, plainly. Selecting one shows a message pointing you
# at System Settings — tmux can't mask password input, so this deliberately
# doesn't try to join a genuinely new network directly.
#
# Every action reopens this menu afterward (toggle power, connect,
# disconnect) instead of just closing, per your ask that it feel persistent
# rather than one-shot.
#
# NOT using `set -e`: networksetup/airport calls can transiently fail right
# after a power toggle while the interface comes back up, and that shouldn't
# kill the whole menu with exit 1 — better to show slightly stale info than
# nothing at all. `-u`/pipefail stay on to catch real bugs.
set -uo pipefail

AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
NEW_CACHE="/tmp/tmux-wifi-new.tsv"
SELF="~/.config/tmux/custom/wifi-menu.sh"

DEV=$(networksetup -listallhardwareports 2>/dev/null | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
[ -z "$DEV" ] && DEV="en0"

POWER=$(networksetup -getairportpower "$DEV" 2>/dev/null | awk '{print $NF}')
[ -z "$POWER" ] && POWER="Unknown"

args=(-T "#[align=centre]󰤨 Wi-Fi" -x M -y M -s "fg=#cdd6f4" -S "fg=#89b4fa")

if [ "$POWER" != "On" ]; then
    args+=("Turn Wi-Fi On" "o" "run-shell 'networksetup -setairportpower $DEV on; sleep 2; $SELF'")
    tmux display-menu "${args[@]}"
    exit 0
fi

args+=("Turn Wi-Fi Off" "o" "run-shell 'networksetup -setairportpower $DEV off; sleep 1; $SELF'")
args+=("" "" "")

RAW_CURRENT=$(networksetup -getairportnetwork "$DEV" 2>/dev/null || true)
case "$RAW_CURRENT" in
    "Current Wi-Fi Network: "*) CURRENT="${RAW_CURRENT#Current Wi-Fi Network: }" ;;
    *) CURRENT="" ;;
esac

# --- Known networks: always listed, regardless of scan/range. ---
i=1
while IFS= read -r ssid; do
    ssid="${ssid#"${ssid%%[![:space:]]*}"}"
    [ -z "$ssid" ] && continue
    if [ "$ssid" = "$CURRENT" ]; then
        label="✓ $ssid"
    else
        label="  $ssid"
    fi
    args+=("$label" "$i" "run-shell '~/.config/tmux/custom/wifi-connect.sh $DEV known $i; sleep 2; $SELF'")
    i=$((i + 1))
done < <(networksetup -listpreferredwirelessnetworks "$DEV" 2>/dev/null | tail -n +2)

# --- New networks: anything scanned that ISN'T already in the list above. ---
KNOWN=$(networksetup -listpreferredwirelessnetworks "$DEV" 2>/dev/null | tail -n +2 | sed 's/^[[:space:]]*//')

declare -A best_rssi
while IFS= read -r line; do
    if [[ "$line" =~ ^(.*)[[:space:]]([0-9a-fA-F]{2}(:[0-9a-fA-F]{2}){5})[[:space:]]+(-?[0-9]+) ]]; then
        ssid="${BASH_REMATCH[1]}"
        ssid="${ssid%"${ssid##*[![:space:]]}"}"
        rssi="${BASH_REMATCH[4]}"
        [ -z "$ssid" ] && continue
        grep -qxF "$ssid" <<< "$KNOWN" && continue
        if [ -z "${best_rssi[$ssid]:-}" ] || [ "$rssi" -gt "${best_rssi[$ssid]}" ]; then
            best_rssi[$ssid]="$rssi"
        fi
    fi
done < <("$AIRPORT" -s 2>/dev/null || true)

: > "$NEW_CACHE"
if [ "${#best_rssi[@]}" -gt 0 ]; then
    for ssid in "${!best_rssi[@]}"; do
        printf '%s\t%s\n' "${best_rssi[$ssid]}" "$ssid"
    done | sort -rn -k1,1 | cut -f2- > "$NEW_CACHE"

    args+=("" "" "")
    j=1
    while IFS= read -r ssid; do
        args+=("  $ssid" "$j" "run-shell '~/.config/tmux/custom/wifi-connect.sh $DEV new $j; $SELF'")
        j=$((j + 1))
    done < "$NEW_CACHE"
fi

tmux display-menu "${args[@]}"
