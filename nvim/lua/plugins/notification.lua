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
                view = "cmdline_popup",

                format = {
                    cmdline = { icon = "" },
                    search_down = { icon = " " },
                    search_up = { icon = " " },
                    filter = { icon = "$" },
                    lua = { icon = "" },
                    help = { icon = "󰋖" },
                },
            },

            messages = {
                enabled = true,
                view = "notify",
                view_error = "notify",
                view_warn = "notify",
                view_history = "split",
                view_search = false,
            },

            popupmenu = {
                enabled = true,
                backend = "nui",
            },

            notify = {
                enabled = true,
                view = "notify",
            },

            lsp = {
                progress = {
                    enabled = true,
                    view = "mini",
                },

                hover = {
                    enabled = true,
                    silent = false,
                },

                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = false,
                    },
                },

                documentation = {
                    view = "hover",
                },

                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },

            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
            },

            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = {
                        skip = true,
                    },
                },
                {
                    filter = {
                        event = "notify",
                        find = "No information available",
                    },
                    opts = {
                        skip = true,
                    },
                },
            },
        },
    },

    {
        "rcarriga/nvim-notify",

        config = function()
            local notify = require("notify")

            notify.setup({
                background_colour = "#000000",
                fps = 60,
                top_down = false,
                icons = {
                    ERROR = "",
                    WARN = "",
                    INFO = "",
                    DEBUG = "",
                    TRACE = "✎",
                },
            })

            vim.notify = notify
        end,
    },
}
