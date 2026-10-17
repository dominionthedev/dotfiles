#!/usr/bin/env bash
# Television launcher menu for tmux. Called from a tmux popup.
set -euo pipefail

tmux display-menu \
  -T " #[align=centre] Television " -x M -y M -s "fg=#cdd6f4" -S "fg=#89b4fa" \
  "Files"             "f" "display-popup -E -d '#{pane_current_path}' -w 85% -h 80% 'tv files'" \
  "Directories"       "d" "display-popup -E -d '#{pane_current_path}' -w 75% -h 70% 'tv dirs'" \
  "Git repositories"  "g" "display-popup -E -d '#{pane_current_path}' -w 85% -h 80% 'tv git-repos'" \
  "Git branches"      "b" "display-popup -E -d '#{pane_current_path}' -w 85% -h 80% 'tv git-branches'" \
  "Processes"         "p" "display-popup -E -d '#{pane_current_path}' -w 80% -h 75% 'tv processes'" \
  "MacPorts installed" "i" "display-popup -E -d '#{pane_current_path}' -w 90% -h 85% 'tv macports-installed'" \
  "MacPorts outdated"  "o" "display-popup -E -d '#{pane_current_path}' -w 90% -h 85% 'tv macports-outdated'" \
  "MacPorts search"    "m" "display-popup -E -d '#{pane_current_path}' -w 90% -h 85% 'tv macports-search'"
