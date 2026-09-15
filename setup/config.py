from dataclasses import dataclass


@dataclass(frozen=True)
class Config:
    name: str
    source: str
    target: str


CONFIGS = (
    Config("atuin", "atuin", "~/.config/atuin"),
    Config("bat", "bat", "~/.config/bat"),
    Config("btop", "bpytop", "~/.config/bpytop"),
    Config("delta", "delta", "~/.config/delta"),
    Config("eza", "eza", "~/.config/eza"),
    Config("fast-syntax-highlighing", "fsh", "~/.config/fsh"),
    Config("git", ".gitconfig", "~/.gitconfig"),
    Config("lazygit", "lazygit", "~/.config/lazygit"),
    Config("nvim", "nvim", "~/.config/nvim"),
    Config("posting", "posting", "~/.config/posting"),
    Config("starship", "starship.toml", "~/.config/starship.toml"),
    Config("tv", "television", "~/.config/television"),
    Config("tmux", "tmux", "~/.config/tmux"),
    Config("wezterm", "wezterm", "~/.config/wezterm"),
    Config("yazi", "yazi", "~/.config/yazi"),
    Config("zsh", "zsh", "~/.config/zsh"),
    Config("zshrc", ".zshrc", "~/.zshrc"),
    Config("zshenv", ".zshenv", "~/.zshenv"),
    Config("zprofile", ".zprofile", "~/.zprofile"),
)
