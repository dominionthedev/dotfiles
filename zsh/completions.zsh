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
