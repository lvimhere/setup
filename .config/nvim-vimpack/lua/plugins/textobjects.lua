-- LazyVim-style: select via mini.ai (editing.lua); this file only does move + incremental.
-- Keymap reference: ~/.config/nvim/docs/textobjects.md

require("nvim-treesitter-textobjects").setup({
  move = {
    set_jumps = true,
  },
})

local move = require("nvim-treesitter-textobjects.move")

local move_keys = {
  goto_next_start = {
    ["]f"] = "@function.outer",
    ["]c"] = "@class.outer",
    ["]a"] = "@parameter.inner",
  },
  goto_next_end = {
    ["]F"] = "@function.outer",
    ["]C"] = "@class.outer",
    ["]A"] = "@parameter.inner",
  },
  goto_previous_start = {
    ["[f"] = "@function.outer",
    ["[c"] = "@class.outer",
    ["[a"] = "@parameter.inner",
  },
  goto_previous_end = {
    ["[F"] = "@function.outer",
    ["[C"] = "@class.outer",
    ["[A"] = "@parameter.inner",
  },
}

for method, keymaps in pairs(move_keys) do
  for key, query in pairs(keymaps) do
    local desc = (key:sub(1, 1) == "[" and "Prev " or "Next ")
      .. query:gsub("@", ""):gsub("%..*", "")
      .. (key:sub(2, 2) == key:sub(2, 2):upper() and " end" or " start")
    vim.keymap.set({ "n", "x", "o" }, key, function()
      -- LazyVim: in diff mode keep native ]c/[c hunk motion
      if vim.wo.diff and key:find("[cC]") then
        return vim.cmd("normal! " .. key)
      end
      move[method](query, "textobjects")
    end, { desc = desc, silent = true })
  end
end

-- Incremental selection (Neovim 0.12). <C-Space> reserved for IME.
local function ts_select(target)
  return function()
    vim.treesitter.select(target, vim.v.count1)
  end
end

vim.keymap.set({ "n", "x", "o" }, "<M-o>", ts_select("parent"), {
  desc = "TS incremental: grow to parent",
})
vim.keymap.set({ "x", "o" }, "<M-i>", ts_select("child"), {
  desc = "TS incremental: shrink to child",
})
