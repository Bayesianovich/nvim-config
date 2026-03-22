-- 配置 clang-format 用于 C/C++ 文件格式化
-- clang-format 会自动使用项目根目录下的 .clang-format 文件

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.c = { "clang-format" }
      opts.formatters_by_ft.cpp = { "clang-format" }

      opts.formatters = opts.formatters or {}
      opts.formatters["clang-format"] = {
        prepend_args = {
          "--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}",
        },
      }
    end,
  },
}
