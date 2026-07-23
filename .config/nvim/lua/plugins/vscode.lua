local pack_opts = { confirm = false, load = true }

vim.pack.add({
  "https://github.com/numToStr/Comment.nvim",
  { src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("4") },
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/folke/flash.nvim",
}, pack_opts)

require("Comment").setup()
require("nvim-surround").setup({})
require("mini.ai").setup({
  n_lines = 500,
})
require("plugins.flash")
