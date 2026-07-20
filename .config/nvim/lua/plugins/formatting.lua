local conform = require("conform")

local prettier_formatters = { "prettierd", "prettier", stop_after_first = true }

conform.setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    css = prettier_formatters,
    go = { "gofumpt", "goimports" },
    html = prettier_formatters,
    javascript = prettier_formatters,
    javascriptreact = prettier_formatters,
    json = prettier_formatters,
    jsonc = prettier_formatters,
    lua = { "stylua" },
    markdown = prettier_formatters,
    python = { "isort", "black" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    typescript = prettier_formatters,
    typescriptreact = prettier_formatters,
    vue = prettier_formatters,
    yaml = prettier_formatters,
  },
  format_on_save = false,
})

local lint = require("lint")

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  python = { "ruff" },
  sh = { "shellcheck" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  vue = { "eslint_d" },
}

local lint_group = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_group,
  callback = function()
    require("lint").try_lint()
  end,
})
