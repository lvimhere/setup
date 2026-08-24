-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Move line: keep LazyVim defaults Alt-j / Alt-k (n/i/v).

-- Override LazyVim <C-w>hjkl so we can leave Neovim into a Kitty / tmux pane.
local smart_splits = require("smart-splits")
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Go to Right Window" })

-- Drop builtin gs (:sleep) so it can be a prefix group (see mini.splitjoin).
vim.keymap.set({ "n", "x" }, "gs", "<Nop>", { desc = "+split/join" })

-- Disable macros; reuse q for the common "close window" remap.
vim.keymap.set("n", "@", "<Nop>", { desc = "Disable macro play" })
vim.keymap.set("n", "Q", "<Nop>", { desc = "Disable macro replay" })
vim.keymap.set("n", "q", function()
  local ok, err = pcall(vim.cmd.close)
  if not ok then
    local msg = tostring(err or ""):gsub("^Vim%(close%):", ""):gsub("^Vim:", "")
    if msg:find("E444") then
      vim.notify("Last window — not closed", vim.log.levels.INFO)
    else
      vim.notify("Close failed: " .. msg, vim.log.levels.WARN)
    end
  end
end, { desc = "Close window" })
