return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",

        opts = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = "▎" },
            },

            signs_staged = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
            },

            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = true,

            current_line_blame = false,
            current_line_blame_opts = {
                delay = 250,
                ignore_whitespace = true,
                virt_text_pos = "eol",
            },

            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
            },

            attach_to_untracked = true,
            trouble = true,

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = bufnr,
                        silent = true,
                        desc = desc,
                    })
                end

                -- Navigation
                map("n", "]h", gs.next_hunk, "Next Hunk")
                map("n", "[h", gs.prev_hunk, "Previous Hunk")

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage Selection")

                map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset Selection")

                map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")

                -- Preview
                map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>hi", gs.preview_hunk_inline, "Inline Preview")

                -- Blame
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, "Blame Line")

                map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle Line Blame")

                -- Diff
                map("n", "<leader>hd", gs.diffthis, "Diff")
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, "Diff Against HEAD~")

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
            end,
        },
    },
}
