local M = {}

local notes_dir = "~/Developer/notes"
local cwd_history = {}

---@param path string
function M.set_cwd(path)
  local target = vim.fn.fnamemodify(path, ":p")
  if vim.fn.isdirectory(target) == 0 then
    vim.notify("Not a directory: " .. target, vim.log.levels.WARN)
    return
  end

  table.insert(cwd_history, vim.fn.getcwd())
  vim.cmd.cd(vim.fn.fnameescape(target))
  vim.notify("cwd: " .. target)
end

function M.restore_cwd()
  local previous = table.remove(cwd_history)
  if not previous then
    vim.notify("No previous cwd to restore", vim.log.levels.WARN)
    return
  end

  vim.cmd.cd(vim.fn.fnameescape(previous))
  vim.notify("cwd: " .. previous)
end

function M.new_note()
  vim.fn.mkdir(notes_dir, "p")

  vim.ui.input({ prompt = "Note title: " }, function(title)
    if not title or title == "" then
      return
    end

    local filename = title:gsub("%s+", "-"):lower() .. ".md"
    local path = notes_dir .. "/" .. filename

    if vim.fn.filereadable(path) == 1 then
      vim.notify("Note already exists: " .. filename, vim.log.levels.WARN)
      vim.cmd("edit " .. vim.fn.fnameescape(path))
      return
    end

    vim.fn.writefile({}, path)
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end)
end

function M.find_note()
  Snacks.picker.files({
    cwd = vim.fn.expand(notes_dir),
  })
end

function M.grep_notes()
  Snacks.picker.grep({
    dirs = { vim.fn.expand(notes_dir) },
  })
end

function M.open_jotting()
  vim.cmd.edit(vim.fn.expand(notes_dir .. "/jotting.md"))
end

return M
