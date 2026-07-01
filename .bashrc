# Initialize Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Enhanced ls with eza
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons'
    alias ll='eza --icons -l'
    alias la='eza --icons -la'
    alias tree='eza --icons --tree'
fi

# Enhanced cat with bat
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=auto'
fi

# Enhanced grep with ripgrep
if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
fi

# Tmux shortcuts
alias ta='tmux attach-session -t'
alias tl='tmux list-sessions'
alias tk="tmux kill-server"

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

alias ollama="ollacloud"
