return {
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        dependencies = {
            "folke/snacks.nvim",
        },

        opts = {
            auto_close = false,
            auto_open = false,
            auto_preview = false,
            auto_refresh = true,
            focus = true,
            restore = true,
            follow = true,
            pinned = false,
            warn_no_results = false,
            open_no_results = true,
            use_diagnostic_signs = true,

            preview = {
                type = "main",
                scratch = false,
            },

            win = {
                type = "split",
                position = "right",
                size = 0.24,
            },

            modes = {
                diagnostics = {
                    mode = "diagnostics",
                    -- Was `any = { buf = 0, {severity=ERROR}, ... }` — an OR,
                    -- not an AND. Every diagnostic has some severity, so that
                    -- clause alone made the filter always true and `buf = 0`
                    -- never actually restricted anything: this mode was
                    -- silently showing workspace-wide results under a
                    -- "buffer" label. No need for the severity checks at
                    -- all — not filtering by severity already means every
                    -- severity is included.
                    filter = {
                        buf = 0,
                    },
                },

                diagnostics_all = {
                    mode = "diagnostics",
                    filter = {},
                },

                symbols = {
                    mode = "symbols",
                    focus = false,
                    win = {
                        position = "right",
                        size = 0.24,
                    },
                },

                lsp = {
                    mode = "lsp",
                    win = {
                        position = "right",
                        size = 0.26,
                    },
                },

                qflist = {
                    mode = "quickfix",
                },

                loclist = {
                    mode = "loclist",
                },
            },

            keys = {
                ["?"] = "help",
                ["r"] = "refresh",
                ["R"] = "toggle_refresh",
                ["q"] = "close",
                ["o"] = "jump_close",
                ["<cr>"] = "jump",
                ["<2-leftmouse>"] = "jump",
                ["<c-s>"] = "jump_split",
                ["<c-v>"] = "jump_vsplit",
                ["}"] = "next",
                ["{"] = "prev",
                ["]q"] = "next",
                ["[q"] = "prev",
                ["i"] = "inspect",
                ["p"] = "preview",
                ["P"] = "toggle_preview",
                ["zo"] = "fold_open",
                ["zc"] = "fold_close",
                ["zR"] = "fold_open_recursive",
                ["zM"] = "fold_close_recursive",
                ["zm"] = "fold_more",
                ["zr"] = "fold_reduce",
                ["<esc>"] = "cancel",
            },
        },
    },
}
