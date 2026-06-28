local M = {}

local active_workspace = nil

local function workspace_dir(choice)
    return choice == "Notes"
        and vim.fn.expand("~/Developer/notes")
        or vim.fn.expand("~/Developer/vault")
end

local function workspace_picker(callback)
    if active_workspace then
        callback(active_workspace)
        return
    end

    vim.ui.select(
        { "Notes", "Vault" },
        { prompt = "Workspace" },
        function(choice)
            if not choice then
                return
            end

            active_workspace = choice
            callback(choice)
        end
    )
end

function M.new_note()
    workspace_picker(function(choice)
        local dir = workspace_dir(choice)
        vim.fn.mkdir(dir, "p")

        vim.ui.input({ prompt = "Note title: " }, function(title)
            if not title or title == "" then
                return
            end

            local filename = title:gsub("%s+", "-"):lower() .. ".md"
            local path = dir .. "/" .. filename

            if vim.fn.filereadable(path) == 1 then
                vim.notify("Note already exists: " .. filename, vim.log.levels.WARN)
                vim.cmd("edit " .. vim.fn.fnameescape(path))
                return
            end

            vim.fn.writefile({}, path)
            vim.cmd("edit " .. vim.fn.fnameescape(path))
        end)
    end)
end

function M.find_note()
    workspace_picker(function(choice)
        Snacks.picker.files({
            cwd = workspace_dir(choice),
        })
    end)
end

function M.grep_notes()
    workspace_picker(function(choice)
        Snacks.picker.grep({
            dirs = { workspace_dir(choice) },
        })
    end)
end

function M.switch_workspace()
    vim.ui.select(
        { "Notes", "Vault" },
        { prompt = "Workspace" },
        function(choice)
            if not choice then
                return
            end

            active_workspace = choice
            vim.notify("Active workspace: " .. choice)
        end
    )
end

function M.open_jotting()
    vim.cmd.edit(vim.fn.expand("~/Developer/vault/jotting.md"))
end

return M
