-- leap.nvim
-- https://codeberg.org/andyg/leap.nvim

return {
  "https://codeberg.org/andyg/leap.nvim.git",
  event = "VeryLazy",
  config = function()
    local function map_if_free(modes, lhs, rhs, desc)
      for _, mode in ipairs(modes) do
        if vim.fn.mapcheck(lhs, mode) == "" and vim.fn.hasmapto(rhs, mode) == 0 then
          vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
        end
      end
    end

    map_if_free({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", "Leap forward")
    map_if_free({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", "Leap backward")
    map_if_free({ "x", "o" }, "x", "<Plug>(leap-forward-till)", "Leap forward till")
    map_if_free({ "x", "o" }, "X", "<Plug>(leap-backward-till)", "Leap backward till")
    map_if_free({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", "Leap from window")
  end,
}
