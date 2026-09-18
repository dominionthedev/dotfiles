local M = {}

local function clients_for_buffer(bufnr)
  return vim.lsp.get_clients({
    bufnr = bufnr or 0,
  })
end

local function client_label(client)
  return ("%s [%d]"):format(client.name, client.id)
end

function M.list()
  local clients = clients_for_buffer()

  if #clients == 0 then
    vim.notify(
      "No LSP clients attached to this buffer",
      vim.log.levels.INFO,
      { title = "LSP" }
    )
    return
  end

  vim.ui.select(clients, {
    prompt = "LSPs:",
    format_item = client_label,
  }, function(client)
    if not client then
      return
    end

    M.client_menu(client)
  end)
end

function M.client_menu(client)
  vim.ui.select({
    "Restart",
    "Stop",
    "Info",
  }, {
    prompt = client_label(client) .. ":",
  }, function(action)
    if not action then
      return
    end

    if action == "Restart" then
      vim.cmd("lsp restart " .. client.name)
    elseif action == "Stop" then
      client:stop()

      vim.notify(
        ("Stopped LSP: %s"):format(client.name),
        vim.log.levels.INFO,
        { title = "LSP" }
      )
    elseif action == "Info" then
      M.info(client)
    end
  end)
end

function M.stop_all()
  if #clients_for_buffer() == 0 then
    vim.notify(
      "No LSP clients attached to this buffer",
      vim.log.levels.INFO,
      { title = "LSP" }
    )
    return
  end

  vim.cmd("lsp stop")
end

function M.restart_all()
  if #clients_for_buffer() == 0 then
    vim.notify(
      "No LSP clients attached to this buffer",
      vim.log.levels.INFO,
      { title = "LSP" }
    )
    return
  end

  vim.cmd("lsp restart")
end

function M.info(client)
  local lines = {
    "Name: " .. client.name,
    "ID: " .. client.id,
    "Root: " .. (client.root_dir or "N/A"),
    "Command: " .. table.concat(client.config.cmd or {}, " "),
    "Filetypes: " .. table.concat(client.config.filetypes or {}, ", "),
  }

  local capabilities = {}

  for capability, enabled in pairs(client.server_capabilities or {}) do
    if enabled == true then
      table.insert(capabilities, capability)
    end
  end

  table.sort(capabilities)

  if #capabilities > 0 then
    table.insert(lines, "")
    table.insert(lines, "Capabilities:")

    for _, capability in ipairs(capabilities) do
      table.insert(lines, "  " .. capability)
    end
  end

  vim.notify(
    table.concat(lines, "\n"),
    vim.log.levels.INFO,
    {
      title = "LSP: " .. client.name,
      timeout = 10000,
    }
  )
end

return M
