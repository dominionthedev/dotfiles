if [[ -z "$TMUX" ]] && [[ "$SHLVL" -eq 1 ]]; then
    source "${HOME}/.config/zsh/themes/catppuccin.zsh"
    toilet -f slant --gay "DOMINIONDEV"
fi

source "${HOME}/.config/zsh/aliases.zsh"
source "${HOME}/.config/zsh/completions.zsh"
source "${HOME}/.config/zsh/hooks.zsh"
source "${HOME}/.config/zsh/options.zsh"
source "${HOME}/.config/zsh/plugins.zsh"
source "${HOME}/.config/zsh/widgets.zsh"

eval "$(tv init zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
