# Tmux on WSL（与 Neovim smart-splits 配合）

## 推荐用法

```text
Windows 宿主机终端（Kitty / Windows Terminal）
  └─ WSL shell
       └─ tmux          ← 多窗格 / 会话持久化
            └─ nvim     ← smart-splits：<C-hjkl> 移动，<A-hjkl> 缩放
```

在 WSL 里优先用 **tmux** 做分屏，而不是依赖 Kitty 跨 Windows/WSL 的窗格集成（更脆、配置更重）。

`<C-\>` 仍留给 Neovim ToggleTerm，**不要**在 tmux 里占用。

## 安装

```bash
sudo pacman -S --needed tmux
```

配置文件在仓库：`setup/.config/tmux/tmux.conf`，应通过符号链接到：

```bash
ln -sfn ~/Projects/setup/.config/tmux ~/.config/tmux
```

生效：

```bash
tmux source-file ~/.config/tmux/tmux.conf
# 或新开 tmux 会话
```

## 常用键

| 按键 | 作用 |
| --- | --- |
| `C-b` `|` / `-` | 水平 / 垂直分屏（当前路径） |
| `C-b` `r` | 重载 tmux 配置 |
| `C-h/j/k/l` | 在 nvim 分屏与 tmux 窗格间移动 |
| `Alt-h/j/k/l` | 缩放 nvim 分屏或 tmux 窗格 |

## 与 Neovim 状态栏

- **tmux 底栏始终开启**（shell / 其它程序也要看会话与窗口）
- **nvim 在 tmux 内**：用 [vim-tpipeline](https://github.com/vimpostor/vim-tpipeline) 把 **完整 lualine**（mode / git / 文件 / 诊断等）嵌进 tmux 底栏，避免双行；焦点离开 nvim 窗格后恢复普通 tmux status
- **单独启动 nvim**：照常显示 lualine

改完 tmux 配置后执行：`tmux source-file ~/.config/tmux/tmux.conf`（或新开会话）。

详见 [neovim-config.md](./neovim-config.md)。
