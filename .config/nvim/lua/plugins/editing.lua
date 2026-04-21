require("nvim-autopairs").setup()
require("Comment").setup()
require("nvim-surround").setup({})
require("mini.ai").setup({
  n_lines = 500,
})
require("todo-comments").setup()

local function disable_undotree_builtin_last_window_exit()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].isUndotreeBuffer == 1 then
      pcall(vim.cmd, ("autocmd! Undotree_Main BufEnter <buffer=%d>"):format(bufnr))
      pcall(vim.cmd, ("autocmd! Undotree_Diff BufEnter <buffer=%d>"):format(bufnr))
    end
  end
end

local function toggle_undotree()
  vim.cmd("UndotreeToggle")
  vim.schedule(disable_undotree_builtin_last_window_exit)
end

vim.keymap.set("n", "<leader>uu", toggle_undotree, { desc = "[U]ndo tree" })

local undotree_cleanup_group = vim.api.nvim_create_augroup("undotree_cleanup", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  group = undotree_cleanup_group,
  callback = function(args)
    if vim.b[args.buf].isUndotreeBuffer == 1 then
      -- Undotree installs its own "exit if last window" BufEnter hooks. Remove
      -- those and let our unified sidebar-close logic own the behavior.
      vim.schedule(disable_undotree_builtin_last_window_exit)
    end
  end,
})
