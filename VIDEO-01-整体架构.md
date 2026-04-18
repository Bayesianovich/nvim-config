# 视频 01：整体架构

## 标题候选

- 我的 Neovim 配置到底是怎么组织的
- 我为什么用 LazyVim 做底座，而不是从零写一套配置
- 一次讲清这套 Neovim 配置的目录结构和设计思路

## 定位

- 建议时长：8-12 分钟
- 目标观众：已经装过 Neovim，但配置越来越乱的人
- 核心目标：让观众看懂这套配置的组织方式，而不是记住每一个插件名

## 开场钩子

你可以直接照着念：

> 很多人看别人 Neovim 配置的时候，最容易被一堆插件名淹没。但我觉得真正值得学的不是“装了什么”，而是“怎么组织”。这一期我不讲花哨功能，我先把我这套配置的骨架讲清楚。你如果看懂这一期，后面几期再看具体工作流就不会乱。

## 讲稿

### 第一段：先讲底座，不讲插件

> 我这套配置不是从零起一个巨大的 `init.lua`，而是基于 LazyVim 做底座。这样做的原因很简单，基础设施它已经帮我铺好了，比如插件管理、很多常用默认键位、LSP 相关的通用能力。我真正关心的是在这个基础上加我自己的工作流，而不是重复造轮子。

> 所以如果你打开这个仓库，第一眼看到的入口非常简单，就是根目录下的 `init.lua`。这里没有堆很多逻辑，它只做一件事，就是 `require("config.lazy")`。这其实就是我想表达的第一个设计原则：入口越薄越好，真正的逻辑都往模块里拆。

### 第二段：讲 `lua/config`

> 继续看 `lua/config` 这个目录，这里是整套配置的核心层。最重要的几个文件，一个是 `lazy.lua`，它负责把 LazyVim 和我自己的 `plugins` 目录都接进来。一个是 `options.lua`，放编辑器选项。一个是 `keymaps.lua`，放我额外加的快捷键。`autocmds.lua` 放自动命令。现在我还专门拆了一个 `platform.lua`，把跨平台剪贴板和 `gx` 打开路径、链接的行为单独收口。

> 这几个文件的职责很明确。选项在选项里，快捷键在快捷键里，自动命令在自动命令里。你后面维护的时候脑子负担会小很多。很多人的配置越写越乱，本质上不是不会写 Lua，而是文件职责一开始没分清。

### 第三段：讲 `lua/plugins`

> 再往下看就是 `lua/plugins`。这个目录是我最常用的组织方式。它不是按“插件作者”分，也不是按“安装顺序”分，而是按功能分。比如 AI 相关我拆成 `claudecode.lua`、`codex.lua`、`gemini.lua`。Git 和项目信息流拆成 `git-view.lua`、`todo.lua`。调试相关拆成 `dap.lua` 和 `dap-lang.lua`。格式化有 `formatting.lua`。编辑体验有 `editing.lua`、`leap.lua`、`folding.lua`。界面和视觉有 `ui.lua`、`dashboard.lua`。平台兼容和前端补丁则单独拆成 `platform.lua`、`web.lua`。

> 这么拆的好处是，你以后想删一个能力，或者重做一类功能，直接找到对应文件就行，不需要在一个上千行的总配置里到处搜。

### 第四段：讲一个很有代表性的自定义

> 这套配置里我觉得比较能代表我思路的，不是某一个插件，而是我会在默认行为上做很小但很具体的补丁。比如 `lua/config/platform.lua` 里，我把跨平台剪贴板和 `gx` 打开动作抽成了一层；`lua/plugins/snacks.lua` 里，我也没有重写整个 Snacks，而是只补了终端和 picker 的局部行为。这个思路很重要：你不需要为了一个细节问题推翻整套插件，只要在局部把路径补顺。

### 第五段：讲为什么这样拆适合教学

> 如果你也想做一套长期维护的 Neovim 配置，我建议你优先学这种拆法。因为这不是只为了“现在能用”，而是为了三个月以后你回来看，还能知道每段代码为什么在这里。尤其是你开始录教程、写文档、分享仓库的时候，这种结构会非常省力。

### 结尾

> 所以这一期你可以先记住三个点。第一，入口要薄。第二，核心配置和插件配置分开。第三，插件文件按功能拆，不要堆成一个大文件。后面几期我会基于这个结构，具体讲我每天怎么用这套配置写代码。

## 录屏顺序

1. 先开 `nvim`，展示启动界面 5-8 秒。
2. 回到项目根目录，展示仓库树结构。
3. 打开 `init.lua`，停留 3 秒，强调入口很薄。
4. 打开 `lua/config/lazy.lua`，讲 LazyVim 和自定义插件入口。
5. 依次打开 `lua/config/options.lua`、`lua/config/keymaps.lua`、`lua/config/autocmds.lua`、`lua/config/platform.lua`。
6. 切到 `lua/plugins` 目录，快速扫过文件名。
7. 分别点开 `claudecode.lua`、`git-view.lua`、`dap.lua`、`editing.lua`、`web.lua`、`ui.lua`，展示“按功能拆文件”的感觉。
8. 最后点开 `lua/plugins/snacks.lua`，讲“只补细节，不推翻默认”的思路。

## 录屏时应该打开的文件

- `init.lua`
- `lua/config/lazy.lua`
- `lua/config/options.lua`
- `lua/config/keymaps.lua`
- `lua/config/autocmds.lua`
- `lua/config/platform.lua`
- `lua/plugins/snacks.lua`
- `lua/plugins/claudecode.lua`
- `lua/plugins/git-view.lua`
- `lua/plugins/dap.lua`
- `lua/plugins/dap-lang.lua`
- `lua/plugins/editing.lua`
- `lua/plugins/web.lua`
- `lua/plugins/ui.lua`

## 镜头备注

- 不要一开始就展示所有插件名称，那样观众会疲劳。
- `lua/plugins` 目录可以用树形视图扫一遍，但停留别太久。
- 讲到“职责分离”时，最好把光标停在文件名上，而不是只念路径。

## 这一集的核心句

如果你想做一个短封面文案或视频简介，可以直接用这句：

> 这套 Neovim 配置真正值得学的，不是装了什么插件，而是它怎么把入口、核心配置和插件能力拆开。
