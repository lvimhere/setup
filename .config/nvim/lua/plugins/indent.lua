-- Match nvim-vimpack listchars space marker (·) instead of LazyVim default │.
return {
  "folke/snacks.nvim",
  opts = {
    indent = {
      indent = { char = "·" },
      scope = { char = "·" },
    },
  },
}
