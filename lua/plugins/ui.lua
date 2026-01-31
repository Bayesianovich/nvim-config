return {
  -- 1. 基础透明度插件，可以强制让所有窗口透明
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      extra_groups = {
        "NormalFloat", -- 浮动窗口
        "NvimTreeNormal", -- 文件树
        "NeoTreeNormal", -- Neo-tree
        "MasonNormal", -- Mason 界面
        "TelescopeNormal", -- Telescope 搜索框
        "TelescopeBorder",
        "WhichKeyFloat", -- 快捷键提示
        "SagaNormal", -- LspSaga
        "SagaBorder",
      },
    },
  },

  -- 2. 主题透明配置
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      transparent_mode = true,
    },
  },
}
