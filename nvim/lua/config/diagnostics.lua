-- Diagnostics

vim.diagnostic.config({
    severity_sort = true,
    underline = false,
    update_in_insert = false,

    virtual_text = {
        spacing = 2,
        source = "if_many",
        prefix = function(diagnostic)
            local icons = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN]  = "",
                [vim.diagnostic.severity.INFO]  = "",
                [vim.diagnostic.severity.HINT]  = "󰌵",
            }
            return icons[diagnostic.severity] .. " "
        end,
    },

    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌵 ",
        },
    },

    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
        focusable = false,
    },
})
