vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config")

if vim.g.vscode then
  require("plugins.vscode")
else
  require("plugins")
end
