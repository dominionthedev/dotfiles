local augroup = vim.api.nvim_create_augroup("autocmds", {
    clear = true,
})

-- Restore cursor position when reopening files
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')[1]

        if mark > 1 and mark <= vim.api.nvim_buf_line_count(0) then
            pcall(vim.cmd, 'normal! g`"')
        end
    end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank({
            timeout = 150,
        })
    end,
})

-- Automatically create parent directories before writing
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function(event)
        local file = vim.loop.fs_realpath(event.match) or event.match
        local dir = vim.fn.fnamemodify(file, ":p:h")
        vim.fn.mkdir(dir, "p")
    end,
})
