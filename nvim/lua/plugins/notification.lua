return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",

        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },

        opts = {
            cmdline = {
                enabled = true,
            },

            messages = {
                enabled = true,
            },

            popupmenu = {
                enabled = true,
            },

            lsp = {
                progress = {
                    enabled = true,
                    view = "mini",
                },

                hover = {
                    enabled = true,
                },

                signature = {
                    enabled = true,
                },
            },

            presets = {
                long_message_to_split = true,
                lsp_doc_border = true,
                inc_rename = true,
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
        end,
    },
}
