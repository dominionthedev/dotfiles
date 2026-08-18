from dataclasses import dataclass


@dataclass(frozen=True)
class Config:
    name: str
    source: str
    target: str


CONFIGS = (
    Config("bash", ".bashrc", "~/.bashrc"),
    Config("git", ".gitconfig", "~/.gitconfig"),
    Config("starship", "starship.toml", "~/.config/starship.toml"),
    Config("nvim", "nvim", "~/.config/nvim"),
    Config("tmux", "tmux", "~/.config/tmux"),
    Config("wezterm", "wezterm", "~/.config/wezterm"),
    Config("lazygit", "lazygit", "~/.config/lazygit"),
    Config("bat", "bat", "~/.config/bat"),
    Config("delta", "delta", "~/.config/delta"),
    Config("eza", "eza", "~/.config/eza"),
    Config("tealdeer", "tealdeer", "~/.config/tealdeer"),
    Config("television", "television", "~/.config/television"),
    Config("atuin", "atuin", "~/.config/atuin"),
)
