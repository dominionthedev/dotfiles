-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Leader & Core Settings
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.opt.pumheight = 10

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true

-- ============================================================================
-- Plugin Configuration
-- ============================================================================

require("lazy").setup({

    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
                term_colors = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    bufferline = true,
                    indent_blankline = { enabled = true },
                    native_lsp = { enabled = true },
                    dap = true,
                    neotest = true,
                    snacks = true,
                    mini = { enabled = true },
                    noice = true,
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        config = true,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            notifier = { enabled = true, timeout = 3000 },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
▓█████▄  ▒█████   ███▄ ▄███▓ ██▓ ███▄    █  ██▓ ▒█████   ███▄    █ ▓█████▄ ▓█████ ██▒   █▓
▒██▀ ██▌▒██▒  ██▒▓██▒▀█▀ ██▒▓██▒ ██ ▀█   █ ▓██▒▒██▒  ██▒ ██ ▀█   █ ▒██▀ ██▌▓█   ▀▓██░   █▒
░██   █▌▒██░  ██▒▓██    ▓██░▒██▒▓██  ▀█ ██▒▒██▒▒██░  ██▒▓██  ▀█ ██▒░██   █▌▒███   ▓██  █▒░
░▓█▄   ▌▒██   ██░▒██    ▒██ ░██░▓██▒  ▐▌██▒░██░▒██   ██░▓██▒  ▐▌██▒░▓█▄   ▌▒▓█  ▄  ▒██ █░░
░▒████▓ ░ ████▓▒░▒██▒   ░██▒░██░▒██░   ▓██░░██░░ ████▓▒░▒██░   ▓██░░▒████▓ ░▒████▒  ▒▀█░
 ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░   ░  ░░▓  ░ ▒░   ▒ ▒ ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░░ ▒░ ░  ░ ▐░
 ░ ░  ░ ░ ░ ░ ▒  ░      ░    ▒ ░   ░   ░ ░  ▒ ░░ ░ ░ ▒     ░   ░ ░  ░ ░  ░    ░       ░░
   ░        ░ ░         ░    ░           ░  ░      ░ ░           ░    ░       ░  ░     ░
                              🔥 Nvim Power Mode 🔥
          ]],
                },
            },
            picker = { enabled = true },
            scroll = { enabled = true },
            words = { enabled = true },
            animate = { enabled = true },
            terminal = { enabled = true },
            rename = { enabled = true },
            lazygit = { enabled = true },
            image = { enabled = true },
            gh = { enabled = true },
            zen = { enabled = true }
        },
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        opts = {
            cmdline = { enabled = true },
            messages = { enabled = true },
            popupmenu = { enabled = true },
            lsp = { progress = { enabled = true } },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = require("catppuccin.utils.lualine")(),
                    component_separators = { left = "│", right = "│" },
                    section_separators = { left = "", right = "" },
                    icons_enabled = true,
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "lsp_progress", "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = true,
                },
            })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "│" },
                scope = { enabled = true },
            })
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup({
                view = { width = 35, side = "left" },
                renderer = {
                    group_empty = true,
                    icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
                },
                filters = { dotfiles = false },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        lazy = vim.fn.argc(-1) == 0,
        opts = {
            ensure_installed = {
                "lua", "vim", "vimdoc",
                "python", "javascript", "typescript",
                "rust", "go", "zig",
                "html", "css", "json", "yaml",
                "markdown", "bash",
            },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts) -- DO NOT Change, mind your business, Nosy brat!
        end,
    },

    -- ==================== LSP CONFIG ====================
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            -- ====================== CMP ======================
            local cmp = require("cmp")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
                experimental = { ghost_text = true },
            })

            -- ====================== Capabilities & on_attach ======================

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local function on_attach(client, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = bufnr,
                        silent = true,
                        desc = desc,
                    })
                end

                -- ====================== LSP navigation ======================
                map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
                map("n", "gr", vim.lsp.buf.references, "References")
                map("n", "K", vim.lsp.buf.hover, "Hover docs")
                map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

                -- ====================== Actions ======================
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                map(
                    "n",
                    "<leader>cf",
                    function()
                        vim.lsp.buf.format({ async = true })
                    end,
                    "Format"
                )

                -- ====================== Workspace ======================
                map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
                map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
                map("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "List workspace folders")

                -- ====================== Semantic tokens control ======================
                if client.server_capabilities.semanticTokensProvider then
                    local ft = vim.bo[bufnr].filetype

                    -- keep semantic tokens for these; Treesitter handles the rest
                    local keep = { "rust", "go" }
                    local allowed = false

                    for _, v in ipairs(keep) do
                        if v == ft then
                            allowed = true
                            break
                        end
                    end

                    if not allowed then
                        client.server_capabilities.semanticTokensProvider = nil
                    end
                end
            end

            -- ====================== LSP Configurations ======================

            -- Python: ty (fast) + ruff (linting/formatting)
            vim.lsp.config("ty", {
                cmd = { "ty", "server" },
                filetypes = { "python" },
                root_markers = { "pyproject.toml", "uv.lock", ".git" },
                single_file_support = true,
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("ty")

            vim.lsp.config("ruff", {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    client.server_capabilities.hoverProvider = false
                    on_attach(client, bufnr)
                end,
                init_options = {
                    settings = {
                        lineLength = 100,
                    },
                },
            })
            vim.lsp.enable("ruff")

            -- Lua
            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("lua_ls")

            -- TypeScript / JavaScript
            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("ts_ls")

            -- Rust
            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                on_attach = on_attach,
                -- settings
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = { command = "clippy" },
                    },
                },
            })
            vim.lsp.enable("rust_analyzer")

            -- Go
            vim.lsp.config("gopls", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("gopls")

            -- Zig
            vim.lsp.config("zls", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable('zls')

            -- Toml
            vim.lsp.config("taplo", {
                capabilities = capabilities,
                on_attach = on_attach
            })
            vim.lsp.enable("taplo")

            -- YAML
            vim.lsp.config("yamlls", {
                cmd = { "yaml-language-server", "--stdio" },
                capabilities = capabilities,
                on_attach = on_attach,
                -- settings
                settings = {
                    yaml = {
                        validate = true,
                        schemaStore = { enable = true },
                    },
                },
            })
            vim.lsp.enable("yamlls")

            -- Markdown
            vim.lsp.config("marksman", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("marksman")
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "▎" },
                    change       = { text = "▎" },
                    delete       = { text = "" },
                    topdelete    = { text = "" },
                    changedelete = { text = "▎" },
                },

                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local map = function(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                    end

                    map("n", "]h", gs.next_hunk, "Next hunk")
                    map("n", "[h", gs.prev_hunk, "Prev hunk")

                    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                    map("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end, "Blame line")

                    map("n", "<leader>hd", gs.diffthis, "Diff this")
                end,
            })
        end,
    },

    { "lewis6991/gitsigns.nvim", config = true },
    { "windwp/nvim-autopairs",   config = true },
    { "numToStr/Comment.nvim",   config = true },
    { "kylechui/nvim-surround",  config = true },
    { "folke/which-key.nvim",    config = true },

}, { checker = { enabled = false } })

-- ============================================================================
-- Diagnostics & Final Setup
-- ============================================================================
vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    severity_sort = true,
    float = { border = "rounded", source = true },
    underline = true,
})

-- ============================================================================
-- Keymaps
-- ============================================================================
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- File tree
keymap("n", "<leader>e", function()
    require("nvim-tree.api").tree.toggle({ focus = true })
end)

-- Snacks pickers
keymap("n", "<leader>ff", function() Snacks.picker.files() end)
keymap("n", "<leader>fg", function() Snacks.picker.grep() end)
keymap("n", "<leader>fb", function() Snacks.picker.buffers() end, opts)
keymap("n", "<leader>p", function() Snacks.picker.commands() end)

-- Snacks extras
keymap("n", "<leader>z", function() Snacks.zen() end, opts)
keymap("n", "<leader>gl", function() Snacks.lazygit() end, opts)
keymap("n", "<leader>gb", function() Snacks.git.blame_line() end, opts)
keymap("n", "<leader>un", function() Snacks.notifier.hide() end, opts)

-- Dashboard
keymap("n", "<leader>H", function()
    vim.cmd("enew")
    require("snacks.dashboard").open()
end)

-- Which-key
keymap("n", "?", function()
    require("which-key").show({ global = true })
end)

keymap("n", "g?", function()
    require("which-key").show({ global = false })
end)

-- Diagnostics navigation
keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "<leader>vd", vim.diagnostic.open_float)

-- Centered scrolling behavior
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- LSP buffer keymaps (fallback layer)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufopts = { buffer = args.buf }

        keymap("n", "gd", vim.lsp.buf.definition, bufopts)
        keymap("n", "gr", vim.lsp.buf.references, bufopts)
        keymap("n", "K", vim.lsp.buf.hover, bufopts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    end,
})

-- File operations
keymap("n", "<leader>w", "<cmd>w<cr>", opts)
keymap("n", "<leader>q", "<cmd>q<cr>", opts)
keymap("n", "<leader>Q", "<cmd>qa<cr>", opts)
keymap("n", "<leader>x", "<cmd>x<cr>", opts)

-- Buffer navigation
keymap("n", "<S-h>", "<cmd>bprevious<cr>", opts)
keymap("n", "<S-l>", "<cmd>bnext<cr>", opts)
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", opts)

-- Search
keymap("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

-- Terminal
keymap("n", "<leader>tt", function() Snacks.terminal() end, opts)
keymap("t", "<esc>", [[<C-\><C-n>]], opts)

-- Editing helpers
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", opts)
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", opts)
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

print("🔥 DominionDev NeoVim OS MODE")
