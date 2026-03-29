# AI 快捷键说明

这份文档整理当前 Neovim 配置里与 AI 相关的快捷键，包含：

- Claude Code
- Codex
- Gemini

补充说明：

- `<leader>` 是空格键
- 现在 `Claude Code` 和 `Codex` 主要走 `<leader>a*`
- 现在 `Gemini` 仍然走 `<leader>g*`
- `<leader>c*` 已经让回给 `LSP`，用于 code action、rename 等代码能力

## Claude Code

Claude Code 适合处理“带上下文的项目级任务”，例如：

- 让 AI 理解当前文件和周边文件后再改代码
- 做多步修改
- 让 AI 产出 diff，然后你决定接收还是拒绝
- 延续上一次会话，而不是每次从零开始

| 快捷键 | 模式 | 作用 | 什么时候用 |
| --- | --- | --- | --- |
| `<leader>ac` | Normal | 打开/关闭 Claude 面板 | 需要开始或结束 Claude 会话时 |
| `<leader>af` | Normal | 聚焦 Claude 面板 | Claude 已经开着，只想快速切过去继续聊时 |
| `<leader>ar` | Normal | 恢复上一段 Claude 会话 | 上次聊到一半退出了，现在想接着上次上下文继续时 |
| `<leader>aC` | Normal | 继续当前 Claude 会话 | 当前项目里已有会话，想直接延续而不是新开时 |
| `<leader>am` | Normal | 选择 Claude 模型 | 当前任务复杂度变化了，想切模型时 |
| `<leader>ab` | Normal | 把当前 buffer 加入上下文 | 想让 Claude 明确看到当前文件内容时 |
| `<leader>as` | Visual | 发送选中代码到 Claude | 只想让 Claude 看一小段代码，而不是整个文件时 |
| `<leader>as` | 文件树 | 从文件树添加文件到 Claude 上下文 | 想追加别的文件作为上下文时 |
| `<leader>ay` | Normal | 接受 Claude 生成的 diff | Claude 改得对，准备落地时 |
| `<leader>ad` | Normal | 拒绝 Claude 生成的 diff | Claude 方案不合适，想撤掉建议时 |

### Claude Code 的常见用法

1. 用 `<leader>ac` 打开 Claude
2. 用 `<leader>ab` 把当前文件放进上下文
3. 需要精确讨论某一段代码时，用 Visual 模式选中后按 `<leader>as`
4. Claude 产出 diff 后，用 `<leader>ay` 或 `<leader>ad` 决定是否接收

更适合 Claude 的情况：

- 跨文件改动
- 重构
- 需要连续对话
- 需要 AI 基于上下文真正“动手改”

## Codex

Codex 现在是一个轻量侧边栏入口，适合快速调用，不强调像 Claude 那样完整的会话编排。

| 快捷键 | 模式 | 作用 | 什么时候用 |
| --- | --- | --- | --- |
| `<leader>ax` | Normal / Terminal | 打开/关闭 Codex 侧边栏 | 想快速呼出 Codex 时 |
| `<C-q>` | Codex 窗口内 | 退出 Codex 窗口 | 已经在 Codex 窗口里，想直接关闭时 |

更适合 Codex 的情况：

- 想快速打开一个 AI 侧栏
- 想边看代码边在侧边栏里问问题
- 不需要像 Claude 那样显式管理 diff 接收/拒绝

## Gemini

Gemini 现在更偏“诊断分析”和“把当前代码或错误送去问 AI”的工作流。

| 快捷键 | 模式 | 作用 | 什么时候用 |
| --- | --- | --- | --- |
| `<leader>ge` | Normal | 打开/关闭 Gemini 侧边栏 | 想切换 Gemini 面板显示状态时 |
| `<leader>gc` | Normal | 启动或切换到 Gemini 会话 | 想进入 Gemini 对话时 |
| `<leader>gd` | Normal | 发送当前行诊断给 Gemini | 当前行报错，想让 Gemini 直接解释时 |
| `<leader>gD` | Normal | 发送整个文件诊断给 Gemini | 当前文件报错较多，想整体分析时 |
| `<leader>gs` | Visual | 发送选中代码给 Gemini | 想单独分析某段代码时 |
| `<leader>ga` | Normal | 接受 Gemini 生成的 diff | Gemini 改得对，准备采纳时 |
| `<leader>gx` | Normal | 拒绝 Gemini 生成的 diff | Gemini 生成的修改不合适时 |

更适合 Gemini 的情况：

- 解释诊断信息
- 快速分析报错
- 对某一段代码做解释、排错、建议
- 基于诊断结果生成修复 diff

## 怎么选

可以按这个原则选：

- 需要项目级上下文、多轮修改、明确接收 diff：用 Claude Code
- 需要轻量侧边栏、快速问答：用 Codex
- 需要围绕报错和诊断快速分析：用 Gemini

## 一个实用建议

如果你写代码时已经进入 “修 bug” 模式，可以优先这样用：

1. 先用 `LSP` 看诊断
2. 报错不直观时，用 Gemini 的 `<leader>gd` 或 `<leader>gD`
3. 需要真正跨文件修改时，再切到 Claude Code
4. 只想快速开一个 AI 侧栏问一句时，用 Codex
