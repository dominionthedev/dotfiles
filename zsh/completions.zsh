# ── Completions ───────────────────────────────────────────────────────────────
mkdir -p "${XDG_CACHE_HOME}/zsh"

# Custom completion functions (ouch, git-am, tplate, and whatever comes next)
fpath=("${XDG_CONFIG_HOME}/zsh/completions" $fpath)

autoload -Uz compinit
if [[ ! -f $XDG_CACHE_HOME/zsh/zcompdump || $XDG_CACHE_HOME/zsh/zcompdump -ot ~/.zshrc ]]; then
    compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump"
else
    compinit -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"
fi

# Belt-and-suspenders: _git dispatches subcommands by looking up a
# `_git-<subcommand>` function. It's autoloaded from fpath above, but if your
# particular git-completion setup doesn't pick it up, this forces it.
compdef _git-am git-am 2>/dev/null

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

zstyle ':fzf-tab:complete:ouch:*' fzf-preview \
  'ouch list "$word" 2>/dev/null || echo "(new archive) will be created at:\n$word"'
zstyle ':fzf-tab:complete:git-am:*' fzf-preview \
  'bat --color=always --language=diff "$word" 2>/dev/null'
zstyle ':fzf-tab:complete:tplate:*' fzf-preview \
  'bat --color=always --style=numbers "$HOME/.local/share/tmux/templates/$word" 2>/dev/null'

zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border
