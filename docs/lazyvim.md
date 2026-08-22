# Neovim 配置文档（LazyVim）

> 当前使用的配置：`~/setup/.config/nvim` → `~/.config/nvim`。  
> 旧版 `vim.pack` 配置见 [neovim-config.md](./neovim-config.md)（`~/setup/.config/nvim-vimpack`）。

本仓库在 [LazyVim](https://www.lazyvim.org/) 上只做少量覆盖：配色、缩进显示、SQL（dadbod）、splitjoin，以及与 **Zellij** 共存的 `Alt-*` 改键。

## 配置结构

```text
~/setup/.config/nvim/
├── init.lua
├── lazyvim.json          # LazyExtras
└── lua/
    ├── config/
    │   ├── lazy.lua
    │   ├── options.lua
    │   ├── keymaps.lua   # Alt-Shift-j/k 移动行
    │   └── autocmds.lua
    └── plugins/
        ├── snacks.lua    # picker / LSP words 的 Alt-Shift 改键
        ├── indent.lua
        ├── colorscheme.lua
        ├── splitjoin.lua
        └── dadbod.lua
```

## 与 Zellij 的按键分工

Zellij 默认 **Locked**（`docs/zellij.md`）：`Ctrl-*` 交给 Neovim，日常窗格操作用 Locked 白名单里的 `Alt-*`。

白名单（Neovim **收不到** 这些组合）：

| Zellij | 作用 |
| --- | --- |
| `Alt-h/j/k/l` | 切窗格（贴边 `h/l` 切 tab） |
| `Alt-n` | 新窗格 |
| `Alt-f` | 开关浮动窗 |
| `Alt-=` / `Alt-+` / `Alt--` | 缩放窗格 |

原则：**这些键让给 Zellij**；Neovim 侧同类功能改到 **`Alt-Shift` 同字母**，与移动行的改法一致。不要在 Locked 里拆掉 `Alt-h` 只留方向键——`hjkl` 要保持对称。

### 为什么要改

`<leader>ff`（Find Files）打开的是 Snacks picker。默认：

- `Alt-h`：`toggle_hidden`（搜索隐藏文件）
- `Alt-f`：`toggle_follow`

Zellij 先吃掉 `Alt-h` / `Alt-f`，按下去是切左 pane / 开关浮窗，picker 里看不到 hidden/follow 切换。

LazyVim LSP 默认还有：

- `Alt-n`：Snacks words 跳到下一处引用

同样被 Zellij「新窗格」抢走。

`Alt-l`、`Alt-=` / `Alt-+` / `Alt--` 在当前 LazyVim / Snacks 默认里没有对等映射，不必改。`Alt-i`（picker 里 toggle ignored / gitignore）Zellij 未占用，保持默认。

### 本仓库改键

| 原键（会被 Zellij 吃掉） | 改后 | 作用 | 配置位置 |
| --- | --- | --- | --- |
| `Alt-j` / `Alt-k` | `Alt-Shift-j` / `Alt-Shift-k` | 上下移动行 | `lua/config/keymaps.lua` |
| `Alt-h` | `Alt-Shift-h` | picker：切换隐藏文件 | `lua/plugins/snacks.lua` |
| `Alt-f` | `Alt-Shift-f` | picker：toggle follow | `lua/plugins/snacks.lua` |
| `Alt-n` | `Alt-Shift-n` | LSP：下一处引用（Snacks words） | `lua/plugins/snacks.lua` |

`Alt-p`（words 上一处引用）Zellij 未占用，仍用默认。`]]` / `[[` 跳引用也不变。

Picker 内按 `?` 可核对当前键。Zellij 侧完整对照表见 [zellij.md](./zellij.md)。

## 其它本仓库覆盖

| 文件 | 作用 |
| --- | --- |
| `lua/config/options.lua` | 空白字符显示；Nerd Font；GUI 字体 |
| `lua/plugins/indent.lua` | Snacks indent 用 `·`，与 listchars 对齐 |
| `lua/plugins/colorscheme.lua` | TokyoNight：函数名加粗 |
| `lua/plugins/splitjoin.lua` | mini.splitjoin：`gS` / `gss` / `gsj` |
| `lua/plugins/dadbod.lua` | 练习库 MySQL 连接；避免占用 `<leader>S` |

Leader 仍是 LazyVim 默认 `<Space>`。`<leader>ff` 找文件，`<leader>/` 或 `<leader>sg` grep。
