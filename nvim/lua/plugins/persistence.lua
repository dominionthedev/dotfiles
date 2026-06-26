return {
    {
        "folke/persistence.nvim",
        lazy = false,
        opts = {
            dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
            need = 1,
            branch = true,
        },
        keys = {
            {
                "<leader>sr",
                function() require("persistence").load() end,
                desc = "Restore session",
            },
            {
                "<leader>s.",
                function() require("persistence").select() end,
                desc = "Select session",
            },
            {
                "<leader>sl",
                function() require("persistence").load({ last = true }) end,
                desc = "Restore last session",
            },
            {
                "<leader>sq",
                function() require("persistence").stop() end,
                desc = "Stop session saving",
            },
        },
    },
}
