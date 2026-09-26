return {
  {
    "dominionthedev/timeline.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = {
      {
        "<leader>ft",
        "<cmd>TimelineView<cr>",
        desc = "File timeline",
      },
    },
    config = function()
      require("timeline").setup({})
    end,
  },
}
