return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = function(_, opts)
      opts.flavour = "mocha"
      opts.transparent_background = true
      opts.float = vim.tbl_deep_extend("force", opts.float or {}, {
        transparent = true,
      })
      opts.auto_integrations = true
      opts.styles = vim.tbl_deep_extend("force", opts.styles or {}, {
        functions = { "bold" },
      })
      local prev_custom = opts.custom_highlights
      opts.custom_highlights = function(colors)
        local highlights = {}
        if type(prev_custom) == "function" then
          highlights = prev_custom(colors) or {}
        elseif type(prev_custom) == "table" then
          highlights = vim.deepcopy(prev_custom)
        end
        return vim.tbl_deep_extend("force", highlights, {
          ["@function.method"] = { style = { "bold" } },
          ["@function.method.call"] = { style = { "bold" } },
          ["@lsp.type.method"] = { style = { "bold" } },
        })
      end
      opts.lsp_styles = vim.tbl_deep_extend("force", opts.lsp_styles or {}, {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      })
      return opts
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
