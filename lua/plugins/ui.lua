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

  -- 3. 终端版 Neovim 的平滑光标动画，接近 Neovide 的观感
  {
    "sphamba/smear-cursor.nvim",
    enabled = not vim.g.neovide,
    event = "VeryLazy",
    opts = {
      cursor_color = "#00ffff",
      stiffness = 0.55,
      trailing_stiffness = 0.18,
      stiffness_insert_mode = 0.5,
      trailing_stiffness_insert_mode = 0.2,
      damping = 0.72,
      damping_insert_mode = 0.78,
      trailing_exponent = 4,
      distance_stop_animating = 0.2,
      time_interval = 7,
      gamma = 1,
      never_draw_over_target = true,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = true,
      scroll_buffer_space = true,
      particles_enabled = true,
      particles_per_second = 90,
      particles_per_length = 12,
      particle_spread = 1,
      particle_max_lifetime = 450,
      particle_max_initial_velocity = 10,
      particle_velocity_from_cursor = 0.35,
      particle_damping = 0.18,
      particle_gravity = -28,
      min_distance_emit_particles = 0,
      transparent_bg_fallback_color = "#303030",
    },
  },
}
