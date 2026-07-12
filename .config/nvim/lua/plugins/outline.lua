require("aerial").setup({
  backends = { "treesitter", "lsp", "markdown" },
  layout = {
    default_direction = "prefer_right",
    placement = "window",
    min_width = 20,
    max_width = { 36, 0.25 },
    resize_to_content = true,
  },
  attach_mode = "window",
  show_guides = true,
  filter_kind = false,
})

vim.keymap.set("n", "<leader>aa", "<cmd>AerialToggle! right<CR>", { desc = "[A]erial toggle" })
vim.keymap.set("n", "<leader>af", "<cmd>AerialToggle! float<CR>", { desc = "[A]erial [F]loat" })
vim.keymap.set("n", "<leader>an", "<cmd>AerialNavToggle<CR>", { desc = "[A]erial [N]av" })
