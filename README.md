# My Neovim Configuration

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的个人 Neovim 配置，重点围绕下面几类日常开发场景来组织：

- AI 协作：Claude Code、Gemini、Codex
- 终端与 Git 工作流：Snacks Terminal、Lazygit、Diffview
- 调试：`nvim-dap`、`nvim-dap-ui`、`mason-nvim-dap`
- 编辑体验：Leap、Yanky、Surround、UFO Folding
- 文档与界面：render-markdown、Dashboard、Lualine、透明主题

这不是一套“尽量堆满插件”的配置，而是一套按功能拆文件、方便长期维护和复用的配置。

## 特点

- 基于 LazyVim，但保留了明确的个人工作流
- `lua/config` 负责核心行为，`lua/plugins` 负责功能模块
- AI、终端、调试、编辑体验分层清晰
- 保留 `lazy-lock.json`，方便复现锁定版本
- 支持按文件类型覆盖缩进，例如 Python / C / C++ / Rust 默认 4 空格

## 前置要求

建议至少准备下面这些基础环境：

- Neovim `>= 0.11`
- `git`
- `curl` 和 `unzip`
- `ripgrep`
- `fd` 或 `fdfind`
- 一个可用的 C 编译器
- Nerd Font

根据你的使用场景，下面这些工具也很推荐：

- `lazygit`
- `wl-clipboard` 或 `xclip`
- `node`
- `python3`
- `go`
- `clang-format`

## 安装

1. 备份旧配置：

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

2. 克隆仓库：

```bash
git clone https://github.com/Bayesianovich/nvim-config.git ~/.config/nvim
```

3. 首次启动：

```bash
nvim
```

首次启动时，Lazy.nvim 会根据 [lazy-lock.json](./lazy-lock.json) 安装锁定版本的插件。

4. 建议首次启动后执行：

```vim
:checkhealth
:Mason
```

如果你更新了仓库但本地插件没有同步，可以执行：

```vim
:Lazy sync
```

## AI 相关配置

### Claude Code

需要本机已安装 `claude` CLI，并完成认证。这个插件本身依赖 Claude Code CLI，而不只是一个环境变量。

参考命令：

```bash
which claude
claude doctor
```

### Gemini

需要设置：

```bash
export GEMINI_API_KEY="your-api-key-here"
```

### Codex

当前配置使用的是 `pittcat/codex.nvim`，它依赖 Codex CLI，并通过 `Snacks` 右侧分栏承载终端，同时支持把当前文件、选区引用和选区内容直接送进 Codex 会话。

你至少需要：

```bash
npm install -g @openai/codex
codex login
```

如果你更偏好 API Key，也可以：

```bash
export OPENAI_API_KEY="your-api-key-here"
printenv OPENAI_API_KEY | codex login --with-api-key
```

### LazyVim AI Extras

当前 [lazyvim.json](./lazyvim.json) 里还启用了这些 extras：

- `ai.copilot`
- `ai.copilot-chat`
- `ai.supermaven`

如果你不想用它们，可以直接从 [lazyvim.json](./lazyvim.json) 里删掉对应条目。

## 常用快捷键

### 通用

- `<leader>` = 空格
- `<leader>2`：打开/关闭居中的浮动终端
- `<leader>3`：打开/关闭右侧终端
- `<leader>gg`：打开 Lazygit
- `<leader>p`：打开 Yank 历史

### Claude Code

- `<leader>ac`：打开/关闭 Claude
- `<leader>af`：聚焦 Claude
- `<leader>ar`：恢复上一段会话
- `<leader>aC`：继续当前会话
- `<leader>am`：选择模型
- `<leader>ab`：添加当前 buffer 到上下文
- Visual 模式 `<leader>as`：发送选中内容
- `<leader>ay`：接受 Claude diff
- `<leader>ad`：拒绝 Claude diff

### Codex

- `<leader>xc`：打开/关闭 Codex 终端分栏
- `<leader>xf`：打开并聚焦 Codex
- `<leader>xb`：发送当前文件路径到 Codex
- Visual 模式 `<leader>xs`：发送选中内容（按当前配置默认走引用）
- Visual 模式 `<leader>xr`：发送选中范围的文件引用
- Visual 模式 `<leader>xC`：发送选中范围的实际代码内容

### Gemini

- `<leader>ge`：切换 Gemini 侧边栏
- `<leader>gc`：启动或切换 Gemini 会话
- `<leader>gd`：发送当前行诊断
- `<leader>gD`：发送整个文件诊断
- Visual 模式 `<leader>gs`：发送选中代码
- `<leader>ga`：接受 Gemini diff
- `<leader>gx`：拒绝 Gemini diff

### 调试

- `<F5>`：开始/继续调试
- `<F1>`：步入
- `<F2>`：步过
- `<F3>`：步出
- `<F7>`：切换调试 UI
- `<leader>db`：切换断点
- `<leader>dB`：条件断点

### Todo

- `<leader>xt`：在 Trouble 中查看 Todo
- `<leader>xT`：在 Trouble 中查看 `TODO/FIX/FIXME`

说明：`<leader>x` 这个前缀现在同时承载 Codex 和 Todo 相关操作。

## 文档索引

仓库里已经附带几份针对当前配置的说明文档：

- [AI-快捷键说明.md](./AI-快捷键说明.md)
- [复制粘贴速查表.md](./复制粘贴速查表.md)
- [LEAP.md](./LEAP.md)
- [VIDEO-00-录制总表.md](./VIDEO-00-录制总表.md)
- [VIDEO-01-整体架构.md](./VIDEO-01-整体架构.md)
- [VIDEO-02-日常工作流.md](./VIDEO-02-日常工作流.md)
- [VIDEO-03-AI工作流.md](./VIDEO-03-AI工作流.md)
- [VIDEO-04-调试与格式化.md](./VIDEO-04-调试与格式化.md)
- [VIDEO-05-编辑体验与界面.md](./VIDEO-05-编辑体验与界面.md)
- [VIDEO-06-如何扩展这套配置.md](./VIDEO-06-如何扩展这套配置.md)

## 目录结构

```text
~/.config/nvim/
├── init.lua
├── lazy-lock.json
├── lazyvim.json
├── after/
│   └── ftplugin/
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins/
│       ├── claudecode.lua
│       ├── codex.lua
│       ├── dap.lua
│       ├── dap-lang.lua
│       ├── editing.lua
│       ├── formatting.lua
│       ├── gemini.lua
│       ├── markdown.lua
│       ├── snacks.lua
│       ├── ui.lua
│       └── ...
├── AI-快捷键说明.md
├── 复制粘贴速查表.md
└── README.md
```

## 复用建议

如果你是第一次直接复用这套配置，建议按这个顺序检查：

1. `nvim --version` 是否足够新
2. `ripgrep`、`fd`、剪贴板工具是否已安装
3. `:checkhealth` 是否通过
4. AI 相关 CLI 或 API Key 是否配置好
5. `:Mason` 里需要的调试器和语言工具是否安装完成

如果你不需要某些能力，最简单的删减方式不是去改一个大文件，而是直接删对应的插件文件或 extras：

- 不用某个 AI，就删对应插件文件或移除 `lazyvim.json` extras
- 不用某个语言层，就删对应 `lua/plugins/*.lua`
- 不用某份文档，就单独删对应 Markdown 文件

## 自定义

### 添加新插件

在 `lua/plugins/` 下新增一个文件，例如：

```lua
return {
  "username/plugin-name",
  opts = {},
}
```

### 修改核心行为

- 编辑器选项：`lua/config/options.lua`
- 快捷键：`lua/config/keymaps.lua`
- 自动命令：`lua/config/autocmds.lua`
- 插件入口：`lua/config/lazy.lua`

### 调整语言默认缩进

当前按文件类型的缩进覆盖在 `after/ftplugin/` 下：

- `python.lua`
- `c.lua`
- `cpp.lua`
- `rust.lua`

## License

[MIT](./LICENSE)
