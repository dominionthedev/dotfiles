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
vim.opt.mousemoveevent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = "menuone,noselect"
vim.opt.smoothscroll = true
vim.opt.splitkeep = "screen"
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.cmdheight = 0
vim.opt.pumheight = 10
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.fillchars = {
    fold = " ",
    foldopen = "",
    foldclose = "",
    foldsep = " ",
}
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
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

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
                    treesitter = true,
                    bufferline = true,
                    which_key = true,
                    snacks = true,
                    noice = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            warnings = { "italic" },
                            hints = { "italic" },
                            information = { "italic" },
                        },
                    },
                    mini = { enabled = true },
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
                    ]],
                },
            },
            picker = {
                enabled = true,
                layout = { preset = "ivy" },
                sources = { explorer = { hidden = true } }
            },
            gh = { enabled = true },
            git = { enabled = true },
            debug = { enabled = true },
            scratch = { enabled = true },
            explorer = {
                enabled = true,
                replace_netrw = true,
                follow_file = true,
                auto_close = false,
            },
            input = { enabled = true },
            scope = { enabled = true },
            indent = { enabled = true },
            words = { enabled = true },
            scroll = { enabled = true },
            animate = { enabled = true },
            terminal = { enabled = true },
            lazygit = { enabled = true },
            rename = { enabled = true },
            image = { enabled = true },
            zen = { enabled = true },
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
            lsp = {
                progress = { enabled = true, view = "mini" },
                hover = { enabled = true },
                signature = { enabled = true },
            },
            presets = {
                long_message_to_split = true,
                lsp_doc_border = true,
                inc_rename = true
            },
        },
    },

    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
            vim.notify = require("notify")
        end
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
                    disabled_filetypes = {
                        statusline = { "snacks_dashboard" },
                    },
                },
                sections = {
                    lualine_a = { { "mode", icons_enabled = true, } },
                    lualine_b = {
                        { "branch", icon = "󰘬" },
                        "diff",
                        "diagnostics",
                    },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                }
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
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { 'close' }
                    },
                },
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
            require("nvim-treesitter").setup(opts)
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
            "windwp/nvim-autopairs"
        },
        config = function()
            -- ====================== CMP ======================
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
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
                sorting = { priority_weight = 2 },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                experimental = { ghost_text = true },
                formatting = {
                    format = function(_, vim_item)
                        local icons = {
                            Text          = "󰉿",
                            Method        = "󰆧",
                            Function      = "󰊕",
                            Constructor   = "",
                            Field         = "󰜢",
                            Variable      = "󰀫",
                            Class         = "󰠱",
                            Interface     = "",
                            Module        = "󰏗",
                            Property      = "󰜢",
                            Unit          = "󰑭",
                            Value         = "󰎠",
                            Enum          = "",
                            Keyword       = "󰌋",
                            Snippet       = "",
                            Color         = "󰏘",
                            File          = "󰈙",
                            Reference     = "󰈇",
                            Folder        = "󰉋",
                            EnumMember    = "",
                            Constant      = "󰏿",
                            Struct        = "󰙅",
                            Event         = "",
                            Operator      = "󰆕",
                            TypeParameter = "󰊄",
                        }
                        vim_item.kind = (icons[vim_item.kind] or "") .. " " .. vim_item.kind
                        return vim_item
                    end,
                },
            })
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )

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
                map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                map("n", "K", vim.lsp.buf.hover, "Hover docs")
                map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature help")

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
            -- Python: ty (definitions/types) + ruff (linting/formatting)
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
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                }
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
            -- vim.lsp.config("zls", {
            --    capabilities = capabilities,
            --    on_attach = on_attach,
            --})
            --vim.lsp.enable('zls')

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
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "▎" },
                    change       = { text = "▎" },
                    delete       = { text = "-" },
                    topdelete    = { text = "-" },
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

    {
        "folke/which-key.nvim",
        opts = { preset = "modern" },
    },

    { "numToStr/Comment.nvim",  config = true },
    { "kylechui/nvim-surround", config = true },

}, { checker = { enabled = true, notify = true } })

-- ============================================================================
-- Diagnostics & Final Setup
-- ============================================================================
vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
        spacing = 4,
        prefix = "",
    },
    float = {
        border = "rounded",
        source = "if_many",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌵 ",
        },
    },
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
keymap("n", "<leader>e", function() Snacks.explorer() end, opts)
keymap("n", "<leader>ff", function() Snacks.picker.files() end)
keymap("n", "<leader>fg", function() Snacks.picker.grep() end)
keymap("n", "<leader>fb", function() Snacks.picker.buffers() end, opts)
keymap("n", "<leader>p", function() Snacks.picker.commands() end)
keymap("n", "<leader>z", function() Snacks.zen() end, opts)
keymap("n", "<leader>gl", function() Snacks.lazygit() end, opts)
keymap("n", "<leader>gb", function() Snacks.git.blame_line() end, opts)
keymap("n", "<leader>fr", function() Snacks.picker.recent() end)
keymap("n", "<leader>..", function() Snacks.scratch() end, opts)
keymap("n", "<leader>.l", function() Snacks.scratch.list() end, opts)
keymap("n", "<leader>.s", function() Snacks.scratch.select() end, opts)
keymap("n", "<leader>fk", function() Snacks.picker.keymaps() end)
keymap("n", "<leader>fh", function() Snacks.picker.help() end)
keymap("n", "<leader>fd", function() Snacks.picker.diagnostics() end)
keymap("n", "<leader>fs", function() Snacks.picker.lsp_symbols() end)
keymap("n", "<leader>fS", function() Snacks.picker.workspace_symbols() end)
keymap("n", "<leader>gc", function() Snacks.picker.git_log() end)
keymap("n", "<leader>gs", function() Snacks.picker.git_status() end)
keymap("n", "<leader>fo", function() Snacks.picker.oldfiles() end)
keymap("n", "<leader>fm", function() Snacks.picker.marks() end)
keymap("n", "<leader>gbc", function() Snacks.picker.git_branches() end)
keymap("n", "<leader>gf", function() Snacks.picker.git_files() end)
keymap("n", "gr", function() Snacks.picker.lsp_references() end)
keymap("n", "gd", function() Snacks.picker.lsp_definitions() end)
keymap("n", "gi", function() Snacks.picker.lsp_implementations() end)
keymap("n", "gt", function() Snacks.picker.lsp_type_definitions() end)
keymap("n", "<leader>ghi", function() Snacks.gh.issues() end, opts)
keymap("n", "<leader>ghp", function() Snacks.gh.pull_requests() end, opts)
keymap("n", "<leader>ghc", function() Snacks.gh.checkout() end, opts)
keymap("n", "<leader>ghb", function() Snacks.gh.branches() end, opts)
keymap("n", "<leader>ghs", function() Snacks.gh.search() end, opts)
keymap("n", "<leader>H", function()
    vim.cmd("enew")
    Snacks.dashboard.open()
end)
keymap("n", "?", function() require("which-key").show({ global = true }) end)
keymap("n", "g?", function() require("which-key").show({ global = false }) end)
keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "<leader>vd", vim.diagnostic.open_float)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<leader>w", "<cmd>w<cr>", opts)
keymap("n", "<leader>q", "<cmd>q<cr>", opts)
keymap("n", "<leader>Q", "<cmd>qa<cr>", opts)
keymap("n", "<leader>x", "<cmd>x<cr>", opts)
keymap("n", "<S-h>", "<cmd>bprevious<cr>", opts)
keymap("n", "<S-l>", "<cmd>bnext<cr>", opts)
keymap("n", "<leader>bd", "<cmd>BufferLinePickClose<cr>", opts)
keymap("n", "<leader>ba", "<cmd>BufferLineCloseOthers<cr>", opts)
keymap("n", "<leader>bg", "<cmd>BufferLinePick<cr>", opts)
keymap("n", "<leader>bp", "<cmd>BufferLineMoveNext<cr>", opts)
keymap("n", "<leader>bn", "<cmd>BufferLineMovePrev<cr>", opts)
keymap("n", "<leader>bi", "<cmd>BufferLineTogglePin<cr>", opts)
keymap("n", "<esc>", "<cmd>nohlsearch<cr>", opts)
keymap("n", "<leader>tt", function() Snacks.terminal() end, opts)
keymap("t", "<esc>", [[<C-\><C-n>]], opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", opts)
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", opts)
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

vim.notify("🔥 NeoVim OS MODE Activated")
