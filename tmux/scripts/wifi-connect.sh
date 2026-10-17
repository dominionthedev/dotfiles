#!/usr/bin/env bash
# Handles one Wi-Fi menu selection. Called as:
#   wifi-connect.sh <dev> known <N>:  connect to, or disconnect from, the Nth
#                                     known network — whichever it currently
#                                     isn't
#   wifi-connect.sh <dev> new <N>     show info about the Nth newly-scanned
#                                     (not-in-Keychain) network
set -uo pipefail

DEV="$1"
MODE="$2"
N="$3"
NEW_CACHE="/tmp/tmux-wifi-new.tsv"
AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

if [ "$MODE" = "new" ]; then
    SSID=$(sed -n "${N}p" "$NEW_CACHE" 2>/dev/null || true)
    if [ -n "$SSID" ]; then
        tmux display-message "\"$SSID\" isn't in Keychain — join it once from System Settings > Wi-Fi, then it'll connect instantly from here."
    fi
    exit 0
fi

SSID=$(networksetup -listpreferredwirelessnetworks "$DEV" 2>/dev/null | tail -n +2 | sed -n "${N}p" | sed 's/^[[:space:]]*//')
[ -z "$SSID" ] && exit 0

RAW_CURRENT=$(networksetup -getairportnetwork "$DEV" 2>/dev/null || true)
CURRENT=""
case "$RAW_CURRENT" in
    "Current Wi-Fi Network: "*) CURRENT="${RAW_CURRENT#Current Wi-Fi Network: }" ;;
esac

if [ "$SSID" = "$CURRENT" ]; then
    tmux display-message "Disconnecting from $SSID…"
    # `airport -z` was deprecated by Apple as of macOS 14.4 and stopped
    # working there. if this fails, that's what to check first.
    if ! "$AIRPORT" -z >/dev/null 2>&1; then
        tmux display-message "Couldn't disconnect — 'airport -z' failed (may need sudo on your macOS version, or may just not be supported)."
    fi
else
    tmux display-message "Connecting to $SSID…"
    networksetup -setairportnetwork "$DEV" "$SSID"
fi
