# Kitty 配置说明

## 配置文件位置

- 主配置：`~/.config/kitty/kitty.conf`
- 当前主题：`~/.config/kitty/current-theme.conf`

## 当前配置概览

### 字体

- 字体：`Maple Mono NF CN`
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

当前使用主题：**Catppuccin Mocha**

主要颜色：

- 前景色：`#CDD6F4`
- 背景色：`#1E1E2E`
- 选中背景：`#F5E0DC`
- 光标：`#F5E0DC`
- 活动边框：`#B4BEFE`
- 非活动边框：`#6C7086`
- 活动 Tab：`#CBA6F7`
- 非活动 Tab 背景：`#181825`

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
| 左/下/上/右切换窗口 | `Ctrl+H` / `Ctrl+J` / `Ctrl+K` / `Ctrl+L` |

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
| 打开 scrollback | `Ctrl+Shift+H` |
| 搜索 scrollback | `Ctrl+Shift+/` |

## 主题与配置操作

| 功能 | 快捷键 |
| --- | --- |
| 打开主题选择器 | `Ctrl+Shift+I` |
| 重载 kitty 配置 | `Ctrl+Shift+F5` |
| 搜索历史输出（需要 `fzf`） | `Ctrl+Shift+F2` |

## 备注

- 当前主题通过 `include current-theme.conf` 引入，主题切换后通常会更新该文件或相关引用。
- `Ctrl+Shift+R` 是 kitty 原生的 resize mode。
- `Ctrl+Shift+\` 会在当前 tab 中按左右分屏新开终端，`Ctrl+Shift+'` 会按上下分屏新开终端。
- 分屏后的每个终端都属于 kitty 的一个 window，因此关闭当前分屏依然使用 `Ctrl+Shift+W`。
- 现在也支持直接用 `Ctrl+Shift+Alt+方向键/HJKL` 调整窗口大小，不必先进入 resize mode。
