require("neo-tree").setup({
  auto_clean_after_session_restore = true,
  close_if_last_window = false,
  popup_border_style = "",
  source_selector = {
    winbar = true,
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
  git_status_scope_to_path = true,
  window = {
    position = "left",
    width = 36,
  },
})

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
