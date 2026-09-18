return {
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    cmd = "Yazi",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      { "<leader>y", nil, desc = "Yazi" },
      {
        "<leader>yf",
        "<cmd>Yazi<cr>",
        mode = { "n", "v" },
        desc = "Yazi: Current File",
      },
      {
        "<leader>yc",
        "<cmd>Yazi cwd<cr>",
        desc = "Yazi: Working Directory",
      },
      {
        "<leader>yr",
        "<cmd>Yazi toggle<cr>",
        desc = "Yazi: Resume Session",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
}
