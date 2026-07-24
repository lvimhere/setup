-- Java LSP + DAP via nvim-jdtls (eclipse.jdt.ls + java-debug + java-test).
-- Requires a JDK **21+** to run jdtls itself; project code may still target 8/11/17.

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  return
end

local function is_dir(path)
  return path and path ~= "" and vim.fn.isdirectory(path) == 1
end

local function java_major(java_home)
  local java = java_home .. "/bin/java"
  if vim.fn.executable(java) ~= 1 then
    return nil
  end
  local out = vim.fn.system({ java, "-version" })
  local major = out:match('version "(%d+)') or out:match("version (%d+)")
  return major and tonumber(major) or nil
end

--- JDK used to *run* eclipse.jdt.ls (must be 21+).
local function find_jdtls_java_home()
  local candidates = {
    vim.env.JDTLS_JAVA_HOME,
    "/usr/lib/jvm/java-21-openjdk",
    "/usr/lib/jvm/java-21-jdk",
    "/usr/lib/jvm/jdk-21-openjdk",
    vim.fn.expand("~/.local/jdks/temurin-21"),
    vim.fn.expand("~/.sdkman/candidates/java/21.0.2-tem"),
    vim.fn.expand("~/.sdkman/candidates/java/current"),
  }

  for _, home in ipairs(candidates) do
    if is_dir(home) then
      local major = java_major(home)
      if major and major >= 21 then
        return home
      end
    end
  end
  return nil
end

--- Project/runtime JDKs for jdtls `settings.java.configuration.runtimes`.
local function collect_runtimes()
  local runtimes = {}
  local known = {
    { name = "JavaSE-1.8", path = "/usr/lib/jvm/java-8-openjdk" },
    { name = "JavaSE-1.8", path = vim.fn.expand("~/.local/jdks/temurin-8") },
    { name = "JavaSE-11", path = "/usr/lib/jvm/java-11-openjdk" },
    { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk" },
    { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk" },
    { name = "JavaSE-21", path = vim.fn.expand("~/.local/jdks/temurin-21") },
  }

  local seen = {}
  for _, rt in ipairs(known) do
    if is_dir(rt.path) and not seen[rt.name] then
      table.insert(runtimes, { name = rt.name, path = rt.path })
      seen[rt.name] = true
    end
  end
  return runtimes
end

local function mason_pkg(name)
  return vim.fn.stdpath("data") .. "/mason/packages/" .. name
end

local function java_debug_bundles()
  local bundles = {}
  local debug_jars = vim.fn.glob(
    mason_pkg("java-debug-adapter") .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
    true,
    true
  )
  vim.list_extend(bundles, debug_jars)

  local test_jars = vim.fn.glob(mason_pkg("java-test") .. "/extension/server/*.jar", true, true)
  local excluded = {
    ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
    ["jacocoagent.jar"] = true,
  }
  for _, jar in ipairs(test_jars) do
    local fname = vim.fn.fnamemodify(jar, ":t")
    if not excluded[fname] then
      table.insert(bundles, jar)
    end
  end
  return bundles
end

local root_dir = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
if not root_dir then
  root_dir = vim.fn.getcwd()
end

local jdtls_java_home = find_jdtls_java_home()
if not jdtls_java_home then
  vim.notify(
    "jdtls needs JDK 21+ to run (project may still use 8/11/17).\n"
      .. "Install e.g. `sudo pacman -S jdk21-openjdk`, or put Temurin 21 at ~/.local/jdks/temurin-21,\n"
      .. "or set JDTLS_JAVA_HOME to a JDK 21+ home.",
    vim.log.levels.ERROR
  )
  return
end

local jdtls_bin = vim.fn.exepath("jdtls")
if jdtls_bin == "" then
  jdtls_bin = mason_pkg("jdtls") .. "/bin/jdtls"
end
if vim.fn.executable(jdtls_bin) ~= 1 then
  vim.notify(
    "jdtls not found. Install via Mason (`jdtls`) or ensure it is on PATH.",
    vim.log.levels.ERROR
  )
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

local bundles = java_debug_bundles()
if #bundles == 0 then
  vim.notify(
    "Java debug bundles missing. Install Mason packages: java-debug-adapter, java-test.",
    vim.log.levels.WARN
  )
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local config = {
  cmd = {
    "env",
    "JAVA_HOME=" .. jdtls_java_home,
    jdtls_bin,
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = collect_runtimes(),
      },
      maven = { downloadSources = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      format = { enabled = true },
    },
  },
  init_options = {
    bundles = bundles,
  },
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    local ok_dap = pcall(function()
      require("jdtls.dap").setup_dap_main_class_configs()
    end)
    if not ok_dap then
      vim.notify("jdtls.dap.setup_dap_main_class_configs failed (is java-debug-adapter installed?)", vim.log.levels.WARN)
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "<leader>jo", jdtls.organize_imports, "Java organize imports")
    map("n", "<leader>jv", jdtls.extract_variable, "Java extract variable")
    map("v", "<leader>jv", function()
      jdtls.extract_variable(true)
    end, "Java extract variable")
    map("n", "<leader>jc", jdtls.extract_constant, "Java extract constant")
    map("v", "<leader>jc", function()
      jdtls.extract_constant(true)
    end, "Java extract constant")
    map("v", "<leader>jm", function()
      jdtls.extract_method(true)
    end, "Java extract method")
    map("n", "<leader>djtc", jdtls.test_class, "Debug Java test class")
    map("n", "<leader>djtm", jdtls.test_nearest_method, "Debug Java nearest test")
  end,
}

jdtls.start_or_attach(config)
