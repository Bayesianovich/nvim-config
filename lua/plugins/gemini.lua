return {
  "gutsavgupta/nvim-gemini-companion",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    require("gemini").setup()
  end,
  keys = {
    { "<leader>g", nil, desc = "Gemini Code" },
    { "<leader>ge", "<cmd>GeminiToggle<cr>", desc = "Toggle Gemini sidebar" },
    { "<leader>gc", "<cmd>GeminiSwitchToCli<cr>", desc = "Spawn or switch to AI session" },
    { "<leader>gd", "<cmd>GeminiSendLineDiagnostic<cr>", mode = "n", desc = "Send to Gemini" },
    { "<leader>gD", "<cmd>GeminiSendFileDiagnostic<cr>", mode = "n", desc = "Send to Gemini" },
    { "<leader>ga", "<cmd>GeminiAccept<cr>", mode = "n", desc = "Accept Gemini Diff" },
    { "<leader>gx", "<cmd>GeminiDeny<cr>", mode = "n", desc = "Deny Gemini Diff" },
    { "<leader>gs", "<cmd>GeminiSend<cr>", mode = { "v" }, desc = "Send selection to Gemini" },
  },
}
