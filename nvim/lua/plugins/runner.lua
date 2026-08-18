return {
    {
        "stevearc/overseer.nvim",
        keys = {
            {
                "<leader>rr",
                "<cmd>OverseerRun<cr>",
                desc = "Run task",
            },
            {
                "<leader>rt",
                "<cmd>OverseerToggle<cr>",
                desc = "Toggle task list",
            },
            {
                "<leader>ra",
                "<cmd>OverseerTaskAction<cr>",
                desc = "Task action",
            },
            {
                "<leader>rs",
                "<cmd>OverseerShell<cr>",
                desc = "Run shell command as task",
            },
        },

        opts = {
            task_list = {
                direction = "bottom",
                min_height = 10,
                max_height = 20,
                default_detail = 1,
            },
            templates = {
                "builtin",
                "user.go_run",
                "user.go_test",
                "user.go_build",
            },
            -- TODO: Add more useful templates...
        },
    },
}
