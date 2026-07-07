# Neovim 配置文档

本文档说明当前 `~/.config/nvim` 中的 Neovim 0.12 编码配置，包括整体结构、核心行为、插件用途、维护状态与快捷键。

## 概览

- **目标版本：** Neovim 0.12
- **包管理方式：** 内置 `vim.pack`
- **Leader 键：** `<Space>`
- **定位：** 面向编码的全能型工作流，覆盖补全、AI 助手、LSP、格式化、Lint、搜索、HTTP 请求、文件浏览、Git、调试、测试与 Markdown 渲染

## 配置结构

```text
~/.config/nvim/
├── init.lua
└── lua/
    ├── config/
    │   ├── init.lua
    │   ├── options.lua
    │   ├── diagnostics.lua
    │   ├── autocmds.lua
    │   └── keymaps.lua
    └── plugins/
        ├── init.lua
        ├── vscode.lua
        ├── specs.lua
        ├── colorscheme.lua
        ├── treesitter.lua
        ├── snippets.lua
        ├── completion.lua
        ├── ai.lua
        ├── lsp.lua
        ├── formatting.lua
        ├── frontend.lua
        ├── markdown.lua
        ├── search.lua
        ├── kulala.lua
        ├── session.lua
        ├── explorers.lua
        ├── outline.lua
        ├── folding.lua
        ├── git.lua
        ├── trouble.lua
        ├── dap.lua
        ├── test.lua
        ├── ui.lua
        └── editing.lua
```

## 环境分流

- `init.lua` 会先加载通用配置 `require("config")`
- 当 `vim.g.vscode` 为真时，只加载 `lua/plugins/vscode.lua`
- 在终端中运行 Neovim 时，继续加载完整插件入口 `lua/plugins/init.lua`

当前分流策略如下：

| 运行环境 | 加载内容 | 说明 |
| --- | --- | --- |
| 终端 Neovim | `config` + `plugins` | 保留完整编码工作流，包括 LSP、补全、搜索、文件树、Git、调试、测试等 |
| VSCode Neovim | `config` + `plugins.vscode` | 仅保留轻量编辑增强，避免与 VSCode 的 LSP、补全、面板和 UI 行为冲突 |

`lua/plugins/vscode.lua` 当前只启用以下插件：

- `numToStr/Comment.nvim`
- `kylechui/nvim-surround`
- `nvim-mini/mini.ai`

这样拆分后，终端中的 Neovim 功能不会减少；只有 VSCode 嵌入场景会改走精简插件集。

## 核心编辑行为

### 基础显示与编辑

- 开启真彩色：`termguicolors = true`
- 开启行号与相对行号
- 支持鼠标操作
- 使用系统剪贴板：`unnamedplus`
- 开启当前行高亮：`cursorline = true`
- 垂直分屏默认向右打开，水平分屏默认向下打开
- 搜索使用 `ignorecase + smartcase`

### 缩进与空白字符

- `tabstop = 2`
- `shiftwidth = 2`
- `expandtab = true`
- 代码默认不自动换行：`wrap = false`
- 代码默认不限制文本宽度：`textwidth = 0`
- 开启空白字符显示：
  - Tab：`» `
  - 普通空格：`·`
  - 行尾空格：`·`
  - 不换行空格：`␣`
  - 行尾符：`↴`

### 文本类文件特殊处理

对 `markdown`、`text`、`gitcommit` 自动启用：

- `wrap = true`
- `linebreak = true`
- `textwidth = 80`

### 诊断显示

- 诊断标记使用 Nerd Font 图标
- 开启虚拟文本
- 浮窗统一去边框

## 插件清单

### 外观与语法高亮

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `catppuccin/nvim` | 主题 | 当前使用 `catppuccin-mocha` |
| `nvim-treesitter/nvim-treesitter` | 语法树解析与高亮 | 采用兼容 Neovim 0.12 的新写法 |

**Treesitter 命令**

- `:TSInstallRecommended`：安装这套配置推荐的解析器

**当前行为**

- 启动后会在后台自动安装缺失的推荐解析器
- 打开某文件类型时，若对应推荐解析器尚未安装，会按需补装后再启用高亮

**已配置的 Treesitter 语言**

`bash`、`c`、`cpp`、`css`、`go`、`html`、`javascript`、`json`、`lua`、`markdown`、`markdown_inline`、`python`、`rust`、`tsx`、`typescript`、`vim`、`vimdoc`、`yaml`

### 补全与代码片段

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `saghen/blink.cmp` | 补全引擎 | 提供 LSP、路径、Snippet、Buffer 补全 |
| `L3MON4D3/LuaSnip` | Snippet 引擎 | 作为 blink.cmp 的 snippet 后端 |
| `rafamadriz/friendly-snippets` | 常用 Snippet 集合 | 通过 LuaSnip 加载 |

**补全特性**

- 接受补全时自动补全括号
- 开启 ghost text
- 自动显示补全文档
- 开启函数签名提示
- 补全菜单、文档浮窗、签名浮窗均已去边框

**插入模式补全快捷键**

| 按键 | 作用 |
| --- | --- |
| `<C-n>` | 选择下一项 |
| `<C-p>` | 选择上一项 |
| `<C-y>` | 接受当前补全项 |
| `<C-e>` | 取消补全 |
| `<Tab>` | Snippet 前跳，否则选下一项 |
| `<S-Tab>` | Snippet 后跳，否则选上一项 |
| `<CR>` | 接受当前补全项 |
| `<Esc>` | 取消补全并关闭文档窗口 |
| `<C-Space>` | 打开补全 / 文档 |
| `<C-b>` | 向上滚动补全文档 |
| `<C-f>` | 向下滚动补全文档 |
| `<C-k>` | 切换函数签名窗口 |

### AI 编码助手

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `zbirenbaum/copilot.lua` | GitHub Copilot 补全与认证 | 提供 Copilot 建议、面板和认证入口 |
| `olimorris/codecompanion.nvim` | AI 对话、Inline 改写与 Prompt Library | 默认通过 Copilot adapter 工作，集成中文工作流和前端专用 prompts |

**当前行为**

- Copilot 建议默认**手动触发**，避免和 `blink.cmp` 的 ghost text 相互干扰
- Copilot 面板默认开启并支持自动刷新
- `CodeCompanion` 的 `chat`、`inline`、`cmd` 交互默认都走 Copilot adapter
- `CodeCompanion` 聊天缓冲区使用 `blink` 作为补全来源，并开启上下文管理
- 已加入一组中文常用 prompts：解释、修复、重构、补测试、总结文件
- 已加入一组前端专用 prompts：解释组件、修复前端选区、重构前端选区、生成前端测试
- `:Copilot auth` 用于首次登录 GitHub Copilot
- 命令行中输入 `:cc` 会自动展开为 `:CodeCompanion`

**Copilot 建议快捷键**

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 插入模式 | `<M-l>` | 接受当前 Copilot 建议 |
| 插入模式 | `<M-]>` | 查看下一条 Copilot 建议 |
| 插入模式 | `<M-[>` | 查看上一条 Copilot 建议 |
| 插入模式 | `<M-;>` | 关闭当前 Copilot 建议 |

### LSP 与外部工具

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `neovim/nvim-lspconfig` | LSP 配置入口 | 负责各语言服务器配置 |
| `mason-org/mason.nvim` | 外部工具安装器 | 管理 LSP、格式化、调试等工具 |
| `mason-org/mason-lspconfig.nvim` | Mason 与 LSP 桥接 | 确保已配置的 LSP 自动安装 |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | 自动安装工具 | 确保格式化、Lint、调试相关工具存在 |

**已启用的 LSP**

- `bashls`
- `clangd`
- `cssls`
- `gopls`
- `html`
- `jsonls`
- `lua_ls`
- `marksman`
- `pyright`
- `rust_analyzer`
- `ts_ls`
- `vue_ls`
- `yamlls`

**当前行为**

- LSP 不会在启动时一次性全部启用，而是按当前 buffer 的 `filetype` 懒加载对应语言服务器
- 首次打开某语言文件时，才会启用匹配的 LSP

**Vue 支持说明**

- `.vue` 文件使用 `vue_ls`
- TypeScript 相关能力由 `ts_ls` 提供
- 已注入 `@vue/typescript-plugin`，保证 Vue + TypeScript 场景正常工作

**Mason 确保安装的工具**

- `black`
- `debugpy`
- `delve`
- `eslint_d`
- `gofumpt`
- `goimports`
- `isort`
- `prettierd`
- `ruff`
- `shellcheck`
- `shfmt`
- `stylua`
- `vue-language-server`

### 格式化与 Lint

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `stevearc/conform.nvim` | 格式化 | 默认关闭全局自动格式化，只有检测到项目格式化配置文件时才会在保存时自动格式化 |
| `mfussenegger/nvim-lint` | Lint | 在进入缓冲区、保存后、离开插入模式时触发 |

**已配置的格式化器**

| 文件类型 | 工具 |
| --- | --- |
| `c`、`cpp` | `clang_format` |
| `css`、`html`、`javascript`、`javascriptreact`、`json`、`jsonc`、`markdown`、`typescript`、`typescriptreact`、`vue`、`yaml` | `prettierd`，失败回退到 `prettier` |
| `go` | `gofumpt`、`goimports` |
| `lua` | `stylua` |
| `python` | `isort`、`black` |
| `rust` | `rustfmt` |
| `sh` | `shfmt` |

**已配置的 Lint 工具**

| 文件类型 | 工具 |
| --- | --- |
| `javascript`、`javascriptreact`、`typescript`、`typescriptreact`、`vue` | `eslint_d` |
| `python` | `ruff` |
| `sh` | `shellcheck` |

**自动格式化触发规则**

- 默认不对所有项目强制开启保存即格式化
- 只有检测到对应语言的项目格式化配置文件时，保存才会自动格式化
- 手动格式化快捷键 `<leader>cf` 仍然保留

**当前会检测的配置文件**

| 文件类型 | 自动格式化检测条件 |
| --- | --- |
| `javascript` / `typescript` / `vue` / `css` / `html` / `json` / `jsonc` / `markdown` / `yaml` | `.prettierrc*`、`prettier.config.*`、`.editorconfig`、或带 `prettier` 字段的 `package.json` |
| `lua` | `stylua.toml` 或 `.stylua.toml` |
| `python` | 含 `tool.black` / `tool.isort` 的 `pyproject.toml`，或包含 `isort` 配置的 `setup.cfg` / `tox.ini`，或 `.isort.cfg` |
| `c` / `cpp` | `.clang-format` 或 `_clang-format` |
| `rust` | `rustfmt.toml` 或 `.rustfmt.toml` |
| `sh` | `.editorconfig` |

未检测到这些配置文件时，不会自动格式化；这样可以明显减少与项目规范不一致导致的大量 Git diff。

### 前端辅助

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `brenoprata10/nvim-highlight-colors` | 行内显示颜色值 | 支持 hex、rgb、hsl、CSS 变量、命名颜色、Tailwind |

### Markdown 渲染

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `MeanderingProgrammer/render-markdown.nvim` | 在 Neovim 内渲染 Markdown | 可在原始视图与渲染视图之间切换，也可侧边预览 |

**当前行为**

- 对 `markdown` 与 `codecompanion` buffer 启用
- 在普通模式、命令行模式、终端模式显示渲染效果
- 与 `blink.cmp` 联动，支持 Markdown 中的补全能力

### HTTP / API 客户端

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `mistweaverco/kulala.nvim` | HTTP / GraphQL / gRPC / WebSocket 客户端 | 兼容 JetBrains `.http` 规范，支持环境变量、脚本与断言 |

**系统依赖**

- `curl`：下载并运行 `kulala-core` 后端
- `git`：拉取 Kulala 专用 Treesitter grammar 与 queries
- `tree-sitter` CLI：从内置 grammar 生成 `kulala_http` 解析器

**当前行为**

- 识别 `.http` 与 `.rest` 文件
- 响应窗口默认在右侧 split 打开，边框风格与现有配置一致
- 启用 Kulala 内置 LSP，为 HTTP 脚本提供补全
- 启用全局快捷键，前缀为 `<leader>R`
- 在 `auto-session` 之前加载，以便正确注册会话恢复相关 hook
- 自动追加 `sessionoptions+=globals`，用于恢复 Kulala 请求历史与 UI 状态

**常用全局快捷键**

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通 / 可视模式 | `<leader>Rs` | 发送当前请求 |
| 普通 / 可视模式 | `<leader>Ra` | 发送文件中全部请求 |
| 普通模式 | `<leader>Rb` | 打开 Scratchpad |
| 普通模式 | `<leader>Rr` | 重放上次请求 |

在 `.http` / `.rest` 文件中，Kulala 还会提供额外的 filetype 快捷键；按 `<leader>` 可查看完整列表。

### 搜索与跳转

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `nvim-telescope/telescope.nvim` | 模糊搜索与选择器 | 主搜索入口 |
| `nvim-lua/plenary.nvim` | Telescope 依赖 | 通用 Lua 工具库 |

### 会话、结构与折叠

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `rmagatti/auto-session` | 会话管理 | 自动保存/恢复项目现场，并提供会话选择器 |
| `stevearc/aerial.nvim` | 代码结构大纲 | 查看并跳转当前文件中的符号结构 |
| `kevinhwang91/nvim-ufo` | 折叠增强 | 用 LSP/indent 提供更稳定的折叠体验 |
| `kevinhwang91/promise-async` | `nvim-ufo` 依赖 | 异步依赖 |

**当前行为**

- 进入项目目录时自动尝试恢复该项目会话
- 退出 Neovim 时自动保存当前项目会话
- 通过 `vim.ui.select` 提供会话选择器
- 使用新版 `:AutoSession ...` 子命令，已禁用废弃的 `Session*` 兼容命令
- Aerial 默认在右侧打开，也支持浮窗导航
- 折叠优先使用 LSP folding range，回退到缩进折叠
- `zR` / `zM` 打开或关闭所有折叠，`zp` 预览光标下折叠内容

### 文件浏览

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `stevearc/oil.nvim` | 轻量目录浏览器 | 像编辑 buffer 一样操作目录 |
| `nvim-neo-tree/neo-tree.nvim` | 完整文件树 | 左侧边栏文件树 |
| `MunifTanjim/nui.nvim` | Neo-tree 依赖 | UI 依赖 |
| `nvim-tree/nvim-web-devicons` | 文件图标 | 提供文件、目录、状态图标 |

**Oil 特点**

- 作为默认文件浏览器
- 回归官方思路的轻量目录浏览模式，不再使用自定义级联浮窗
- 浮窗无边框，`<leader>of` 可单独打开 Oil 浮窗
- `-` 在普通模式下打开当前文件所在目录的 Oil 视图
- Oil 内保留默认导航逻辑，按 `-` 返回父目录，按 `<CR>` 打开条目
- 默认显示隐藏文件，但始终隐藏 `..` 和 `.git`
- `q` 关闭 Oil，`<C-r>` 刷新，`<C-p>` 预览，`g.` 切换隐藏文件显示

**Neo-tree 特点**

- 默认在左侧打开
- 宽度为 `36`
- 自动跟随当前文件
- 在 Neo-tree 内按 `H` 可切换隐藏文件显示
- 层级线做了简化，美化了图标与 Git 状态符号
- Neo-tree 自己的“最后窗口自动退出”已关闭，改由统一辅助窗口退出逻辑处理
- UndoTree 自己的“最后窗口自动退出”也已关闭，改由统一辅助窗口退出逻辑处理
- 当任意窗口真正关闭后，如果当前 tab 里只剩 Neo-tree / Aerial / UndoTree 这类辅助窗口，则直接退出 Neovim
- 对 UndoTree，会同时把它的主窗口和下方的 diff 细节窗口一起视为辅助窗口

**Neo-tree 主流打开模式**

- **filesystem + left**：最常见的常驻侧边栏文件树
- **filesystem + float**：临时浮窗浏览文件
- **buffers source**：按 buffer 列表浏览已打开文件
- **git_status source**：查看当前仓库改动文件
- **reveal current file**：在树中自动定位当前文件

这几种里，最主流的通常是：

1. 左侧 `filesystem`
2. 浮窗 `filesystem`
3. `buffers`
4. `git_status`

### Git 与问题面板

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `lewis6991/gitsigns.nvim` | Git hunk 标记与操作 | 同时开启当前行 blame |
| `NeogitOrg/neogit` | Git 仓库级工作流面板 | 处理状态、提交、分支、stash、rebase、push/pull 等 |
| `sindrets/diffview.nvim` | Git diff / 历史可视化 | 查看工作区 diff、文件历史、仓库历史、merge diff |
| `akinsho/git-conflict.nvim` | 冲突解决辅助 | 在冲突文件中提供快捷处理与跳转 |
| `folke/trouble.nvim` | 诊断 / 符号 / 列表面板 | 用于集中查看问题、引用、quickfix 等 |

**Git 工作流分工**

- `gitsigns.nvim`：文件内 hunk 级别操作
- `neogit`：仓库级 Git 操作
- `diffview.nvim`：差异查看、提交历史、文件历史
- `git-conflict.nvim`：merge / rebase 时解决冲突

**Git 工作流能力**

- 分支管理
- 提交、暂存、stash
- pull / push
- rebase
- 历史与 diff 查看
- merge / rebase 冲突处理

### 调试

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `mfussenegger/nvim-dap` | DAP 调试核心 | 提供调试能力 |
| `rcarriga/nvim-dap-ui` | 调试 UI | 调试开始时自动打开，结束时自动关闭 |
| `theHamsta/nvim-dap-virtual-text` | 行内调试变量显示 | 调试时直接在代码旁显示变量值 |

### 测试

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `nvim-neotest/neotest` | 测试框架主入口 | 统一测试运行界面 |
| `nvim-neotest/neotest-python` | Python 测试适配器 | 支持 DAP 调试 |
| `akinsho/neotest-go` | Go 测试适配器 | 已启用 |
| `marilari88/neotest-vitest` | Vitest 适配器 | 已启用 |
| `nvim-neotest/neotest-plenary` | Plenary 适配器 | 可用时自动启用 |
| `nvim-neotest/nvim-nio` | Neotest 依赖 | 异步依赖 |
| `antoinemadec/FixCursorHold.nvim` | Neotest 兼容依赖 | 修复 CursorHold 行为 |

### UI 与编辑增强

| 插件 | 作用 | 说明 |
| --- | --- | --- |
| `nvim-lualine/lualine.nvim` | 状态栏 | 使用简洁分隔符，启用全局状态栏 |
| `folke/which-key.nvim` | 快捷键提示 | 用于提示 Leader 键分组 |
| `windwp/nvim-autopairs` | 自动补全括号与引号 | 默认启用 |
| `numToStr/Comment.nvim` | 注释操作 | 提供 `gcc`、`gbc`、文本对象注释等 |
| `kylechui/nvim-surround` | 环绕编辑 | 提供增删改包裹符、标签、函数调用等 |
| `nvim-mini/mini.ai` | 文本对象增强 | 增强 `a` / `i` 文本对象选择能力 |
| `mbbill/undotree` | Undo 树可视化 | 浏览分支式撤销历史 |
| `folke/todo-comments.nvim` | 高亮 TODO 类注释 | 默认启用 |

## 快捷键

## 全局快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<Esc>` | 清除搜索高亮 |
| 普通模式 | `<leader>?` | 打开 which-key 快捷键提示 |
| 普通模式 | `]b` | 切换到下一个 buffer |
| 普通模式 | `[b` | 切换到上一个 buffer |
| 普通模式 | `<leader>bb` | 切换到上一个使用过的 buffer |
| 普通模式 | `]t` | 切换到下一个 tabpage |
| 普通模式 | `[t` | 切换到上一个 tabpage |
| 普通模式 | `-` | 打开 Oil |
| 普通模式 | `<leader>of` | 切换 Oil 浮窗 |
| 普通模式 | `<leader>e` | 切换 Neo-tree |
| 普通模式 | `<leader>E` | 在 Neo-tree 中定位当前文件 |
| 普通模式 | `<leader>ef` | 以浮窗模式打开 Neo-tree 文件树 |
| 普通模式 | `<leader>eb` | 打开 Neo-tree buffers 视图 |
| 普通模式 | `<leader>eg` | 打开 Neo-tree git_status 视图 |

## 搜索快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<leader>sp` | 打开 Telescope 内置选择器列表 |
| 普通模式 | `<leader>sb` | 搜索缓冲区 |
| 普通模式 | `<leader>sf` | 搜索文件 |
| 普通模式 | `<leader>sw` | 搜索当前光标下单词 |
| 普通模式 | `<leader>sg` | 全局文本搜索 |
| 普通模式 | `<leader>sr` | 恢复上一次搜索 |
| 普通模式 | `<leader>sh` | 搜索帮助文档 |
| 普通模式 | `<leader>sm` | 搜索 man 手册 |

## Oil 快捷键

这些快捷键在 Oil buffer / 浮窗内部生效。

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<CR>` | 打开当前条目 |
| 普通模式 | `-` | 返回父目录 |
| 普通模式 | `q` | 关闭 Oil |
| 普通模式 | `<C-p>` | 预览当前条目 |
| 普通模式 | `<C-r>` | 刷新目录 |
| 普通模式 | `g.` | 切换隐藏文件显示 |

## LSP / 代码快捷键

这些快捷键在 LSP 附加到当前缓冲区后生效。

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `gd` | 跳转到定义 |
| 普通模式 | `gD` | 跳转到声明 |
| 普通模式 | `gI` | 跳转到实现 |
| 普通模式 | `gy` | 跳转到类型定义 |
| 普通模式 | `K` | 查看悬停文档 |
| 普通模式 | `gr` | 通过 Trouble 查看引用 |
| 普通模式 | `<leader>ca` | 代码操作 |
| 普通模式 | `<leader>cr` | 重命名符号 |
| 普通模式 | `<leader>cf` | 格式化当前缓冲区 |
| 普通模式 | `<leader>cd` | 查看当前行诊断信息 |
| 普通模式 | `[d` | 跳到上一条诊断 |
| 普通模式 | `]d` | 跳到下一条诊断 |

## Git 快捷键

### Gitsigns（hunk 级）

这些快捷键在 Gitsigns 附加后生效。

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `]h` | 下一个 Git hunk |
| 普通模式 | `[h` | 上一个 Git hunk |
| 普通模式 | `<leader>hs` | 暂存当前 hunk |
| 可视模式 | `<leader>hs` | 暂存选中 hunk |
| 普通模式 | `<leader>hr` | 重置当前 hunk |
| 可视模式 | `<leader>hr` | 重置选中 hunk |
| 普通模式 | `<leader>hS` | 暂存整个 buffer |
| 普通模式 | `<leader>hR` | 重置整个 buffer |
| 普通模式 | `<leader>hp` | 预览当前 hunk |
| 普通模式 | `<leader>hb` | 查看当前行 blame |
| 普通模式 | `<leader>hd` | 对当前文件执行 diff |

### Git 工作流（Neogit / Diffview）

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<leader>gg` | 打开 Neogit 状态面板 |
| 普通模式 | `<leader>gc` | 打开提交弹窗 |
| 普通模式 | `<leader>gb` | 打开分支弹窗 |
| 普通模式 | `<leader>gs` | 打开 stash 弹窗 |
| 普通模式 | `<leader>gp` | 打开 pull 弹窗 |
| 普通模式 | `<leader>gP` | 打开 push 弹窗 |
| 普通模式 | `<leader>gr` | 打开 rebase 弹窗 |
| 普通模式 | `<leader>go` | 打开 Diffview |
| 普通模式 | `<leader>gq` | 关闭 Diffview |
| 普通模式 | `<leader>gh` | 查看当前文件历史 |
| 普通模式 | `<leader>gH` | 查看仓库历史 |

### 冲突处理（git-conflict）

当文件中存在 Git 冲突时，插件会提供这些快捷键：

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `co` | 选择 ours |
| 普通模式 | `ct` | 选择 theirs |
| 普通模式 | `cb` | 同时保留双方 |
| 普通模式 | `c0` | 全部删除该冲突块 |
| 普通模式 | `[x` | 跳到上一个冲突 |
| 普通模式 | `]x` | 跳到下一个冲突 |

## Trouble 快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<leader>xx` | 切换工作区诊断列表 |
| 普通模式 | `<leader>xX` | 切换当前 buffer 诊断列表 |
| 普通模式 | `<leader>xs` | 切换符号面板 |
| 普通模式 | `<leader>xq` | 切换 quickfix 列表 |
| 普通模式 | `<leader>xl` | 切换 location list |

## 会话 / 大纲 / 折叠 / 编辑增强快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<leader>ws` | 手动保存当前项目会话 |
| 普通模式 | `<leader>wl` | 打开会话选择器 |
| 普通模式 | `<leader>wr` | 恢复当前项目会话 |
| 普通模式 | `<leader>wd` | 删除当前项目会话 |
| 普通模式 | `<leader>aa` | 在右侧切换 Aerial 大纲 |
| 普通模式 | `<leader>af` | 以浮窗方式切换 Aerial |
| 普通模式 | `<leader>an` | 切换 Aerial 导航窗口 |
| 普通模式 | `zR` | 打开所有折叠 |
| 普通模式 | `zM` | 关闭所有折叠 |
| 普通模式 | `zp` | 预览当前折叠内容 |
| 普通模式 | `<leader>uu` | 切换 UndoTree |

**编辑增强说明**

- `Comment.nvim` 默认启用主流注释键位：`gcc`、`gbc`、`gc` / `gb` + motion
- `nvim-surround` 默认启用主流环绕编辑键位：`ys`、`ds`、`cs`
- `mini.ai` 会增强原生 `a` / `i` 文本对象体验

**AutoSession 当前命令**

- `:AutoSession save`
- `:AutoSession search`
- `:AutoSession restore`
- `:AutoSession delete`

不再使用已废弃的：

- `:SessionSave`
- `:SessionSearch`
- `:SessionRestore`
- `:SessionDelete`

## 调试快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<F5>` | 开始 / 继续调试 |
| 普通模式 | `<F10>` | 单步跳过 |
| 普通模式 | `<F11>` | 单步进入 |
| 普通模式 | `<F12>` | 单步跳出 |
| 普通模式 | `<leader>db` | 切换断点 |
| 普通模式 | `<leader>dB` | 设置条件断点 |
| 普通模式 | `<leader>dc` | 开始 / 继续调试 |
| 普通模式 | `<leader>dr` | 切换调试 REPL |
| 普通模式 | `<leader>du` | 切换调试 UI |

## 测试快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<leader>tt` | 运行离光标最近的测试 |
| 普通模式 | `<leader>tf` | 运行当前测试文件 |
| 普通模式 | `<leader>td` | 以调试模式运行最近测试 |
| 普通模式 | `<leader>ts` | 切换测试摘要面板 |
| 普通模式 | `<leader>to` | 打开测试输出 |
| 普通模式 | `<leader>tO` | 切换测试输出面板 |
| 普通模式 | `<leader>tS` | 停止测试运行 |

## Markdown 快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通模式 | `<leader>mt` | 切换当前 Markdown buffer 的渲染状态 |
| 普通模式 | `<leader>mp` | 在侧边打开 Markdown 渲染预览 |

也可以直接使用命令：

- `:RenderMarkdown toggle`
- `:RenderMarkdown buf_toggle`
- `:RenderMarkdown preview`

## AI 快捷键

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通 / 可视模式 | `<leader>ia` | 打开 CodeCompanion Action Palette |
| 普通模式 | `<leader>ic` | 切换 CodeCompanion 聊天窗口 |
| 普通 / 可视模式 | `<leader>ii` | 打开 CodeCompanion Inline Prompt |
| 可视模式 | `<leader>is` | 将选中内容加入当前 Chat |
| 普通模式 | `<leader>ip` | 打开 Copilot Panel |
| 普通 / 可视模式 | `<leader>ie` | 中文解释代码 |
| 可视模式 | `<leader>ifx` | 中文修复选中代码 |
| 可视模式 | `<leader>ir` | 中文重构选中代码 |
| 普通 / 可视模式 | `<leader>it` | 中文生成测试思路与样例 |
| 普通模式 | `<leader>im` | 中文总结当前文件 |
| 普通 / 可视模式 | `<leader>ife` | 前端解释组件 / Hook / 状态流 |
| 可视模式 | `<leader>iff` | 修复前端选中代码 |
| 可视模式 | `<leader>ifr` | 重构前端选中代码 |
| 普通 / 可视模式 | `<leader>ift` | 生成前端测试方案与样例 |

**提示**

- 前端专用 prompts 只会在 `javascript`、`typescript`、`javascriptreact`、`typescriptreact`、`vue`、`css`、`scss`、`less`、`html` 等前端文件类型里出现
- 常用 prompts 也可以通过 `:CodeCompanion /explain_cn`、`/fix_cn`、`/refactor_cn`、`/tests_cn`、`/summary_cn` 等 alias 调用

## HTTP / API 快捷键

这些快捷键由 Kulala 注册，可在任意 buffer 中使用；部分操作在 `.http` / `.rest` 文件中体验最佳。

| 模式 | 按键 | 作用 |
| --- | --- | --- |
| 普通 / 可视模式 | `<leader>Rs` | 发送当前请求 |
| 普通 / 可视模式 | `<leader>Ra` | 发送文件中全部请求 |
| 普通模式 | `<leader>Rb` | 打开 Scratchpad |
| 普通模式 | `<leader>Rr` | 重放上次请求 |

## which-key 分组

为了让 Leader 键更容易记忆，which-key 已注册以下分组：

| 前缀 | 分组 |
| --- | --- |
| `<leader>c` | Code |
| `<leader>d` | Debug |
| `<leader>g` | Git |
| `<leader>i` | AI |
| `<leader>if` | AI Frontend |
| `<leader>b` | Buffer |
| `<leader>h` | Git hunks |
| `<leader>m` | Markdown |
| `<leader>o` | Oil |
| `<leader>R` | HTTP Request |
| `<leader>s` | Search |
| `<leader>t` | Test |
| `<leader>u` | Undo |
| `<leader>w` | Workspace |
| `<leader>x` | Trouble |

## 新增插件维护状态

以下是这次新增或重点补强插件的维护情况（基于公开仓库最近提交）：

| 插件 | 用途 | 维护状态 |
| --- | --- | --- |
| `rmagatti/auto-session` | 会话管理 | **在维护**，最近提交时间为 2026-02 |
| `stevearc/aerial.nvim` | 代码大纲 | **在维护**，最近提交时间为 2026-02 |
| `kevinhwang91/nvim-ufo` | 折叠增强 | **在维护**，最近提交时间为 2026-01 |
| `mbbill/undotree` | Undo 树 | **在维护**，最近提交时间为 2026-03 |
| `kylechui/nvim-surround` | 环绕编辑 | **在维护**，最近提交时间为 2026-04 |
| `nvim-mini/mini.ai` | 文本对象增强 | **在维护**，最近提交时间为 2026-04 |
| `olimorris/codecompanion.nvim` | AI 对话与工作流 | **在维护**，最近提交时间为 2026-04 |
| `zbirenbaum/copilot.lua` | Copilot 接入 | **在维护**，最近提交时间为 2026-04 |
| `mistweaverco/kulala.nvim` | HTTP / API 客户端 | **在维护**，最近提交时间为 2026-04 |
| `numToStr/Comment.nvim` | 注释操作 | **稳定可用**，最近提交时间为 2024-06，更新频率低于上面几项，但插件成熟、使用广泛 |

## 说明

- 大多数弹窗都已统一去边框，界面更干净。
- 补全窗口、悬停文档、诊断浮窗、Oil 浮窗等都使用无边框样式。
- 同时保留 Oil 与 Neo-tree：
  - **Oil** 适合轻量查看和直接编辑目录
  - **Neo-tree** 适合持续驻留的文件树浏览
- Markdown 现在支持：
  - **原始文本视图**
  - **渲染后的阅读视图**
  - **侧边预览视图**
- AI 工作流现在默认接入 Copilot，并补充了中文 prompts 与前端专用 prompts。
- Kulala 已接入，可在 Neovim 内直接编写并发送 `.http` / `.rest` 请求。
