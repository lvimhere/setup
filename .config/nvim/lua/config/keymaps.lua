vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Show keybindings" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "]b", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>buffer #<CR>", { desc = "Switch to alternate buffer" })
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tabpage" })
vim.keymap.set("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tabpage" })

local function cd_to_current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.fnamemodify(file, ":p:h")
  if vim.fn.isdirectory(dir) ~= 1 then
    vim.notify("Directory does not exist: " .. dir, vim.log.levels.ERROR)
    return
  end
  vim.cmd.cd(dir)
  vim.notify("cwd → " .. vim.fn.fnamemodify(dir, ":~"), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>wc", cd_to_current_file, { desc = "[W]orkspace [C]d to current file dir" })
