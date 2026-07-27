vim.g.mapleader = " "
-- maplocalleader defaults to "\" (grug-far and other buffer-local maps use <localleader>)

require("config")

if vim.g.vscode then
  require("plugins.vscode")
else
  require("plugins")
end
