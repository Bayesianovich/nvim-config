return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.terminal = opts.terminal or {}
      opts.terminal.win = opts.terminal.win or {}
      opts.terminal.win.keys = opts.terminal.win.keys or {}
      opts.terminal.win.keys.term_normal = {
        "<esc>",
        function(self)
          self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
          if self.esc_timer:is_active() then
            self.esc_timer:stop()
            self:hide()
            return ""
          end
          self.esc_timer:start(300, 0, function() end)
          return "<esc>"
        end,
        mode = "t",
        expr = true,
        desc = "Double escape to hide terminal",
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local ok, actions = pcall(require, "snacks.picker.actions")
          if not ok or actions._bayes_safe_jump_patch then
            return
          end

          local picker_util = require("snacks.picker.util")
          local fallback_cmd = {
            split = "split",
            vsplit = "vsplit",
            tab = "tabedit",
            drop = "drop",
            tabdrop = "tab drop",
          }

          local function focus_picker_target(picker)
            if picker.opts.jump.close then
              picker:close()
            else
              vim.api.nvim_set_current_win(picker.main)
            end
          end

          -- Feed an Ex command as user input so Neovim can show the built-in
          -- swap-file prompt instead of raising E325 back into Lua.
          local function open_from_cmdline(cmd, path)
            local keys = vim.api.nvim_replace_termcodes(
              ":" .. cmd .. " " .. vim.fn.fnameescape(path) .. "<CR>",
              true,
              false,
              true
            )
            vim.schedule(function()
              vim.cmd.redraw()
              vim.api.nvim_input(keys)
            end)
          end

          local original_jump = actions.jump
          actions.jump = function(picker, item, action)
            local ok_jump, err = pcall(original_jump, picker, item, action)
            if ok_jump then
              return
            end

            local msg = tostring(err)
            local stale_buffer = msg:find("Vim%(buffer%):E86", 1, false)
              or msg:find("Vim%(buffer%):E939", 1, false)
            local swap_attention = msg:find("E325:", 1, false)
            if not stale_buffer and not swap_attention then
              error(err)
            end

            local items = picker:selected({ fallback = true })
            local target = items[1]
            local path = target and picker_util.path(target)
            if not path then
              Snacks.notify.error("Selected item could not be opened")
              return
            end

            focus_picker_target(picker)

            local fallback = fallback_cmd[action and action.cmd or ""] or "edit"

            if swap_attention then
              open_from_cmdline(fallback, path)
              return
            end

            local ok_open = pcall(vim.cmd, ("%s %s"):format(fallback, vim.fn.fnameescape(path)))
            if not ok_open then
              Snacks.notify.error("Selected item could not be opened")
            end
          end

          actions._bayes_safe_jump_patch = true
        end,
      })
    end,
  },
}
