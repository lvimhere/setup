-- nvim-treesitter (main) has no official `less` parser (see SUPPORTED_LANGUAGES.md).
-- Keep `scss` for Vue <style lang="scss">; map .less filetype to css as a fallback.
local treesitter_languages = {
  "bash",
  "c",
  "cpp",
  "css",
  "dockerfile",
  "go",
  "graphql",
  "html",
  "java",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "scss",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

local ts = require("nvim-treesitter")

ts.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Standalone *.less buffers: reuse css highlighting (Less is CSS-superset-ish).
pcall(vim.treesitter.language.register, "css", "less")

local recommended = {}
for _, lang in ipairs(treesitter_languages) do
  recommended[lang] = true
end

local function missing_recommended_languages()
  local installed = ts.get_installed("parsers")
  return vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
  end, treesitter_languages)
end

local function install_recommended_languages()
  local missing = missing_recommended_languages()
  if #missing == 0 then
    return
  end
  return ts.install(missing)
end

vim.api.nvim_create_user_command("TSInstallRecommended", function()
  local job = install_recommended_languages()
  if job then
    job:wait(300000)
  end
end, { desc = "Install the recommended Treesitter parsers for this config" })

local ts_group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = ts_group,
  once = true,
  callback = function()
    vim.schedule(function()
      install_recommended_languages()
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    local started = pcall(vim.treesitter.start, args.buf, lang)
    if started or not recommended[lang] then
      return
    end

    if vim.tbl_contains(ts.get_installed("parsers"), lang) then
      return
    end

    ts.install({ lang }):wait(120000)
    pcall(vim.treesitter.start, args.buf, lang)
  end,
})
