if not vim.o.sessionoptions:match("globals") then
  vim.opt.sessionoptions = vim.o.sessionoptions .. ",globals"
end

-- WSL: kulala-core must use Linux curl, not /mnt/c/WINDOWS/system32/curl.exe (ENOEXEC).
local function linux_first_path()
  local preferred = {
    "/usr/local/sbin",
    "/usr/local/bin",
    "/usr/sbin",
    "/usr/bin",
    "/sbin",
    "/bin",
    vim.fn.expand("~/.local/bin"),
    vim.fn.expand("~/sdk/go/bin"),
  }
  local seen, out = {}, {}
  for _, p in ipairs(preferred) do
    if p ~= "" and not seen[p] then
      seen[p] = true
      table.insert(out, p)
    end
  end
  for _, p in ipairs(vim.split(vim.env.PATH or "", ":", { plain = true })) do
    if p ~= "" and not p:match("^/mnt/") and not seen[p] then
      seen[p] = true
      table.insert(out, p)
    end
  end
  return table.concat(out, ":")
end

local wsl_ok, wsl_version = pcall(vim.fn.readfile, "/proc/version")
if wsl_ok and wsl_version[1] and wsl_version[1]:lower():match("microsoft") then
  vim.env.PATH = linux_first_path()
end

vim.filetype.add({
  extension = {
    http = "http",
    rest = "rest",
  },
})

local tree_sitter_cli = vim.fn.exepath("tree-sitter")
if tree_sitter_cli == "" then
  tree_sitter_cli = "tree-sitter"
end

require("kulala").setup({
  kulala_core = {
    download_tool = "/usr/sbin/curl",
  },
  treesitter = {
    enable = true,
    cli_path = tree_sitter_cli,
  },
  ui = {
    display_mode = "split",
    split_direction = "right",
    win_opts = {
      wo = { winborder = "none" },
    },
  },
  session = {
    restore = true,
  },
  lsp = {
    enable = true,
    filetypes = { "http", "rest" },
    -- Only HTTP-specific maps; K / <leader>ca / <leader>cf come from global LspAttach.
    keymaps = {
      ["<leader>ls"] = { vim.lsp.buf.document_symbol, desc = "HTTP document symbols" },
      ["<leader>lt"] = { "<cmd>Trouble symbols toggle focus=false<cr>", desc = "HTTP symbols outline" },
      ["<leader>lS"] = {
        function()
          require("aerial").toggle()
        end,
        desc = "HTTP symbols (aerial)",
      },
    },
  },
  global_keymaps = true,
  global_keymaps_prefix = "<leader>R",
  kulala_keymaps = {
    ["Jump to response"] = {
      "<CR>",
      function()
        local ui = require("kulala.ui")
        local resp = ui.get_current_response()
        local line = type(resp) == "table" and resp.line or nil
        if type(line) ~= "number" or line < 1 then
          require("kulala.logger").warn("No request to jump to. Send a request first (<leader>Rs or Enter in .http).")
          return
        end
        if vim.fn.bufwinid(resp.buf or -1) <= 0 then
          require("kulala.logger").warn("HTTP buffer is not open.")
          return
        end
        ui.keymap_enter()
      end,
      mode = { "n", "v" },
      desc = "Jump to request",
      prefix = false,
    },
  },
  kulala_keymaps_prefix = "",
})
