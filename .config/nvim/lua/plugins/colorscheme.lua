return {
  {
    "folke/tokyonight.nvim",
    opts = {
      styles = {
        functions = { bold = true },
      },
      on_highlights = function(hl, c)
        -- Methods: Function blue + bold.
        hl["@function.method"] = { fg = c.blue, bold = true }
        hl["@function.method.call"] = { fg = c.blue, bold = true }
        hl["@lsp.type.method"] = { fg = c.blue, bold = true }
      end,
    },
  },
}
