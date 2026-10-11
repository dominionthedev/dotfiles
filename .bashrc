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

