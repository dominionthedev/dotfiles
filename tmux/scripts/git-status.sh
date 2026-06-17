#!/bin/bash
# git-status.sh — compact git status for tmux status bar
# Uses pane_current_path so it reflects the active pane's directory

pane_path=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null)
[ -z "$pane_path" ] && exit 0

gitdir() {
    git -C "$pane_path" "$@" 2>/dev/null
}

gitdir rev-parse --is-inside-work-tree >/dev/null || {
    echo "#[fg=#{@dim}]no git"
    exit 0
}

branch=$(gitdir rev-parse --abbrev-ref HEAD)
[ -z "$branch" ] && exit 0
[ ${#branch} -gt 20 ] && branch="${branch:0:18}…"

staged=$(gitdir diff --cached --name-only | wc -l | tr -d ' ')
modified=$(gitdir diff --name-only | wc -l | tr -d ' ')
untracked=$(gitdir ls-files --others --exclude-standard | wc -l | tr -d ' ')

upstream=$(gitdir rev-parse --abbrev-ref @{u})
ahead=0
behind=0

if [ -n "$upstream" ]; then
    ahead=$(gitdir rev-list @{u}..HEAD | wc -l | tr -d ' ')
    behind=$(gitdir rev-list HEAD..@{u} | wc -l | tr -d ' ')
fi

out=" ${branch}"

[ "$staged" -gt 0 ]    && out="${out} #[fg=#{@green}]+${staged}"
[ "$modified" -gt 0 ]  && out="${out} #[fg=#{@yellow}]!${modified}"
[ "$untracked" -gt 0 ] && out="${out} #[fg=#{@blue}]?${untracked}"
[ "$ahead" -gt 0 ]     && out="${out} #[fg=#{@peach}]⇡${ahead}"
[ "$behind" -gt 0 ]    && out="${out} #[fg=#{@red}]⇣${behind}"

if [ "$staged" -eq 0 ] && [ "$modified" -eq 0 ] && [ "$untracked" -eq 0 ]; then
    out="${out} #[fg=#{@teal}]✓"
fi

echo "#[fg=#{@sky}]${out}"
