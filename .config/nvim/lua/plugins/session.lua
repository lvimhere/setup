require("auto-session").setup({
  auto_restore = true,
  auto_save = true,
  auto_create = true,
  legacy_cmds = false,
  suppressed_dirs = {
    vim.loop.os_homedir(),
    "/",
  },
  close_filetypes_on_save = {
    "checkhealth",
    "neo-tree",
    "neo-tree-popup",
    "oil",
    "undotree",
  },
  session_lens = {
    picker = "select",
  },
})

vim.keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "[W]orkspace [S]ave session" })
vim.keymap.set("n", "<leader>wl", "<cmd>AutoSession search<CR>", { desc = "[W]orkspace [L]ist sessions" })
vim.keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "[W]orkspace [R]estore session" })
vim.keymap.set("n", "<leader>wd", "<cmd>AutoSession delete<CR>", { desc = "[W]orkspace [D]elete session" })
