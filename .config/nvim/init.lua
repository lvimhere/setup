vim.g.mapleader = " "
-- Plugins such as grug-far use <localleader> for buffer-local maps.
vim.g.maplocalleader = ","

require("config")

if vim.g.vscode then
  require("plugins.vscode")
else
  require("plugins")
end
