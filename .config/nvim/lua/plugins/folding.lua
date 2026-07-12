vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.fillchars:append({
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
})

require("ufo").setup({
  provider_selector = function(_, filetype, _)
    if filetype == "markdown" or filetype == "text" then
      return { "indent" }
    end
    return { "lsp", "indent" }
  end,
})

vim.keymap.set("n", "zR", function()
  require("ufo").openAllFolds()
end, { desc = "Open all folds" })

vim.keymap.set("n", "zM", function()
  require("ufo").closeAllFolds()
end, { desc = "Close all folds" })

vim.keymap.set("n", "zp", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek folded lines" })
