return {
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
      show_stop_reason = true,
      commented = true,
      only_first_definition = true,
      clear_on_continue = true,
      virt_text_pos = "inline",
    },
  },
}
