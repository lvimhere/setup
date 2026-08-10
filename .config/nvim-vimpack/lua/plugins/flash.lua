require("flash").setup({
  modes = {
    search = {
      -- Labels on `/` and `?` matches by default; toggle with <C-s> in cmdline.
      enabled = true,
    },
    char = {
      -- Enhanced f / t / F / T with labels when useful.
      enabled = true,
      jump_labels = true,
    },
  },
})

-- Prefer lua function rhs so flash jumps remain dot-repeatable.
vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash jump" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })

vim.keymap.set({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

vim.keymap.set("c", "<C-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
