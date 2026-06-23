return {
    {
        "nvim-treesitter/nvim-treesitter",

        version = false,
        build = ":TSUpdate",

        lazy = vim.fn.argc(-1) == 0,

        opts = {
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",

                "python",
                "go",
                "bash",

                "rust",
                "zig",

                "javascript",
                "typescript",
                "html",
                "css",

                "json",
                "yaml",
                "markdown",
            },

            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
            },
        },

        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
    },
}
