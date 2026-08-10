local adapters = {}

local ok_plenary, neotest_plenary = pcall(require, "neotest-plenary")
if ok_plenary then
  table.insert(adapters, neotest_plenary)
end

local ok_python, neotest_python = pcall(require, "neotest-python")
if ok_python then
  table.insert(adapters, neotest_python({
    dap = { justMyCode = false },
  }))
end

local ok_go, neotest_go = pcall(require, "neotest-go")
if ok_go then
  table.insert(adapters, neotest_go({}))
end

local ok_vitest, neotest_vitest = pcall(require, "neotest-vitest")
if ok_vitest then
  table.insert(adapters, neotest_vitest({}))
end

require("neotest").setup({
  adapters = adapters,
})

vim.keymap.set("n", "<leader>Tt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>Tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run current test file" })
vim.keymap.set("n", "<leader>Td", function()
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })
vim.keymap.set("n", "<leader>Ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>To", function()
  require("neotest").output.open({ enter = true })
end, { desc = "Open test output" })
vim.keymap.set("n", "<leader>TO", function()
  require("neotest").output_panel.toggle()
end, { desc = "Toggle test output panel" })
vim.keymap.set("n", "<leader>TS", function()
  require("neotest").run.stop()
end, { desc = "Stop test run" })
