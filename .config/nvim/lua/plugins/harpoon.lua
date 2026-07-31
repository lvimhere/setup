local harpoon = require("harpoon")

-- REQUIRED: sets up autocmds used by Harpoon
harpoon:setup()

vim.keymap.set("n", "<leader>pa", function()
  harpoon:list():add()
end, { desc = "Harpoon add file" })

vim.keymap.set("n", "<leader>pe", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

vim.keymap.set("n", "<leader>p1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon file 1" })

vim.keymap.set("n", "<leader>p2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon file 2" })

vim.keymap.set("n", "<leader>p3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon file 3" })

vim.keymap.set("n", "<leader>p4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon file 4" })

vim.keymap.set("n", "<leader>pp", function()
  harpoon:list():prev()
end, { desc = "Harpoon prev" })

vim.keymap.set("n", "<leader>pn", function()
  harpoon:list():next()
end, { desc = "Harpoon next" })
