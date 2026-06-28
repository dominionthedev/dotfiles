local M = {}

M.transparent = false
M.flavour = "mocha"

function M.is_transparent()
    return M.transparent
end

local function apply(opts)
    require("catppuccin").setup({
        flavour = M.flavour,
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
end

function M.toggle()
    M.transparent = not M.transparent
    apply()
    return M.transparent
end

---@param flavour string
function M.set_flavour(flavour)
    M.flavour = flavour
    apply()
end

return M
