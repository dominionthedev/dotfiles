return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
            -- "rouge8/neotest-rust",
            -- "alfaix/neotest-zig",
        },

        keys = {
            {
                "<leader>tr",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run nearest test",
            },
            {
                "<leader>tf",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run file tests",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open()
                end,
                desc = "Open test output",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle test summary",
            },
        },

        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python"),
                    require("neotest-go"),
                    -- require("neotest-rust"),
                    -- require("neotest-zig"),
                },
            })
        end,
    },
}
