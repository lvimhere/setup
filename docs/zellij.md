# Zellij（本机主用，原生 Linux + WSL）

## 分工

| 场景 | 工具 |
| --- | --- |
| 本机日常分屏 / 会话 | **Zellij** |
| 偶尔 SSH 到服务器 | **tmux**（远端几乎都有，不必装 Zellij） |

自动命名会话 / 进 shell 就挂会话：先不做，需要时再说。

**不要**在 tmux 会话里再开 Zellij（嵌套 multiplexer）。

## 安装

```bash
sudo pacman -S --needed zellij
# 若以前装过用户目录二进制，可删：rm ~/.local/bin/zellij
```

先接入共享 shell 环境（剪贴板 / runtime 目录），见 [shell.md](./shell.md)。

## 配置链接

仓库：`setup/.config/zellij/` → `~/.config/zellij`

```bash
# 路径按本机仓库位置调整
ln -sfn ~/Projects/setup/.config/zellij ~/.config/zellij
```

当前 UI / 可移植行为：

- **不写死 shell**：省略 `default_shell`，使用 `$SHELL`（WSL 上多为 bash，原生可为 fish）
- **剪贴板**：`copy_command "clipcopy"`（`setup/.config/shell/clipcopy`，自动适配 win32yank / wl-copy / xclip）
- `default_layout "compact"`：单行底栏
- `simplified_ui true`：不用 powerline 尖角字体
- **主题**：`catppuccin-mocha-muted`（窗格边框压暗：未选中 surface0、选中 surface2；进模式时用蓝色高亮）
- **默认 Locked**（`default_mode "locked"`）：不抢 Neovim 的 `Ctrl-p/t/o/…`；Locked 下仍可用 `Alt-*` 切窗格 / 开浮窗
- 底栏插件：**zjstatus**（模式 / 会话 / tabs / git 分支 / 时间）

插件二进制（不进 git）：

```bash
mkdir -p ~/.config/zellij/plugins
curl -fsSL -L -o ~/.config/zellij/plugins/zjstatus.wasm \
  https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm
```

首次打开时一般会弹出权限浮窗，按 **`y`**。若底栏仍空：

```bash
# 不要附着旧会话；先清掉再全新启动
zellij delete-all-sessions -y -f
zellij
```

然后焦点到底栏（或权限浮窗）再按 **`y`**。

## WSL 闪退（PermissionDenied）

若 `zellij` 闪一下就退出，多半是 `XDG_RUNTIME_DIR=/run/user/$UID` 目录不存在。  
接入 [shell.md](./shell.md) 的 `env.sh` / `env.fish` 后会自动回退到 `~/.cache/xdg-runtime`。

```bash
source ~/.bashrc   # 或 fish: source ~/.config/fish/config.fish
zellij
```

## 日常用法

```bash
zellij                 # 新会话
zellij attach -c       # 有则附着，无则新建
zellij ls              # 列出会话
# Ctrl-o → d           # detach（会话保留）
# Ctrl-o → w           # session manager（含复活已退出会话）
```

改完 layout / zjstatus 后建议 **新开会话**（旧会话可能仍用旧布局）。

## 快捷键

### 与 Neovim：默认 Locked + Alt 白名单

本仓库 **启动即为 Locked**（类似官方 Unlock-First，但在 Locked 里放开了日常 `Alt-*`）：

| 状态 | 行为 |
| --- | --- |
| **Locked（默认）** | `Ctrl-p/t/o/n/s/h/q` 等交给 Neovim（Telescope / blink / jumplist…） |
| Locked 下仍可用 | 下面的 `Alt-*`（切窗格、新窗格、浮窗、缩放） |
| 需要完整模式键 | **`Ctrl-g`** → Normal，再用 `Ctrl-p` 等；用完再 `Ctrl-g` 锁回 |

底栏模式指示：`LOCKED` / `NORMAL`（zjstatus）。

**已关闭** 默认的 `Ctrl-b`（Zellij「tmux 模式」），避免和 Neovim `<C-b>` 冲突。

Neovim 内分屏导航继续用 `Ctrl-hjkl`（smart-splits）。  
注意：`Alt-hjkl` 优先给 **Zellij 切窗格**，不再用于 smart-splits 缩放（需要缩放 Neovim 分屏时用 `<C-Left/Right/Up/Down>` 或 `<leader>w…`）。

### 与 Neovim 冲突的按键

对照本仓库 Zellij 默认/自定键与 Neovim 配置。  
`<leader>…`（如 `<leader>sg`）本身不冲突；冲突出在打开 Telescope 等 UI 之后的 `Ctrl-*`，或两侧都绑了的 `Alt-*`。

#### Locked 下已交给 Neovim（不再被 Zellij 抢走）

| 按键 | Zellij（Normal 时） | Neovim 中原来的作用 |
| --- | --- | --- |
| `Ctrl-p` | 进入 Pane 模式 | blink.cmp：补全上一项；Telescope：预览 / 上一项；Oil：预览 |
| `Ctrl-n` | 进入 Resize 模式 | blink.cmp：补全下一项；Telescope：下一项 |
| `Ctrl-t` | 进入 Tab 模式 | Telescope：在新 tab 打开；Vim：tag stack 返回 |
| `Ctrl-o` | 进入 Session 模式 | jumplist 后退（与 `<C-i>` 配对） |
| `Ctrl-s` | 进入 Scroll 模式 | Flash：在 `/` `?` 命令行里开关搜索标签 |
| `Ctrl-h` | 进入 Move 模式 | smart-splits / ToggleTerm：向左跳分屏（`Ctrl-j/k/l` 无 Zellij 模式键，本就不抢） |
| `Ctrl-q` | 退出 Zellij 会话 | Telescope：结果送入 quickfix 等 |
| `Ctrl-g` | 锁定 ↔ 解锁 | Vim：显示文件名等信息（影响较小；本仓库用它切换 Locked） |

#### 刻意让给 Zellij 的键（Locked 白名单，仍生效）

| 按键 | Zellij | Neovim 中原来的作用 | 本仓库取舍 |
| --- | --- | --- | --- |
| `Alt-h/j/k/l` | 切窗格（贴边 `h/l` 切 tab） | smart-splits：**缩放**当前分屏 | 优先 Zellij 切窗；nvim 缩放改用 `<C-方向键>` / `<leader>w…` |
| `Alt-n` | 新窗格 | （配置中未占用） | 给 Zellij |
| `Alt-f` | 开关浮窗 | （配置中未占用） | 给 Zellij |
| `Alt-=` / `Alt-+` / `Alt--` | 放大 / 缩小窗格 | （配置中未占用） | 给 Zellij |

#### 已解除冲突

| 按键 | 原 Zellij | Neovim | 处理 |
| --- | --- | --- | --- |
| `Ctrl-b` | 「tmux 模式」前缀 | blink.cmp：补全文档上滚 | 已 `unbind`，始终给 Neovim |

#### 一般不冲突（便于对照）

| 按键 / 类型 | 说明 |
| --- | --- |
| `<leader>sg` 等 | leader 映射 Zellij 不拦截 |
| `Ctrl-j` / `Ctrl-k` / `Ctrl-l` | Zellij 无对应模式键 → smart-splits 正常 |
| `Ctrl-f` / `Ctrl-y` / `Ctrl-e` | blink 文档下滚 / 接受 / 取消；Zellij Normal 不抢 |
| `Ctrl-\` | ToggleTerm 浮动终端；Zellij 不抢 |
| `Alt-1`…`Alt-0` | barbar 切 buffer；Zellij 默认不绑 |

### 无需进模式（Locked / Normal 都可用）

| 按键 | 作用 |
| --- | --- |
| `Alt-h/j/k/l` | 窗格间移动（贴边时 `h/l` 切 tab） |
| `Alt-n` | 新窗格（浮层已显示时新开浮窗） |
| `Alt-f` | 开关浮动窗 |
| `Alt-=` / `Alt-+` | 放大当前窗格 |
| `Alt--` | 缩小当前窗格 |

### 模式键（需先 `Ctrl-g` 解锁到 Normal）

Zellij 多数操作是**两段式**：先按模式键进入模式，再按动作键。  
任意非 Normal / Locked 模式下，按 **`Enter` / `Esc`** 回到 Normal；再按一次模式键也可退出该模式。

| 模式键 | 模式 | 管什么 |
| --- | --- | --- |
| `Ctrl-p` | Pane | 窗格 |
| `Ctrl-t` | Tab | 标签页 |
| `Ctrl-o` | Session | 会话 / 插件 |
| `Ctrl-n` | Resize | 缩放 |
| `Ctrl-s` | Scroll | 滚动缓冲 |
| `Ctrl-g` | Locked ↔ Normal | 锁定 / 解锁 |
| `Ctrl-q` | — | 直接退出会话（仅 Normal） |

### `Ctrl-p` — Pane 模式

进入后底栏通常显示 `PANE`。先 `Ctrl-p`，再按：

| 第二键 | 作用 |
| --- | --- |
| `h` / `j` / `k` / `l`（或方向键） | 移动焦点 |
| `p` | 在窗格间轮换焦点 |
| `n` | 新窗格（自动布局）后回 Normal |
| `d` | 下方新开窗格 |
| `r` | 右侧新开窗格 |
| `s` | 堆叠式（stacked）新窗格 |
| `x` | 关闭当前窗格 |
| `f` | 当前窗格全屏 / 取消 |
| `z` | 开关窗格边框 |
| `w` | 开关浮动窗 |
| `e` | 当前窗格嵌入 ↔ 浮动 |
| `c` | 重命名窗格 |
| `i` | 固定 / 取消固定窗格 |
| `Ctrl-p` | 退出回 Normal |

示例：`Ctrl-p` → `d` = 在下方新开一个 pane。

### `Ctrl-t` — Tab 模式

进入后底栏通常显示 `TAB`。先 `Ctrl-t`，再按：

| 第二键 | 作用 |
| --- | --- |
| `n` | 新建 tab |
| `x` | 关闭当前 tab |
| `h` / `k` / `←` / `↑` | 上一个 tab |
| `l` / `j` / `→` / `↓` | 下一个 tab |
| `1`–`9` | 跳到第 N 个 tab |
| `Tab` | 在最近两个 tab 间切换 |
| `r` | 重命名 tab |
| `s` | 同步输入（当前 tab 内所有 pane 一起接收按键）开/关 |
| `b` | 把当前 pane 拆成独立 tab |
| `]` / `[` | 把 pane 拆到右侧 / 左侧 tab |
| `Ctrl-t` | 退出回 Normal |

示例：`Ctrl-t` → `n` = 新建 tab；`Ctrl-t` → `x` = 关闭 tab。

### `Ctrl-o` — Session 模式

进入后底栏通常显示 `SESSION`。先 `Ctrl-o`，再按：

| 第二键 | 作用 |
| --- | --- |
| `d` | Detach（会话留在后台，退出界面） |
| `w` | Session Manager（列会话、附着、复活） |
| `c` | 打开配置插件 |
| `p` | 打开插件管理器 |
| `a` | About |
| `l` | Layout Manager |
| `s` | Share |
| `Ctrl-s` | 进入 Scroll 模式 |
| `Ctrl-o` | 退出回 Normal |

示例：`Ctrl-o` → `d` = detach；之后用 `zellij attach` / `zellij attach -c` 回来。

### 其它模式（简表）

#### `Ctrl-n` — Resize

| 第二键 | 作用 |
| --- | --- |
| `h/j/k/l` | 向该方向增大 |
| `H/J/K/L` | 向该方向减小 |
| `=` / `+` | 整体放大 |
| `-` | 整体缩小 |

#### `Ctrl-s` — Scroll

| 第二键 | 作用 |
| --- | --- |
| `j` / `k` | 下 / 上滚一行 |
| `Ctrl-f` / `Ctrl-b`（或 `PageDown` / `PageUp`） | 下 / 上翻页 |
| `d` / `u` | 下 / 上半页 |
| `e` | 用 `$EDITOR` 编辑滚动缓冲 |
| `s` | 进入搜索 |

#### `Ctrl-g` — Locked

锁定后 Zellij 快捷键不抢应用（适合全屏用 nvim 等）。再按 `Ctrl-g` 解锁。

## 与 tmux

本机已有 `~/.config/tmux`，**保留**：SSH 上去仍用 `tmux`。不要在远端强依赖 Zellij。
