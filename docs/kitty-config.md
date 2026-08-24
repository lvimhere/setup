# Kitty 配置说明

## 配置文件位置

- 主配置：`~/.config/kitty/kitty.conf`
- 当前主题：`~/.config/kitty/current-theme.conf`

## 当前配置概览

### 字体

- 主字体：`Hack Nerd Font Mono`
- CJK 回退：`Maple Mono NF CN`（`symbol_map` 覆盖汉字 / CJK 标点区间）
- 字重/斜体：`auto`
- 字号：`10.5`
- 列宽调整：`0`

### 外观

- 背景透明度：`0.85`
- 动态透明：`yes`
- 窗口装饰：`hide_window_decorations no`
- Wayland 标题栏颜色：`background`
- 窗口内边距：`0`
- 窗口外边距：`0`
- 单窗口 margin：`-1`

### 光标与滚动

- 光标形状：`block`
- 光标闪烁间隔：`0.5`
- 停止闪烁时间：`10.0`
- 光标厚度：`1.5`
- 滚动缓存：`10000`
- 鼠标滚轮倍率：`5.0`

### 窗口与布局

- 初始窗口大小：`120c x 32c`
- 多窗口边框：`yes`
- 边框宽度：`1pt`
- 可用布局：`splits, tall, fat, grid, stack`

### Tab 栏

- 位置：`bottom`
- 样式：`powerline`
- Powerline 风格：`slanted`

### 主题

当前使用主题：**Tokyo Night**（`tokyonight.nvim` extras night）

主要颜色：

- 前景色：`#c0caf5`
- 背景色：`#1a1b26`
- 选中背景：`#283457`
- 光标：`#c0caf5`
- 活动边框：`#7aa2f7`
- 非活动边框：`#292e42`
- 活动 Tab：`#7aa2f7`
- 非活动 Tab 背景：`#292e42`

## 常用快捷键

说明：`kitty_mod = Ctrl+Shift`

| 功能 | 快捷键 |
| --- | --- |
| 新建窗口 | `Ctrl+Shift+Enter` |
| 关闭窗口 | `Ctrl+Shift+W` |
| 关闭当前终端（shell 退出） | `exit` 或 `Ctrl+D` |
| 进入窗口 resize 模式 | `Ctrl+Shift+R` |
| 下一个窗口 | `Ctrl+Shift+]` |
| 上一个窗口 | `Ctrl+Shift+[` |
| 移动当前窗口顺序 | `Ctrl+Shift+F` |
| 左右分屏新开终端 | `Ctrl+Shift+\` |
| 上下分屏新开终端 | `Ctrl+Shift+'` |
| 左/下/上/右切换窗口（与 nvim 共用） | `Ctrl+H` / `Ctrl+J` / `Ctrl+K` / `Ctrl+L` |

说明：

- `Ctrl+Shift+W` 关闭的是**当前焦点所在的终端窗口**。
- 如果这个终端是通过分屏打开的，那么按下 `Ctrl+Shift+W` 关闭的就是**当前分屏**，不会直接关闭整个 tab。
- 也可以在当前终端里执行 `exit` 或按 `Ctrl+D` 关闭该分屏。

## 直接调整窗口大小

| 功能 | 快捷键 |
| --- | --- |
| 向左收窄 | `Ctrl+Shift+Alt+H` 或 `Ctrl+Shift+Alt+Left` |
| 向右加宽 | `Ctrl+Shift+Alt+L` 或 `Ctrl+Shift+Alt+Right` |
| 向上增高 | `Ctrl+Shift+Alt+K` 或 `Ctrl+Shift+Alt+Up` |
| 向下减高 | `Ctrl+Shift+Alt+J` 或 `Ctrl+Shift+Alt+Down` |

## Tab 管理

| 功能 | 快捷键 |
| --- | --- |
| 新建 Tab | `Ctrl+Shift+T` |
| 关闭 Tab | `Ctrl+Shift+Q` |
| 下一个 Tab | `Ctrl+Tab` |
| 上一个 Tab | `Ctrl+Shift+Tab` |
| 跳转到 Tab 1-5 | `Ctrl+Shift+1` 到 `Ctrl+Shift+5` |

## 字体与显示

| 功能 | 快捷键 |
| --- | --- |
| 放大字体 | `Ctrl+Shift+=` |
| 缩小字体 | `Ctrl+Shift+-` |
| 重置字体大小 | `Ctrl+Shift+0` |
| 增加透明度 | `Ctrl+Shift+O` 后按 `=` |
| 减少透明度 | `Ctrl+Shift+O` 后按 `-` |
| 重置透明度为 1.0 | `Ctrl+Shift+O` 后按 `0` |

## 剪贴板与滚动

| 功能 | 快捷键 |
| --- | --- |
| 复制 | `Ctrl+Shift+C` |
| 粘贴 | `Ctrl+Shift+V` |
| 向上滚动一行 | `Ctrl+Shift+Up` |
| 向下滚动一行 | `Ctrl+Shift+Down` |
| 向上翻页 | `Ctrl+Shift+PageUp` |
| 向下翻页 | `Ctrl+Shift+PageDown` |
| 滚动到顶部 | `Ctrl+Shift+Home` |
| 滚动到底部 | `Ctrl+Shift+End` |
| 用 nvim 打开 scrollback | `Ctrl+Shift+H` |
| 用 nvim 打开上一条命令输出 | `Ctrl+Shift+G` |
| 点选命令输出后用 nvim 打开 | `Ctrl+Shift` + 鼠标右键 |
| 用 fzf 搜 scrollback | `Ctrl+Shift+F2` |

## 主题与配置操作

| 功能 | 快捷键 |
| --- | --- |
| 打开主题选择器 | `Ctrl+Shift+I` |
| 重载 kitty 配置 | `Ctrl+Shift+F5` |
| 搜索历史输出（需要 `fzf`） | `Ctrl+Shift+F2` |

## 与 Neovim（smart-splits / 遥控）

完整按键路径、为何要开遥控、如何验收，见 [lazyvim.md 的 smart-splits 一节](./lazyvim.md#smart-splitsctrl-hjkl-跨窗格)。这里只写 Kitty 侧已经配好的部分。

**遥控不是另写业务脚本。** 只装 `smart-splits.nvim` 时，`<C-h>` 只能在 nvim 分屏里打转。要跳出编辑器，Kitty 必须听 socket，并且用 `IS_NVIM` 决定「自己切窗格」还是「把键交给 nvim」。插件启动时会设这个用户变量；`install-kittens.bash` 只是把插件自带的 `.py` 拷进 `~/.config/kitty/`（不进 git）。

| 配置 | 本仓库取值 |
| --- | --- |
| `allow_remote_control` | `socket-only`（只认 Unix socket，不认 TTY 里的 `kitty @`） |
| `listen_on` | `unix:${HOME}/.cache/kitty/kitty-{kitty_pid}` |
| 切窗格 | `ctrl+h/j/k/l` → `neighboring_window` |
| 焦点在 nvim | `map --when-focus-on var:IS_NVIM ctrl+h`（以及 j/k/l）无动作，键进 nvim |
| 缩放 | `Ctrl+Shift+Alt+hjkl`，不占用 `Alt-j/k` |

改 `allow_remote_control` / `listen_on` 后要**完全退出并重开 Kitty**（只 `Ctrl+Shift+F5` 不够，旧进程没有 socket）。

| 功能 | 说明 |
| --- | --- |
| `<C-hjkl>` | 普通终端：切窗格。nvim 里：先走分屏，贴边再经 socket 切 Kitty 窗格 |
| `Ctrl+Shift+H` | [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim) 翻历史；精简 `-u`，`q` 退出 |
| `Ctrl+Shift+G` | 上一条命令的输出 |
| `Ctrl+Shift` + 右键 | 点选的那条命令输出 |

scrollback 的 Python kitten 在 `~/.local/share/nvim/lazy/kitty-scrollback.nvim/`，`-u` 用 `~/setup/.config/nvim/kitty-scrollback-kitten.lua`。

## 备注

- 当前主题通过 `include current-theme.conf` 引入，主题切换后通常会更新该文件或相关引用。
- `Ctrl+Shift+R` 是 kitty 原生的 resize mode。
- `Ctrl+Shift+\` 会在当前 tab 中按左右分屏新开终端，`Ctrl+Shift+'` 会按上下分屏新开终端。
- 分屏后的每个终端都属于 kitty 的一个 window，因此关闭当前分屏依然使用 `Ctrl+Shift+W`。
- 现在也支持直接用 `Ctrl+Shift+Alt+方向键/HJKL` 调整窗口大小，不必先进入 resize mode。
