local prose_group = vim.api.nvim_create_augroup("prose_options", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = prose_group,
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 80
  end,
})

local yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    vim.hl.on_yank()
  end,
})

local auxiliary_close_group = vim.api.nvim_create_augroup("close_on_auxiliary_windows", { clear = true })

local auxiliary_filetypes = {
  ["aerial"] = true,
  ["aerial-nav"] = true,
  ["neo-tree"] = true,
  ["neo-tree-popup"] = true,
  ["undotree"] = true,
}

local function is_auxiliary_sidebar_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  -- Undotree's lower diff panel uses filetype=diff, so rely on its buffer marker
  -- instead of filetype alone.
  if vim.b[bufnr].isUndotreeBuffer == 1 then
    return true
  end

  return auxiliary_filetypes[vim.bo[bufnr].filetype] or false
end

local function only_auxiliary_sidebar_windows_remain()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins == 0 then
    return false
  end

  for _, winid in ipairs(wins) do
    if vim.api.nvim_win_is_valid(winid) then
      local bufnr = vim.api.nvim_win_get_buf(winid)
      if not is_auxiliary_sidebar_buffer(bufnr) then
        return false
      end
    end
  end

  return true
end

vim.api.nvim_create_autocmd("WinClosed", {
  group = auxiliary_close_group,
  callback = function()
    -- Run after the window is actually gone so :q on a normal editing window can
    -- naturally collapse the tab into "only sidebars left" and then exit cleanly.
    vim.schedule(function()
      if vim.fn.mode() == "c" or vim.fn.getcmdwintype() ~= "" then
        return
      end

      if only_auxiliary_sidebar_windows_remain() then
        pcall(vim.cmd, "qa")
      end
    end)
  end,
})
