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

-- Resize the currently focused window (neo-tree | editor | AI/terminal layouts).
-- Count works: 5<A-l> widens by 5 columns.
local function resize_win(dir)
  -- Default step 2; prefix count overrides, e.g. 5<A-l>
  local step = vim.v.count > 0 and vim.v.count or 2
  if dir == "left" then
    vim.cmd("vertical resize -" .. step)
  elseif dir == "right" then
    vim.cmd("vertical resize +" .. step)
  elseif dir == "up" then
    vim.cmd("resize -" .. step)
  elseif dir == "down" then
    vim.cmd("resize +" .. step)
  end
end

local resize_maps = {
  { "<A-h>", "left", "Resize window narrower" },
  { "<A-l>", "right", "Resize window wider" },
  { "<A-k>", "up", "Resize window shorter" },
  { "<A-j>", "down", "Resize window taller" },
  { "<C-Left>", "left", "Resize window narrower" },
  { "<C-Right>", "right", "Resize window wider" },
  { "<C-Up>", "up", "Resize window shorter" },
  { "<C-Down>", "down", "Resize window taller" },
}

for _, map in ipairs(resize_maps) do
  local lhs, dir, desc = map[1], map[2], map[3]
  vim.keymap.set({ "n", "i", "t" }, lhs, function()
    resize_win(dir)
  end, { desc = desc })
end

vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "[W]indow equalize sizes" })
vim.keymap.set("n", "<leader>w_", "<C-w>_", { desc = "[W]indow maximize height" })
vim.keymap.set("n", "<leader>w|", "<C-w>|", { desc = "[W]indow maximize width" })
