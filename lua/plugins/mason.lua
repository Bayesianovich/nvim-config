return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Prefer binaries from the system/cargo path over Mason's prebuilt tools.
      -- This avoids glibc mismatches for tools like tree-sitter on older distros.
      opts.PATH = "append"
    end,
  },
}
