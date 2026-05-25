#!/bin/bash
# git-status.sh — compact git status for tmux status bar
# Uses pane_current_path so it reflects the active pane's directory, not $PWD

pane_path=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null)
[ -z "$pane_path" ] && exit 0

git -C "$pane_path" rev-parse --is-inside-work-tree &>/dev/null || exit 0

branch=$(git -C "$pane_path" rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$branch" ] && exit 0
[ ${#branch} -gt 20 ] && branch="${branch:0:18}…"

staged=$(git -C "$pane_path" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
modified=$(git -C "$pane_path" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
untracked=$(git -C "$pane_path" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

upstream=$(git -C "$pane_path" rev-parse --abbrev-ref @{u} 2>/dev/null)
ahead=0; behind=0
if [ -n "$upstream" ]; then
    ahead=$(git -C "$pane_path" rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    behind=$(git -C "$pane_path" rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
fi

out=" ${branch}"
[ "$staged" -gt 0 ]    && out="${out} #[fg=#a6e3a1]+${staged}"
[ "$modified" -gt 0 ]  && out="${out} #[fg=#f9e2af]!${modified}"
[ "$untracked" -gt 0 ] && out="${out} #[fg=#89b4fa]?${untracked}"
[ "$ahead" -gt 0 ]     && out="${out} #[fg=#cba6f7]⇡${ahead}"
[ "$behind" -gt 0 ]    && out="${out} #[fg=#f38ba8]⇣${behind}"

if [ "$staged" -eq 0 ] && [ "$modified" -eq 0 ] && [ "$untracked" -eq 0 ]; then
    out="${out} #[fg=#a6e3a1]✓"
fi

echo "#[fg=#89dceb]${out}#[default]"
