local treesitter_languages = {
  "bash",
  "c",
  "cpp",
  "css",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_user_command("TSInstallRecommended", function()
  require("nvim-treesitter").install(treesitter_languages):wait(300000)
end, { desc = "Install the recommended Treesitter parsers for this config" })

local ts_group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
