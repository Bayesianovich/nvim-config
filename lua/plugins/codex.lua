return {
  {
    "kkrampis/codex.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = { "Codex", "CodexToggle" },
    keys = {
      {
        "<leader>cx",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex (AI)",
        mode = { "n", "t" },
      },
    },
    opts = {
      keymaps = {
        toggle = nil,
        quit = "<C-q>",
      },
      border = "rounded",
      width = 0.4, -- 侧边栏模式下，宽度通常设小一点
      height = 0.8,
      model = nil,
      autoinstall = true,
      panel = true, -- 开启侧边栏模式（垂直分割）
      use_buffer = false,
    },
  },

  -- 整合 Lualine 状态显示
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          local ok, codex = pcall(require, "codex")
          return ok and codex.status() or ""
        end,
      })
    end,
  },
}
