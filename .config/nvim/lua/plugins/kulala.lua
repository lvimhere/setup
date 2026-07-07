if not vim.o.sessionoptions:match("globals") then
  vim.opt.sessionoptions = vim.o.sessionoptions .. ",globals"
end

vim.filetype.add({
  extension = {
    http = "http",
    rest = "rest",
  },
})

local tree_sitter_cli = vim.fn.exepath("tree-sitter")
if tree_sitter_cli == "" then
  tree_sitter_cli = "tree-sitter"
end

require("kulala").setup({
  treesitter = {
    enable = true,
    cli_path = tree_sitter_cli,
  },
  ui = {
    display_mode = "split",
    split_direction = "right",
    win_opts = {
      wo = { winborder = "none" },
    },
  },
  session = {
    restore = true,
  },
  lsp = {
    enable = true,
  },
  global_keymaps = true,
  global_keymaps_prefix = "<leader>R",
  kulala_keymaps = true,
  kulala_keymaps_prefix = "",
})
