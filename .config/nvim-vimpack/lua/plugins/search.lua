require("telescope").setup({})

local pickers = require("telescope.builtin")

--- Prompt for a directory, then run a Telescope picker there without changing cwd.
local function search_other_dir(picker)
  return function()
    vim.ui.input({
      prompt = "Directory: ",
      default = vim.fn.expand("~") .. "/",
      completion = "dir",
    }, function(dir)
      if not dir or dir == "" then
        return
      end
      dir = vim.fn.fnamemodify(vim.fn.expand(dir), ":p")
      if vim.fn.isdirectory(dir) ~= 1 then
        vim.notify("Not a directory: " .. dir, vim.log.levels.ERROR)
        return
      end
      picker({ cwd = dir })
    end)
  end
end

vim.keymap.set("n", "<leader>sp", pickers.builtin, { desc = "[S]earch builtin [P]ickers" })
vim.keymap.set("n", "<leader>sb", pickers.buffers, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>sf", pickers.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sF", search_other_dir(pickers.find_files), { desc = "[S]earch [F]iles in other dir" })
vim.keymap.set("n", "<leader>sw", pickers.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", pickers.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sG", search_other_dir(pickers.live_grep), { desc = "[S]earch by [G]rep in other dir" })
vim.keymap.set("n", "<leader>sr", pickers.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sh", pickers.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sm", pickers.man_pages, { desc = "[S]earch [M]anuals" })
