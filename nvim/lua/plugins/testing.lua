return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",

            -- "rouge8/neotest-rust",
            -- "alfaix/neotest-zig",
        },

        keys = {
            {
                "<leader>tr",
                function()
                    require("neotest").run.run(vim.fn.getcwd())
                end,
                desc = "Run all tests",
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
            {
                "<leader>td",
                function()
                    require("neotest").run.run({ strategy = "dap" })
                end,
                desc = "Debug test",
            },
            {
                "<leader>ta",
                function()
                    require("neotest").run.attach()
                end,
                desc = "Attach",
            },
            {
                "<leader>tp",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Output panel",
            },
            {
                "<leader>tw",
                function()
                    require("neotest").watch.toggle()
                end,
                desc = "Watch",
            },
            {
                "<leader>tS",
                function()
                    require("neotest").run.stop()
                end,
                desc = "Stop tests",
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

                discovery = {
                    enabled = true,
                },

                output = {
                    open_on_run = false,
                },

                output_panel = {
                    enabled = true,
                    open = "botright split | resize 12",
                },

                summary = {
                    animated = true,
                    follow = true,
                    expand_errors = true,
                },

                icons = {
                    passed = "",
                    failed = "",
                    running = "󰑮",
                    skipped = "󰒭",
                    unknown = "?",
                },
            })
        end,
    },
}
