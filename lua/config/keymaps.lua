-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>2", function()
  Snacks.terminal.toggle(nil, {
    win = {
      position = "float",
      border = "rounded",
      width = 0.8,
      height = 0.8,
    },
  })
end, { desc = "Floating Terminal (Center)" })

-- 同时也支持在终端模式下用同样的快捷键关闭
vim.keymap.set("t", "<leader>2", function()
  Snacks.terminal.toggle()
end, { desc = "Hide Terminal" })

vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit.open()
end, { desc = "Lazygit" })
