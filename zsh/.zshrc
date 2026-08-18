if [[ -z "$TMUX" ]] && [[ "$SHLVL" -eq 1 ]]; then
    source "${XDG_DATA_HOME}/zsh/themes/catppuccin.zsh"
    # toilet -f slant --gay "$USERNAME"
fi
eval "$(starship init zsh)"

# ── Plugins ────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait"1" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
zinit ice wait"1" lucid
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait"1" lucid
zinit light zsh-users/zsh-completions
zinit ice wait"1" lucid
zinit light Aloxaf/fzf-tab

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

# ── Completions ───────────────────────────────────────────────────────────────
mkdir -p "${XDG_CACHE_HOME}/zsh"
autoload -Uz compinit
if [[ ! -f $XDG_CACHE_HOME/zsh/zcompdump || $XDG_CACHE_HOME/zsh/zcompdump -ot ~/.zshrc ]]; then
    compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
else
    compinit -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format '%F{red}no matches found%f'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:cd:*' fzf-preview \
  'eza --tree --level=2 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview '
if [[ -d $realpath ]]; then
  eza --icons --tree --color=always $realpath
else
  bat --color=always --line-range=:300 $realpath
fi
'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border

# ── Tool integrations ──────────────────────────────────────────────────────────
unalias zi
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

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
    [[ -d .runbox ]] && runbox shell
}
add-zsh-hook chpwd dir_enter

if [[ -n "$TMUX" ]]; then
  : ${PANEWATCH_SOCK:=$HOME/.local/share/panewatch/panewatch.sock}

  __panewatch_send() {
    # -w1: give up after 1s if the daemon is wedged rather than hang the
    # shell. Backgrounded + output silenced: this must never be visible.
    nc -U -w1 "$PANEWATCH_SOCK" >/dev/null 2>&1 &!
  }

  __panewatch_preexec() {
    __panewatch_pane=$(command tmux display-message -p '#{pane_id}' 2>/dev/null) || return
    __panewatch_cmd=$1
    # printf avoids a trailing newline in the field; the daemon splits on
    # the unit separator and only cares about the final newline itself.
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

# ── Aliases ───────────────────────────────────────────────────────────────────
alias cd="z"
alias ..='cd ..'
alias ~='cd ~'
alias -- -='cd -'
alias realrm='/bin/rm -i'
alias rm='trash'
alias du='dust'
alias cat='bat'
alias ls="eza --long --icons --group-directories-first"
alias ll="ls --all"
alias la="ls --all --header --git"
alias tree='ls --all --tree'
alias g='git'
alias ta='tmux attach-session -t'
alias tk='tmux kill-server'
alias reload='source ~/.zshrc'
alias myip='curl -s https://api.ipify.org && echo'
