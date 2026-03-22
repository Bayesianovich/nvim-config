local function peek_fold_or_hover()
  local ok, ufo = pcall(require, "ufo")
  if ok then
    local winid = ufo.peekFoldedLinesUnderCursor()
    if winid then
      return
    end
  end

  vim.lsp.buf.hover()
end

return {
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    init = function()
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "lsp", "indent" }
      end,
    },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open All Folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close All Folds",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.folds = opts.folds or {}
      opts.folds.enabled = false

      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}
      opts.servers["*"].capabilities = vim.tbl_deep_extend("force", opts.servers["*"].capabilities or {}, {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      })

      local keys = opts.servers["*"].keys or {}
      local replaced = false

      for _, key in ipairs(keys) do
        if key[1] == "K" then
          key[2] = peek_fold_or_hover
          key.desc = "Peek Fold or Hover"
          replaced = true
          break
        end
      end

      if not replaced then
        table.insert(keys, { "K", peek_fold_or_hover, desc = "Peek Fold or Hover" })
      end

      opts.servers["*"].keys = keys
    end,
  },
}
