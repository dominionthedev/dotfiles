-- Keymaps

local custom = require("config.custom")
local keymap = vim.keymap.set

local function map(mode, lhs, rhs, desc, extra)
    local o = vim.tbl_extend("force", { noremap = true, silent = true, desc = desc }, extra or {})
    keymap(mode, lhs, rhs, o)
end

-- ── Window navigation ─────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to window below")
map("n", "<C-k>", "<C-w>k", "Go to window above")
map("n", "<C-l>", "<C-w>l", "Go to right window")

-- ── File / buffer management ──────────────────────────────────────
map("n", "<leader>e", function() Snacks.explorer() end, "File explorer")
map("n", "<leader>w", "<cmd>w<cr>", "Save file")
map("n", "<leader>q", "<cmd>q<cr>", "Quit window")
map("n", "<leader>Q", "<cmd>qa<cr>", "Quit all")
map("n", "<leader>x", "<cmd>x<cr>", "Save and quit")
map("n", "<leader>rf", function() Snacks.rename.rename_file() end, "Rename file")

map("n", "<S-h>", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bd", "<cmd>BufferLinePickClose<cr>", "Pick buffer to close")
map("n", "<leader>ba", "<cmd>BufferLineCloseOthers<cr>", "Close other buffers")
map("n", "<leader>bg", "<cmd>BufferLinePick<cr>", "Pick buffer")
map("n", "<leader>bp", "<cmd>BufferLineMoveNext<cr>", "Move buffer right")
map("n", "<leader>bn", "<cmd>BufferLineMovePrev<cr>", "Move buffer left")
map("n", "<leader>bi", "<cmd>BufferLineTogglePin<cr>", "Toggle pin buffer")

-- ── Find / picker (Snacks) ────────────────────────────────────────
map("n", "<leader>ff", function() Snacks.picker.files() end, "Find files")
map("n", "<leader>fg", function() Snacks.picker.grep() end, "Grep workspace")
map("n", "<leader>fb", function() Snacks.picker.buffers() end, "Find buffers")
map("n", "<leader>fr", function() Snacks.picker.recent() end, "Recent files")
map("n", "<leader>fk", function() Snacks.picker.keymaps() end, "Find keymaps")
map("n", "<leader>fh", function() Snacks.picker.help() end, "Find help")
map("n", "<leader>fd", function() Snacks.picker.diagnostics() end, "Find diagnostics")
map("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end, "Find LSP symbols (buffer)")
map("n", "<leader>fS", function() Snacks.picker.workspace_symbols() end, "Find LSP symbols (workspace)")
map("n", "<leader>fm", function() Snacks.picker.marks() end, "Find marks")
map("n", "<leader>p", function() Snacks.picker.commands() end, "Command palette")

-- ── Git (Snacks pickers + lazygit/blame) ──────────────────────────
map("n", "<leader>gl", function() Snacks.lazygit() end, "Open lazygit")
map("n", "<leader>gb", function() Snacks.git.blame_line() end, "Blame line (popup)")
map("n", "<leader>gc", function() Snacks.picker.git_log() end, "Git log")
map("n", "<leader>gs", function() Snacks.picker.git_status() end, "Git status")
map("n", "<leader>gf", function() Snacks.picker.git_files() end, "Git files")
map("n", "<leader>gbc", function() Snacks.picker.git_branches() end, "Git branches")

-- ── GitHub  ────────────────────────────────────
map("n", "<leader>ghi", function() Snacks.picker.gh_issue() end, "GitHub issues")
map("n", "<leader>ghp", function() Snacks.picker.gh_pr() end, "GitHub pull requests")

-- ── LSP go-to (Snacks pickers) ─────────────────────────────────────
map("n", "gr", function() Snacks.picker.lsp_references() end, "Go to references")
map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")

-- ── Diagnostics ────────────────────────────────────────────────────
map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "<leader>vd", vim.diagnostic.open_float, "Line diagnostics float")
map("n", "<leader>ie", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    vim.cmd("normal! zz")
    vim.cmd("startinsert")
end, "Next error and insert")

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (buffer)")
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Diagnostics (workspace)")
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix list")
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", "Location list")
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols outline")
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    "LSP references/definitions/etc (Trouble)")

-- ── Formatting ─────────────────────────────────────────────────────
map("n", "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, "Format buffer")

-- ── UI toggles ─────────────────────────────────────────────────────
map("n", "<leader>o", function()
    local transparent = require("config.theme").toggle()
    vim.notify("Transparent mode " .. tostring(transparent))
end, "Toggle transparent background")
map("n", "<leader>z", function() Snacks.zen() end, "Zen mode")
map("n", "<leader>H", function()
    vim.cmd("enew")
    Snacks.dashboard.open()
end, "Open dashboard")
map("n", "?", function() require("which-key").show({ global = true }) end, "Show all keymaps")
map("n", "g?", function() require("which-key").show({ global = false }) end, "Show buffer keymaps")
map("n", "<leader>vb", function() Snacks.debug.backtrace() end, "Lua backtrace")

-- ── Word reference jump (Snacks.words, LSP document highlight) ────
map("n", "[[", function() Snacks.words.jump(-1) end, "Prev reference")
map("n", "]]", function() Snacks.words.jump(1) end, "Next reference")

-- ── Scratch buffers ────────────────────────────────────────────────
map("n", "<leader>..", function() Snacks.scratch() end, "Toggle scratch buffer")
map("n", "<leader>.l", function() Snacks.scratch.list() end, "List scratch buffers")
map("n", "<leader>.s", function() Snacks.scratch.select() end, "Select scratch buffer")

-- ── Terminal ───────────────────────────────────────────────────────
map("n", "<leader>tt", function() Snacks.terminal() end, "Toggle terminal")
map("t", "<esc>", [[<C-\><C-n>]], "Exit terminal mode")

-- ── Markdown / notes (markview + custom workspace logic) ──────────
map("n", "<leader>mp", "<cmd>Markview splitToggle<CR>", "Toggle markdown preview split")
map("n", "<leader>mn", custom.new_note, "New note")
map("n", "<leader>mf", custom.find_note, "Find note")
map("n", "<leader>ms", custom.grep_notes, "Search notes")
map("n", "<leader>mw", custom.switch_workspace, "Switch workspace")
map("n", "<leader>mj", custom.open_jotting, "Open jotting.md")

-- ── Search / scroll behaviour ──────────────────────────────────────
map("n", "<esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
map("n", "n", "nzzzv", "Next search result (centered)")
map("n", "N", "Nzzzv", "Previous search result (centered)")
map("n", "<C-d>", "<C-d>zz", "Scroll down (centered)")
map("n", "<C-u>", "<C-u>zz", "Scroll up (centered)")

-- ── Editing ─────────────────────────────────────────────────────────
map("v", "<", "<gv", "Indent left (stay in visual)")
map("v", ">", ">gv", "Indent right (stay in visual)")
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
map("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move selection up")

-- Insert mode
map("i", "<C-l>", "<C-o>==", "Reindent line")
map("i", ",", ",<C-g>u", "Comma (undo breakpoint)")
map("i", ".", ".<C-g>u", "Period (undo breakpoint)")
map("i", ";", ";<C-g>u", "Semicolon (undo breakpoint)")

-- luasnip choice-cycling.
keymap({ "i", "s" }, "<A-l>", function()
    if require("luasnip").choice_active() then
        require("luasnip").change_choice(1)
    end
end, { desc = "Next snippet choice", noremap = true, silent = true })
