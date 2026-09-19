# My Neovim Configuration

基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的个人 Neovim 配置，重点围绕下面几类日常开发场景来组织：

- AI 协作：Claude Code、Codex、Copilot / Copilot Chat / Supermaven
- 终端与 Git 工作流：Snacks Terminal、Lazygit、Diffview
- 文件管理：Yazi 浮动窗口、当前文件定位与会话恢复
- 调试：`nvim-dap`、`nvim-dap-ui`、`mason-nvim-dap`
- 编辑体验：Flash、Yanky、Surround、UFO Folding
- 文档与界面：render-markdown、Dashboard、Lualine、透明主题
- Web 前端：HTML / CSS / SCSS、Tailwind、Emmet

这不是一套“尽量堆满插件”的配置，而是一套按功能拆文件、方便长期维护和复用的配置。

当前仓库支持 `macOS / Linux / WSL2 / Windows`，剪贴板和 `gx` 打开链接/文件会根据平台自动选择合适的系统命令。Linux、WSL2 和原生 Windows 提供一键安装脚本。

前端相关能力除了 LazyVim extras 里的 `typescript` / `tailwind` / `prettier` / `eslint` 之外，还额外补了 HTML、CSS、SCSS 的 Treesitter 与 LSP，以及 `emmet-language-server`。

## 特点

- 基于 LazyVim，但保留了明确的个人工作流
- `lua/config` 负责核心行为，`lua/plugins` 负责功能模块
- AI、终端、调试、编辑体验分层清晰
- 内置跨平台剪贴板和 `gx` 打开能力
- HTML / CSS / SCSS / Emmet 语言支持按模块补齐
- Cargo 与系统工具优先、Mason 作为兜底，降低预编译工具的兼容性风险
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
- `wl-clipboard`、`xclip` 或 `xsel`
- `node`
- `python3`
- `go`
- `clang-format`

平台说明：

- 如果检测到 `win32yank.exe`，会优先用它接管系统剪贴板
- `macOS`：优先使用系统自带的 `pbcopy` / `pbpaste` 和 `open`
- `Ubuntu`：优先使用 `wl-clipboard`，其次回退到 `xclip` / `xsel`，打开链接依赖 `xdg-open`
- `WSL2`：默认走 `clip.exe` / `powershell.exe` 和 `explorer.exe`
- `Windows`：配置安装到 `%LOCALAPPDATA%\nvim`，通过 `rundll32.exe` 打开链接或文件

## 一键安装

安装器会完成这些工作：

- 安装或检查 Neovim `>= 0.11`、Git、ripgrep、fd、Node、Python、编译器和剪贴板工具
- 安装 Lazygit
- 将已有 Nvim 配置移动到带时间戳的备份目录
- 克隆当前仓库到正确的平台配置目录
- 运行 Lazy.nvim 的首次插件同步

### Linux / WSL2

支持 Ubuntu / Debian、Fedora、Arch / Manjaro。需要当前用户能够使用 `sudo`，并且系统至少已有 `curl` 用于下载安装器。

一条命令安装：

```bash
curl -fsSL https://raw.githubusercontent.com/Bayesianovich/nvim-config/main/install.sh | bash
```

如果希望先检查脚本再执行：

```bash
curl -fsSLO https://raw.githubusercontent.com/Bayesianovich/nvim-config/main/install.sh
less install.sh
bash install.sh
```

常用选项：

```bash
bash install.sh --dry-run      # 只显示将要执行的操作
bash install.sh --skip-deps    # 已准备好依赖，只安装配置
bash install.sh --with-ai      # 同时安装 Claude Code 和 Codex CLI
```

### Windows

在 PowerShell 中执行。脚本依赖 Windows 10/11 自带或 Microsoft App Installer 提供的 `winget`。

一条命令安装：

```powershell
irm https://raw.githubusercontent.com/Bayesianovich/nvim-config/main/install.ps1 | iex
```

如果希望先检查脚本，或者使用可选参数：

```powershell
irm https://raw.githubusercontent.com/Bayesianovich/nvim-config/main/install.ps1 -OutFile install.ps1
Get-Content .\install.ps1
.\install.ps1 -DryRun
.\install.ps1 -WithAI
```

Windows 安装过程中可能出现 UAC 或 `winget` 软件许可确认。安装完成后请重新打开 PowerShell，让新的 `PATH` 完全生效。

### 安装器不会自动完成的事情

- Claude、Codex、Copilot 等账号登录或 API Key 配置
- 在 Windows Terminal、WezTerm、Kitty 等终端里选择 Nerd Font
- 安装每一种语言的完整 SDK，例如 Go、Rust、Java 或 Haskell
- 替你处理项目自己的编译工具链和环境变量

## 手动安装 / macOS

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

首次启动时，Lazy.nvim 会根据 [lazy-lock.json](./lazy-lock.json) 安装锁定版本的插件。一键安装脚本已经自动执行了这一步。

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
- `<C-/>`：打开/关闭继承当前文件目录的默认终端
- Normal 模式 `gx`：按当前平台打开光标下的文件路径或 URI
- Visual 模式 `gx`：打开选中的单行文件路径或 URI
- `<leader>p`：打开 Yank 历史
- `<leader>yf`：在当前文件位置打开 Yazi
- `<leader>yc`：在当前工作目录打开 Yazi
- `<leader>yr`：恢复上一次 Yazi 会话
- `<leader>cR`：格式化、保存、编译并运行当前单文件 C++ 源码
- `<leader>Pp`：项目列表
- `<leader>Pf`：当前项目文件
- `<leader>Ps`：保存所有文件

### Git / Diffview

- `<leader>gg`：打开 Lazygit
- `<leader>gV`：打开 Diffview
- `<leader>gH`：查看当前文件历史
- `<leader>gF`：切换 Diffview 文件列表

说明：`<leader>g` 专门用于 Git / Diffview，AI 功能统一放在 `<leader>a` 下。

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

- `<leader>aoc`：打开/关闭 Codex 终端分栏
- `<leader>aof`：打开并聚焦 Codex
- `<leader>aob`：发送当前文件路径到 Codex
- Visual 模式 `<leader>aos`：发送选中内容（按当前配置默认走引用）
- Visual 模式 `<leader>aor`：发送选中范围的文件引用
- Visual 模式 `<leader>aoC`：发送选中范围的实际代码内容

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

说明：`<leader>x` 保留给 LazyVim 的诊断、Trouble 和 Todo 操作。

## 文档索引

仓库里已经附带几份针对当前配置的说明文档：

- [AI-快捷键说明.md](./AI-快捷键说明.md)
- [复制粘贴速查表.md](./复制粘贴速查表.md)
- [TEACHING-00-教学文档规范.md](./TEACHING-00-教学文档规范.md)
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
├── install.sh
├── install.ps1
├── lazy-lock.json
├── lazyvim.json
├── after/
│   └── ftplugin/
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── cpp.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── options.lua
│   │   └── platform.lua
│   └── plugins/
│       ├── claudecode.lua
│       ├── codex.lua
│       ├── copilot-chat.lua
│       ├── dap.lua
│       ├── dap-lang.lua
│       ├── dashboard.lua
│       ├── editing.lua
│       ├── formatting.lua
│       ├── git-view.lua
│       ├── haskell.lua
│       ├── keymap-alignment.lua
│       ├── markdown.lua
│       ├── mason.lua
│       ├── platform.lua
│       ├── snacks.lua
│       ├── ui.lua
│       ├── web.lua
│       ├── yazi.lua
│       └── ...
├── AI-快捷键说明.md
├── TEACHING-00-教学文档规范.md
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
