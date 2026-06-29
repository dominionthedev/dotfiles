---@type overseer.TemplateFileDefinition
return {
    name = "go test",
    builder = function()
        return {
            cmd = { "go", "test", "./...", "-v" },
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
