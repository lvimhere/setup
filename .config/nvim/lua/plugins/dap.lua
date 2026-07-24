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

-- Java DAP adapter/configs are registered by nvim-jdtls when jdtls attaches
-- (see ftplugin/java.lua).

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
