return {
    {
        "stevearc/aerial.nvim",
        keys = {
            {
                "<leader>a",
                "<cmd>AerialToggle<cr>",
                desc = "Toggle symbols outline (Aerial)",
            },
        },

        opts = {
            backends = { "treesitter", "lsp", "markdown", "man" },
            layout = {
                default_direction = "right",
                width = 30,
            },
        },
    },
}
