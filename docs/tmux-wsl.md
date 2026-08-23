# Tmux on WSL（Oh My Tmux + Neovim smart-splits）

## 推荐用法

```text
Windows 宿主机终端（Kitty / Windows Terminal）
  └─ WSL shell
       └─ tmux          ← 多窗格 / 会话持久化（Oh My Tmux）
            └─ nvim     ← smart-splits：<C-hjkl> 移动，<A-hjkl> 缩放
```

在 WSL 里优先用 **tmux** 做分屏，而不是依赖 Kitty 跨 Windows/WSL 的窗格集成（更脆、配置更重）。

`<C-\>` 仍留给 Neovim ToggleTerm，**不要**在 tmux 里占用。

## 安装

```bash
sudo pacman -S --needed tmux
```

本仓库使用 [Oh My Tmux](https://github.com/gpakosz/.tmux) + [Catppuccin for Tmux](https://github.com/catppuccin/tmux)（Mocha，与 Neovim 一致）+ TPM 插件。

首次克隆 setup 后拉 submodule：

```bash
cd ~/setup
git submodule update --init --recursive .config/tmux/oh-my-tmux .config/tmux/catppuccin/tmux
# catppuccin 固定 v2.3.0 tag：若需切换版本，在 catppuccin/tmux 内 git checkout v2.3.0
```

目录布局（XDG）：

```text
~/.config/tmux  →  ~/setup/.config/tmux   # 符号链接
  tmux.conf     →  oh-my-tmux/.tmux.conf            # 勿改 upstream
  tmux.conf.local                                # 定制：Catppuccin、smart-splits、插件
  oh-my-tmux/                                    # submodule
  catppuccin/tmux/                       # submodule（勿放在 plugins/，否则 TPM clean 会删）
  plugins/                                       # TPM 自动安装 resurrect / continuum 等
```

链接到 home（若尚未链接）：

```bash
ln -sfn ~/setup/.config/tmux ~/.config/tmux
```

不要使用 `~/.tmux.conf` 或 `~/.tmux/` 的旧式路径，以免与 XDG 配置冲突。

## 更新 submodule

```bash
cd ~/setup
git submodule update --remote .config/tmux/oh-my-tmux
git submodule update --remote .config/tmux/catppuccin/tmux
# 只改 tmux.conf.local，不要改 oh-my-tmux/.tmux.conf 或 catppuccin 仓库内文件
```

## 主题与插件

| 组件 | 说明 |
| --- | --- |
| **Catppuccin Mocha** | 官方 `catppuccin/tmux` v2，`rounded` 窗口样式；底栏 session / uptime / 路径 / host / 电池 |
| **resurrect** | 手动保存/恢复布局：`<prefix>` `Ctrl-s` 保存，`Ctrl-r` 恢复 |
| **continuum** | 每 15 分钟自动保存；`@continuum-restore` 启动时恢复 |

首次启用 TPM 插件：`<prefix>` `I`（大写 I）安装。之后 `<prefix>` `r` 重载配置。
tmux.conf.local 里 tmux_conf_uninstall_plugins_on_reload=false，避免 TPM 的 clean_plugins 误删非 @plugin 目录。Catppuccin 用 run-shell 检测脚本存在后再加载；submodule 未 init 时不会 exit 127。



## 生效 / 重载

```bash
tmux source-file ~/.config/tmux/tmux.conf
# Oh My Tmux 默认：prefix + r（同上效果）
# 或新开 tmux 会话
```

编辑定制：`<prefix>` `e` 会打开 `tmux.conf.local`（Oh My Tmux 自带绑定）。

## 前缀键

**只用 `C-a`**（GNU Screen 风格）。已关闭 OMT 默认的 `C-b` 前缀，避免与 Neovim 补全里 `<C-b>`（滚动文档）冲突。

下文 `<prefix>` = **`Ctrl-a`**，先按前缀，松手后再按第二个键。

## 常用键

### 配置 / 插件

| 按键 | 作用 |
| --- | --- |
| `<prefix>` `e` | 编辑 `tmux.conf.local` |
| `<prefix>` `r` | 重载配置 |
| `<prefix>` `I` | TPM 安装插件（大写 I） |
| `<prefix>` `u` | TPM 更新插件 |
| `<prefix>` `Alt-u` | TPM 卸载插件 |
| `<prefix>` `Ctrl-s` | resurrect 手动保存布局 |
| `<prefix>` `Ctrl-r` | resurrect 手动恢复布局 |

### 会话 / 窗口

| 按键 | 作用 |
| --- | --- |
| `<prefix>` `Ctrl-c` | 新建 session |
| `<prefix>` `Ctrl-f` | 按名切换 session |
| `<prefix>` `Tab` | 上一个 session |
| `<prefix>` `c` | 新建 window |
| `<prefix>` `&` | 关闭 window |
| `<prefix>` `,` / `.` | 重命名 / 移动 window |
| `<prefix>` `Ctrl-h` / `Ctrl-l` | 上一个 / 下一个 window |
| `<prefix>` `Tab`（窗口内） | 上一个活跃 window |

### 窗格

| 按键 | 作用 |
| --- | --- |
| `<prefix>` `-` | 垂直分屏 |
| `<prefix>` `_` | 水平分屏 |
| `<prefix>` `x` | 关闭 pane |
| `<prefix>` `z` | 最大化 / 还原 pane（也可用 `<prefix>` `+` OMT 版） |
| `<prefix>` `h/j/k/l` | 移动 pane（vim 方向） |
| `<prefix>` `H/J/K/L` | 缩放 pane |
| `<prefix>` `<` / `>` | 交换 pane |
| `<prefix>` `+` | 最大化 pane 到新 window（OMT） |
| `<prefix>` `m` | 开关鼠标模式 |
| `<prefix>` `q` | 显示 pane 编号 |

### 与 Neovim 联动（无需 prefix）

| 按键 | 作用 |
| --- | --- |
| `C-h/j/k/l` | nvim 分屏 ↔ tmux 窗格移动（smart-splits） |
| `Alt-h/j/k/l` | 缩放 nvim 分屏 / tmux 窗格 |

### 复制模式（vi）

| 按键 | 作用 |
| --- | --- |
| `<prefix>` `Enter` | 进入 copy 模式 |
| `v` / `y` | 选择 / 复制（y 可进系统剪贴板） |
| `C-h/j/k/l` | copy 模式下切换 pane |

更多见 [OMT README](https://github.com/gpakosz/.tmux/blob/master/README.md)。

## 与 Neovim 状态栏

- **tmux 底栏始终开启**（shell / 其它程序也要看会话与窗口）
- **status 长度**：`tmux.conf.local` 里 `status-left-length` / `status-right-length` 为 99，便于 [vim-tpipeline](https://github.com/vimpostor/vim-tpipeline) 嵌入 lualine
- **nvim 在 tmux 内**：tpipeline 把 **完整 lualine**（mode / git / 文件 / 诊断等）嵌进 tmux 底栏；焦点离开 nvim 窗格后恢复普通 tmux status
- **单独启动 nvim**：照常显示 lualine

剪贴板：copy 模式选中会同步到 OS 剪贴板（`tmux_conf_copy_to_os_clipboard=true`，依赖 `wl-copy` / `xclip` / Windows 侧 win32yank 等）。

改完 **`tmux.conf.local`** 后执行：`tmux source-file ~/.config/tmux/tmux.conf`（或 `<prefix>` `r`）。

详见 [neovim-config.md](./neovim-config.md)。
