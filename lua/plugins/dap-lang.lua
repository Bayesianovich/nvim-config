return {
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        detached = vim.fn.has("win32") == 0,
      },
    },
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local python = vim.fn.exepath("python3")
      if python == "" then
        python = vim.fn.exepath("python")
      end
      require("dap-python").setup(python ~= "" and python or "python")
    end,
  },
}
