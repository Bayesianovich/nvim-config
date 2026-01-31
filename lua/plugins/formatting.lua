-- 配置 clang-format 用于 C/C++ 文件格式化
-- clang-format 会自动使用项目根目录下的 .clang-format 文件

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["cpp"] = { "clang-format" },
        ["c"] = { "clang-format" },
      },
    },
  },
}
