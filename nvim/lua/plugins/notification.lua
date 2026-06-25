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
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
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
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })

            vim.notify = require("notify")
        end,
    },
}
