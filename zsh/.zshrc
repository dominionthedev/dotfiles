zmodload zsh/zprof

# ---- termbox env ----
source $HOME/.config/termbox/termbox.env
# ---- termbox zsh ----
source $TERMBOX_CONFIG_DIR/zshrc

eval "$(wezterm shell-completion --shell zsh)"

typeset -gU path PATH

# zprof
