return {
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

                    mini = {
                        enabled = true,
                    },
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
        "folke/which-key.nvim",
        opts = {
            preset = "modern",
        },
    },
}
