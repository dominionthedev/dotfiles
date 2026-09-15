# ── Hooks ──────────────────────────────────────────────────────────────────────
autoload -Uz add-zsh-hook

function dir_enter() {
    clear

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git status
    else
        eza --icons --group-directories-first --all --long --header --git
    fi

    [[ -d .venv ]] && source .venv/bin/activate
    [[ -f box.lock ]] && runbox shell
}
add-zsh-hook chpwd dir_enter

if [[ -n "$TMUX" ]]; then
  : ${PANEWATCH_SOCK:=$HOME/.local/share/panewatch/panewatch.sock}

  __panewatch_send() {
    nc -U -w1 "$PANEWATCH_SOCK" >/dev/null 2>&1 &!
  }

  __panewatch_preexec() {
    __panewatch_pane=$(command tmux display-message -p '#{pane_id}' 2>/dev/null) || return
    __panewatch_cmd="${1//$'\n'/ }"
    printf 'START\x1f%s\x1f%s\n' "$__panewatch_pane" "$__panewatch_cmd" | __panewatch_send
  }

  __panewatch_precmd() {
    local ec=$?
    [[ -z "$__panewatch_pane" ]] && return
    printf 'END\x1f%s\x1f%s\x1f%s\n' "$__panewatch_pane" "$ec" "$__panewatch_cmd" | __panewatch_send
    unset __panewatch_pane __panewatch_cmd
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec __panewatch_preexec
  add-zsh-hook precmd __panewatch_precmd
fi
