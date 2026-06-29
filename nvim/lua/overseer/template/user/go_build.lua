---@type overseer.TemplateFileDefinition
return {
    name = "go build",
    builder = function()
        return {
            cmd = { "go", "build", "./..." },
            cwd = vim.fn.expand("%:p:h"),
            components = {
                { "on_output_quickfix", open = true, set_diagnostics = true },
                "default",
            },
        }
    end,
    condition = {
        filetype = { "go" },
    },
}
