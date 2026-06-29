return {
    {
        "dominionthedev/neobar",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "folke/edgy.nvim",
        },
        opts = {},
    },

    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        init = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = "screen"
        end,
        opts = {
            options = {
                right = { size = 3 },
            },
            right = {
                {
                    ft = "neobar",
                    title = "Neobar",
                    pinned = true,
                    open = function()
                        require("neobar.window").open()
                    end,
                },
            },
        },
    },
}
