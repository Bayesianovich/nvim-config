local M = {}

local uname = vim.uv.os_uname()

M.is_wsl = vim.fn.has("wsl") == 1
M.is_mac = uname.sysname == "Darwin"
M.is_linux = uname.sysname == "Linux" and not M.is_wsl

function M.has(bin)
  return vim.fn.executable(bin) == 1
end

local function has_url_scheme(target)
  return target:match("^[%w.+-]+://") ~= nil
end

local function expand_target(target)
  if target:sub(1, 1) == "~" then
    return vim.fn.expand(target)
  end

  if target:match("^%.") or target:match("^/") then
    return vim.fn.fnamemodify(target, ":p")
  end

  return target
end

function M.clipboard_provider()
  if vim.env.SSH_CONNECTION then
    return nil
  end

  if M.has("win32yank.exe") then
    return {
      name = "win32yank",
      copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
      },
      paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
      },
      cache_enabled = 0,
    }
  end

  if M.is_wsl and M.has("clip.exe") and M.has("powershell.exe") then
    local paste = [[powershell.exe -NoLogo -NoProfile -Command [Console]::Out.Write((Get-Clipboard -Raw).ToString().Replace("`r",""))]]
    return {
      name = "wsl-clipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = paste,
        ["*"] = paste,
      },
      cache_enabled = 0,
    }
  end

  if M.has("pbcopy") and M.has("pbpaste") then
    return {
      name = "pbcopy",
      copy = {
        ["+"] = "pbcopy",
        ["*"] = "pbcopy",
      },
      paste = {
        ["+"] = "pbpaste",
        ["*"] = "pbpaste",
      },
      cache_enabled = 0,
    }
  end

  if M.has("wl-copy") and M.has("wl-paste") then
    return {
      name = "wl-clipboard",
      copy = {
        ["+"] = "wl-copy --foreground --type text/plain",
        ["*"] = "wl-copy --primary --foreground --type text/plain",
      },
      paste = {
        ["+"] = "wl-paste --no-newline",
        ["*"] = "wl-paste --primary --no-newline",
      },
      cache_enabled = 0,
    }
  end

  if M.has("xclip") then
    return {
      name = "xclip",
      copy = {
        ["+"] = "xclip -quiet -i -selection clipboard",
        ["*"] = "xclip -quiet -i -selection primary",
      },
      paste = {
        ["+"] = "xclip -o -selection clipboard",
        ["*"] = "xclip -o -selection primary",
      },
      cache_enabled = 0,
    }
  end

  if M.has("xsel") then
    return {
      name = "xsel",
      copy = {
        ["+"] = "xsel --clipboard --input",
        ["*"] = "xsel --primary --input",
      },
      paste = {
        ["+"] = "xsel --clipboard --output",
        ["*"] = "xsel --primary --output",
      },
      cache_enabled = 0,
    }
  end

  return nil
end

function M.setup_clipboard()
  local provider = M.clipboard_provider()
  if not provider then
    return
  end

  vim.g.clipboard = provider

  local clipboard = vim.opt.clipboard:get()
  if not vim.tbl_contains(clipboard, "unnamedplus") then
    vim.opt.clipboard:append("unnamedplus")
  end
end

function M.open(target)
  local value = target or vim.fn.expand("<cfile>")
  if not value or value == "" then
    vim.notify("No filepath or URI under cursor", vim.log.levels.WARN)
    return false
  end

  local open_target = expand_target(value)
  local cmd

  if M.is_wsl and M.has("explorer.exe") then
    if not has_url_scheme(open_target) and M.has("wslpath") then
      local result = vim.fn.systemlist({ "wslpath", "-w", open_target })
      if vim.v.shell_error == 0 and result[1] and result[1] ~= "" then
        open_target = result[1]
      end
    end
    cmd = { "explorer.exe", open_target }
  elseif M.is_mac and M.has("open") then
    cmd = { "open", open_target }
  elseif M.has("xdg-open") then
    cmd = { "xdg-open", open_target }
  else
    vim.notify("No system opener found for this platform", vim.log.levels.ERROR)
    return false
  end

  vim.system(cmd, { detach = true }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify(("Failed to open: %s"):format(open_target), vim.log.levels.ERROR)
      end)
    end
  end)

  return true
end

return M
