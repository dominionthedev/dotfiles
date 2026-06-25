return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require("lualine").setup({
                options = {
                    theme = require("catppuccin.utils.lualine")(),

                    component_separators = {
                        left = "│",
                        right = "│",
                    },

                    section_separators = {
                        left = "",
                        right = "",
                    },

                    icons_enabled = true,
                    globalstatus = true,

                    disabled_filetypes = {
                        statusline = {
                            "snacks_dashboard",
                        },
                    },
                },

                sections = {
                    lualine_a = {
                        {
                            "mode",
                            icons_enabled = true,
                        },
                    },

                    lualine_b = {
                        {
                            "branch",
                            icon = "󰘬",
                        },
                        "diff",
                        "diagnostics",
                    },

                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                        },
                    },

                    lualine_x = {
                        "encoding",
                        "fileformat",
                        "filetype",
                    },

                    lualine_y = {
                        "progress",
                    },

                    lualine_z = {
                        "location",
                    },
                },
            })
        end,
    },

    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

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
                        reveal = {
                            "close",
                        },
                    },
                },
            })
        end,
    },
}
