-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 彻底禁止换行自动延续注释
local function disable_comment_continuation()
  if vim.bo.modifiable and vim.bo.buftype ~= "terminal" then
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  pattern = "*",
  callback = disable_comment_continuation,
})

disable_comment_continuation()

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*lazygit*",
  callback = function()
    require("neo-tree.sources.manager").refresh("filesystem")
  end,
})
