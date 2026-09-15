# ── Widgets ─────────────────────────────────────────────────────────────────────
edit-target() {
    local target="$BUFFER"
    [[ -z "$target" ]] && target="."

    if [[ -f "$target" || -d "$target" ]]; then
        BUFFER="nvim ${(q)target}"
        CURSOR=${#BUFFER}
        zle .accept-line
    else
        zle beep
    fi
}
zle -N edit-target
bindkey '^O' edit-target

sudo-command() {
    [[ -z $BUFFER ]] && return
    if [[ "$BUFFER" == sudo\ * ]]; then
        BUFFER="${BUFFER#sudo }"
    else
        BUFFER="sudo $BUFFER"
    fi

    CURSOR=${#BUFFER}
}
zle -N sudo-command
bindkey '^S' sudo-command

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^V' edit-command-line
