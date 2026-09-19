#!/usr/bin/env bash
# Wi-Fi control menu.
#
# Base list is always your KNOWN (preferred/Keychain) networks — unconditional,
# doesn't depend on scanning or being in range, so it's always predictable:
# anything in this section connects instantly, password-less.
#
# `airport -s` is used as a SUPPORTIVE addition only: anything nearby that
# ISN'T already known gets listed separately, tagged (new). Selecting one of
# those doesn't try to connect — tmux has no password-masking, so joining a
# genuinely new network still goes through System Settings once, after which
# it becomes a known network here too.
#
# Whether `airport -s` keeps working without a permission prompt depends on
# your macOS version — Apple has tightened this over time. If it ever stops
# working, this degrades gracefully to just the known-networks list, since
# the scan is additive, not load-bearing.
set -euo pipefail

AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

DEV=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
[ -z "$DEV" ] && DEV="en0"

POWER=$(networksetup -getairportpower "$DEV" | awk '{print $NF}')

args=(-T "#[align=centre]󰤨 Wi-Fi" -x M -y M -s "fg=#cdd6f4" -S "fg=#89b4fa")

if [ "$POWER" != "On" ]; then
    args+=("Turn Wi-Fi On" "o" "run-shell 'networksetup -setairportpower $DEV on'")
    tmux display-menu "${args[@]}"
    exit 0
fi

args+=("Turn Wi-Fi Off" "o" "run-shell 'networksetup -setairportpower $DEV off'")
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
    label="  $ssid"
    [ "$ssid" = "$CURRENT" ] && label="✓ $ssid"
    args+=("$label" "$i" "run-shell '~/.config/tmux/custom/wifi-connect.sh $DEV $i'")
    i=$((i + 1))
done < <(networksetup -listpreferredwirelessnetworks "$DEV" | tail -n +2)
known_count=$((i - 1))

# --- New networks: anything scanned that ISN'T already in the list above. ---
KNOWN=$(networksetup -listpreferredwirelessnetworks "$DEV" | tail -n +2 | sed 's/^[[:space:]]*//')

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

if [ "${#best_rssi[@]}" -gt 0 ]; then
    args+=("" "" "")
    while IFS= read -r ssid; do
        args+=("  $ssid" "" "")
    done < <(
        for ssid in "${!best_rssi[@]}"; do
            printf '%s\t%s\n' "${best_rssi[$ssid]}" "$ssid"
        done | sort -rn -k1,1 | cut -f2-
    )
fi

tmux display-menu "${args[@]}"
