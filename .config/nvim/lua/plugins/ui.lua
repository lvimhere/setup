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

require("which-key").setup({
  spec = {
    { "<leader>a", group = "[A]erial" },
    { "<leader>b", group = "[B]uffer" },
    { "<leader>c", group = "[C]ode" },
    { "<leader>d", group = "[D]ebug" },
    { "<leader>e", group = "[E]xplorer" },
    { "<leader>g", group = "[G]it" },
    { "<leader>h", group = "Git [H]unks" },
    { "<leader>m", group = "[M]arkdown" },
    { "<leader>o", group = "[O]il" },
    { "<leader>R", group = "HTTP [R]equest" },
    { "<leader>s", group = "[S]earch" },
    { "<leader>t", group = "Terminal" },
    { "<leader>T", group = "[T]est" },
    { "<leader>u", group = "[U]ndo" },
    { "<leader>w", group = "[W]orkspace / Window" },
    { "<leader>x", group = "Trouble" },
  },
})
