-- 本机练习库连接。写在这里是因为项目里的 .lazy.lua 要先 :trust 才会执行，
-- 未信任时 DBUI 只会显示 Add connection。
-- 账号与仓库 README 本地 Docker 默认值一致。

local function find_mysql_wrapper_dir()
  local path = vim.uv.cwd() or ""
  while path ~= "" do
    if vim.fn.executable(path .. "/bin/mysql") == 1 then
      return path .. "/bin"
    end
    local parent = vim.fn.fnamemodify(path, ":h")
    if parent == path then
      break
    end
    path = parent
  end

  local fallback = vim.fn.expand("~/Projects/vue-node-fullstack-practice/bin")
  if vim.fn.executable(fallback .. "/mysql") == 1 then
    return fallback
  end
end

if vim.fn.executable("mysql") == 0 then
  local dir = find_mysql_wrapper_dir()
  if dir then
    vim.env.PATH = dir .. ":" .. vim.env.PATH
  end
end

-- 用扁平字典：vim.g 不能可靠保存嵌套 table，dadbod-ui 会当成空连接。
vim.g.db = "mysql://practice:practice@127.0.0.1:3306/practice"
vim.g.dbs = {
  practice = "mysql://practice:practice@127.0.0.1:3306/practice",
  ["practice-sql"] = "mysql://root:root@127.0.0.1:3306/practice_sql",
  ["practice-root"] = "mysql://root:root@127.0.0.1:3306/practice",
}

local sandbox = {
  ["schema.sql"] = true,
  ["06-business.sql"] = true,
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*/practice/phase2/w7/*.sql",
  callback = function(ev)
    local name = vim.fn.fnamemodify(ev.file, ":t")
    vim.b.db = sandbox[name] and vim.g.dbs["practice-sql"] or vim.g.dbs.practice
  end,
})

-- dadbod 默认 <leader>S 会盖掉 LazyVim 的「选草稿纸」。
-- 执行查询改到 <leader><CR>，走 :DB，普通 SQL 文件也能跑（不依赖 DBUI 缓冲）。
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.schedule(function()
      pcall(vim.keymap.del, "n", "<leader>S", { buffer = true })
      pcall(vim.keymap.del, "x", "<leader>S", { buffer = true })
      pcall(vim.keymap.del, "v", "<leader>S", { buffer = true })
      vim.keymap.set("n", "<leader><CR>", ":%DB<CR>", { buffer = true, silent = true, desc = "Run SQL file" })
      vim.keymap.set("x", "<leader><CR>", ":DB<CR>", { buffer = true, silent = true, desc = "Run SQL selection" })
    end)
  end,
})

return {
  "kristijanhusak/vim-dadbod-ui",
}
