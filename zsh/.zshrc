# zmodload zsh/zprof
# ── Plugins ────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait"1" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
zinit ice wait"1" lucid
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait"1" lucid
zinit light zsh-users/zsh-completions
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# ── History ─────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="${XDG_DATA_HOME}/zsh/history"

setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS SHARE_HISTORY APPEND_HISTORY

setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CORRECT INTERACTIVE_COMMENTS PROMPT_SUBST

# ── Vi mode ──────────────────────────────────────────────────────────────────
# hack to allow ^Y, ^S, ^Q, etc to work
stty -ixon -ixoff

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
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"

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

# catppuccin/fzf mocha
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# ── Tool integrations ──────────────────────────────────────────────────────────
eval "$(starship init zsh)"
unalias zi
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
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

# ── Widgets ─────────────────────────────────────────────────────────────────────
# edit target
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

# prepend/remove sudo from buffer
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

# edit buffer
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
alias pgstart='sudo -u postgres pg_ctl -D $PGDATA start'
alias pgstop='sudo -u postgres pg_ctl -D $PGDATA stop'

# added by termbox
source $HOME/.config/termbox/zshrc

# zprof
