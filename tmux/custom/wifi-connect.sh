#!/usr/bin/env bash
# Handles one Wi-Fi menu selection. Called as:
#   wifi-connect.sh <dev> known <N>   connect to, or disconnect from, the Nth
#                                     known network — whichever it currently
#                                     isn't
#   wifi-connect.sh <dev> new <N>     show info about the Nth newly-scanned
#                                     (not-in-Keychain) network; see the
#                                     comment in wifi-menu.sh for why this
#                                     doesn't try to join it directly
#
# The tmux display-message calls here are the closest honest approximation
# of a "loading" indicator tmux's menu system can actually do — a brief
# toast, not a spinner inside the popup itself, since display-menu's content
# is fixed at the moment it opens and can't update live mid-display. The
# caller (wifi-menu.sh) is what handles "reopen after this finishes."
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
    # working there. Untested whether it needs sudo on your specific
    # (older) macOS version — if this fails, that's what to check first,
    # not a bug in the logic here.
    if ! "$AIRPORT" -z >/dev/null 2>&1; then
        tmux display-message "Couldn't disconnect — 'airport -z' failed (may need sudo on your macOS version, or may just not be supported). Not something this script can work around."
    fi
else
    tmux display-message "Connecting to $SSID…"
    networksetup -setairportnetwork "$DEV" "$SSID"
fi
