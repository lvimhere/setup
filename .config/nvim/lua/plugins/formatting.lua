local conform = require("conform")

local prettier_formatters = { "prettierd", "prettier", stop_after_first = true }

local prettier_config_names = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
  "prettier.config.cts",
  "prettier.config.mts",
  ".editorconfig",
}

local config_markers_by_ft = {
  c = { ".clang-format", "_clang-format" },
  cpp = { ".clang-format", "_clang-format" },
  css = prettier_config_names,
  html = prettier_config_names,
  javascript = prettier_config_names,
  javascriptreact = prettier_config_names,
  json = prettier_config_names,
  jsonc = prettier_config_names,
  lua = { "stylua.toml", ".stylua.toml" },
  markdown = prettier_config_names,
  python = { "pyproject.toml", "setup.cfg", "tox.ini", ".isort.cfg" },
  rust = { "rustfmt.toml", ".rustfmt.toml" },
  sh = { ".editorconfig" },
  typescript = prettier_config_names,
  typescriptreact = prettier_config_names,
  vue = prettier_config_names,
  yaml = prettier_config_names,
}

local prettier_filetypes = {
  css = true,
  html = true,
  javascript = true,
  javascriptreact = true,
  json = true,
  jsonc = true,
  markdown = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
  yaml = true,
}

local function find_upward(markers, startpath)
  if not markers or not startpath or startpath == "" then
    return nil
  end
  return vim.fs.find(markers, { path = startpath, upward = true })[1]
end

local function buffer_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end
  return vim.fs.dirname(name)
end

local function has_prettier_in_package_json(startpath)
  local package_json = find_upward({ "package.json" }, startpath)
  if not package_json then
    return false
  end

  local ok, lines = pcall(vim.fn.readfile, package_json)
  if not ok then
    return false
  end

  local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  return decoded_ok and type(decoded) == "table" and decoded.prettier ~= nil
end

local function has_python_formatter_config(startpath)
  local pyproject = find_upward({ "pyproject.toml" }, startpath)
  if pyproject then
    local ok, lines = pcall(vim.fn.readfile, pyproject)
    if ok then
      local content = table.concat(lines, "\n")
      if content:find("%[tool%.black%]") or content:find("%[tool%.isort%]") then
        return true
      end
    end
  end

  local setup_cfg = find_upward({ "setup.cfg" }, startpath)
  if setup_cfg then
    local ok, lines = pcall(vim.fn.readfile, setup_cfg)
    if ok then
      local content = table.concat(lines, "\n")
      if content:find("%[isort%]") then
        return true
      end
    end
  end

  local tox_ini = find_upward({ "tox.ini" }, startpath)
  if tox_ini then
    local ok, lines = pcall(vim.fn.readfile, tox_ini)
    if ok then
      local content = table.concat(lines, "\n")
      if content:find("%[isort%]") then
        return true
      end
    end
  end

  return find_upward({ ".isort.cfg" }, startpath) ~= nil
end

local function has_formatter_config(bufnr)
  local ft = vim.bo[bufnr].filetype
  local startpath = buffer_dir(bufnr)
  if not startpath then
    return false
  end

  if ft == "python" then
    return has_python_formatter_config(startpath)
  end

  local markers = config_markers_by_ft[ft]
  if not markers then
    return false
  end

  if find_upward(markers, startpath) then
    return true
  end

  if prettier_filetypes[ft] then
    return has_prettier_in_package_json(startpath)
  end

  return false
end

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
  format_on_save = function(bufnr)
    if not has_formatter_config(bufnr) then
      return nil
    end

    return {
      timeout_ms = 800,
      lsp_format = "never",
    }
  end,
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
