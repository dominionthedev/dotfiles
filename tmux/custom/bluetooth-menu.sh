#!/usr/bin/env bash
# Bluetooth control menu — lists PAIRED devices only (connect/disconnect),
# no live discovery of unpaired ones. Needs blueutil: brew install blueutil
set -euo pipefail

POWER=$(blueutil -p)

args=(-T "#[align=centre] Bluetooth" -x M -y M -s "fg=#cdd6f4" -S "fg=#89b4fa")

if [ "$POWER" = "1" ]; then
    args+=("Turn Bluetooth Off" "o" "run-shell 'blueutil -p 0'")
    args+=("" "" "")

    i=1
    while IFS=$'\t' read -r addr name connected; do
        [ -z "$addr" ] && continue
        if [ "$connected" = "true" ]; then
            label="✓ $name"
            action="disconnect"
        else
            label="  $name"
            action="connect"
        fi
        args+=("$label" "$i" "run-shell 'blueutil --$action $addr'")
        i=$((i + 1))
    done < <(blueutil --paired --format json | jq -r '.[] | [.address, .name, .connected] | @tsv')
else
    args+=("Turn Bluetooth On" "o" "run-shell 'blueutil -p 1'")
fi

tmux display-menu "${args[@]}"
