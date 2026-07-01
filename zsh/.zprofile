# ---- Bin and Shell ----
. "$HOME/.local/bin/env"

# ---- BASE PATH (LOGIN SCOPE) ----
typeset -gU path PATH

path=(
  /opt/local/bin
  /opt/local/sbin
  $HOME/.local/bin
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $HOME/go/bin
  $HOME/.cargo/bin
  /usr/local/go/bin
  /opt/local/lib/postgresql18/bin
)

export PATH

# func path
typeset -gU fpath

fpath=(
    /opt/local/share/zsh/site-functions
    $fpath
)

# manpath
export MANPATH="/opt/local/share/man:$MANPATH"

