# Textobjects 快捷键说明

配置风格对齐 **LazyVim**：

- **[mini.ai](https://github.com/nvim-mini/mini.ai)**：负责所有 `a` / `i` **选中**（含 Treesitter 函数/类/块）
- **[nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)**：只负责 **跳转**（move）
- **Neovim 0.12 `vim.treesitter.select()`** + Flash `S`：渐进 / 节点选区

相关文件：`lua/plugins/editing.lua`、`lua/plugins/textobjects.lua`。

前缀约定：

| 前缀 | 含义 |
|------|------|
| `a` + 对象 | around：含边界 |
| `i` + 对象 | inside：不含边界（或按规则处理空白） |
| 操作符 | 可接 `d` / `c` / `y` / `v` 等，如 `daf`、`cif`、`vaf` |

部分语言若缺少 textobjects query，对应 AST 对象可能无效。

---

## 1. Select（mini.ai）

### 1.1 前缀与方向

| 按键 | 操作 |
|------|------|
| `a` / `i` | around / inside |
| `an` / `in` | 下一个匹配对象 |
| `al` / `il` | 上一个匹配对象 |
| `g[` / `g]` | 跳到当前 `a` 对象左 / 右边界 |

Visual 下可连续按同一对象扩大选区。

### 1.2 LazyVim 风格对象（含覆盖默认）

| 键 | 操作 |
|----|------|
| `f` | **函数定义**（Treesitter `@function`，覆盖 mini 默认的「调用」） |
| `c` | **类**（Treesitter `@class`） |
| `o` | **块 / 条件 / 循环**（`@block` / `@conditional` / `@loop`） |
| `u` | **函数调用**（原默认 `f` 的语义） |
| `U` | 函数调用（函数名不含点） |
| `a` | 参数 |
| `g` | 整个 buffer（`ig` 去掉首尾空行） |
| `d` | 连续数字 |
| `e` | CamelCase / 词片段 |
| `t` | HTML/XML 标签 |
| `b` | 括号别名 `)` / `]` / `}` |
| `q` | 引号别名 `"` / `'` / `` ` `` |
| `(` `)` `[` `]` `{` `}` `<` `>` | 对应括号对 |
| `"` `'` `` ` `` | 对应引号 |
| `?` | 交互输入定界符 |

示例：

- `vaf` / `daf`：选中 / 删除**整个函数定义**
- `vac` / `dac`：整个类
- `vao`：if / for / 代码块
- `vau` / `dau`：函数**调用**
- `cia`：改写当前参数
- `vig`：选中（几乎）整个文件

---

## 2. Move（treesitter-textobjects）

| 按键 | 操作 |
|------|------|
| `]f` / `[f` | 下一个 / 上一个**函数**开头 |
| `]F` / `[F` | 下一个 / 上一个**函数**结尾 |
| `]c` / `[c` | 下一个 / 上一个**类**开头 |
| `]C` / `[C` | 下一个 / 上一个**类**结尾 |
| `]a` / `[a` | 下一个 / 上一个**参数**开头 |
| `]A` / `[A` | 下一个 / 上一个**参数**结尾 |

diff 模式下 `]c` / `[c` 仍走 Vim 原生 hunk 跳转（与 LazyVim 一致）。  
日常 git hunk 仍用 gitsigns 的 `]h` / `[h`。

---

## 3. 渐进式选区

| 按键 | 模式 | 操作 |
|------|------|------|
| `<M-o>`（Alt+o） | Normal / Visual / Operator | 扩大到父节点 |
| `<M-i>`（Alt+i） | Visual / Operator | 缩小到子节点 |
| `]n` / `[n` | Visual（Neovim 默认） | 同级下一 / 上一节点 |
| `S` | Flash Treesitter | 节点标签选区 |

未绑定 `<C-Space>`（留给 IME）。

用法：光标放在代码上 → 反复 `<M-o>` 逐级扩大 → `<M-i>` 缩回；或用 `S` 点选节点。

---

## 4. 分工速查

| 需求 | 按键 |
|------|------|
| 整函数定义 | `vaf` / `daf` / `cif` |
| 整类 | `vac` / `dac` |
| if / for / 块 | `vao` / `vio` |
| 函数调用 | `vau` / `dau` |
| 参数 | `cia` / `daa`；跳转 `]a` |
| 括号 / 引号 | `vib` / `viq` |
| 跳到下一函数 / 类 | `]f` / `]c` |
| 逐级扩大选区 | `<M-o>` / `<M-i>` 或 Flash `S` |

---

## 5. 相对旧配置的变化

| 旧（本仓库先前方案） | 现（LazyVim） |
|----------------------|---------------|
| `am`/`im` 选方法 | `af`/`if` |
| `aC`/`iC` 选类 | `ac`/`ic` |
| `af`/`if` = 调用 | `au`/`iu`（及 `aU`） |
| `]m`/`[m` 跳方法 | `]f`/`[f` |
| `]k`/`[k` 跳类 | `]c`/`[c` |
| `<leader>cp` 等 swap | 已移除（LazyVim 默认无 swap） |
| 条件/注释/return 等独立 select | 合并进 `ao`/`io`（块/条件/循环） |
