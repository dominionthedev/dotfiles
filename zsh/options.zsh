# ── History ─────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="${XDG_DATA_HOME}/zsh/history"
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS SHARE_HISTORY APPEND_HISTORY

# ── Options ─────────────────────────────────────────────────────────────────
stty -ixon -ixoff
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CORRECT INTERACTIVE_COMMENTS PROMPT_SUBST
bindkey -v
export KEYTIMEOUT=1
bindkey '^B' history-incremental-search-backward
bindkey '^F' history-incremental-search-forward
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' insert-last-word
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^Y' yank
