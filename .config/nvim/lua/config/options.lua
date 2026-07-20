vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
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
