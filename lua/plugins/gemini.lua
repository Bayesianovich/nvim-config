local function has_gemini_cli()
  return vim.fn.executable("gemini") == 1 or vim.fn.executable("qwen") == 1
end

return {
  "gutsavgupta/nvim-gemini-companion",
  dependencies = { "nvim-lua/plenary.nvim" },
  cond = has_gemini_cli,
  cmd = {
    "GeminiToggle",
    "GeminiSwitchToCli",
    "GeminiSend",
    "GeminiSendFileDiagnostic",
    "GeminiSendLineDiagnostic",
    "GeminiAccept",
    "GeminiReject",
    "GeminiClose",
    "GeminiSwitchSidebarStyle",
  },
  config = function()
    require("gemini").setup()
  end,
  keys = {
    { "<leader>g", nil, desc = "Git / AI" },
    { "<leader>ge", "<cmd>GeminiToggle<cr>", desc = "Toggle Gemini sidebar" },
    { "<leader>gc", "<cmd>GeminiSwitchToCli<cr>", desc = "Spawn or switch to AI session" },
    { "<leader>gd", "<cmd>GeminiSendLineDiagnostic<cr>", mode = "n", desc = "Send to Gemini" },
    { "<leader>gD", "<cmd>GeminiSendFileDiagnostic<cr>", mode = "n", desc = "Send to Gemini" },
    { "<leader>ga", "<cmd>GeminiAccept<cr>", mode = "n", desc = "Accept Gemini Diff" },
    { "<leader>gx", "<cmd>GeminiReject<cr>", mode = "n", desc = "Reject Gemini Diff" },
    { "<leader>gs", "<cmd>GeminiSend<cr>", mode = { "v" }, desc = "Send selection to Gemini" },
  },
}
