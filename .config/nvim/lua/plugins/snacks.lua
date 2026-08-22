-- Zellij Locked 白名单占用 Alt-h/f/n（切 pane / 浮窗 / 新窗格）。
-- Snacks 默认同键，改到 Alt-Shift，策略与 lua/config/keymaps.lua 的 Alt-Shift-j/k 一致。
-- 原因见 ~/setup/docs/lazyvim.md 与 ~/setup/docs/zellij.md。
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
