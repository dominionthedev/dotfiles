return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = require("config.theme").is_transparent(),
                term_colors = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    treesitter = true,
                    bufferline = true,
                    lualine = true,
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

                    mini = {
                        enabled = true,
                    },
                },
                custom_highlights = function(colors)
                    return {
                        NoiceMini = { bg = colors.mantle },
                        NoiceMiniIcon = { bg = colors.mantle },
                        NoiceMiniTitle = { bg = colors.mantle },
                        NoiceMiniProgress = { bg = colors.mantle },
                    }
                end,

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
        "OXY2DEV/markview.nvim",
        ft = { "markdown" },

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            preview = {
                enable = true,
                hybrid_modes = { "n" },
            },

            markdown = {
                headings = {
                    shift_width = 1,
                },
            },

            code_blocks = {
                style = "block",
            },

            tables = {
                enable = true,
            },

            checkboxes = {
                enable = true,
            },

            links = {
                enable = true,
            },
        },
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*",
        ft = "markdown",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },

        opts = {
            workspaces = {
                {
                    name = "Notes",
                    path = "~/Developer/notes",
                },
                {
                    name = "Vault",
                    path = "~/Developer/vault",
                },
            },

            disable_frontmatter = true,

            preferred_link_style = "wiki",

            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },

            ui = {
                enable = false,
            },
        },

        config = function(_, opts)
            require("obsidian").setup(opts)

            local function workspace_picker(callback)
                vim.ui.select(
                    { "Notes", "Vault" },
                    { prompt = "Workspace" },
                    function(choice)
                        if not choice then
                            return
                        end

                        vim.cmd("ObsidianWorkspace " .. choice)
                        callback(choice)
                    end
                )
            end

            local function new_note()
                workspace_picker(function()
                    vim.cmd("ObsidianNew")
                end)
            end

            local function find_note()
                workspace_picker(function(choice)
                    local cwd = choice == "Notes"
                        and "~/Developer/notes"
                        or "~/Developer/vault"

                    Snacks.picker.files({
                        cwd = vim.fn.expand(cwd),
                    })
                end)
            end

            local function grep_notes()
                Snacks.picker.grep({
                    dirs = {
                        vim.fn.expand("~/Developer/notes"),
                        vim.fn.expand("~/Developer/vault"),
                    },
                })
            end

            local function list_notes()
                Snacks.picker.files({
                    dirs = {
                        vim.fn.expand("~/Developer/notes"),
                        vim.fn.expand("~/Developer/vault"),
                    }
                })
            end

            vim.keymap.set("n", "<leader>nn", new_note, {
                desc = "New note",
            })

            vim.keymap.set("n", "<leader>nf", find_note, {
                desc = "Find note",
            })

            vim.keymap.set("n", "<leader>ns", grep_notes, {
                desc = "Search notes",
            })

            vim.keymap.set("n", "<leader>no", list_notes, {
                desc = "List and Pick notes",
            })

            vim.keymap.set("n", "<leader>nb", "<cmd>ObsidianBacklinks<CR>", {
                desc = "Backlinks",
            })

            vim.keymap.set("n", "<leader>nl", "<cmd>ObsidianLinks<CR>", {
                desc = "Outgoing links",
            })

            vim.keymap.set("n", "<leader>nr", "<cmd>ObsidianRename<CR>", {
                desc = "Rename note",
            })

            vim.keymap.set("n", "<leader>nw", function()
                workspace_picker(function() end)
            end, {
                desc = "Switch workspace",
            })

            vim.keymap.set("n", "<leader>nj", function()
                vim.cmd.edit(vim.fn.expand("~/Developer/vault/jotting.md"))
            end, {
                desc = "Open jotting",
            })

            vim.keymap.set("n", "gf", function()
                if require("obsidian").util.cursor_on_markdown_link() then
                    return "<cmd>ObsidianFollowLink<CR>"
                end
                return "gf"
            end, {
                expr = true,
                desc = "Follow markdown link",
            })
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
        },
    },
}
