-- Open Kitty scrollback in Neovim (Ctrl+Shift+H). Loaded only when Kitty launches it.
return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    version = "*",
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
}
