local M = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, {
    title = "Go Tools",
  })
end

local function executable(name)
  if vim.fn.executable(name) == 1 then
    return true
  end

  notify(("'%s' is not installed or is not on $PATH"):format(name), vim.log.levels.ERROR)
  return false
end

local function root()
  return vim.fs.root(0, { "go.mod", ".git" }) or vim.fn.getcwd()
end

local function current_file()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    notify("Current buffer has no file", vim.log.levels.ERROR)
    return nil
  end

  if vim.bo.filetype ~= "go" then
    notify("This command only works in Go buffers", vim.log.levels.ERROR)
    return nil
  end

  return file
end

local function save_buffer()
  if vim.bo.modified then
    vim.cmd.write()
  end
end

local function run(cmd, opts, callback)
  opts = vim.tbl_extend("force", {
    cwd = root(),
    text = true,
  }, opts or {})

  vim.system(cmd, opts, vim.schedule_wrap(function(result)
    callback(result)
  end))
end

---------------------------------------------------------------------------
-- impl
---------------------------------------------------------------------------

local function receiver_default()
  local node = vim.treesitter.get_node()

  while node do
    if node:type() == "type_declaration" then
      local spec = node:named_child(0)

      if spec and spec:type() == "type_spec" then
        local name = spec:field("name")[1]

        if name then
          local type_name = vim.treesitter.get_node_text(name, 0)

          if type_name ~= "" then
            local receiver = type_name:sub(1, 1):lower()

            return ("%s *%s"):format(receiver, type_name)
          end
        end
      end
    end

    node = node:parent()
  end

  return ""
end

function M.impl()
  if not executable("impl") then
    return
  end

  if not current_file() then
    return
  end

  local default_receiver = receiver_default()

  vim.ui.input({
    prompt = "Receiver: ",
    default = default_receiver,
  }, function(receiver)
    if not receiver or receiver == "" then
      return
    end

    vim.ui.input({
      prompt = "Interface: ",
    }, function(interface)
      if not interface or interface == "" then
        return
      end

      run({ "impl", receiver, interface }, {}, function(result)
        if result.code ~= 0 then
          notify(
            vim.trim(result.stderr ~= "" and result.stderr or result.stdout),
            vim.log.levels.ERROR
          )
          return
        end

        local output = vim.trim(result.stdout)

        if output == "" then
          notify("impl produced no methods", vim.log.levels.WARN)
          return
        end

        local lines = vim.split(output, "\n", {
          plain = true,
        })

        local row = vim.api.nvim_win_get_cursor(0)[1]

        vim.api.nvim_buf_set_lines(
          0,
          row,
          row,
          true,
          lines
        )

        notify(("Generated methods for %s"):format(interface))
      end)
    end)
  end)
end

---------------------------------------------------------------------------
-- gotests
---------------------------------------------------------------------------

local function current_function()
  local node = vim.treesitter.get_node()

  while node do
    local type = node:type()

    if type == "function_declaration" or type == "method_declaration" then
      local name = node:field("name")[1]

      if name then
        return vim.treesitter.get_node_text(name, 0)
      end

      return nil
    end

    node = node:parent()
  end

  return nil
end

function M.tests()
  if not executable("gotests") then
    return
  end

  local file = current_file()

  if not file then
    return
  end

  save_buffer()

  local func = current_function()

  local cmd = {
    "gotests",
    "-w",
  }

  if func then
    vim.list_extend(cmd, {
      "-only",
      "^" .. vim.pesc(func) .. "$",
    })
  end

  table.insert(cmd, file)

  run(cmd, {}, function(result)
    if result.code ~= 0 then
      notify(
        vim.trim(result.stderr ~= "" and result.stderr or result.stdout),
        vim.log.levels.ERROR
      )
      return
    end

    vim.cmd.checktime()

    if func then
      notify(("Generated tests for %s"):format(func))
    else
      notify("Generated tests for file")
    end
  end)
end

---------------------------------------------------------------------------
-- goplay
---------------------------------------------------------------------------

function M.play()
  if not executable("goplay") then
    return
  end

  local file = current_file()

  if not file then
    return
  end

  save_buffer()

  vim.system({
    "goplay",
    file,
  }, {
    cwd = root(),
  }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        notify(
          vim.trim(result.stderr ~= "" and result.stderr or result.stdout),
          vim.log.levels.ERROR
        )
        return
      end

      local output = vim.trim(result.stdout)

      if output ~= "" then
        vim.notify(output, vim.log.levels.INFO, {
          title = "Go Playground",
        })
      else
        notify("Sent file to the Go Playground")
      end
    end)
  end)
end

function M.play_selection()
  if not executable("goplay") then
    return
  end

  if vim.bo.filetype ~= "go" then
    notify("This command only works in Go buffers", vim.log.levels.ERROR)
    return
  end

  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  local lines = vim.api.nvim_buf_get_lines(
    0,
    start_row - 1,
    end_row,
    false
  )

  if #lines == 0 then
    notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Trim the first line to the beginning of the selection.
  local same_line = start_row == end_row
  lines[1] = lines[1]:sub(start_col + 1)

  -- Trim the last line to the end of the selection. If it's the same line as
  -- above, end_col needs shifting by start_col since that line has already
  -- been trimmed from the front.
  local last_end_col = same_line and (end_col - start_col) or end_col
  if last_end_col < #lines[#lines] then
    lines[#lines] = lines[#lines]:sub(1, last_end_col + 1)
  end

  local temp = vim.fn.tempname() .. ".go"

  vim.fn.writefile(lines, temp)

  vim.system({
    "goplay",
    temp,
  }, {}, function(result)
    vim.schedule(function()
      vim.fn.delete(temp)

      if result.code ~= 0 then
        notify(
          vim.trim(result.stderr ~= "" and result.stderr or result.stdout),
          vim.log.levels.ERROR
        )
        return
      end

      local output = vim.trim(result.stdout)

      if output ~= "" then
        vim.notify(output, vim.log.levels.INFO, {
          title = "Go Playground",
        })
      else
        notify("Sent selection to the Go Playground")
      end
    end)
  end)
end

return M
