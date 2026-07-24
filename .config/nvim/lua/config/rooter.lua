-- Auto-chdir to project root (git / common markers). Manual: <leader>wp
local markers = {
  ".git",
  "package.json",
  "pnpm-workspace.yaml",
  "go.mod",
  "Cargo.toml",
  "pyproject.toml",
  "Makefile",
  "CMakeLists.txt",
}

local skip_filetype = {
  ["neo-tree"] = true,
  ["neo-tree-popup"] = true,
  oil = true,
  ["minifiles"] = true,
  help = true,
  qf = true,
  TelescopePrompt = true,
  ["grug-far"] = true,
  ["dap-repl"] = true,
  toggleterm = true,
}

local function should_skip(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return true
  end
  if vim.bo[bufnr].buftype ~= "" then
    return true
  end
  if skip_filetype[vim.bo[bufnr].filetype] then
    return true
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return true
  end
  return false
end

local function find_project_root(path)
  if not path or path == "" then
    return nil
  end
  return vim.fs.root(path, markers)
end

local function cd_to_root(root, silent)
  if not root or root == "" then
    return false
  end
  if vim.fn.isdirectory(root) ~= 1 then
    return false
  end
  if vim.fn.getcwd() == root then
    return true
  end
  vim.fn.chdir(root)
  if not silent then
    vim.notify("cwd → " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.INFO)
  end
  return true
end

local function sync_root(bufnr, silent)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if should_skip(bufnr) then
    return false
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  local root = find_project_root(name)
  if not root then
    if not silent then
      vim.notify("No project root found for current buffer", vim.log.levels.WARN)
    end
    return false
  end
  return cd_to_root(root, silent)
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("project_rooter", { clear = true }),
  callback = function(args)
    sync_root(args.buf, true)
  end,
})

vim.keymap.set("n", "<leader>wp", function()
  sync_root(0, false)
end, { desc = "[W]orkspace [P]roject root (cd)" })
