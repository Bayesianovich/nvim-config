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
    { "<leader>ag", nil, desc = "Gemini" },
    { "<leader>agt", "<cmd>GeminiToggle<cr>", desc = "Toggle Gemini sidebar" },
    { "<leader>agc", "<cmd>GeminiSwitchToCli<cr>", desc = "Spawn or switch to AI session" },
    { "<leader>agd", "<cmd>GeminiSendLineDiagnostic<cr>", mode = "n", desc = "Send to Gemini" },
    { "<leader>agD", "<cmd>GeminiSendFileDiagnostic<cr>", mode = "n", desc = "Send to Gemini" },
    { "<leader>aga", "<cmd>GeminiAccept<cr>", mode = "n", desc = "Accept Gemini Diff" },
    { "<leader>agx", "<cmd>GeminiReject<cr>", mode = "n", desc = "Reject Gemini Diff" },
    { "<leader>ags", "<cmd>GeminiSend<cr>", mode = { "v" }, desc = "Send selection to Gemini" },
  },
}
