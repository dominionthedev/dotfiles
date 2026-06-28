local augroup = vim.api.nvim_create_augroup("dominion_autocmds", { clear = true })

-- "Did you know..." startup tip
-- Shows one random tip from config/startup_tips.lua via vim.notify
-- (routed through nvim-notify, same as everything else in this
-- config). Deferred slightly past VimEnter so it doesn't compete with
-- the dashboard/lazy-sync notifications that also fire on startup —
-- showing all of them at once just becomes noise instead of a tip.
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    desc = "Show a random startup tip",
    callback = function()
        -- skip if nvim was opened to actually do something specific
        -- (a file path, stdin, etc.) rather than just launched bare —
        -- the tip is for the "just opened nvim casually" case, where
        -- the dashboard is what's on screen.
        if vim.fn.argc() > 0 then
            return
        end

        vim.defer_fn(function()
            local tips = require("config.startup_tips")
            if #tips == 0 then
                return
            end

            local tip = tips[math.random(#tips)]
            vim.notify(tip, vim.log.levels.INFO, { title = "Did you know?" })
        end, 300)
    end,
})


vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore cursor position",
    callback = function(event)
        local exclude = {
            gitcommit = true,
            gitrebase = true,
            svn = true,
            hgcommit = true,
        }

        local ft = vim.bo[event.buf].filetype
        if exclude[ft] then
            return
        end

        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')[1]
        local line_count = vim.api.nvim_buf_line_count(event.buf)

        if mark > 1 and mark <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, { mark, 0 })
        end
    end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    desc = "Highlight yanked text",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 150,
        })
    end,
})

-- Create parent dirs on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    desc = "Create parent directories on save",
    callback = function(event)
        if event.match:match("^%w+://") then
            return
        end

        local file = vim.uv.fs_realpath(event.match) or event.match
        local dir = vim.fn.fnamemodify(file, ":p:h")
        vim.fn.mkdir(dir, "p")
    end,
})

-- Close some temporary windows with q
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    desc = "Close some filetypes with q",
    pattern = {
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "checkhealth",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
        "neotest-output",
        "neotest-summary",
        "dbout",
        "gitsigns-blame",
        "dap-repl",
        "dapui_scopes",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_watches",
        "dapui_console",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc = "Close window",
        })
    end,
})

-- Check if file changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup,
    desc = "Check if file changed outside of Neovim",
    command = "checktime",
})

-- Resize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    desc = "Resize splits on vim resized",
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Keep cursorline only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    group = augroup,
    desc = "Enable cursorline in active window",
    callback = function()
        if vim.bo.buftype ~= "nofile" then
            vim.wo.cursorline = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    group = augroup,
    desc = "Disable cursorline in inactive window or insert mode",
    callback = function()
        vim.wo.cursorline = false
    end,
})

-- Wrap + spell for text-like buffers
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    desc = "Enable wrap and spell in text-like files",
    pattern = { "gitcommit", "markdown", "text", "plaintex" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.linebreak = true
        vim.opt_local.conceallevel = 2
    end,
})

-- Better local settings for json/yaml/etc
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    desc = "2-space indent for common config/data files",
    pattern = {
        "json",
        "jsonc",
        "yaml",
        "yml",
        "toml",
        "html",
        "css",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

-- Don’t continue comments automatically on o/O or Enter
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    desc = "Disable comment continuation",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Terminal defaults
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    desc = "Terminal local options",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.cmd("startinsert")
    end,
})

-- Quickfix/location list niceties
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    desc = "Quickfix settings",
    pattern = { "qf" },
    callback = function()
        vim.opt_local.wrap = false
    end,
})

-- Strip visual clutter inside dapui's own inspector panels (scopes, stacks,
-- breakpoints, watches). These are dense, narrow side panels; line numbers
-- and cursorline just add noise.
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    desc = "Declutter dapui panels",
    pattern = {
        "dapui_scopes",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_watches",
    },
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.statuscolumn = ""
        vim.opt_local.cursorline = false
    end,
})

-- Briefly show diagnostics on current line when cursor stops
vim.api.nvim_create_autocmd("CursorHold", {
    group = augroup,
    desc = "Show line diagnostics in a non-focusable float",
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = {
                "BufLeave",
                "CursorMoved",
                "InsertEnter",
                "FocusLost",
            },
            border = "rounded",
            source = "if_many",
            scope = "line",
        })
    end,
})
