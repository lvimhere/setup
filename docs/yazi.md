# Yazi

终端文件管理器。包与周边工具见 [cli-tools.md](./cli-tools.md)。

## 配置链接

仓库：`setup/.config/yazi/` → `~/.config/yazi`

```bash
ln -sfn ~/setup/.config/yazi ~/.config/yazi
```

只覆盖需要的项，不复制整份默认配置。插件 / 主题用 `ya pkg`，清单在 `package.toml`；`plugins/`、`flavors/` 不进 git。

重装后：

```bash
ya pkg install
```

## 已装

官方插件：

| 包 | 作用 |
| --- | --- |
| `smart-enter` | `l` / Enter：目录进入，文件打开 |
| `smart-paste` | `p`：粘到悬停目录，否则当前目录 |
| `git` | 文件列表显示 Git 状态 |
| `full-border` | 四周边框（`init.lua` 里设为圆角） |
| `toggle-pane` | `T`：放大 / 还原预览 |

`init.lua` 还把 git 插件的 `order` 设成 `1500`（状态列位置）。主题：`catppuccin-mocha`（与 Zellij 同系）。

额外键位：

| 键 | 作用 |
| --- | --- |
| `!` | 在当前目录打开 `$SHELL` |
| `gr` | 回到当前 Git 仓库根 |
| `y` | Yazi yank，同时用内置 `copy path` 把路径写入系统剪贴板 |

默认仍可用：`z` fzf、`Z` zoxide（需本机已装）。

## Shell wrapper `y`

写在 `env.sh` / `env.fish`（未装 yazi 则跳过）。日常用 `y` 启动：

| 退出 | 外面的目录 |
| --- | --- |
| `q` | 跟着进 Yazi 最后停留的目录 |
| `Q` | 保持进入前的路径 |

直接跑 `yazi` 也不会改外面的目录。

## 预览依赖

`ffmpeg`、`ffmpegthumbnailer`、`poppler` 已在 CLI 清单里。图片预览跟 Kitty 走。

## 系统剪贴板

Yazi 的 `copy path`（本仓库的 `y`，以及默认 `cc`）走它自己的剪贴板，**不走** `clipcopy`。Wayland 需要 `wl-clipboard`（`wl-copy`）。WSL 上也不会自动改用 win32yank。

```bash
sudo pacman -S --needed wl-clipboard
```
