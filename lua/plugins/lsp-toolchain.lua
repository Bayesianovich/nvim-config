-- Prefer the existing system/Cargo/Node toolchain for these servers.
-- Mason remains responsible for servers that are not already available.
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      for _, server in ipairs({ "clangd", "pyright", "ruff" }) do
        opts.servers[server] = opts.servers[server] or {}
        opts.servers[server].mason = false
      end
    end,
  },
}
