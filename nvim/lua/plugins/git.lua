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
                map("n", "<leader>ga", gs.stage_hunk, "Stage Hunk")
                map("v", "<leader>ga", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage Selection")

                map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
                map("v", "<leader>gr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset Selection")

                map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")

                -- Preview
                map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>gP", gs.preview_hunk_inline, "Inline Preview")

                -- Blame
                map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle Line Blame")

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
            end,
        },
    },
}
