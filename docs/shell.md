# Shell 环境（原生 Linux + WSL）

共享逻辑在仓库：

```text
setup/.config/shell/
  env.sh       # bash / zsh
  env.fish     # fish
  clipcopy     # 跨平台剪贴板
```

本机仓库在 `~/setup`。换路径时改 `SETUP_ROOT`。

## 接入

按你用的壳选一种。

### bash

`~/.bashrc` 顶部（interactive `return` 之前）：

```bash
SETUP_ROOT="${SETUP_ROOT:-$HOME/setup}"
[[ -f "$SETUP_ROOT/.config/shell/env.sh" ]] && . "$SETUP_ROOT/.config/shell/env.sh"
```

### zsh

仓库：`setup/.config/zsh/zshrc` → `~/.zshrc`

```bash
ln -sfn ~/setup/.config/zsh/zshrc ~/.zshrc
```

`zshrc` 会 source：

1. `setup/.config/zsh/cachyos-config.zsh` — CachyOS 1.0.3 的副本，**去掉 Powerlevel10k**，并加上下面这些
2. `setup/.config/shell/env.sh` — mise / zoxide / yazi / Starship
3. broot 的 `br` launcher（存在才 source）

不要改 `/usr/share/cachyos-zsh-config/cachyos-config.zsh`：那是发行版自带的完整 zsh 配置（含 Powerlevel10k），`pacman -Syu` 会覆盖。上游若改了那份文件，把 diff 合进仓库副本即可。

### zsh 相对 CachyOS 默认多了什么

| 项 | 行为 |
| --- | --- |
| 键位 | **vim**（`bindkey -v` + OMZ `vi-mode`），不是 emacs。插入态光标为梁，Normal 为块 |
| 提示符 | Normal / replace / visual 时 Starship 显示 `❮`（`vimcmd_*`） |
| `vv` | Normal 模式把当前命令行丢给 `$EDITOR`（nvim） |
| 历史 | zsh 的 `HISTORY_IGNORE` / `HIST_IGNORE_ALL_DUPS`；已删 bash 的 `HISTCONTROL`、`PROMPT_COMMAND` |
| 纠正 | 关掉 `ENABLE_CORRECTION` |
| `cleanup` | 函数，运行时才查孤儿包 |
| eza | `ls` / `ll` / `la` / `lt` / `l.`，与 CachyOS fish 对齐 |
| bat | 不替换 `cat`；`man` 走 `bat` |
| fzf-tab | archlinuxcn `fzf-tab-git`（或 AUR `fzf-tab`），Tab 补全用 fzf；`cd`/`z` 用 eza 预览 |
| 历史子串 | 输入一段再按上/下、`Ctrl-P`/`Ctrl-N`，或 Normal 的 `j`/`k` |
| sudo | **Alt-S** 在行首加/去掉 `sudo`（`KEYTIMEOUT=1` 时 Esc Esc 不好用） |
| extract | OMZ `extract`：`x` / `extract` 解压常见压缩包 |
| mise | `env.sh` 里 `mise activate zsh` |

### zsh 常用键

| 键 | 模式 | 作用 |
| --- | --- | --- |
| Esc | 插入 | 进 Normal |
| `i` / `a` | Normal | 回插入 |
| `j` / `k` 或 ↑↓ | Normal / 插入 | 按缓冲区内容做历史子串搜索 |
| `Ctrl-P` / `Ctrl-N` | 插入 | 同上（历史子串上 / 下） |
| `Ctrl-R` | 插入 | fzf 历史 |
| `Ctrl-T` | 插入 | fzf 文件 |
| `Alt-C` | 插入 | fzf 目录 |
| Tab | 插入 | fzf-tab 补全 |
| `Alt-S` | 两种 | 行首 toggle `sudo` |
| `vv` | Normal | 用 nvim 编辑当前命令行 |

### fish

`~/.config/fish/config.fish`：

```fish
set -q SETUP_ROOT; or set -gx SETUP_ROOT $HOME/setup
test -f $SETUP_ROOT/.config/shell/env.fish; and source $SETUP_ROOT/.config/shell/env.fish
```

首次 source 后会自动把 `clipcopy` 链到 `~/.local/bin/clipcopy`。

## `env.sh` / `env.fish` 做什么

| 项 | 行为 |
| --- | --- |
| `PATH` | 加入 `~/.local/bin` |
| `EDITOR` / `VISUAL` | 未设置时默认为 `nvim` |
| `XDG_RUNTIME_DIR` | 不可用时回退到 `~/.cache/xdg-runtime`（WSL 上 `/run/user/$UID` 常不存在） |
| `~/.cache/kitty` | 仅建目录（700），给 Kitty `listen_on` socket 用 |
| `clipcopy` | 符号链接到 `~/.local/bin` |
| `win32yank.exe` | 仅当 `/mnt/c/Program Files/Neovim/bin/...` 存在时创建（WSL） |
| `curl` alias | 仅 WSL 交互壳，强制 Linux curl |
| zoxide | 已装时 `zoxide init`（`z` / `zi`；未装则跳过） |
| `y` | 已装 yazi 时：官方 wrapper（`q` 跟随目录，`Q` 保持原路径） |
| Starship | 已装 `starship` 时：`starship init`（zsh / bash / fish）。配置见 [starship.md](./starship.md) |
| mise | 已装 `mise` 时：`mise activate`（zsh / bash 在 `env.sh`；fish 在 `config.fish`，`env.fish` 作兜底） |

原生 Linux 上这些探测多为 no-op，不会覆盖正常的 `/run/user/$UID`。

## `clipcopy` 优先级

1. `win32yank.exe`（WSL）
2. `wl-copy`（Wayland socket 真实存在）
3. `xclip` / `xsel`
4. `clip.exe`（WSL 兜底）

日常 CLI 重装清单见 [cli-tools.md](./cli-tools.md)。
