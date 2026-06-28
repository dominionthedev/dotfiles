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
                "toml",
                "markdown",
                "markdown_inline",
                "regex",
            })

            local highlight_fts = {
                lua = true,
                vim = true,
                vimdoc = true,
                bash = true,
                python = true,
                go = true,
                rust = true,
                javascript = true,
                typescript = true,
                html = true,
                css = true,
                json = true,
                yaml = true,
                toml = true,
                markdown = true,
            }

            local indent_fts = {
                lua = true,
                python = true,
                go = true,
                rust = true,
                javascript = true,
                typescript = true,
                html = true,
                css = true,
                json = true,
                yaml = true,
                toml = true,
            }

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
                callback = function(args)
                    local ft = vim.bo[args.buf].filetype

                    if highlight_fts[ft] then
                        pcall(vim.treesitter.start, args.buf)
                    end

                    if indent_fts[ft] then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
