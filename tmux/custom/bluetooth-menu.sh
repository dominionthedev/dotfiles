#!/usr/bin/env bash
# Bluetooth control menu — lists paired devices (connect/disconnect),
# and can discover, pair, and connect new devices.
# Needs blueutil and jq.
set -euo pipefail

SCRIPT="$HOME/.config/tmux/custom/bluetooth-menu.sh"

display_error() {
    tmux display-message "Bluetooth: $*"
}

pair_device() {
    local addr="$1"
    local output

    if ! output=$(blueutil --pair "$addr" 2>&1); then
        display_error "pairing failed: $output"
        return 1
    fi

    if ! output=$(blueutil --connect "$addr" 2>&1); then
        display_error "connection failed: $output"
        return 1
    fi

    tmux display-message "Bluetooth: connected"
}

pair_new_device() {
    local paired inquiry

    if ! paired=$(blueutil --paired --format json 2>&1); then
        display_error "could not list paired devices: $paired"
        return 1
    fi

    if ! inquiry=$(blueutil --inquiry 10 --format json 2>&1); then
        display_error "discovery failed: $inquiry"
        return 1
    fi

    local args=(
        -T "#[align=centre] Pair New Device"
        -x M
        -y M
        -s "fg=#cdd6f4"
        -S "fg=#89b4fa"
    )

    local i=1

    while IFS=$'\t' read -r addr name; do
        [ -z "$addr" ] && continue

        if printf '%s\n' "$paired" |
            jq -e --arg addr "$addr" '.[] | select(.address == $addr)' >/dev/null; then
            continue
        fi

        [ -z "$name" ] && name="$addr"

        args+=(
            "$name"
            "$i"
            "run-shell '$SCRIPT --pair \"$addr\"'"
        )

        i=$((i + 1))
    done < <(
        printf '%s\n' "$inquiry" |
            jq -r '.[] | [.address, .name] | @tsv'
    )

    if [ "$i" -eq 1 ]; then
        args+=("No new devices found" "" "")
    fi

    tmux display-menu "${args[@]}"
}

if [ "${1:-}" = "--pair" ]; then
    if [ -z "${2:-}" ]; then
        display_error "no device specified"
        exit 1
    fi

    pair_device "$2"
    exit
fi

if [ "${1:-}" = "--pair-new" ]; then
    pair_new_device
    exit
fi

POWER=$(blueutil -p 2>/dev/null || echo 0)

args=(
    -T "#[align=centre] Bluetooth"
    -x M
    -y M
    -s "fg=#cdd6f4"
    -S "fg=#89b4fa"
)

if [ "$POWER" = "1" ]; then
    args+=(
        "Turn Bluetooth Off"
        "o"
        "run-shell 'if ! output=\$(blueutil -p 0 2>&1); then tmux display-message \"Bluetooth: \$output\"; fi'"
    )

    args+=("" "" "")

    i=1

    if ! paired=$(blueutil --paired --format json 2>&1); then
        display_error "could not list paired devices: $paired"
        exit 1
    fi

    while IFS=$'\t' read -r addr name connected; do
        [ -z "$addr" ] && continue

        if [ "$connected" = "true" ]; then
            label="✓ $name"
            action="disconnect"
        else
            label="  $name"
            action="connect"
        fi

        args+=(
            "$label"
            "$i"
            "run-shell 'if ! output=\$(blueutil --$action \"$addr\" 2>&1); then tmux display-message \"Bluetooth: \$output\"; fi'"
        )

        i=$((i + 1))
    done < <(
        printf '%s\n' "$paired" |
            jq -r '.[] | [.address, .name, .connected] | @tsv'
    )

    args+=("" "" "")
    args+=(
        "Pair New Device"
        "p"
        "run-shell '$SCRIPT --pair-new'"
    )
else
    args+=(
        "Turn Bluetooth On"
        "o"
        "run-shell 'if ! output=\$(blueutil -p 1 2>&1); then tmux display-message \"Bluetooth: \$output\"; fi'"
    )
fi

tmux display-menu "${args[@]}"
