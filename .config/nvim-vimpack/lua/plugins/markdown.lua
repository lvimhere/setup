require("render-markdown").setup({
  file_types = { "markdown" },
  render_modes = { "n", "c", "t" },
  completions = {
    lsp = {
      enabled = true,
    },
  },
})

vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown buf_toggle<CR>", { desc = "[M]arkdown [T]oggle" })
vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown preview<CR>", { desc = "[M]arkdown [P]review" })
