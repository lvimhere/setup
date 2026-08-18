-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Align invisible chars with nvim-vimpack
vim.opt.list = true
vim.opt.listchars = { tab = "» ", space = "·", trail = "·", nbsp = "␣", eol = "↴" }

-- WSL TUI nvim is rendered by Windows Terminal (Hack Nerd Font Mono + Maple CJK).
-- Let LazyVim / mini.icons / lualine use Nerd glyphs instead of ASCII fallbacks.
vim.g.have_nerd_font = true

-- GUI / WSLg only. TUI ignores guifont and follows the terminal font.
if vim.fn.has("gui_running") == 1 then
  vim.opt.guifont = "Hack Nerd Font Mono:h14"
end
