# 视频 06：如何扩展这套配置

## 标题候选

- 想在这套 Neovim 里加新语言和新插件，我会怎么做
- 别再把所有东西都塞进 init.lua 了
- 我是怎么按模块扩展 Neovim 配置的

## 定位

- 建议时长：8-12 分钟
- 目标观众：想在现有配置上继续加功能的人
- 核心目标：教观众怎么沿着你现在的组织方式继续扩展

## 开场钩子

> 前面几期讲的都是“我已经在用什么”。这一期我讲一个更关键的问题：如果我要继续扩展这套配置，我会怎么加，而且怎么保证它不会越长越乱。这个问题其实比装插件本身更重要。

## 讲稿

### 第一段：扩展原则

> 我扩展这套配置时，第一原则不是“先找一个最强插件”，而是先判断它属于哪一层。是编辑器基础选项？是额外快捷键？还是一个独立能力模块？如果是独立能力模块，我就尽量给它单独一个文件，放进 `lua/plugins`。语言支持只是其中一种扩展，平台兼容和开发栈补丁我也会按这个原则拆。

> 也就是说，我不会轻易把一个新功能塞回 `init.lua`，也不会把所有增量都堆进一个大杂烩文件。

### 第二段：以 Haskell 为例

> 比如 `lua/plugins/haskell.lua` 这个文件就是一个很标准的例子。它只做两件事，一个是给 `nvim-lspconfig` 增加 `hls`，一个是给 Treesitter 增加 `haskell` parser。这个文件结构很适合拿来教学，因为它说明了一件事：当你加一门语言时，通常只需要补三类东西，LSP、语法高亮、必要的话再加格式化或调试。

### 第三段：以 Markdown、Web、Platform 为例

> `lua/plugins/markdown.lua` 也是一样。它补了 markdown 和 markdown_inline 的 parser，再接一个 `render-markdown.nvim`。`lua/plugins/web.lua` 则把 HTML、CSS、SCSS 和 Emmet 的 parser、LSP、Mason 安装收在一起。再加上 `lua/config/platform.lua` 和 `lua/plugins/platform.lua` 这种平台层，你会发现扩展并不一定只按语言分，也可以按平台兼容和开发栈分。关键是主题要清楚。

### 第四段：以格式化和调试为例

> 如果你要给某门语言单独接格式化或者调试，也最好沿着这个思路走。比如当前 `formatting.lua` 就只讲 C/C++ 的 `clang-format`。`dap.lua` 是整个调试层的总入口，`dap-lang.lua` 则放语言相关补充。也就是说，你不是把所有语言的所有工具全塞在一个文件里，而是让“通用层”和“语言层”分开。

### 第五段：为什么这样扩展更适合长期维护

> 这种结构最大的好处不是优雅，而是可维护。你以后想删一门语言，直接删对应文件。想重做某个工作流，直接改那一类插件文件。你不会被一个历史包袱极重的 `init.lua` 绑住。

### 结尾

> 所以如果你想从我这套配置里带走一个长期有用的习惯，那就是：增量功能尽量按主题拆，核心入口尽量保持稳定。配置能不能长期维护，关键不在于你会不会写 Lua，而在于你有没有给未来的自己留结构。

## 录屏顺序

1. 先打开 `lua/config/lazy.lua`，说明插件入口就是 `import = "plugins"`。
2. 打开 `lua/plugins/haskell.lua`，讲语言扩展最小单元。
3. 打开 `lua/plugins/markdown.lua`，讲文档类能力怎么加。
4. 打开 `lua/plugins/web.lua`，讲前端栈能力怎么按主题补齐。
5. 打开 `lua/config/platform.lua` 和 `lua/plugins/platform.lua`，讲平台兼容为什么也值得单独一层。
6. 打开 `lua/plugins/formatting.lua`，讲格式化怎么做局部覆盖。
7. 打开 `lua/plugins/dap.lua` 和 `lua/plugins/dap-lang.lua`，讲通用调试层和语言层协作。
8. 最后回到 `lua/plugins` 目录，强调“按主题拆文件”的方法论。

## 这一集要打开的文件

- `lua/config/lazy.lua`
- `lua/config/platform.lua`
- `lua/plugins/haskell.lua`
- `lua/plugins/markdown.lua`
- `lua/plugins/platform.lua`
- `lua/plugins/web.lua`
- `lua/plugins/formatting.lua`
- `lua/plugins/dap.lua`
- `lua/plugins/dap-lang.lua`

## 可直接念的总结

> 扩展 Neovim 配置，最怕的不是加不进去，而是加进去之后结构开始崩。我的做法是把每次扩展都当成一个独立主题：语言支持一个文件，平台兼容一层，格式化一个文件，调试一层总入口。这样你以后改起来才不会痛苦。

## 注意事项

- 这一集要少演示，多讲组织方式。
- 最好把观众的预期拉到“方法论”，而不是“抄这一门语言的配置”。
- 如果你想加一段现场演示，可以临时新建一个 `lua/plugins/demo.lua` 思路讲解，但不一定真的要保存。
