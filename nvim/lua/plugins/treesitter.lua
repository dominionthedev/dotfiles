return {
    {
        "nvim-treesitter/nvim-treesitter",

        lazy = false,
        version = false,
        build = ":TSUpdate",

        config = function()
            local ts = require("nvim-treesitter")

            ts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            ts.install({
                "lua",
                "vim",
                "vimdoc",

                "bash",
                "python",
                "go",

                "rust",

                "javascript",
                "typescript",

                "html",
                "css",

                "json",
                "yaml",

                "markdown",
                "markdown_inline",

                "regex",
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
