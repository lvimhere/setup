return {
  {
    "nvim-mini/mini.splitjoin",
    event = "VeryLazy",
    opts = {
      mappings = {
        toggle = "gS",
        split = "gss",
        join = "gsj",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "gs", group = "split/join", mode = { "n", "x" } },
      },
    },
  },
}
