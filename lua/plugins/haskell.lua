return {
  -- 添加 Haskell LSP 支持
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hls = {
          -- Haskell Language Server 配置
          settings = {
            haskell = {
              formattingProvider = "ormolu", -- 或 "fourmolu", "stylish-haskell"
            },
          },
        },
      },
    },
  },

  -- 添加 Treesitter 语法高亮
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "haskell" },
    },
  },
}
