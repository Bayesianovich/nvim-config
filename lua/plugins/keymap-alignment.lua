return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Prevent LSP attach from replacing the shared C++ run key with Rename File.
      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}
      local keys = opts.servers["*"].keys or {}
      for i = #keys, 1, -1 do
        if keys[i][1] == "<leader>cR" then
          table.remove(keys, i)
        end
      end
      keys[#keys + 1] = { "<leader>cR", false }
      opts.servers["*"].keys = keys
    end,
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>sp", function() Snacks.picker.grep({ cwd = vim.fn.stdpath("config") }) end,
        desc = "Search configuration" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>P", group = "project" } } },
  },
}
