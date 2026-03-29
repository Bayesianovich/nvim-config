return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = {
      { "<leader>ax", false },
      {
        "<leader>aX",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "x" },
      },
    },
  },
}
