require("barbar").setup({
  animation = true,
  auto_hide = 1,
  clickable = true,
  focus_on_close = "left",
  highlight_visible = true,
  hide = { extensions = true },
  insert_at_end = true,
  icons = {
    buffer_index = true,
    buffer_number = false,
    button = "",
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "󰅙" },
      [vim.diagnostic.severity.WARN] = { enabled = true, icon = "󰀪" },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = false },
    },
    gitsigns = {
      added = { enabled = true, icon = "󰐕" },
      changed = { enabled = true, icon = "󰏫" },
      deleted = { enabled = true, icon = "󰍴" },
    },
    filetype = {
      custom_colors = false,
      enabled = true,
    },
    separator = { left = "▎", right = "" },
    separator_at_end = true,
    modified = { button = "●" },
    pinned = { button = "󰐃", filename = true },
    preset = "default",
    inactive = { button = "×" },
  },
  maximum_length = 24,
  semantic_letters = true,
  exclude_ft = {
    "neo-tree",
    "neo-tree-popup",
    "minifiles",
    "Trouble",
    "qf",
    "checkhealth",
    "aerial",
    "aerial-nav",
  },
  sort = {
    ignore_case = true,
  },
})

vim.keymap.set("n", "<S-h>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })

for i = 1, 9 do
  vim.keymap.set("n", "<M-" .. i .. ">", "<Cmd>BufferGoto " .. i .. "<CR>", {
    desc = "Go to buffer " .. i,
  })
end
vim.keymap.set("n", "<M-0>", "<Cmd>BufferLast<CR>", { desc = "Go to last buffer" })

vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPick<CR>", { desc = "Pick buffer (10+)" })
vim.keymap.set("n", "<leader>bd", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", "<Cmd>BufferCloseAllButCurrent<CR>", { desc = "Close other buffers" })
vim.keymap.set("n", "<leader>bP", "<Cmd>BufferPin<CR>", { desc = "Pin buffer" })
vim.keymap.set("n", "<leader>bx", "<Cmd>BufferPickDelete<CR>", { desc = "Pick buffer to close" })
