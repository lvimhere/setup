-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move lines on Alt-Shift-j/k so Alt-j/k stay free for Zellij pane focus (Locked).
for _, lhs in ipairs({ "<A-j>", "<A-k>" }) do
  for _, mode in ipairs({ "n", "i", "v" }) do
    pcall(vim.keymap.del, mode, lhs)
  end
end

vim.keymap.set("n", "<A-J>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-K>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-J>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-K>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-J>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-K>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

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
