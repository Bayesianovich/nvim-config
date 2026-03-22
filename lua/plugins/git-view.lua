return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gV", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      { "<leader>gF", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Diff Files" },
    },
    opts = {},
  },
}
