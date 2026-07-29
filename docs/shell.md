# Shell 环境（原生 Linux + WSL）

共享逻辑在仓库：

```text
.setup/.config/shell/
  env.sh       # bash / zsh
  env.fish     # fish
  clipcopy     # 跨平台剪贴板（Zellij / 脚本）
```

## 接入

按你用的壳选一种（`SETUP_ROOT` 按本机仓库路径改）。

### bash

`~/.bashrc` 顶部（interactive `return` 之前）：

```bash
SETUP_ROOT="${SETUP_ROOT:-$HOME/Projects/setup}"
[[ -f "$SETUP_ROOT/.config/shell/env.sh" ]] && . "$SETUP_ROOT/.config/shell/env.sh"
```

### zsh

`~/.zshrc`：

```bash
SETUP_ROOT="${SETUP_ROOT:-$HOME/Projects/setup}"
[[ -f "$SETUP_ROOT/.config/shell/env.sh" ]] && . "$SETUP_ROOT/.config/shell/env.sh"
```

### fish

`~/.config/fish/config.fish`：

```fish
set -q SETUP_ROOT; or set -gx SETUP_ROOT $HOME/Projects/setup
test -f $SETUP_ROOT/.config/shell/env.fish; and source $SETUP_ROOT/.config/shell/env.fish
```

首次 source 后会自动把 `clipcopy` 链到 `~/.local/bin/clipcopy`。

## `env.sh` / `env.fish` 做什么

| 项 | 行为 |
| --- | --- |
| `PATH` | 加入 `~/.local/bin` |
| `XDG_RUNTIME_DIR` | 不可用时回退到 `~/.cache/xdg-runtime`（修 WSL 上 Zellij PermissionDenied） |
| `ZELLIJ_SOCKET_DIR` | 默认 `~/.cache/zellij-sock` |
| `clipcopy` | 符号链接到 `~/.local/bin` |
| `win32yank.exe` | 仅当 `/mnt/c/Program Files/Neovim/bin/...` 存在时创建（WSL） |
| `curl` alias | 仅 WSL 交互壳，强制 Linux curl |

原生 Linux 上这些探测多为 no-op，不会覆盖正常的 `/run/user/$UID`。

## `clipcopy` 优先级

1. `win32yank.exe`（WSL）
2. `wl-copy`（Wayland socket 真实存在）
3. `xclip` / `xsel`
4. `clip.exe`（WSL 兜底）
