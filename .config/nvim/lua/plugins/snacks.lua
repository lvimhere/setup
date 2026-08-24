-- Snacks / LSP 部分默认同键改到 Alt-Shift。当初为避开 Zellij；Zellij 已作废，改键仍保留。
-- 见 ~/setup/docs/lazyvim.md。移动行已恢复 LazyVim 默认 Alt-j/k。
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ["<a-h>"] = false,
              ["<a-f>"] = false,
              ["<a-H>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<a-F>"] = { "toggle_follow", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<a-h>"] = false,
              ["<a-f>"] = false,
              ["<a-H>"] = "toggle_hidden",
              ["<a-F>"] = "toggle_follow",
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<a-n>", false },
            {
              "<a-N>",
              function()
                Snacks.words.jump(vim.v.count1, true)
              end,
              has = "documentHighlight",
              desc = "Next Reference",
              enabled = function()
                return Snacks.words.is_enabled()
              end,
            },
          },
        },
      },
    },
  },
}
