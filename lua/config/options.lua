-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.formatoptions = "jqlnt" -- 移除 c, r, o 等自动注释选项

local function set_cyan_cursor()
  local cursor_bg = "#00ffff"
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local cursor_fg = normal.bg and string.format("#%06x", normal.bg) or "#222436"

  vim.api.nvim_set_hl(0, "Cursor", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "lCursor", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "CursorIM", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "TermCursor", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "TermCursorNC", { fg = cursor_fg, bg = cursor_bg })
end

vim.opt.guicursor =
  "n-v-c-sm:block-Cursor,i-ci-ve:ver25-lCursor,r-cr-o:hor20-Cursor,t:block-blinkon500-blinkoff500-TermCursor"

local cursor_augroup = vim.api.nvim_create_augroup("user_cyan_cursor", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = cursor_augroup,
  callback = set_cyan_cursor,
})

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter" }, {
  group = cursor_augroup,
  callback = set_cyan_cursor,
})

set_cyan_cursor()
vim.schedule(set_cyan_cursor)
