# � My Neovim Configuration

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的个人 Neovim 配置，集成了多个AI助手和实用插件，打造强大的开发环境。

## ✨ 特性

- 🤖 **多AI助手集成**: Claude Code, Gemini, Codex 三大AI助手
- 🐛 **强大的调试功能**: 集成 DAP 调试器，支持 Go 和 Python
- ⚡ **快速导航**: Leap 快速跳转
- 📝 **Todo 管理**: Todo Comments 高亮和快速跳转
- 💼 **时间追踪**: WakaTime 编码时间统计
- 🎨 **美化界面**: 自定义 Dashboard
- 🔧 **代码格式化**: Conform.nvim + clang-format
- 🔤 **自动配对**: 智能括号配对

## 📦 插件列表

### AI 助手
- **Claude Code** (`coder/claudecode.nvim`) - Claude AI 编码助手
  - `<leader>cc` - 打开/关闭 Claude
  - `<leader>cf` - 聚焦 Claude
  - `<leader>ca` - 接受差异
  - `<leader>cd` - 拒绝差异
  
- **Gemini Companion** (`gutsavgupta/nvim-gemini-companion`) - Google Gemini AI 助手
  - `<leader>ge` - 切换 Gemini 侧边栏
  - `<leader>gc` - 启动 AI 会话
  - `<leader>ga` - 接受建议
  - `<leader>gx` - 拒绝建议
  
- **Codex** (`kkrampis/codex.nvim`) - AI 代码助手
  - `<leader>cx` - 切换 Codex 侧边栏

### 开发工具
- **nvim-dap** - 调试适配器协议支持
  - `<F5>` - 开始/继续调试
  - `<F1>` - 步入
  - `<F2>` - 步过
  - `<F3>` - 步出
  - `<leader>db` - 切换断点
  
- **Leap** (`andyg/leap.nvim`) - 快速跳转
- **Todo Comments** (`folke/todo-comments.nvim`) - Todo 注释高亮
  - `]t` / `[t` - 下一个/上一个 todo
  - `<leader>xt` - 在 Trouble 中显示
  - `<leader>st` - 在 Telescope 中搜索
  
- **Conform.nvim** - 代码格式化（支持 clang-format）
- **nvim-autopairs** - 自动括号配对
- **WakaTime** - 编码时间统计

### 界面美化
- **Snacks Dashboard** - 自定义启动界面
- **Lualine** - 状态栏（集成 Codex 状态显示）

## 🚀 快速开始

### 前置要求

- Neovim >= **0.10.0** (推荐 0.11.0+，最低要求 0.9.0)
- Git
- [Nerd Font](https://www.nerdfonts.com/) (推荐 JetBrainsMono Nerd Font)
- Node.js (用于某些 LSP 服务器)
- Python 3 (用于 Python 调试)
- Go (用于 Go 调试，可选)

### 安装步骤

1. **备份现有配置**（如果有的话）
```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

2. **克隆此配置**
```bash
git clone https://github.com/Bayesianovich/nvim-config.git ~/.config/nvim
```

3. **启动 Neovim**
```bash
nvim
```

首次启动时，Lazy.nvim 会自动安装所有插件，请耐心等待。

### AI 助手配置

#### Claude Code
需要配置 Anthropic API Key:
```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

#### Gemini
需要配置 Google Gemini API Key:
```bash
export GEMINI_API_KEY="your-api-key-here"
```

建议将这些环境变量添加到你的 `~/.bashrc` 或 `~/.zshrc` 文件中。

### 调试器配置

调试器适配器会通过 Mason 自动安装，支持：
- Go (delve)
- Python (debugpy)

### WakaTime 配置

首次使用 WakaTime 时，会提示输入 API key，可以从 [WakaTime 官网](https://wakatime.com/) 获取。

## ⌨️ 常用快捷键

### 通用快捷键
- `<leader>` = `空格键`
- `<leader>2` - 打开浮动终端
- `<leader>gg` - 打开 Lazygit

### AI 助手快捷键

#### Claude Code 快捷键
| 快捷键 | 模式 | 功能说明 |
|--------|------|----------|
| `<leader>cc` | Normal | 打开/关闭 Claude 对话窗口 |
| `<leader>cf` | Normal | 聚焦到 Claude 窗口 |
| `<leader>cr` | Normal | 恢复上一次 Claude 会话 |
| `<leader>cC` | Normal | 继续当前 Claude 对话 |
| `<leader>cm` | Normal | 选择 Claude AI 模型 |
| `<leader>cb` | Normal | 添加当前缓冲区到 Claude 上下文 |
| `<leader>cs` | Visual | 发送选中的文本到 Claude |
| `<leader>cs` | File Tree | 从文件树添加文件到 Claude |
| `<leader>ca` | Normal | 接受 Claude 建议的代码差异 |
| `<leader>cd` | Normal | 拒绝 Claude 建议的代码差异 |

#### Gemini 快捷键
| 快捷键 | 模式 | 功能说明 |
|--------|------|----------|
| `<leader>ge` | Normal | 切换 Gemini 侧边栏显示/隐藏 |
| `<leader>gc` | Normal | 启动或切换到 Gemini AI 会话 |
| `<leader>gd` | Normal | 发送当前行的诊断信息到 Gemini |
| `<leader>gD` | Normal | 发送整个文件的诊断信息到 Gemini |
| `<leader>gs` | Visual | 发送选中的代码到 Gemini 分析 |
| `<leader>ga` | Normal | 接受 Gemini 建议的代码修改 |
| `<leader>gx` | Normal | 拒绝 Gemini 建议的代码修改 |

#### Codex 快捷键
| 快捷键 | 模式 | 功能说明 |
|--------|------|----------|
| `<leader>cx` | Normal/Terminal | 切换 Codex AI 侧边栏 |
| `<C-q>` | Codex 窗口 | 退出 Codex 窗口 |

### 调试快捷键
| 功能 | 快捷键 | 说明 |
|------|--------|------|
| 开始/继续 | `<F5>` | 启动或继续调试 |
| 步入 | `<F1>` | Step Into |
| 步过 | `<F2>` | Step Over |
| 步出 | `<F3>` | Step Out |
| 断点 | `<leader>db` | 切换断点 |

### Todo 快捷键
| 功能 | 快捷键 | 说明 |
|------|--------|------|
| 下一个 Todo | `]t` | 跳转到下一个 todo 注释 |
| 上一个 Todo | `[t` | 跳转到上一个 todo 注释 |
| Todo 列表 | `<leader>st` | 在 Telescope 中搜索 |

## 📁 目录结构

```
~/.config/nvim/
├── init.lua                 # 入口文件
├── lazy-lock.json          # 插件版本锁定
├── lazyvim.json            # LazyVim 配置
├── stylua.toml             # Lua 格式化配置
├── lua/
│   ├── config/             # 核心配置
│   │   ├── autocmds.lua    # 自动命令
│   │   ├── keymaps.lua     # 自定义快捷键
│   │   ├── lazy.lua        # Lazy.nvim 配置
│   │   └── options.lua     # Vim 选项配置
│   └── plugins/            # 插件配置
│       ├── autopairs.lua   # 自动配对
│       ├── claudecode.lua  # Claude Code AI
│       ├── codex.lua       # Codex AI
│       ├── dap.lua         # 调试器
│       ├── dashboard.lua   # 启动界面
│       ├── formatting.lua  # 格式化配置
│       ├── gemini.lua      # Gemini AI
│       ├── leap.lua        # 快速跳转
│       ├── todo.lua        # Todo 注释
│       ├── ui.lua          # UI 配置
│       └── wakatime.lua    # 时间追踪
```

## 🔧 自定义配置

### 添加新插件

在 `lua/plugins/` 目录下创建新的 `.lua` 文件，例如 `lua/plugins/myplugin.lua`:

```lua
return {
  "username/plugin-name",
  config = function()
    -- 配置代码
  end,
}
```

### 修改快捷键

编辑 `lua/config/keymaps.lua` 文件添加自定义快捷键。

### 修改选项

编辑 `lua/config/options.lua` 文件修改 Vim 选项。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🙏 致谢

- [LazyVim](https://github.com/LazyVim/LazyVim) - 优秀的 Neovim 配置框架
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - 现代化的插件管理器
- 所有插件作者的辛勤工作

---

如果这个配置对你有帮助，请给个 ⭐️ Star！
