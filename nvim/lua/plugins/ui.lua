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
        "echasnovski/mini.icons",
        lazy = false,
        priority = 1001,
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },

    {
        "sindrets/diffview.nvim",

        cmd = {
            "DiffviewOpen",
            "DiffviewFileHistory",
            "DiffviewClose",
        },

        keys = {
            {
                "<leader>gd",
                "<cmd>DiffviewOpen<CR>",
                desc = "Git diff",
            },
            {
                "<leader>gh",
                "<cmd>DiffviewFileHistory %<CR>",
                desc = "File history",
            },
            {
                "<leader>gH",
                "<cmd>DiffviewFileHistory<CR>",
                desc = "Project history",
            },
        },

        opts = {
            enhanced_diff_hl = true,

            file_panel = {
                listing_style = "tree",
                win_config = {
                    width = 35,
                },
            },

            view = {
                merge_tool = {
                    layout = "diff3_mixed",
                },
            },
        },
    },

    {
        "alexpasmantier/tv.nvim",
        config = function()
            -- built-in niceties
            local h = require("tv").handlers

            require("tv").setup({
                layout = "landscape", -- "landscape" (default) or "portrait"
                -- global window appearance (can be overridden per channel)
                window = {
                    width = 0.8,  -- 80% of editor width
                    height = 0.8, -- 80% of editor height
                    border = "none",
                    title = " tv.nvim ",
                    title_pos = "center",
                },
                -- per-channel configurations
                channels = {
                    -- `files`: fuzzy find files in your project
                    files = {
                        layout = "portrait",  --- override global setting for this channel
                        keybinding = "<C-p>", -- Launch the files channel
                        -- what happens when you press a key
                        handlers = {
                            ["<CR>"] = h.open_as_files,      -- default: open selected files
                            ["<C-q>"] = h.send_to_quickfix,  -- send to quickfix list
                            ["<C-s>"] = h.open_in_split,     -- open in horizontal split
                            ["<C-v>"] = h.open_in_vsplit,    -- open in vertical split
                            ["<C-y>"] = h.copy_to_clipboard, -- copy paths to clipboard
                        },
                    },

                    -- `text`: ripgrep search through file contents
                    text = {
                        keybinding = "<leader><leader>",
                        handlers = {
                            ["<CR>"] = h.open_at_line,       -- Jump to line:col in file
                            ["<C-q>"] = h.send_to_quickfix,  -- Send matches to quickfix
                            ["<C-s>"] = h.open_in_split,     -- Open in horizontal split
                            ["<C-v>"] = h.open_in_vsplit,    -- Open in vertical split
                            ["<C-y>"] = h.copy_to_clipboard, -- Copy matches to clipboard
                        },
                    },

                    -- `env`: search environment variables
                    env = {
                        keybinding = "<leader>ev",
                        handlers = {
                            ["<CR>"] = h.insert_at_cursor,    -- Insert at cursor position
                            ["<C-l>"] = h.insert_on_new_line, -- Insert on new line
                            ["<C-y>"] = h.copy_to_clipboard,
                        },
                    },

                    -- `aliases`: search shell aliases
                    alias = {
                        keybinding = "<leader>al",
                        handlers = {
                            ["<CR>"] = h.insert_at_cursor,
                            ["<C-y>"] = h.copy_to_clipboard,
                        },
                    },
                },

                tv_binary = "tv",
                global_keybindings = {
                    channels = "<leader>tv", -- opens the channel selector
                },
                quickfix = {
                    auto_open = true, -- automatically open quickfix window after populating
                },
            })
        end,
    },

    {
        "numToStr/Comment.nvim",

        event = {
            "BufReadPre",
            "BufNewFile",
        },

        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },

        opts = {
            padding = true,
            sticky = true,
            ignore = "^$",
        },
    },

    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        ft = { "markdown" },

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },

        opts = {
            preview = {
                enable = false,
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
