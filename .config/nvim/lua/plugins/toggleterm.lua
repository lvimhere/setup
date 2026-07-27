local toggleterm = require("toggleterm")
local Terminal = require("toggleterm.terminal").Terminal

toggleterm.setup({
  direction = "float",
  start_in_insert = true,
  shade_terminals = false,
  persist_size = true,
  float_opts = {
    border = "curved",
    width = function()
      return math.floor(vim.o.columns * 0.85)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.85)
    end,
  },
})

local function toggle_direction(direction, size)
  if size then
    vim.cmd(("ToggleTerm direction=%s size=%d"):format(direction, size))
  else
    vim.cmd(("ToggleTerm direction=%s"):format(direction))
  end
end

local function send_lines(mode)
  toggleterm.send_lines_to_terminal(mode, true, { args = vim.v.count1 })
end

local function project_test_cmd()
  local ft = vim.bo.filetype
  local path = vim.fn.expand("%:p")

  if ft == "python" then
    return path ~= "" and ("pytest " .. vim.fn.shellescape(path)) or "pytest"
  end
  if ft == "go" then
    return "go test ./..."
  end
  if ft == "typescript" or ft == "javascript" or ft == "typescriptreact" or ft == "javascriptreact" then
    return "npm test"
  end
  if ft == "rust" then
    return "cargo test"
  end

  return nil
end

local function run_project_tests()
  local cmd = project_test_cmd()
  if not cmd then
    vim.notify("No terminal test command for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  toggleterm.exec(cmd, nil, 20, nil, "horizontal")
end

local function compile_and_run_c()
  local ft = vim.bo.filetype
  if ft ~= "c" and ft ~= "cpp" then
    vim.notify("Compile & run supports filetype c/cpp (current: " .. ft .. ")", vim.log.levels.WARN)
    return
  end

  local src = vim.api.nvim_buf_get_name(0)
  if src == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  vim.cmd.write()

  local out = vim.fn.fnamemodify(src, ":r")
  local compiler
  if ft == "cpp" then
    compiler = vim.fn.executable("clang++") == 1 and "clang++" or "g++"
  else
    compiler = vim.fn.executable("clang") == 1 and "clang" or "gcc"
  end

  if vim.fn.executable(compiler) ~= 1 then
    vim.notify("Compiler not found: " .. compiler, vim.log.levels.ERROR)
    return
  end

  local cmd = table.concat({
    compiler,
    "-Wall",
    "-Wextra",
    "-g",
    "-o",
    vim.fn.shellescape(out),
    vim.fn.shellescape(src),
    "&&",
    vim.fn.shellescape(out),
  }, " ")

  toggleterm.exec(cmd, nil, 20, nil, "float")
end

local git_status = Terminal:new({
  cmd = "git status",
  dir = "git_dir",
  direction = "float",
  count = 8,
  hidden = true,
  close_on_exit = false,
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, desc = "Close terminal" })
  end,
})

local htop_term = Terminal:new({
  cmd = "htop",
  direction = "float",
  count = 9,
  hidden = true,
  on_open = function(term)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, desc = "Close terminal" })
  end,
})

local function open_htop()
  if vim.fn.executable("htop") == 0 then
    vim.notify("htop is not installed", vim.log.levels.WARN)
    return
  end
  htop_term:toggle()
end

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<Esc>", [[<C-\><C-N>]], vim.tbl_extend("force", opts, { desc = "Exit terminal mode" }))
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-N><C-w>]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*toggleterm#*",
  callback = set_terminal_keymaps,
})

-- Primary toggle: floating terminal
vim.keymap.set("n", "<C-\\>", function()
  toggle_direction("float")
end, { desc = "Toggle floating terminal" })
vim.keymap.set("i", "<C-\\>", function()
  vim.cmd.stopinsert()
  toggle_direction("float")
end, { desc = "Toggle floating terminal" })
vim.keymap.set("t", "<C-\\>", function()
  toggle_direction("float")
end, { desc = "Toggle floating terminal" })

-- <leader>t> terminal cluster (lowercase t; test uses uppercase <leader>T)
vim.keymap.set("n", "<leader>tf", function()
  toggle_direction("float")
end, { desc = "Terminal [F]loat" })
vim.keymap.set("n", "<leader>th", function()
  toggle_direction("horizontal", 15)
end, { desc = "Terminal [H]orizontal" })
vim.keymap.set("n", "<leader>tv", function()
  toggle_direction("vertical", math.floor(vim.o.columns * 0.4))
end, { desc = "Terminal [V]ertical" })
vim.keymap.set("n", "<leader>tn", "<cmd>TermNew<CR>", { desc = "Terminal [N]ew" })
vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", { desc = "Terminal [S]elect" })
vim.keymap.set("n", "<leader>ta", "<cmd>ToggleTermToggleAll<CR>", { desc = "Terminal toggle [A]ll" })
vim.keymap.set("n", "<leader>tr", run_project_tests, { desc = "Terminal [R]un test suite" })
vim.keymap.set("n", "<leader>cr", compile_and_run_c, { desc = "[C]ompile & [R]un (C/C++)" })
vim.keymap.set("n", "<leader>tg", function()
  git_status:toggle()
end, { desc = "Terminal [G]it status" })
vim.keymap.set("n", "<leader>tH", open_htop, { desc = "Terminal [H]top" })

for i = 1, 3 do
  vim.keymap.set("n", "<leader>t" .. i, function()
    vim.cmd(i .. "ToggleTerm")
  end, { desc = "Terminal " .. i })
end

vim.keymap.set("n", "<leader>tl", function()
  send_lines("single_line")
end, { desc = "Terminal send [L]ine" })
vim.keymap.set("v", "<leader>tL", function()
  send_lines("visual_lines")
end, { desc = "Terminal send visual [L]ines" })
vim.keymap.set("v", "<leader>tS", function()
  send_lines("visual_selection")
end, { desc = "Terminal send [S]election" })
