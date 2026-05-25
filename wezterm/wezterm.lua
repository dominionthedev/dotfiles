local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

-- ── Font ─────────────────────────────────────────────────────────────────────
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 11
config.line_height = 1.08
config.harfbuzz_features = { "calt=1", "liga=1", "clig=1" }

-- ── Color ─────────────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Mocha"

-- ── Window ────────────────────────────────────────────────────────────────────
config.window_background_opacity = 0.6
config.macos_window_background_blur = 9

config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

config.scrollback_lines = 10000
config.default_cwd = wezterm.home_dir .. "/Developer"

-- ── Cursor ───────────────────────────────────────────────────────────────────
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ── Tab bar (minimal) ─────────────────────────────────────────────────────────
-- Tab bar is off — tmux handles all windowing
config.enable_tab_bar = false

-- ── Performance ───────────────────────────────────────────────────────────────
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 60
config.term = "xterm-256color"

-- ── Alt key (macOS option key) ────────────────────────────────────────────────
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- ── Reload ───────────────────────────────────────────────────────────────────
config.automatically_reload_config = true

-- ── Leader ───────────────────────────────────────────────────────────────────
config.leader = { key = "b", mods = "CMD", timeout_milliseconds = 1000 }

-- ── Key bindings ─────────────────────────────────────────────────────────────
config.keys = {
    -- Word navigation (macOS-style)
    { key = "Backspace",  mods = "CMD",       action = act.SendString("\x15") },
    { key = "LeftArrow",  mods = "CMD",       action = act.SendString("\x01") },
    { key = "RightArrow", mods = "CMD",       action = act.SendString("\x05") },
    { key = "LeftArrow",  mods = "OPT",       action = act.SendString("\x1bb") },
    { key = "RightArrow", mods = "OPT",       action = act.SendString("\x1bf") },
    { key = "Backspace",  mods = "OPT",       action = act.SendString("\x1b\x7f") },

    -- Copy/paste
    { key = "c",          mods = "CMD",       action = act.CopyTo("Clipboard") },
    { key = "v",          mods = "CMD",       action = act.PasteFrom("Clipboard") },

    -- Launcher / command palette
    { key = "p",          mods = "LEADER",    action = act.ShowLauncher },
    { key = "P",          mods = "CMD|SHIFT", action = act.ActivateCommandPalette },

    -- Font size
    { key = "=",          mods = "CMD",       action = act.IncreaseFontSize },
    { key = "-",          mods = "CMD",       action = act.DecreaseFontSize },
    { key = "0",          mods = "CMD",       action = act.ResetFontSize },

    -- Search
    { key = "f",          mods = "CMD",       action = act.Search({ CaseInSensitiveString = "" }) },

    -- Clear scrollback
    { key = "k",          mods = "CMD",       action = act.ClearScrollback("ScrollbackAndViewport") },
}

return config
