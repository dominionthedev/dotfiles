return {
    {
        "stevearc/conform.nvim",

        event = {
            "BufWritePre",
        },

        opts = {
            formatters_by_ft = {
                python = { "ruff_format" },

                javascript = { "prettier" },
                typescript = { "prettier" },

                html = { "prettier" },
                css = { "prettier" },

                json = { "prettier" },
                yaml = { "prettier" },

                markdown = { "prettier" },

                go = { "gofmt" },
                rust = { "rustfmt" },

                toml = { "taplo" },

                -- zig = { "zigfmt" },
            },

            format_on_save = {
                timeout_ms = 1000,
                lsp_fallback = true,
            },
        },
    },
}
