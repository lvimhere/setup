# 命令行工具（重装清单）

本机自选、日常会用的 CLI。不含系统自带包、桌面套件、CachyOS 元包。

已另有文档的不在此重复安装步骤：

| 工具 | 文档 |
| --- | --- |
| Neovim | [neovim-config.md](./neovim-config.md)、[lazyvim.md](./lazyvim.md) |
| Zellij | [zellij.md](./zellij.md) |
| tmux | [tmux-wsl.md](./tmux-wsl.md) |
| Kitty | [kitty-config.md](./kitty-config.md) |
| Yazi | [yazi.md](./yazi.md) |
| broot | [broot.md](./broot.md) |
| Starship | [starship.md](./starship.md) |
| Shell 环境 | [shell.md](./shell.md) |
| 字体 | [font-setup.md](./font-setup.md) |

`paru`、`mise`、`fastfetch` 不列入本页。

## 一次安装

Arch / CachyOS。`--needed` 已装则跳过。

```bash
sudo pacman -S --needed \
  starship \
  yazi broot zoxide eza fd fzf ripgrep \
  bat tealdeer jq \
  git-delta difftastic \
  btop glances duf \
  7zip unzip unrar \
  ffmpeg ffmpegthumbnailer poppler \
  wl-clipboard
```

AUR / 非官方仓库（按需，本机曾装过）：

```bash
paru -S --needed fzf-tab claude-code openai-codex-bin kimi-code
```

`eza` / `fd` / `fzf` / `bat` / `tealdeer` / `jq` 当前可能被 CachyOS fish/zsh 配置带成依赖。重装后请按上面**显式安装**，避免卸掉发行版 shell 配置时一起消失。

## 清单

### 文件与导航

| 包名 | 命令 | 作用 | 本机 |
| --- | --- | --- | --- |
| `yazi` | `yazi` | 终端文件管理器（预览、Vim 键位、Lua 插件） | 显式已装，配置见 [yazi.md](./yazi.md) |
| `broot` | `br` / `broot` | 树形浏览 + 模糊搜索 | 显式已装，配置见 [broot.md](./broot.md) |
| `zoxide` | `z` / `zi` | 按使用频率智能跳转目录 | 显式已装（`env.sh` / `env.fish` 里有则 init） |
| `starship` | （提示符） | 跨 shell 提示符，Tokyo Night Powerline | 显式已装，配置见 [starship.md](./starship.md) |
| `eza` | `eza` | 现代化 `ls`（图标、Git 列） | 依赖带入，重装请显式 |
| `fd` | `fd` | 比 `find` 好用的文件查找 | 依赖带入，重装请显式 |
| `fzf` | `fzf` | 模糊选择器（管道、Ctrl-R 等） | 依赖带入，重装请显式 |
| `ripgrep` | `rg` | 极速文本搜索 | 显式已装 |
| `fzf-tab` | （zsh Tab） | Tab 补全改用 fzf；`cd`/`z` 用 eza 预览 | AUR，显式已装，见 [shell.md](./shell.md) |

### 阅读与手册

| 包名 | 命令 | 作用 | 本机 |
| --- | --- | --- | --- |
| `bat` | `bat` | 带语法高亮的阅读。本机**不** `alias cat=bat`；zsh 里 `man` 走 `bat` | 依赖带入，重装请显式 |
| `tealdeer` | `tldr` | 简短命令示例（比 man 快查） | 依赖带入，重装请显式 |
| `jq` | `jq` | 命令行处理 JSON | 依赖带入，重装请显式 |

### Git 阅读（diff）

| 包名 | 命令 | 作用 | 本机 |
| --- | --- | --- | --- |
| `git-delta` | `delta` | Git / diff 的语法高亮分页器，行内改动更清楚 | 已装，默认接 `git diff` |
| `difftastic` | `difft` | 按语法树对比，重命名/大重构比行 diff 好懂 | 已装，按次 `git dft` |

二者都装、按场景选用即可，见下一节。

### 系统监控

| 包名 | 命令 | 作用 | 本机 |
| --- | --- | --- | --- |
| `btop` | `btop` | CPU / 内存 / 磁盘 / 网络 + 进程 | 显式已装 |
| `glances` | `glances` | 另一套全屏资源监控 | 显式已装 |
| `duf` | `duf` | 更好读的磁盘分区用量 | 显式已装 |

### 压缩与预览依赖

给 yazi 等看 PDF / 视频 / 压缩包用，脚本里也可单独用。

| 包名 | 作用 | 本机 |
| --- | --- | --- |
| `7zip` | 7z / 常见压缩格式 | 依赖带入，重装请显式 |
| `unzip` / `unrar` | zip / rar | 显式已装 |
| `ffmpeg` / `ffmpegthumbnailer` | 视频信息与缩略图 | 已装 |
| `poppler` | PDF 文本/预览（`pdftotext` 等） | 已装 |

### AI CLI（按需）

| 包名 | 作用 | 来源 |
| --- | --- | --- |
| `claude-code` | Anthropic 终端 Agent | extra，显式已装 |
| `openai-codex-bin` | OpenAI Codex CLI | AUR |
| `kimi-code` | Kimi 终端 Agent | AUR |
| `cursor-agent` | Cursor 命令行 Agent | `~/.local/bin`，不是 pacman |

## delta 与 difftastic

**默认不改 `git diff` 的语义**：日常仍是行级补丁，只是分页器用 delta。  
**不要**设置 `diff.external = difft`，否则所有 `git diff` 都会变成语法树对比。

| | 日常 | 特殊 | 单文件并排 |
| --- | --- | --- | --- |
| 命令 | `git diff` / `git show` / `git log -p` | `git dft`（仓库内）或 `difft a b` | broot `:gd` |
| 工具 | delta | difftastic | nvimdiff（`git difftool`） |
| 适合 | 看改了哪几行、行内改了哪几个字 | 格式化抖动、重命名、大段搬家 | 对着一个文件左右看、顺便改 |

冲突文件不要用 `:gd`。broot 里 `:gm` 会对该文件跑 `git mergetool --tool=nvimdiff`（三路）。`Alt-g` 能把冲突项筛出来。

### 配置

仓库：`setup/.config/git/config` → `~/.config/git`

```bash
# 路径按本机仓库位置调整
ln -sfn ~/setup/.config/git ~/.config/git
```

本机已按上面链接。仓库这份配置**只管 pager / alias**，不含 `user.name` / `user.email`。身份放在 `~/.gitconfig`（不要写进仓库）：

```bash
git config --file ~/.gitconfig user.name "你的名字"
git config --file ~/.gitconfig user.email "you@example.com"
```

内容要点：

- `core.pager = delta`：`git diff` / `show` / `log -p` 自动走 delta
- `interactive.diffFilter`：`git add -p` 同样用 delta
- `alias.dft`：`git -c diff.external=difft diff`，只在这次命令里启用 difftastic

### 用法

```bash
git diff                 # 日常
git diff --cached
git show
git log -p

git dft                  # 当前工作区，语法树对比
git dft --cached
git dft HEAD~1
git dft main...HEAD

difft old.rs new.rs      # 不经过 Git，直接比两个文件
```

## 相关配置

- zoxide：`setup/.config/shell/env.sh`、`env.fish`（未安装则跳过，不报错）
- Starship：`setup/.config/starship.toml`，说明见 [starship.md](./starship.md)
- zsh（vim 键位、fzf-tab、eza）：`setup/.config/zsh/`，说明见 [shell.md](./shell.md)
- Git pager / `git dft`：`setup/.config/git/config`（不含 `diff.tool`）
- Yazi：`setup/.config/yazi/`，说明见 [yazi.md](./yazi.md)
- broot：`setup/.config/broot/`，说明见 [broot.md](./broot.md)。`:gd` / `:gm` 在动词里写死 `--tool=nvimdiff`，不改全局 `diff.tool` / `merge.tool`
