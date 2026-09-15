# ---- Environment Variables ----
# XDG 
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Editor
export BAT_THEME="Catppuccin-mocha"
export BAT_STYLE="changes,numbers"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="bat"
export MANPAGER="bat -l man -p"

# go
export GOROOT="/usr/local/go"
export GO111MODULE=on
export GOPATH="$HOME/go"
export GOBIN=$HOME/go/bin
export GOTOOLCHAIN=local

# nvm
export NVM_DIR="$HOME/.local/share/nvm"

# terminal
export COLORTERM=truecolor
export EZA_CONFIG_DIR="$HOME/.config/eza"

