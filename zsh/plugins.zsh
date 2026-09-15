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
unalias zi
