return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",

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

                return " " .. table.concat(names, ",")
            end

            local blame_cache = {}

            local MAX_SUBJECT_LEN = 40

            local function truncate(text, max_len)
                if vim.fn.strdisplaywidth(text) <= max_len then
                    return text
                end

                return vim.fn.strcharpart(text, 0, max_len - 1) .. "…"
            end

            local function refresh_blame(bufnr)
                local path = vim.api.nvim_buf_get_name(bufnr)
                if path == "" then
                    blame_cache[bufnr] = ""
                    return
                end

                local dir = vim.fn.fnamemodify(path, ":h")

                vim.system(
                    { "git", "-C", dir, "log", "-1", "--format=%an\t%s\t%cr", "--", path },
                    { text = true },
                    function(result)
                        if result.code ~= 0 or not result.stdout then
                            blame_cache[bufnr] = ""
                            return
                        end

                        local first_line = result.stdout:match("^([^\n]*)")
                        if not first_line or first_line == "" then
                            blame_cache[bufnr] = ""
                            return
                        end

                        local author, subject, relative_time =
                            first_line:match("([^\t]*)\t([^\t]*)\t(.*)")

                        if not author then
                            blame_cache[bufnr] = ""
                            return
                        end

                        vim.schedule(function()
                            subject = truncate(subject, MAX_SUBJECT_LEN)

                            blame_cache[bufnr] = string.format(
                                "%s • %s • %s",
                                author,
                                subject,
                                relative_time
                            )

                            if vim.api.nvim_buf_is_valid(bufnr) then
                                require("lualine").refresh({ scope = "tabpage", place = { "statusline" } })
                            end
                        end)
                    end
                )
            end

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
                group = vim.api.nvim_create_augroup("LualineGitBlame", { clear = true }),
                callback = function(args)
                    refresh_blame(args.buf)
                end,
            })

            local function git_blame()
                local bufnr = vim.api.nvim_get_current_buf()
                if blame_cache[bufnr] == nil then
                    refresh_blame(bufnr)
                end
                return blame_cache[bufnr] or ""
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
                            git_blame,
                            color = { fg = mocha.overlay1, bg = mocha.mantle },
                            cond = function()
                                return git_blame() ~= ""
                            end,
                        },
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
                    color_icons = true,
                    right_mouse_command = "vertical sbuffer %d",

                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { "close" },
                    },

                    offsets = {
                        {
                            filetype = "snacks_layout_box",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true,
                        },
                    },

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
                        bg = mocha.surface0,
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

                    close_button = {
                        fg = mocha.overlay1,
                        bg = mocha.mantle,
                    },

                    close_button_visible = {
                        fg = mocha.overlay1,
                        bg = mocha.mantle,
                    },

                    close_button_selected = {
                        fg = mocha.overlay1,
                        bg = mocha.surface0,
                    },
                },
            })
        end,
    },
}
