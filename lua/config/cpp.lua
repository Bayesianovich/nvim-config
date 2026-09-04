local M = {}

-- Single-file C++ build, matching the Emacs run/debug flags.
function M.build_command(source)
  local compiler = vim.fn.exepath("g++")
  if compiler == "" then
    compiler = vim.fn.exepath("clang++")
  end
  assert(compiler ~= "", "No C++ compiler found")
  local output = vim.fn.fnamemodify(source, ":r") .. ".out"
  local args = { compiler, "-std=c++17", "-g", "-O0", "-Wall", "-Wextra", source, "-o", output }
  return table.concat(vim.tbl_map(vim.fn.shellescape, args), " ") .. " && " .. vim.fn.shellescape(output)
end

function M.run()
  local source = vim.api.nvim_buf_get_name(0)
  local extension = vim.fn.fnamemodify(source, ":e"):lower()
  if vim.bo.filetype ~= "cpp" or not vim.tbl_contains({ "cpp", "cc", "cxx", "c++", "c" }, extension) then
    vim.notify("Open a C++ source file first", vim.log.levels.WARN)
    return
  end
  if source:match("^%a[%w+.-]*://") then
    vim.notify("This command supports local C++ files", vim.log.levels.WARN)
    return
  end
  -- Await Conform formatting before saving so the compiler sees the final text.
  local ok, conform = pcall(require, "conform")
  if ok and vim.g.autoformat ~= false and vim.b.autoformat ~= false then
    conform.format({ async = false, timeout_ms = 3000 })
  end
  vim.cmd("update")
  Snacks.terminal(M.build_command(source), {
    cwd = vim.fn.fnamemodify(source, ":h"),
    interactive = false,
    auto_close = false,
    win = { position = "bottom", height = 0.3 },
  })
end

return M
