-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local terminal_context_group = vim.api.nvim_create_augroup("user_terminal_context", { clear = true })
local last_non_terminal_buf = nil

vim.api.nvim_create_autocmd("BufEnter", {
  group = terminal_context_group,
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "terminal" then
      last_non_terminal_buf = event.buf
    end
  end,
})

local function terminal_context_buf()
  local current = vim.api.nvim_get_current_buf()
  if vim.bo[current].buftype ~= "terminal" then
    return current
  end

  if last_non_terminal_buf and vim.api.nvim_buf_is_valid(last_non_terminal_buf) then
    return last_non_terminal_buf
  end

  local alternate = vim.fn.bufnr("#")
  if alternate > 0 and vim.api.nvim_buf_is_valid(alternate) and vim.bo[alternate].buftype ~= "terminal" then
    return alternate
  end

  return current
end

local function terminal_root()
  return LazyVim.root({ buf = terminal_context_buf() })
end

local function toggle_floating_terminal()
  Snacks.terminal.toggle(nil, {
    cwd = terminal_root(),
    count = 2,
    win = {
      position = "float",
      border = "rounded",
      width = 0.8,
      height = 0.8,
    },
  })
end

local function toggle_right_terminal()
  Snacks.terminal.toggle(nil, {
    cwd = terminal_root(),
    count = 3,
    win = {
      position = "right",
      width = 0.42,
    },
  })
end

local function resize_terminal_window(cmd)
  return function()
    vim.cmd("stopinsert")
    vim.cmd(cmd)
    vim.cmd("startinsert")
  end
end

vim.keymap.set({ "n", "t" }, "<leader>2", toggle_floating_terminal, { desc = "Floating Terminal (Center)" })
vim.keymap.set({ "n", "t" }, "<leader>3", toggle_right_terminal, { desc = "Terminal (Right Split)" })
vim.keymap.set("t", "<C-Up>", resize_terminal_window("resize +2"), { desc = "Increase Window Height" })
vim.keymap.set("t", "<C-Down>", resize_terminal_window("resize -2"), { desc = "Decrease Window Height" })
vim.keymap.set("t", "<C-Left>", resize_terminal_window("vertical resize -2"), { desc = "Decrease Window Width" })
vim.keymap.set("t", "<C-Right>", resize_terminal_window("vertical resize +2"), { desc = "Increase Window Width" })

vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit.open()
end, { desc = "Lazygit" })
