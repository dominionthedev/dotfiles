return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",

        opts = {},

        keys = {
            {
                "s",
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
                mode = "o",
            },
            {
                "R",
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
                mode = { "o", "x" },
            },
            {
                "<C-s>",
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
                mode = "c",
            },
        },
    },

    {
        "dominionthedev/neobar",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "folke/edgy.nvim",
        },
        opts = {
            -- defaults: edgy = true, position = "left", width = 3
        },
    },

    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        init = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = "screen"
        end,
        opts = function()
            local neobar_edgy = require("neobar.edgy")
            return {
                left = {
                    neobar_edgy.view(),
                },
                options = {
                    left = neobar_edgy.options(),
                },
            }
        end,
    },
}
