# ---- Environment Variables ----

# XDG 
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# go
export GOROOT="/usr/local/go"
export GO111MODULE=auto
export GOPATH="$HOME/go"
export GOBIN=$HOME/go/bin
export GOTOOLCHAIN=local

# name
export NAME=DominionDev

# terminal
export COLORTERM=truecolor
export TERM=xterm-256color

# cargo
. "$HOME/.cargo/env"

# zig
# export CC="zig cc"

