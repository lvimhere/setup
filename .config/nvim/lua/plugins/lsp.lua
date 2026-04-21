local capabilities = require("blink.cmp").get_lsp_capabilities()
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
local vue_language_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_typescript_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

local servers = {
  bashls = {},
  clangd = {},
  cssls = {},
  gopls = {},
  html = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("lua", true),
        },
      },
    },
  },
  marksman = {},
  pyright = {},
  rust_analyzer = {},
  ts_ls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
    },
    init_options = {
      hostInfo = "neovim",
      plugins = { vue_typescript_plugin },
    },
  },
  vue_ls = {},
  yamlls = {},
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
})
require("mason-tool-installer").setup({
  ensure_installed = {
    "black",
    "debugpy",
    "delve",
    "eslint_d",
    "gofumpt",
    "goimports",
    "isort",
    "prettierd",
    "shellcheck",
    "shfmt",
    "stylua",
    "vue-language-server",
  },
})

local default_hover_handler = vim.lsp.handlers["textDocument/hover"]
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  local merged = vim.tbl_extend("force", config or {}, { border = "none" })
  return default_hover_handler(err, result, ctx, merged)
end

for server, config in pairs(servers) do
  vim.lsp.config(server, vim.tbl_deep_extend("force", {
    capabilities = capabilities,
  }, config))
end

vim.lsp.enable(vim.tbl_keys(servers))

local lsp_group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local bufnr = args.buf

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Goto definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
    map("n", "gI", vim.lsp.buf.implementation, "Goto implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "Goto type definition")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>cf", function()
      require("conform").format({ async = false, lsp_format = "fallback" })
    end, "Format buffer")
    map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    map("n", "gr", "<cmd>Trouble lsp_references toggle focus=false win.position=right<CR>", "References")
  end,
})
