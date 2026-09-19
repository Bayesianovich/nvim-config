return {
  -- 1. 基础透明度插件，可以强制让所有窗口透明
  {
    "xiyaowong/transparent.nvim",
    event = "UIEnter",
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
    lazy = true,
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

  -- 4. 状态栏显示当前 Python / Conda 虚拟环境
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local function python_env()
        -- 1. 优先获取 venv-selector 当前选择的环境
        local ok, vs = pcall(require, "venv-selector")
        if ok and vs and vs.venv then
          local venv_path = vs.venv()
          if venv_path and venv_path ~= "" then
            return " " .. vim.fn.fnamemodify(venv_path, ":t")
          end
        end

        -- 2. 读取终端中已激活的 Conda 环境
        local conda = os.getenv("CONDA_DEFAULT_ENV")
        if conda and conda ~= "" then
          return " " .. conda
        end

        -- 3. 读取终端中已激活的 virtualenv / venv
        local venv = os.getenv("VIRTUAL_ENV")
        if venv and venv ~= "" then
          return " " .. vim.fn.fnamemodify(venv, ":t")
        end

        -- 4. 兜底检测当前工程下的 pyrightconfig.json
        local cwd = vim.fn.getcwd()
        local pyright_cfg = cwd .. "/pyrightconfig.json"
        if vim.fn.filereadable(pyright_cfg) == 1 then
          local content = vim.fn.readfile(pyright_cfg)
          local ok_json, data = pcall(vim.json.decode, table.concat(content, ""))
          if ok_json and data and data.venv and data.venv ~= "" then
            return " " .. data.venv
          end
        end

        -- 5. 兜底检测当前工程下的 .vscode/settings.json
        local vscode_cfg = cwd .. "/.vscode/settings.json"
        if vim.fn.filereadable(vscode_cfg) == 1 then
          local content = vim.fn.readfile(vscode_cfg)
          local ok_json, data = pcall(vim.json.decode, table.concat(content, ""))
          if ok_json and data and data["python.defaultInterpreterPath"] then
            local env = data["python.defaultInterpreterPath"]:match("envs/([^/]+)/bin/python")
            if env then
              return " " .. env
            end
          end
        end

        return ""
      end

      table.insert(opts.sections.lualine_x, 1, {
        python_env,
        cond = function()
          return vim.bo.filetype == "python" or python_env() ~= ""
        end,
        color = { fg = "#7aa2f7", gui = "bold" },
      })
    end,
  },

  -- 5. 优化顶部 Bufferline 标签：让内置终端标签显示为友好名称和环境名，而不是 term:/.../bin/zsh
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.name_formatter = function(buf)
        local name = buf.name or ""
        local path = buf.path or ""
        if name:match("^term://") or path:match("^term://") then
          local conda = os.getenv("CONDA_DEFAULT_ENV")
          if conda and conda ~= "" then
            return "Terminal (" .. conda .. ")"
          end
          return "Terminal"
        end
      end
    end,
  },
}
