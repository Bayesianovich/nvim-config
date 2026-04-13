return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "css", "scss" },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "html-lsp",
        "css-lsp",
        "emmet-language-server",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          init_options = {
            provideFormatter = false,
            embeddedLanguages = { css = true, javascript = true },
            configurationSection = { "html", "css", "javascript" },
          },
        },
        cssls = {
          init_options = { provideFormatter = false },
        },
        emmet_language_server = {},
      },
    },
  },
}
