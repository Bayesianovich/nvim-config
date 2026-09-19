-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require("config.platform").setup_clipboard()

vim.opt.timeoutlen = 500

local function set_custom_highlights()
  local cursor_bg = "#00ffff"
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local cursor_fg = normal.bg and string.format("#%06x", normal.bg) or "#222436"

  vim.api.nvim_set_hl(0, "Cursor", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "lCursor", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "CursorIM", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "TermCursor", { fg = cursor_fg, bg = cursor_bg })
  vim.api.nvim_set_hl(0, "TermCursorNC", { fg = cursor_fg, bg = cursor_bg })

  -- 行号高亮：普通行号（含相对行号）设为清晰柔和的冷绿/浅绿，当前行设为醒目冷翠绿
  local linenr_fg = "#7aa89f" -- 柔和浅冷绿，清晰不刺眼
  local cursor_linenr_fg = "#73daca" -- 亮冷绿/薄荷绿，醒目突出

  vim.api.nvim_set_hl(0, "LineNr", { fg = linenr_fg })
  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = linenr_fg })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = linenr_fg })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = cursor_linenr_fg, bold = true })
end

vim.opt.guicursor =
  "n-v-c-sm:block-Cursor,i-ci-ve:ver25-lCursor,r-cr-o:hor20-Cursor,t:block-blinkon500-blinkoff500-TermCursor"

local custom_hl_augroup = vim.api.nvim_create_augroup("user_custom_highlights", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = custom_hl_augroup,
  callback = set_custom_highlights,
})

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter" }, {
  group = custom_hl_augroup,
  callback = set_custom_highlights,
})

set_custom_highlights()
vim.schedule(set_custom_highlights)

