local M = {}

M.transparent = true
M.flavour = "mocha"

function M.is_transparent()
  return M.transparent
end

local function apply(opts)
  require("catppuccin").setup({
    flavour = "auto",
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = M.is_transparent(),
    term_colors = true,
    default_integrations = true,
    auto_integrations = true,
    integrations = {
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "bold" },
          warnings = { "undercurl" },
          hints = { "italic" },
          information = { "italic" },
        },
      },
      mini = {
        enabled = true,
        indentscope_color = "overlay2",
      },
    },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      functions = { "bold" },
      strings = { "italic" },
      types = { "underline" },
    },
    custom_highlights = function(colors)
      return {
        NoiceMini = { bg = colors.mantle },
        NoiceMiniIcon = { bg = colors.mantle },
        NoiceMiniTitle = { bg = colors.mantle },
        NoiceMiniProgress = { bg = colors.mantle },
      }
    end,
  })

  vim.cmd.colorscheme("catppuccin")
end

function M.toggle()
  M.transparent = not M.transparent
  apply()
  return M.transparent
end

---@param flavour string
function M.set_flavour(flavour)
  M.flavour = flavour
  apply()
  return M.flavour
end

return M
