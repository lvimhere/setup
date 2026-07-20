require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    barbar = true,
  },
})

vim.cmd.colorscheme("catppuccin")
