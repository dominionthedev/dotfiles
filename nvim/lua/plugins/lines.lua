return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            local mocha = require("catppuccin.palettes").get_palette("mocha")

            local function lsp_clients()
                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_clients({ bufnr = bufnr })

                if #clients == 0 then
                    return ""
                end

                local names = {}
                for _, client in ipairs(clients) do
                    table.insert(names, client.name)
                end

                if #names == 0 then
                    return ""
                end

                return " " .. table.concat(names, ", ")
            end

            local function cwd()
                return "󰉋 " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            end

            local theme = {
                normal = {
                    a = { bg = mocha.blue, fg = mocha.base, gui = "bold" },
                    b = { bg = mocha.surface0, fg = mocha.text },
                    c = { bg = mocha.mantle, fg = mocha.text },
                },
                insert = {
                    a = { bg = mocha.green, fg = mocha.base, gui = "bold" },
                    b = { bg = mocha.surface0, fg = mocha.text },
                    c = { bg = mocha.mantle, fg = mocha.text },
                },
                visual = {
                    a = { bg = mocha.mauve, fg = mocha.base, gui = "bold" },
                    b = { bg = mocha.surface0, fg = mocha.text },
                    c = { bg = mocha.mantle, fg = mocha.text },
                },
                replace = {
                    a = { bg = mocha.red, fg = mocha.base, gui = "bold" },
                    b = { bg = mocha.surface0, fg = mocha.text },
                    c = { bg = mocha.mantle, fg = mocha.text },
                },
                command = {
                    a = { bg = mocha.peach, fg = mocha.base, gui = "bold" },
                    b = { bg = mocha.surface0, fg = mocha.text },
                    c = { bg = mocha.mantle, fg = mocha.text },
                },
                inactive = {
                    a = { bg = mocha.surface0, fg = mocha.overlay1, gui = "bold" },
                    b = { bg = mocha.mantle, fg = mocha.overlay1 },
                    c = { bg = mocha.mantle, fg = mocha.overlay1 },
                },
            }

            require("lualine").setup({
                options = {
                    theme = theme,
                    globalstatus = true,
                    icons_enabled = true,

                    component_separators = {
                        left = "│",
                        right = "│",
                    },

                    section_separators = { left = "", right = "" },

                    disabled_filetypes = {
                        statusline = {
                            "snacks_dashboard",
                        },
                    },

                    always_divide_middle = true,
                },

                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                return " " .. str
                            end,
                        },
                    },

                    lualine_b = {
                        {
                            "branch",
                            icon = "󰘬",
                        },
                        {
                            "diff",
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " ",
                            },
                        },
                    },

                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            symbols = {
                                modified = " ●",
                                readonly = " 󰌾",
                                unnamed = "[No Name]",
                                newfile = "[New]",
                            },
                        },
                    },

                    lualine_x = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            sections = { "error", "warn", "info", "hint" },
                            symbols = {
                                error = " ",
                                warn = " ",
                                info = " ",
                                hint = "󰌵 ",
                            },
                            colored = true,
                            update_in_insert = false,
                            always_visible = false,
                        },
                        {
                            lsp_clients,
                            color = { fg = mocha.sapphire, bg = mocha.mantle },
                        },
                    },

                    lualine_y = {
                        {
                            "filetype",
                            colored = true,
                            icon_only = false,
                        },
                    },

                    lualine_z = {
                        {
                            "progress",
                        },
                        {
                            "location",
                        },
                    },
                },

                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                        },
                    },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },

                extensions = {
                    "lazy",
                    "trouble",
                    "quickfix",
                    "man",
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
            local mocha = require("catppuccin.palettes").get_palette("mocha")

            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    always_show_bufferline = true,
                    diagnostics = "nvim_lsp",
                    diagnostics_update_in_insert = false,
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                    color_icons = true,

                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { "close" },
                    },

                    offsets = {
                        {
                            filetype = "snacks_layout_box",
                            text = "Explorer",
                            text_align = "left",
                            separator = true,
                        },
                    },

                    diagnostics_indicator = function(_, _, diag)
                        local ret = {}

                        if diag.error and diag.error > 0 then
                            table.insert(ret, " " .. diag.error)
                        end
                        if diag.warning and diag.warning > 0 then
                            table.insert(ret, " " .. diag.warning)
                        end
                        if diag.info and diag.info > 0 then
                            table.insert(ret, " " .. diag.info)
                        end

                        return table.concat(ret, " ")
                    end,

                    custom_filter = function(buf_number)
                        return vim.bo[buf_number].filetype ~= "snacks_dashboard"
                    end,
                },

                highlights = {
                    fill = {
                        bg = mocha.crust,
                    },

                    background = {
                        fg = mocha.overlay1,
                        bg = mocha.mantle,
                    },

                    buffer_visible = {
                        fg = mocha.subtext1,
                        bg = mocha.mantle,
                    },

                    buffer_selected = {
                        fg = mocha.text,
                        bg = mocha.surface0,
                        bold = true,
                        italic = false,
                    },

                    separator = {
                        fg = mocha.crust,
                        bg = mocha.mantle,
                    },

                    separator_visible = {
                        fg = mocha.crust,
                        bg = mocha.mantle,
                    },

                    separator_selected = {
                        fg = mocha.crust,
                        bg = mocha.surface0,
                    },

                    modified = {
                        fg = mocha.peach,
                        bg = mocha.mantle,
                    },

                    modified_visible = {
                        fg = mocha.peach,
                        bg = mocha.mantle,
                    },

                    modified_selected = {
                        fg = mocha.peach,
                        bg = mocha.surface0,
                    },

                    diagnostic = {
                        bg = mocha.mantle,
                    },

                    diagnostic_visible = {
                        bg = mocha.mantle,
                    },

                    diagnostic_selected = {
                        bg = mocha.mantle,
                    },

                    hint = {
                        fg = mocha.teal,
                        bg = mocha.mantle,
                    },

                    hint_visible = {
                        fg = mocha.teal,
                        bg = mocha.mantle,
                    },

                    hint_selected = {
                        fg = mocha.teal,
                        bg = mocha.surface0,
                    },

                    info = {
                        fg = mocha.sky,
                        bg = mocha.mantle,
                    },

                    info_visible = {
                        fg = mocha.sky,
                        bg = mocha.mantle,
                    },

                    info_selected = {
                        fg = mocha.sky,
                        bg = mocha.surface0,
                    },

                    warning = {
                        fg = mocha.yellow,
                        bg = mocha.mantle,
                    },

                    warning_visible = {
                        fg = mocha.yellow,
                        bg = mocha.mantle,
                    },

                    warning_selected = {
                        fg = mocha.yellow,
                        bg = mocha.surface0,
                    },

                    error = {
                        fg = mocha.red,
                        bg = mocha.mantle,
                    },

                    error_visible = {
                        fg = mocha.red,
                        bg = mocha.mantle,
                    },

                    error_selected = {
                        fg = mocha.red,
                        bg = mocha.surface0,
                    },

                    duplicate = {
                        fg = mocha.overlay1,
                        bg = mocha.mantle,
                        italic = true,
                    },

                    duplicate_visible = {
                        fg = mocha.overlay1,
                        bg = mocha.mantle,
                        italic = true,
                    },

                    duplicate_selected = {
                        fg = mocha.mauve,
                        bg = mocha.surface0,
                        italic = true,
                    },
                },
            })
        end,
    },
}
