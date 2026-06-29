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
        "OXY2DEV/markview.nvim",
        ft = { "markdown" },

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
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
