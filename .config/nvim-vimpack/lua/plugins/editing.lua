require("nvim-autopairs").setup()
require("Comment").setup()
require("nvim-surround").setup({})

-- LazyVim-style mini.ai: Treesitter for select; function call moved to u/U.
-- See docs/textobjects.md
local ai = require("mini.ai")

--- Buffer textobject (from MiniExtra / LazyVim).
local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end
  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

local mini_ai_opts = {
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    d = { "%f[%d]%d+" },
    e = {
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    g = ai_buffer,
    u = ai.gen_spec.function_call(),
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
  },
}

ai.setup(mini_ai_opts)

-- which-key labels for a/i textobjects (LazyVim-style)
local ok_wk, wk = pcall(require, "which-key")
if ok_wk then
  local objects = {
    { " ", desc = "whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "user prompt" },
    { "U", desc = "use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "underscore" },
    { "`", desc = "` string" },
    { "a", desc = "argument" },
    { "b", desc = ")]} block" },
    { "c", desc = "class" },
    { "d", desc = "digit(s)" },
    { "e", desc = "CamelCase / snake_case" },
    { "f", desc = "function" },
    { "g", desc = "entire file" },
    { "o", desc = "block, conditional, loop" },
    { "q", desc = "quote `\"'" },
    { "t", desc = "tag" },
    { "u", desc = "use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }
  local mappings = {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",
  }
  ---@type wk.Spec
  local ret = { mode = { "o", "x" } }
  for name, prefix in pairs(mappings) do
    name = name:gsub("^around_", ""):gsub("^inside_", "")
    ret[#ret + 1] = { prefix, group = name }
    for _, obj in ipairs(objects) do
      ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
    end
  end
  wk.add(ret, { notify = false })
end

require("todo-comments").setup()

-- Default treesj maps use <space>m/j/s and collide with Leader.
require("treesj").setup({
  use_default_keymaps = false,
  max_join_length = 120,
})
vim.keymap.set("n", "gS", require("treesj").toggle, { desc = "Toggle split/join node" })

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
