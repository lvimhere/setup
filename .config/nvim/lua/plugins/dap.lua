local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup({
  commented = true,
})

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

---------------------------------------------------------------------------
-- Go (delve via nvim-dap-go; mason installs `delve`)
---------------------------------------------------------------------------
local ok_dap_go, dap_go = pcall(require, "dap-go")
if ok_dap_go then
  dap_go.setup({
    delve = {
      -- Prefer Mason's dlv when present.
      path = vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "dlv",
    },
  })
end

---------------------------------------------------------------------------
-- JavaScript / TypeScript (vscode-js-debug via mason `js-debug-adapter`)
---------------------------------------------------------------------------
local function js_debug_server()
  local mason = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
  local matches = vim.fn.glob(mason .. "/**/dapDebugServer.js", true, true)
  return matches[1]
end

local function make_js_adapter()
  return function(callback)
    local js_dbg = js_debug_server()
    if not js_dbg then
      vim.notify(
        "js-debug-adapter not found. Install via Mason (`js-debug-adapter`) then restart Neovim.",
        vim.log.levels.ERROR
      )
      return
    end
    callback({
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { js_dbg, "${port}" },
      },
    })
  end
end

dap.adapters["pwa-node"] = make_js_adapter()
dap.adapters["pwa-chrome"] = make_js_adapter()

local js_configs = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch current file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    skipFiles = { "<node_internals>/**" },
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch npm script: debug",
    runtimeExecutable = "npm",
    runtimeArgs = { "run-script", "debug" },
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    console = "integratedTerminal",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  },
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome",
    url = "http://localhost:3000",
    webRoot = "${workspaceFolder}",
    sourceMaps = true,
  },
}

for _, lang in ipairs({
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}) do
  dap.configurations[lang] = js_configs
end

---------------------------------------------------------------------------
-- C / C++ (system gdb 14+ DAP; matches Cursor CodeLLDB workflow via gcc -g)
---------------------------------------------------------------------------
local function c_ensure_build_dir()
  local build = vim.fn.getcwd() .. "/build"
  if vim.fn.isdirectory(build) == 0 then
    vim.fn.mkdir(build, "p")
  end
  return build
end

local function c_compile_current()
  local src = vim.fn.expand("%:p")
  local ft = vim.bo.filetype
  if src == "" or (ft ~= "c" and ft ~= "cpp") then
    vim.notify("Open a .c / .cpp file first.", vim.log.levels.ERROR)
    return dap.ABORT
  end

  local out = c_ensure_build_dir() .. "/" .. vim.fn.expand("%:t:r")
  local compiler = ft == "cpp" and "g++" or "gcc"
  local std = ft == "cpp" and "c++17" or "c17"
  local cmd = { compiler, "-std=" .. std, "-Wall", "-Wextra", "-g", src, "-o", out }
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify(result.stderr ~= "" and result.stderr or "compile failed", vim.log.levels.ERROR)
    return dap.ABORT
  end
  return out
end

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

local c_configs = {
  {
    name = "Build & debug current file",
    type = "gdb",
    request = "launch",
    program = c_compile_current,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Launch executable",
    type = "gdb",
    request = "launch",
    program = function()
      local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
      return (path ~= nil and path ~= "") and path or dap.ABORT
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Attach to process",
    type = "gdb",
    request = "attach",
    pid = require("dap.utils").pick_process,
  },
}

dap.configurations.c = c_configs
dap.configurations.cpp = c_configs

-- Java DAP adapter/configs are registered by nvim-jdtls when jdtls attaches
-- (see ftplugin/java.lua).

---------------------------------------------------------------------------
-- C / C++ (gdb native DAP; GDB 14+)
---------------------------------------------------------------------------
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" },
}

local function resolve_c_executable()
  local candidates = {
    vim.fn.getcwd() .. "/build/main",
    vim.fn.getcwd() .. "/main",
    vim.fn.getcwd() .. "/a.out",
  }
  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

local c_configs = {
  {
    name = "Launch (build/main or prompt)",
    type = "gdb",
    request = "launch",
    program = resolve_c_executable,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Launch (pick executable)",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}

dap.configurations.c = c_configs
dap.configurations.cpp = c_configs

vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug step into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug step out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug continue" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug run last" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug terminate" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle debug REPL" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle debug UI" })

if ok_dap_go then
  vim.keymap.set("n", "<leader>dgt", function()
    require("dap-go").debug_test()
  end, { desc = "Debug Go nearest test" })
  vim.keymap.set("n", "<leader>dgl", function()
    require("dap-go").debug_last_test()
  end, { desc = "Debug Go last test" })
end
