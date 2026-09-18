local function prefer_cargo_over_mason()
  local sep = package.config:sub(1, 1) == "\\" and ";" or ":"
  local cargo_bin = vim.fn.expand("~/.cargo/bin")
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  local path = vim.env.PATH or ""
  local parts = vim.split(path, sep, { plain = true, trimempty = true })
  local filtered = {}
  local seen = {}

  local function normalize(part)
    return vim.fs.normalize(part)
  end

  local cargo_norm = normalize(cargo_bin)
  local mason_norm = normalize(mason_bin)

  for _, part in ipairs(parts) do
    local norm = normalize(part)
    if norm ~= cargo_norm and norm ~= mason_norm and not seen[norm] then
      table.insert(filtered, part)
      seen[norm] = true
    end
  end

  if vim.uv.fs_stat(cargo_bin) then
    table.insert(filtered, 1, cargo_bin)
  end
  if vim.uv.fs_stat(mason_bin) then
    table.insert(filtered, mason_bin)
  end

  vim.env.PATH = table.concat(filtered, sep)
end

prefer_cargo_over_mason()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
