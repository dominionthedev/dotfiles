#!/usr/bin/env bash
# Entry point — click on the right side of the status bar to open this.
set -euo pipefail

tmux display-menu \
    -T "#[align=centre] Controls" -x M -y M -s "fg=#cdd6f4" -S "fg=#89b4fa" \
    "󰤨  Wi-Fi"     "w" "run-shell '~/.config/tmux/custom/wifi-menu.sh'" \
    "󰂯  Bluetooth" "b" "run-shell '~/.config/tmux/custom/bluetooth-menu.sh'"
