return {
    "is0n/jaq-nvim",
    cmd = { "Jaq" },
    keys = {
        {
            "<leader>r",
            function()
                vim.cmd("Jaq float")
            end,
            desc = "Run file (jaq float)",
        },
    },
    config = function()
        require("jaq-nvim").setup({
            cmds = {
                -- File execution (fallback)
                default = "term",

                -- Language-specific runners
                python = "python3 %",
                go = "go run %",
                rust = "cargo run",
                javascript = "node %",
            },

            behavior = {
                default = "float", -- float output by default
                startinsert = false,
                wincmd = false,
            },

            ui = {
                float = {
                    border = "rounded",
                    winhl = "Normal:Normal,FloatBorder:FloatBorder",
                    border_hl = "FloatBorder",
                    blend = 0,
                },
            },
        })
    end,
}
