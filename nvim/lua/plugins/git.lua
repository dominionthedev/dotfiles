return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",

        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "▎" },
                    change = { text = "▎" },
                    delete = { text = "-" },
                    topdelete = { text = "-" },
                    changedelete = { text = "▎" },
                },

                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(
                            mode,
                            lhs,
                            rhs,
                            {
                                buffer = bufnr,
                                desc = desc,
                            }
                        )
                    end

                    map("n", "]h", gs.next_hunk, "Next hunk")
                    map("n", "[h", gs.prev_hunk, "Prev hunk")

                    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")

                    map("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end, "Blame line")

                    map("n", "<leader>hd", gs.diffthis, "Diff this")
                end,
            })
        end,
    },
}
