local M = {}

M.transparent = true

function M.is_transparent()
    return M.transparent
end

function M.toggle()
    M.transparent = not M.transparent

    require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = M.transparent,
        term_colors = true,
        integrations = {
            cmp = true,
            gitsigns = true,
            treesitter = true,
            bufferline = true,
            lualine = true,
            which_key = true,
            snacks = true,
            noice = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    warnings = { "italic" },
                    hints = { "italic" },
                    information = { "italic" },
                },
            },
            mini = {
                enabled = true,
            },
        },
        custom_highlights = function(colors)
            return {
                NoiceMini = { bg = colors.mantle },
                NoiceMiniIcon = { bg = colors.mantle },
                NoiceMiniTitle = { bg = colors.mantle },
                NoiceMiniProgress = { bg = colors.mantle },
            }
        end,
    })

    vim.cmd.colorscheme("catppuccin")

    return M.transparent
end

return M
