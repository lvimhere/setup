require("grug-far").setup({
  headerMaxWidth = 80,
  engines = {
    ripgrep = {
      extraArgs = "--hidden --glob !.git/",
    },
  },
})

vim.keymap.set("n", "<leader>sR", function()
  require("grug-far").open()
end, { desc = "[S]earch [R]eplace (project)" })

vim.keymap.set("x", "<leader>sR", function()
  require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
end, { desc = "[S]earch [R]eplace in selection" })

vim.keymap.set("n", "<leader>sW", function()
  require("grug-far").open({
    prefills = { search = vim.fn.expand("<cword>") },
  })
end, { desc = "[S]earch replace current [W]ord" })
