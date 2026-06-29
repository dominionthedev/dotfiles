-- overseer has no builtin Go template provider (cargo, npm, make,
-- and others are builtin — Go isn't). This fills that gap for `go run`
-- on the current file's package.

---@type overseer.TemplateFileDefinition
return {
    name = "go run",
    builder = function()
        return {
            cmd = { "go", "run", "." },
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
