local oil = require("oil")

oil.setup({
  default_file_explorer = true,
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

require("neo-tree").setup({
  close_if_last_window = false,
  popup_border_style = "",
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
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    window = {
      mappings = {
        ["H"] = "toggle_hidden",
      },
    },
  },
  window = {
    position = "left",
    width = 36,
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>of", oil.toggle_float, { desc = "[O]il [F]loat" })
vim.keymap.set("n", "<leader>e", "<cmd>Neotree source=filesystem position=left toggle=true<CR>",
  { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>E", "<cmd>Neotree source=filesystem position=left reveal=true<CR>",
  { desc = "Reveal current file in explorer" })
vim.keymap.set("n", "<leader>ef", "<cmd>Neotree toggle float<CR>", { desc = "[E]xplorer [F]loat" })
vim.keymap.set("n", "<leader>eb", "<cmd>Neotree source=buffers position=left toggle=true<CR>",
  { desc = "[E]xplorer [B]uffers" })
vim.keymap.set("n", "<leader>eg", "<cmd>Neotree source=git_status float toggle=true<CR>",
  { desc = "[E]xplorer [G]it status" })
