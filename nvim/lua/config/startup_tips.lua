-- "Did you know..." startup tips. Pure data — add a string here any
-- time you add a keymap/feature worth surfacing later. Picked randomly
-- on VimEnter by config/autocmds.lua.
--
-- Keep these short — they're shown via vim.notify, not a popup window,
-- so anything long just gets truncated by nvim-notify's width.

return {
    "Press ? to see every keymap in this config (which-key).",
    "Press <leader>fk to fuzzy-search keymaps (Snacks picker).",
    "<leader>du toggles the DAP UI; <F5> starts/continues a debug session.",
    "<leader>Rr runs an Overseer task; <leader>Rt toggles the task list.",
    "<leader>a toggles Aerial's symbol outline for the current file.",
    "<leader>gl opens lazygit right inside Neovim.",
    "<leader>mn creates a new note in your active workspace.",
    "<leader>z toggles Zen mode for distraction-free writing.",
    "gr/gd/gi/gt jump to references/definitions/implementations/types via Snacks.",
}
