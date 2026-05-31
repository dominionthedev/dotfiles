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
                    telescope = true,
                    bufferline = true,
                    indent_blankline = { enabled = true },
                    native_lsp = { enabled = true },
                    dap = true,
                    neotest = true,
                    snacks = true,
                    mini = { enabled = true },
                    noice = true,
                    flash = true,
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
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
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
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = { prompt_prefix = " ", selection_caret = " " },
            })
            telescope.load_extension("fzf")
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
                "rust", "go", "c", "cpp",
                "html", "css", "json", "yaml",
                "markdown", "bash",
            },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts) -- Works for me
        end,
    },

    -- ==================== LSP CONFIG ====================
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            -- ====================== Mason ======================
            require("mason").setup()

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    -- ts_ls, zls, taplo rust_analyzer, yamlls, gopls, ty, ruff are local
                },
            })

            -- ====================== CMP ======================
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
                experimental = { ghost_text = true },
            })

            -- ====================== Capabilities & on_attach ======================
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local function on_attach(client, bufnr)
                -- add keymaps/settings here later
            end

            -- ====================== LSP Configurations ======================

            -- Python: ty + ruff (linting/formatting)
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

            -- add more Useful LSPs
        end,
    },

    -- fix these

    { "lewis6991/gitsigns.nvim", config = true },
    { "kdheepak/lazygit.nvim",   dependencies = { "nvim-lua/plenary.nvim" } },
    { "windwp/nvim-autopairs",   config = true },
    { "numToStr/Comment.nvim",   config = true },
    { "kylechui/nvim-surround",  config = true },
    { "folke/which-key.nvim",    config = true },
    { "akinsho/toggleterm.nvim", config = function() require("toggleterm").setup({ direction = "float" }) end },

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

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>e", function()
    require("nvim-tree.api").tree.toggle({ focus = true })
end)

keymap("n", "<leader>ff", function() Snacks.picker.files() end)
keymap("n", "<leader>fg", function() Snacks.picker.grep() end)
keymap("n", "<leader>fb", function() require("telescope.builtin").buffers() end)

keymap("n", "<leader>p", function() Snacks.picker.commands() end)

keymap("n", "<leader>H", function()
    vim.cmd("enew")
    require("snacks.dashboard").open()
end)

keymap("n", "?", function()
    require("which-key").show({ global = true })
end)

keymap("n", "g?", function()
    require("which-key").show({ global = false })
end)

keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "<leader>vd", vim.diagnostic.open_float)

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

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

print("🔥 DominionDev NeoVim Activated")
