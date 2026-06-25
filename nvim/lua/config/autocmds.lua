local augroup = vim.api.nvim_create_augroup("autocmds", {
    clear = true,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore cursor position",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')[1]

        if mark > 1 and mark <= vim.api.nvim_buf_line_count(0) then
            pcall(vim.cmd, 'normal! g`"')
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    desc = "Highlight yanked text",
    callback = function()
        vim.highlight.on_yank({
            timeout = 150,
        })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    desc = "Create parent directories on save",
    callback = function(event)
        if event.match:match("^%w+://") then
            return
        end

        local file = vim.uv.fs_realpath(event.match) or event.match
        local dir = vim.fn.fnamemodify(file, ":p:h")

        vim.fn.mkdir(dir, "p")
    end,
})
