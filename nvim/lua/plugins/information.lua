return {
  {
    "stevearc/aerial.nvim",
    keys = {
      {
        "<leader>cs",
        "<cmd>AerialToggle<cr>",
        desc = "Symbols outline",
      },
    },
    opts = {
      backends = { "treesitter", "lsp", "markdown", "man" },
      layout = {
        default_direction = "right",
        width = 30,
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
  },

  {
    "maskudo/devdocs.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>hi",
        mode = "n",
        "<cmd>DevDocs install<cr>",
        desc = "Install Devdocs",
      },
      {
        "<leader>hg",
        mode = "n",
        function()
          local devdocs = require("devdocs")
          local installedDocs = devdocs.GetInstalledDocs()
          vim.ui.select(installedDocs, {}, function(selected)
            if not selected then
              return
            end
            local docDir = devdocs.GetDocDir(selected)
            Snacks.picker.files({ cwd = docDir })
          end)
        end,
        desc = "Get Devdocs",
      },
      {
        "<leader>hd",
        mode = "n",
        "<cmd>DevDocs delete<cr>",
        desc = "Delete Devdoc",
      },
    },
    opts = {
      ensure_installed = {
        "go",
        -- "python~3.11",
        -- "javascript"/"typescript",
        -- "rust",
        -- "zig",
      },
    },
  },
}
