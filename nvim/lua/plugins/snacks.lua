return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,

        opts = {
            bigfile = {
                enabled = true,
                line_length = 1000,
            },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },

            dashboard = {
                enabled = true,
                preset = {
                    header = [[
▓█████▄  ▒█████   ███▄ ▄███▓ ██▓ ███▄    █  ██▓ ▒█████   ███▄    █ ▓█████▄ ▓█████ ██▒   █▓
▒██▀ ██▌▒██▒  ██▒▓██▒▀█▀ ██▒▓██▒ ██ ▀█   █ ▓██▒▒██▒  ██▒ ██ ▀█   █ ▒██▀ ██▌▓█   ▀▓██░   █▒
░██   █▌▒██░  ██▒▓██    ▓██░▒██▒▓██  ▀█ ██▒▒██▒▒██░  ██▒▓██  ▀█ ██▒░██   █▌▒███   ▓██  █▒░
░▓█▄   ▌▒██   ██░▒██    ▒██ ░██░▓██▒  ▐▌██▒░██░▒██   ██░▓██▒  ▐▌██▒░▓█▄   ▌▒▓█  ▄  ▒██ █░░
░▒████▓ ░ ████▓▒░▒██▒   ░██▒░██░▒██░   ▓██░░██░░ ████▓▒░▒██░   ▓██░░▒████▓ ░▒████▒  ▒▀█░
 ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░   ░  ░░▓  ░ ▒░   ▒ ▒ ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░░ ▒░ ░  ░ ▐░
 ░ ░  ░ ░ ░ ░ ▒  ░      ░    ▒ ░   ░   ░ ░  ▒ ░░ ░ ░ ▒     ░   ░ ░  ░ ░  ░    ░       ░░
   ░        ░ ░         ░    ░           ░  ░      ░ ░           ░    ░       ░  ░     ░
                    ]],
                },
            },

            picker = {
                enabled = true,
                layout = {
                    preset = "ivy",
                    cycle = false,
                },

                matcher = {
                    fuzzy = true,
                    smartcase = true,
                    ignorecase = true,
                    sort_empty = false,
                    filename_bonus = true,
                },

                formatters = {
                    file = {
                        filename_first = true,
                        truncate = 80,
                    },
                },

                win = {
                    input = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
                            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
                            ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                            ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                            ["<C-q>"] = { "qflist", mode = { "i", "n" } },
                            ["<C-s>"] = { "edit_split", mode = { "i", "n" } },
                            ["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
                            ["<C-t>"] = { "tab", mode = { "i", "n" } },
                        },
                    },
                },

                sources = {
                    explorer = {
                        hidden = true,
                        ignored = true,
                        follow_file = true,
                        auto_close = false,
                        layout = {
                            preset = "sidebar",
                            preview = false,
                        },
                        win = {
                            list = {
                                keys = {
                                    ["l"] = "confirm",
                                    ["h"] = "explorer_up",
                                    ["a"] = "explorer_add",
                                    ["d"] = "explorer_del",
                                    ["r"] = "explorer_rename",
                                    ["c"] = "explorer_copy",
                                    ["m"] = "explorer_move",
                                    ["."] = "explorer_focus",
                                    ["P"] = "toggle_preview",
                                    ["y"] = { "explorer_yank", mode = { "n" } },
                                },
                            },
                        },
                    },

                    files = {
                        hidden = true,
                        ignored = true,
                    },

                    grep = {
                        hidden = true,
                        ignored = true,
                    },

                    buffers = {
                        layout = "ivy",
                    },

                    diagnostics = {
                        layout = "ivy",
                    },

                    lsp_symbols = {
                        layout = "ivy",
                    },

                    workspace_symbols = {
                        layout = "ivy",
                    },

                    git_status = {
                        layout = "ivy",
                    },

                    command_history = {
                        layout = "ivy",
                    },

                    search_history = {
                        layout = "ivy",
                    },
                },
            },

            gh = { enabled = true },
            git = { enabled = true },
            dim = { enabled = true },
            debug = { enabled = true },
            scratch = { enabled = true },

            explorer = {
                enabled = true,
                replace_netrw = true,
                follow_file = true,
                auto_close = false,
            },

            input = {
                enabled = true,
                border = "rounded",
            },
            scope = { enabled = true },
            indent = {
                enabled = true,
                animate = {
                    enabled = true,
                },
                scope = {
                    enabled = true,
                    underline = false,
                    only_current = false,
                },
            },
            words = { enabled = true },
            scroll = {
                enabled = true,
                animate = {
                    duration = { step = 15, total = 180 },
                    easing = "linear",
                },
            },
            animate = { enabled = true },
            terminal = {
                enabled = true,
                win = {
                    style = "terminal_float",
                },
            },
            lazygit = { enabled = true },
            rename = { enabled = true },
            image = {
                enabled = true,
                doc = {
                    inline = false,
                    float = true,
                    max_width = 80,
                    max_height = 40,
                },
            },
            zen = {
                enabled = true,
                toggles = {
                    dim = true,
                    git_signs = false,
                    mini_diff_signs = false,
                    diagnostics = true,
                    inlay_hints = false,
                },
            },
            styles = {
                notification = {
                    wo = { wrap = true },
                    border = "rounded",
                },

                input = {
                    relative = "cursor",
                    row = 1,
                    col = 0,
                    border = "rounded",
                    title_pos = "left",
                },

                terminal_float = {
                    relative = "editor",
                    border = "rounded",
                    width = 0.90,
                    height = 0.88,
                    row = 0.06,
                    col = 0.05,
                    title = " Terminal ",
                    title_pos = "center",
                },

                lazygit = {
                    relative = "editor",
                    border = "rounded",
                    width = 0.95,
                    height = 0.95,
                    row = 0.025,
                    col = 0.025,
                    title = " Lazygit ",
                    title_pos = "center",
                },

                scratch = {
                    relative = "editor",
                    border = "rounded",
                    width = 0.80,
                    height = 0.80,
                    row = 0.10,
                    col = 0.10,
                    title = " Scratch ",
                    title_pos = "center",
                },
            },
        },
    },
}
