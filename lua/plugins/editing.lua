return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "gbprod/yanky.nvim",
    event = "LazyFile",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      system_clipboard = {
        sync_with_ring = not vim.env.SSH_CONNECTION,
      },
      highlight = {
        timer = 150,
      },
    },
    keys = {
      {
        "<leader>p",
        function()
          if Snacks and Snacks.picker and Snacks.picker.yanky then
            Snacks.picker.yanky()
          else
            vim.cmd("YankyRingHistory")
          end
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
      { "[y", "<Plug>(YankyPreviousEntry)", desc = "Previous Yank History Entry" },
      { "]y", "<Plug>(YankyNextEntry)", desc = "Next Yank History Entry" },
    },
  },
}
