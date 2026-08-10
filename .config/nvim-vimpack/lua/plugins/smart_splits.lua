local smart_splits = require("smart-splits")

-- Prefer tmux when available (WSL: host terminal → WSL → tmux → nvim).
-- Avoid noisy init warnings when tmux is not installed / not in a session.
local mux = false
if vim.fn.executable("tmux") == 1 and vim.env.TMUX and vim.env.TMUX ~= "" then
  mux = "tmux"
end

smart_splits.setup({
  ignored_filetypes = {
    "nofile",
    "quickfix",
    "prompt",
    "neo-tree",
    "neo-tree-popup",
    "aerial",
    "undotree",
  },
  default_amount = 2,
  at_edge = "wrap",
  -- ToggleTerm owns <C-\>; do not steal it for "previous pane".
  multiplexer_integration = mux,
})

-- Move between Neovim splits and tmux panes.
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Move to left split/pane" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Move to below split/pane" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Move to above split/pane" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Move to right split/pane" })

-- Resize: Alt+hjkl (also forwarded from tmux when configured).
vim.keymap.set("n", "<A-h>", smart_splits.resize_left, { desc = "Resize split left" })
vim.keymap.set("n", "<A-j>", smart_splits.resize_down, { desc = "Resize split down" })
vim.keymap.set("n", "<A-k>", smart_splits.resize_up, { desc = "Resize split up" })
vim.keymap.set("n", "<A-l>", smart_splits.resize_right, { desc = "Resize split right" })
