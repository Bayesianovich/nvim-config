return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
    {
      "jay-babu/mason-nvim-dap.nvim",
      lazy = true,
      cmd = { "DapInstall", "DapUninstall" },
    },
  },
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F1>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F3>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Set Breakpoint",
    },
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        "codelldb",
        "debugpy",
      },
    })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- 自定义断点图标与高亮（替换默认简陋的字母 B）
    local function set_dap_highlights()
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400", bold = true })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e0af68", bold = true })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#737994" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#7dcfff" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#9ece6a", bold = true })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2d3540" })
    end

    set_dap_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_dap_highlights,
    })

    local signs = {
      DapBreakpoint = { text = "●", texthl = "DapBreakpoint", numhl = "DapBreakpoint" },
      DapBreakpointCondition = { text = "◆", texthl = "DapBreakpointCondition", numhl = "DapBreakpointCondition" },
      DapBreakpointRejected = { text = "", texthl = "DapBreakpointRejected" },
      DapLogPoint = { text = "", texthl = "DapLogPoint" },
      DapStopped = { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" },
    }

    for sign, config in pairs(signs) do
      vim.fn.sign_define(sign, config)
    end
  end,
}
