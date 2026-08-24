-- Minimal -u for kitty-scrollback.nvim (not LazyVim).
-- Avoids this repo's `q` = close-window remap and a full plugin boot.
local data = vim.fn.stdpath("data")
vim.opt.runtimepath:append(data .. "/lazy/kitty-scrollback.nvim")
vim.opt.runtimepath:append(data .. "/lazy/tokyonight.nvim")
pcall(vim.cmd.colorscheme, "tokyonight-night")
require("kitty-scrollback").setup()
