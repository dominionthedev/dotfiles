return {
    {
        "dominionthedev/neobar",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            edgy = false
        },
    },

    {
        "ThePrimeagen/harpoon",
        event = "BufReadPre",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            local list = harpoon:list()

            vim.keymap.set("n", "<leader>ha", function()
                list:add()
            end, { desc = "Harpoon: Add file" })

            vim.keymap.set("n", "<leader>hh", function()
                harpoon.ui:toggle_quick_menu(list)
            end, { desc = "Harpoon: Menu" })

            vim.keymap.set("n", "<leader>hn", function()
                list:next()
            end, { desc = "Harpoon: Next file" })

            vim.keymap.set("n", "<leader>hp", function()
                list:prev()
            end, { desc = "Harpoon: Previous file" })

            for i = 1, 9 do
                vim.keymap.set("n", "<leader>" .. i, function()
                    list:select(i)
                end, {
                    desc = "Harpoon " .. i,
                })
            end
        end,
    },

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

    {
        "maskudo/devdocs.nvim",
        dependencies = {
            "folke/snacks.nvim",
        },

        cmd = { "DevDocs" },

        keys = {
            {
                "<leader>ho",
                mode = "n",
                "<cmd>DevDocs get<cr>",
                desc = "Get Devdocs",
            },
            {
                "<leader>hi",
                mode = "n",
                "<cmd>DevDocs install<cr>",
                desc = "Install Devdocs",
            },
            {
                "<leader>hv",
                mode = "n",
                function()
                    local devdocs = require("devdocs")
                    local installedDocs = devdocs.GetInstalledDocs()
                    vim.ui.select(installedDocs, {}, function(selected)
                        if not selected then
                            return
                        end
                        local docDir = devdocs.GetDocDir(selected)
                        -- prettify the filename as you wish
                        Snacks.picker.files({ cwd = docDir })
                    end)
                end,
                desc = "Get Devdocs",
            },
            {
                "<leader>hd",
                mode = "n",
                "<cmd>DevDocs delete<cr>",
                desc = "Delete Devdoc",
            }
        },

        opts = {
            ensure_installed = {
                "go",
                "python~3.11",
                -- "css",
                -- "javascript",
                -- "typescript",
                -- "rust",
                -- "lua~5.1",
                -- "zig",
            },
        },
    },
}
