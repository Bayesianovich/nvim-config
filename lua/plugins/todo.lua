-- todo-comments.nvim
-- https://github.com/folke/todo-comments.nvim

return {
  "folke/todo-comments.nvim",
  keys = {
    { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
  },
}
