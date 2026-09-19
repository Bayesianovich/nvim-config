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
      local dap_python = require("dap-python")
      dap_python.setup(python ~= "" and python or "python")
      dap_python.resolve_python = function()
        local cwd = vim.fn.getcwd()
        local pyright_cfg = cwd .. "/pyrightconfig.json"
        if vim.fn.filereadable(pyright_cfg) == 1 then
          local content = vim.fn.readfile(pyright_cfg)
          local ok_json, data = pcall(vim.json.decode, table.concat(content, ""))
          if ok_json and data and data.venv and data.venvPath then
            local p = data.venvPath .. "/" .. data.venv .. "/bin/python"
            if vim.fn.filereadable(p) == 1 then
              return p
            end
          end
        end
        return nil
      end
    end,
  },
}
