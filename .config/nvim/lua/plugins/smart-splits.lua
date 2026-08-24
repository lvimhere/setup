-- Seamless <C-hjkl> between Neovim splits and Kitty / tmux panes.
-- Do not lazy-load: Kitty integration sets the IS_NVIM user var on startup.
-- Resize stays on Kitty Ctrl+Shift+Alt+hjkl (not Alt-j/k; those move lines).
return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    build = "./kitty/install-kittens.bash",
    opts = {
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "prompt",
        "snacks_picker_input",
      },
      default_amount = 3,
      -- wrap is not supported when talking to Kitty
      at_edge = "stop",
    },
  },
}
