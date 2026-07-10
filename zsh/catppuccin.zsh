# An unoffical Custom catppuccin theme for zsh and the terminal emulator
# Catppuccin flavour: Mocha
#
# You may not want to apply this if you run a subshell
# or tmux in an already themed shell

# ── Palette ────────────────────────────────────────────────
export THEME_ROSEWATER="#f5e0dc"
export THEME_FLAMINGO="#f2cdcd"
export THEME_PINK="#f5c2e7"
export THEME_MAUVE="#cba6f7"
export THEME_RED="#f38ba8"
export THEME_MAROON="#eba0ac"
export THEME_PEACH="#fab387"
export THEME_YELLOW="#f9e2af"
export THEME_GREEN="#a6e3a1"
export THEME_TEAL="#94e2d5"
export THEME_SKY="#89dceb"
export THEME_SAPPHIRE="#74c7ec"
export THEME_BLUE="#89b4fa"
export THEME_LAVENDER="#b4befe"
export THEME_TEXT="#cdd6f4"
export THEME_SUBTEXT1="#bac2de"
export THEME_SUBTEXT0="#a6adc8"
export THEME_OVERLAY2="#9399b2"
export THEME_OVERLAY1="#7f849c"
export THEME_OVERLAY0="#6c7086"
export THEME_SURFACE2="#585b70"
export THEME_SURFACE1="#45475a"
export THEME_SURFACE0="#313244"
export THEME_BASE="#1e1e2e"
export THEME_MANTLE="#181825"
export THEME_CRUST="#11111b"

export THEME_BG="$THEME_BASE"
export THEME_FG="$THEME_TEXT"
export THEME_PRIMARY="$THEME_MAUVE"
export THEME_SECONDARY="$THEME_BLUE"
export THEME_ACCENT="$THEME_PINK"
export THEME_SUCCESS="$THEME_GREEN"
export THEME_WARNING="$THEME_YELLOW"
export THEME_ERROR="$THEME_RED"
export THEME_BORDER="$THEME_SURFACE0"
export THEME_MUTED="$THEME_OVERLAY0"

export THEME_BLACK="$THEME_CRUST"
export THEME_MAGENTA="$THEME_MAUVE"
export THEME_CYAN="$THEME_TEAL"
export THEME_WHITE="$THEME_SUBTEXT1"
export THEME_BRIGHT_BLACK="$THEME_SURFACE2"
export THEME_BRIGHT_RED="$THEME_RED"
export THEME_BRIGHT_GREEN="$THEME_GREEN"
export THEME_BRIGHT_YELLOW="$THEME_YELLOW"
export THEME_BRIGHT_BLUE="$THEME_BLUE"
export THEME_BRIGHT_MAGENTA="$THEME_PINK"
export THEME_BRIGHT_CYAN="$THEME_SKY"
export THEME_BRIGHT_WHITE="$THEME_TEXT"

# zsh highlighting
# if you use fsh(fast-syntax-highlighting), use the theme at ../fsh/catppuccin-mocha.ini
typeset -A ZSH_HIGHLIGHT_STYLES 2>/dev/null || true
ZSH_HIGHLIGHT_STYLES[command]="fg=$THEME_GREEN"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=$THEME_PEACH"
ZSH_HIGHLIGHT_STYLES[function]="fg=$THEME_BLUE"
ZSH_HIGHLIGHT_STYLES[alias]="fg=$THEME_MAUVE,bold"
ZSH_HIGHLIGHT_STYLES[path]="fg=$THEME_SKY,underline"
ZSH_HIGHLIGHT_STYLES[path_prefix]="fg=$THEME_OVERLAY1"
ZSH_HIGHLIGHT_STYLES[string]="fg=$THEME_YELLOW"
ZSH_HIGHLIGHT_STYLES[comment]="fg=$THEME_OVERLAY0"
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=$THEME_MAUVE,bold"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=$THEME_PEACH"
ZSH_HIGHLIGHT_STYLES[option]="fg=$THEME_SKY"
ZSH_HIGHLIGHT_STYLES[assign]="fg=$THEME_FLAMINGO"
ZSH_HIGHLIGHT_STYLES[number]="fg=$THEME_PEACH"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=$THEME_OVERLAY2"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=$THEME_RED,bold"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$THEME_OVERLAY1"

# FZF (from github.com/catppuccin/fzf)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# Terminal styling (OSC-based)
#
# This may look like it wasn't applied if your terminal(e.g wezterm)
# uses same theme(catppuccin mocha) as this, but it works and is noticable.
# You can comment/reove this block if any issue occurs in you terminal emulator/tmux
printf "\033]10;$THEME_TEXT\007"
printf "\033]11;$THEME_BASE\007"
printf "\033]12;$THEME_LAVENDER\007"
printf "\033]17;$THEME_SURFACE1\007"
printf "\033]19;$THEME_TEXT\007"
printf "\033]4;0;$THEME_CRUST\007"
printf "\033]4;1;$THEME_RED\007"
printf "\033]4;2;$THEME_GREEN\007"
printf "\033]4;3;$THEME_YELLOW\007"
printf "\033]4;4;$THEME_BLUE\007"
printf "\033]4;5;$THEME_MAUVE\007"
printf "\033]4;6;$THEME_TEAL\007"
printf "\033]4;7;$THEME_SUBTEXT1\007"
printf "\033]4;8;$THEME_SURFACE2\007"
printf "\033]4;9;$THEME_RED\007"
printf "\033]4;10;$THEME_GREEN\007"
printf "\033]4;11;$THEME_YELLOW\007"
printf "\033]4;12;$THEME_BLUE\007"
printf "\033]4;13;$THEME_PINK\007"
printf "\033]4;14;$THEME_SKY\007"
printf "\033]4;15;$THEME_TEXT\007"
