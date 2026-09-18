return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "auto",
                background = {
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = require("config.theme").is_transparent(),
                term_colors = true,
                default_integrations = true,
                auto_integrations = true,
                integrations = {
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "bold" },
                            warnings = { "undercurl" },
                            hints = { "italic" },
                            information = { "italic" },
                        },
                    },
                    mini = {
                        enabled = true,
                        indentscope_color = "overlay2",
                    },
                },
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    functions = { "bold" },
                    strings = { "italic" },
                    types = { "underline" },
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
        "rasulomaroff/reactive.nvim",
        event = "VeryLazy",
        opts = {
            load = {
                "catppuccin-mocha-cursor",
                "catppuccin-mocha-cursorline",
            },
            builtin = {
                cursorline = true,
                cursor = true,
                modemsg = true,
            },
        },
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
        event = "VeryLazy",
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
}
