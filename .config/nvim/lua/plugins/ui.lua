require("lualine").setup({
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- Inside tmux: embed lualine into the tmux status bar via vim-tpipeline
-- (mode / git / file / diagnostics stay visible). Outside tmux: normal lualine.
-- Non-nvim tmux panes keep the ordinary tmux status (tpipeline restores on blur).
if vim.env.TMUX and vim.env.TMUX ~= "" then
  -- Do not use lualine.hide(): tpipeline must still evaluate the statusline.
  vim.g.tpipeline_autoembed = 1
  vim.g.tpipeline_restore = 1
  vim.opt.laststatus = 0
  vim.opt.showmode = false

  vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme", "FocusGained" }, {
    group = vim.api.nvim_create_augroup("tpipeline_lualine", { clear = true }),
    callback = function()
      vim.schedule(function()
        if vim.env.TMUX and vim.env.TMUX ~= "" then
          -- lualine may force laststatus=3; keep a single bottom bar in tmux.
          vim.opt.laststatus = 0
          vim.opt.showmode = false
        end
      end)
    end,
  })
else
  vim.opt.showmode = false
end

require("which-key").setup({
  spec = {
    { "<leader>a", group = "[A]erial" },
    { "<leader>b", group = "[B]uffer" },
    { "<leader>c", group = "[C]ode" },
    { "<leader>d", group = "[D]ebug" },
    { "<leader>e", group = "[E]xplorer" },
    { "<leader>g", group = "[G]it" },
    { "<leader>h", group = "Git [H]unks" },
    { "<leader>j", group = "[J]ava" },
    { "<leader>m", group = "[M]arkdown" },
    { "<leader>o", group = "[O]il" },
    { "<leader>p", group = "Har[P]oon" },
    { "<leader>R", group = "HTTP [R]equest" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>t", group = "Terminal" },
    { "<leader>T", group = "[T]est" },
    { "<leader>u", group = "[U]ndo" },
    { "<leader>w", group = "[W]orkspace / Window" },
    { "<leader>x", group = "Trouble" },
  },
})
