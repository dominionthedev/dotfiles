return {
  {
    "stevearc/conform.nvim",

    event = { "BufReadPre", "BufNewFile" },

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
        lua = { "stylua" },

        -- zig = { "zigfmt" },
      },
    },
  },
}
