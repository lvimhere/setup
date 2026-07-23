vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true

-- System clipboard: Neovim may auto-pick wl-copy when WAYLAND_DISPLAY is set,
-- even if the Wayland socket is missing (common in WSL / broken sessions).
-- That makes `yy` error and leaves registers empty (E353), including Flash `yr`.
local function wayland_socket_ready()
  local display = vim.env.WAYLAND_DISPLAY
  if not display or display == "" then
    return false
  end
  local socket = display
  if not display:match("^/") then
    local runtime = vim.env.XDG_RUNTIME_DIR
    if not runtime or runtime == "" then
      runtime = "/run/user/" .. vim.uv.os_getuid()
    end
    socket = runtime .. "/" .. display
  end
  return vim.uv.fs_stat(socket) ~= nil
end

--- Resolve win32yank even when it only exists under "Program Files" (spaces in
--- PATH break vim.fn.executable for that entry on WSL).
local function resolve_win32yank()
  local candidates = {
    vim.fn.exepath("win32yank.exe"),
    vim.fn.expand("~/.local/bin/win32yank.exe"),
    "/mnt/c/Program Files/Neovim/bin/win32yank.exe",
  }
  for _, path in ipairs(candidates) do
    if path ~= "" and vim.uv.fs_stat(path) then
      return path
    end
  end
  return nil
end

local function setup_clipboard()
  local win32yank = resolve_win32yank()
  if win32yank then
    -- List-form commands keep spaces in the path safe (no shell splitting).
    vim.g.clipboard = {
      name = "win32yank",
      copy = {
        ["+"] = { win32yank, "-i", "--crlf" },
        ["*"] = { win32yank, "-i", "--crlf" },
      },
      paste = {
        ["+"] = { win32yank, "-o", "--lf" },
        ["*"] = { win32yank, "-o", "--lf" },
      },
      cache_enabled = 0,
    }
  elseif vim.fn.has("wsl") == 1 and vim.fn.executable("clip.exe") == 1 then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = 'powershell.exe -NoProfile -Command Get-Clipboard',
        ["*"] = 'powershell.exe -NoProfile -Command Get-Clipboard',
      },
      cache_enabled = 0,
    }
  elseif wayland_socket_ready() and vim.fn.executable("wl-copy") == 1 then
    -- Let Neovim use its default wl-copy / wl-paste provider.
  elseif vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
      name = "xclip",
      copy = {
        ["+"] = "xclip -selection clipboard",
        ["*"] = "xclip -selection primary",
      },
      paste = {
        ["+"] = "xclip -selection clipboard -o",
        ["*"] = "xclip -selection primary -o",
      },
      cache_enabled = 0,
    }
  elseif vim.fn.executable("xsel") == 1 then
    vim.g.clipboard = {
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
  else
    -- No working provider: keep yanks in Neovim registers only (no wl-copy errors).
    vim.opt.clipboard = ""
    return
  end

  vim.opt.clipboard = "unnamedplus"
end

setup_clipboard()
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", space = "·", trail = "·", nbsp = "␣", eol = "↴" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 0
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.confirm = true
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.winborder = "none"

vim.opt.title = true

local function update_title()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then
    vim.opt.titlestring = vim.fn.fnamemodify(file, ":~:.")
  else
    vim.opt.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  callback = update_title,
})
