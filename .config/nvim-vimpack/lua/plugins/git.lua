require("gitsigns").setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]h", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, "Next git hunk")

    map("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[h", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, "Previous git hunk")

    map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage hunk")
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset hunk")
    map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
    map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
    map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, "Blame line")
    map("n", "<leader>hd", gitsigns.diffthis, "Diff this")
  end,
})

require("diffview").setup({
  enhanced_diff_hl = true,
  use_icons = true,
  view = {
    default = {
      layout = "diff2_horizontal",
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
    },
    file_history = {
      layout = "diff2_horizontal",
    },
  },
  file_panel = {
    win_config = {
      position = "left",
      width = 35,
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      height = 16,
    },
  },
})

require("neogit").setup({
  kind = "tab",
  disable_line_numbers = true,
  disable_relative_line_numbers = true,
  integrations = {
    diffview = true,
    telescope = true,
  },
  signs = {
    hunk = { "", "" },
    item = { "", "" },
    section = { "", "" },
  },
})

require("git-conflict").setup({
  default_mappings = true,
  default_commands = true,
  disable_diagnostics = true,
  list_opener = "copen",
})

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Git status (Neogit)" })
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Open commit popup" })
vim.keymap.set("n", "<leader>gb", "<cmd>Neogit branch<CR>", { desc = "Open branch popup" })
vim.keymap.set("n", "<leader>gs", "<cmd>Neogit stash<CR>", { desc = "Open stash popup" })
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<CR>", { desc = "Open pull popup" })
vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<CR>", { desc = "Open push popup" })
vim.keymap.set("n", "<leader>gr", "<cmd>Neogit rebase<CR>", { desc = "Open rebase popup" })
vim.keymap.set("n", "<leader>go", "<cmd>DiffviewOpen<CR>", { desc = "Open diff view" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diff view" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Repository history" })
