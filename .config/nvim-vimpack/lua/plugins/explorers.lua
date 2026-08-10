local oil = require("oil")

oil.setup({
  -- Keep neo-tree as the netrw hijacker; open Oil via <leader>of (float).
  -- Global `-` is reserved for mini.files.
  default_file_explorer = false,
  columns = { "icon" },
  win_options = {
    wrap = false,
    signcolumn = "no",
    list = false,
  },
  view_options = {
    show_hidden = true,
    natural_order = true,
    is_always_hidden = function(name, _)
      return name == ".." or name == ".git"
    end,
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  use_default_keymaps = true,
  float = {
    padding = 2,
    max_width = 0.7,
    max_height = 0.7,
    border = "none",
    preview_split = "right",
  },
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-c>"] = false,
    ["<C-r>"] = "actions.refresh",
    ["q"] = "actions.close",
  },
})

--- Neo-tree Enter opens buffers with :edit / :buffer in a normal split.
--- ToggleTerm floats are a separate window type; opening the same term buffer
--- via neo-tree "steals" it into a split and breaks <C-\> float toggle.
local function open_toggleterm_float(state)
  local node = state.tree:get_node()
  if not node then
    return
  end

  -- Folder row under "Terminals" — just expand/collapse.
  if node:has_children() then
    require("neo-tree.sources.common.commands").toggle_node(state)
    return
  end

  local bufnr = node.extra and node.extra.bufnr
  local bufname = ""
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    bufname = vim.api.nvim_buf_get_name(bufnr)
  else
    bufname = node.path or node:get_id() or ""
  end

  local is_toggleterm = type(bufname) == "string" and bufname:find("toggleterm", 1, true)
  if not is_toggleterm then
    require("neo-tree.sources.common.commands").open(state)
    return
  end

  local terminal = require("toggleterm.terminal")
  local id, term = terminal.identify(bufname)
  term = term or (id and terminal.get(id, true))
  if not term then
    require("neo-tree.sources.common.commands").open(state)
    return
  end

  -- Detach the term buffer from any normal (non-float) windows first.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == term.bufnr then
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative == "" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end

  require("neo-tree.command").execute({ action = "close" })

  if term:is_open() and term:is_float() then
    term:focus()
  else
    if term:is_open() then
      term:close()
    end
    term:open(nil, "float")
  end

  if vim.api.nvim_buf_is_valid(term.bufnr) and vim.bo[term.bufnr].buftype == "terminal" then
    vim.cmd("startinsert")
  end
end

require("neo-tree").setup({
  auto_clean_after_session_restore = true,
  close_if_last_window = false,
  popup_border_style = "",
  source_selector = {
    winbar = true,
  },
  commands = {
    open_toggleterm_float = open_toggleterm_float,
  },
  default_component_configs = {
    indent = {
      padding = 0,
      with_markers = false,
      with_expanders = true,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "",
      default = "",
    },
    modified = {
      symbol = "●",
      highlight = "NeoTreeModified",
    },
    name = {
      highlight_opened_files = true,
    },
    git_status = {
      symbols = {
        added = "✚",
        modified = "",
        deleted = "✖",
        renamed = "󰁕",
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",
        conflict = "",
      },
    },
  },
  filesystem = {
    hijack_netrw_behavior = "open_default",
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db",
      },
    },
    window = {
      mappings = {
        ["H"] = "toggle_hidden",
      },
    },
  },
  buffers = {
    window = {
      mappings = {
        ["<cr>"] = "open_toggleterm_float",
        ["o"] = "open_toggleterm_float",
      },
    },
  },
  git_status_scope_to_path = true,
  window = {
    position = "left",
    width = 36,
  },
})

vim.keymap.set("n", "<leader>of", oil.toggle_float, { desc = "[O]il [F]loat" })
vim.keymap.set("n", "<leader>ee", "<cmd>Neotree source=filesystem position=left toggle=true<CR>",
  { desc = "[E]xplorer toggle sidebar" })
vim.keymap.set("n", "<leader>E",
  "<cmd>Neotree source=filesystem position=left reveal=true reveal_force_cwd=true<CR>",
  { desc = "[E]xplorer reveal current file" })
vim.keymap.set("n", "<leader>ed", function()
  local file = vim.api.nvim_buf_get_name(0)
  local dir
  if file ~= "" then
    dir = vim.fn.fnamemodify(file, ":p:h")
    if vim.fn.isdirectory(dir) ~= 1 then
      dir = vim.fn.getcwd()
    end
  else
    dir = vim.fn.getcwd()
  end
  require("neo-tree.command").execute({
    source = "filesystem",
    position = "float",
    dir = dir,
    reveal_force_cwd = true,
  })
end, { desc = "[E]xplorer reveal [D]irectory (float)" })
vim.keymap.set("n", "<leader>ef", "<cmd>Neotree toggle float<CR>", { desc = "[E]xplorer [F]loat" })
vim.keymap.set("n", "<leader>eb", "<cmd>Neotree source=buffers position=left toggle=true<CR>",
  { desc = "[E]xplorer [B]uffers" })
vim.keymap.set("n", "<leader>eg", "<cmd>Neotree source=git_status float toggle=true<CR>",
  { desc = "[E]xplorer [G]it status" })
vim.keymap.set("n", "<leader>es", "<cmd>Neotree close<CR>", { desc = "[E]xplorer [S]hutdown" })
