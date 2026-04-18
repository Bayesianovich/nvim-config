# Neovim 系列视频录制总表

这份文档是整个系列的总索引。你可以先按这里的顺序录，也可以把每一集拆开单独发。

## 推荐发布顺序

| 集数 | 文件 | 主题 | 建议时长 | 适合观众 |
|------|------|------|----------|----------|
| 01 | `VIDEO-01-整体架构.md` | 这套配置的目录结构和设计思路 | 8-12 分钟 | 想看全貌的人 |
| 02 | `VIDEO-02-日常工作流.md` | 终端、Git、剪贴板、项目内日常操作 | 8-12 分钟 | 想抄工作流的人 |
| 03 | `VIDEO-03-AI工作流.md` | Claude、Gemini、Codex 三套 AI 怎么共存 | 10-15 分钟 | 关注 AI 集成的人 |
| 04 | `VIDEO-04-调试与格式化.md` | DAP、Mason、Conform 的开发体验 | 8-12 分钟 | 写代码、调试的人 |
| 05 | `VIDEO-05-编辑体验与界面.md` | Leap、Yanky、Folding、UI 的体验层 | 8-12 分钟 | 关注手感和效率的人 |
| 06 | `VIDEO-06-如何扩展这套配置.md` | 如何按模块扩展语言和插件 | 8-12 分钟 | 想自己改配置的人 |

## 建议统一的录制环境

1. 字体和终端

- 用你平时真的在用的终端和字体，不要为了视频临时换一套完全不同的风格。
- 如果字体太花，建议保持 Nerd Font，但避免字号过小。

2. 演示仓库

- 准备一个干净的 demo 项目，里面最好同时有 `README.md`、`main.py`、`main.go`、`main.cpp` 这几类文件。
- 准备一个 Git 仓库，里边故意留几处修改，方便演示 `lazygit`、`diffview`、TODO 搜索。

3. AI 演示前检查

- 确认 Claude CLI 已认证、Codex 已完成 `codex login`。
- 确认 `gemini` 或 `qwen` CLI 可以直接调用；如果你的 Gemini CLI 走 API Key，再提前配好。
- 提前跑一遍 Claude、Gemini、Codex，确认它们能正常打开。

4. DAP 演示前检查

- 确认 `debugpy`、`delve`、`codelldb` 已装好。
- 先自己手动跑一次调试流程，别把首次安装过程录进去。

5. 录屏窗口布局

- 左边代码，右边终端或插件窗口，尽量别频繁切全屏。
- 保持一个统一的窗口大小，这样系列视频会更整齐。

## 系列统一开场

你每一集都可以用下面这段作为统一开头：

> 大家好，这是一套我自己长期在用的 Neovim 配置。它不是那种为了炫技堆很多插件的配置，而是围绕日常写代码、调试、Git、AI 协作和编辑效率来搭的。这个系列我会按模块拆开讲，每一集只讲一件事，尽量让你看完就能拿走一部分思路。

## 系列统一结尾

每一集可以用类似的话收尾：

> 这一集如果你只记住一件事，那就是我这套配置不是靠一个大而全的 `init.lua` 撑起来的，而是靠按功能拆分的小模块。你不用照抄全部，但你可以拿走这个组织方式。下一集我会继续讲更具体的工作流。

## 每集都建议保留的镜头

1. 开头 10 秒直接展示实际效果，不要先讲概念。
2. 中间切到配置文件时，光标移动要慢，避免观众跟不上。
3. 每讲一个功能，最好马上回到编辑器里演示一次。
4. 结尾放出对应文件路径，让观众知道这一集该看哪几个文件。

## 你这套配置里最值得反复强调的点

- 基于 LazyVim，但没有把所有东西都塞进默认配置里。
- `lua/config` 和 `lua/plugins` 分层明确。
- AI 不是只装一个插件，而是按场景并存。
- 日常工作流里终端、Git、编辑、调试是连起来的。
- 跨平台剪贴板和 `gx` 打开被抽成了单独的平台层。
- 不是追求“插件越多越好”，而是追求“入口少、路径短、能重复使用”。

## 对应文件清单

- `init.lua`
- `lua/config/lazy.lua`
- `lua/config/options.lua`
- `lua/config/keymaps.lua`
- `lua/config/autocmds.lua`
- `lua/config/platform.lua`
- `lua/plugins/claudecode.lua`
- `lua/plugins/codex.lua`
- `lua/plugins/gemini.lua`
- `lua/plugins/dap.lua`
- `lua/plugins/dap-lang.lua`
- `lua/plugins/formatting.lua`
- `lua/plugins/editing.lua`
- `lua/plugins/git-view.lua`
- `lua/plugins/leap.lua`
- `lua/plugins/folding.lua`
- `lua/plugins/markdown.lua`
- `lua/plugins/platform.lua`
- `lua/plugins/ui.lua`
- `lua/plugins/todo.lua`
- `lua/plugins/web.lua`
- `lua/plugins/dashboard.lua`
- `lua/plugins/snacks.lua`

## 建议你先录哪三集

如果你不想一口气录完，优先录这三集：

1. `VIDEO-01-整体架构.md`
2. `VIDEO-02-日常工作流.md`
3. `VIDEO-03-AI工作流.md`

这三集最容易吸引人，也最能体现这套配置的特点。
