require("nvim-highlight-colors").setup({
  render = "background",
  enable_hex = true,
  enable_short_hex = true,
  enable_rgb = true,
  enable_hsl = true,
  enable_hsl_without_function = true,
  enable_var_usage = true,
  enable_named_colors = true,
  enable_tailwind = true,
  exclude_filetypes = {
    "help",
    "lazy",
    "mason",
  },
})
