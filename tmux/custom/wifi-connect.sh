#!/usr/bin/env bash
# Reconnects to the Nth known network, in the same order wifi-menu.sh listed
# them. Takes an index rather than an SSID so the menu never has to embed a
# possibly-spaced/quoted network name directly in a tmux command string.
# No password needed — this only works for networks already in Keychain.
set -euo pipefail

DEV="$1"
N="$2"

SSID=$(networksetup -listpreferredwirelessnetworks "$DEV" | tail -n +2 | sed -n "${N}p" | sed 's/^[[:space:]]*//')
[ -n "$SSID" ] && networksetup -setairportnetwork "$DEV" "$SSID"
