return {
    {
        "stevearc/overseer.nvim",
        keys = {
            {
                "<leader>Rr",
                "<cmd>OverseerRun<cr>",
                desc = "Run task",
            },
            {
                "<leader>Rt",
                "<cmd>OverseerToggle<cr>",
                desc = "Toggle task list",
            },
            {
                "<leader>Ra",
                "<cmd>OverseerTaskAction<cr>",
                desc = "Task action",
            },
            {
                "<leader>Rs",
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
        },
    },
}
