return {
  {
    "pittcat/codex.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = true,
    cmd = {
      "CodexOpen",
      "CodexToggle",
      "CodexSendPath",
      "CodexSendSelection",
      "CodexSendReference",
      "CodexSendContent",
    },
    keys = {
      { "<leader>ao", nil, desc = "Codex" },
      {
        "<leader>aoc",
        function()
          vim.cmd("CodexToggle")
        end,
        desc = "Toggle Codex",
        mode = { "n", "t" },
      },
      {
        "<leader>aof",
        function()
          vim.cmd("CodexOpen")
        end,
        desc = "Focus Codex",
        mode = { "n", "t" },
      },
      {
        "<leader>aob",
        function()
          vim.cmd("CodexSendPath")
        end,
        desc = "Add current buffer",
      },
      {
        "<leader>aos",
        ":'<,'>CodexSendSelection<CR>",
        mode = "x",
        desc = "Send selection",
      },
      {
        "<leader>aor",
        ":'<,'>CodexSendReference<CR>",
        mode = "x",
        desc = "Send reference",
      },
      {
        "<leader>aoC",
        ":'<,'>CodexSendContent<CR>",
        mode = "x",
        desc = "Send content",
      },
    },
    opts = {
      terminal = {
        provider = "snacks",
        direction = "vertical",
        position = "right",
        size = 0.4,
      },
      terminal_bridge = {
        path_format = "rel",
        path_prefix = "@",
        auto_attach = true,
        selection_mode = "reference",
      },
      focus_after_send = false,
    },
  },
}
