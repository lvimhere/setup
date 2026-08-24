# broot

树形浏览 + 模糊搜索。包见 [cli-tools.md](./cli-tools.md)。

日常用 **`br`**。直接跑 `broot` 退出后外面的目录不变。

`br` 按壳分别接入（都是 `broot --install` 生成，**不进 git**）：

| 壳 | 本机 |
| --- | --- |
| zsh | `zshrc` 在文件存在时 source `~/.config/broot/launcher/bash/br` |
| bash | `~/.bashrc` 同样 source 那份 `br`（bashrc 本身不在仓库里） |
| fish | `~/.config/fish/functions/br.fish`（不在仓库里） |

重装或换机器后：

```bash
broot --install
```

## 配置链接

仓库：`setup/.config/broot/` → `~/.config/broot`

```bash
ln -sfn ~/setup/.config/broot ~/.config/broot
```

仓库留 `conf.hjson`、`verbs.hjson`、皮肤。`launcher/` 是本机安装产物（里面的 `br` 还是指向 `~/.local/share/broot/...` 的符号链接），gitignore，用上面的 `--install` 恢复。

## 已开（社区常见项）

| 项 | 作用 |
| --- | --- |
| `default_flags: "-g"` | 启动即显示 Git 状态 |
| `icon_theme: nerdfont` | 用终端 Nerd Font（本机 Kitty：Hack Nerd Font Mono）。`vscode` 要另装 broot 的 `vscode.ttf`，否则会显示成「口」 |
| 皮肤 `tokyo-night` | 暗色终端；浅色终端走 `white.hjson` |
| `edit` 使用 `+{line}` | 从预览/内容搜索跳到 nvim 对应行 |
| `:gtr` / 输入 `gr` | 回到当前 Git 仓库根 |
| `:gd` / `git_diff` | 当前文件用 nvimdiff 并排看普通 diff（`git difftool`） |
| `:gm` / `git_merge` | 当前**冲突**文件用 nvimdiff 三路合并（`git mergetool`） |
| `Alt-g` | 只看仓库改动（`:toggle_git_status`，含冲突文件） |
| `:rm` | 进回收站，不是直接删 |
| `jq` transformer | JSON 预览格式化 |
| 空前缀搜索 | **fuzzy name**（只匹配文件/目录名）。整段路径用 `p/关键字`；`/正则` 仍是按名字的正则 |
| `Ctrl-j` / `Ctrl-k` | 下一行 / 上一行（官方 popular，默认只有方向键） |
| `Ctrl-d` / `Ctrl-u` | 下一页 / 上一页（官方 popular） |

`Ctrl-e` / `:e` 仍用 `$EDITOR` 打开文本。`Ctrl-t` 在当前目录开 shell。

`special_paths`：`/media` 不自动扫、不算大小；`~/.config` 始终显示。官方示例里的 `trav` 已删（本机没有对应目录）。

`:gd`（或输入 `gd`）对当前文件跑 `git difftool -y --tool=nvimdiff`：nvim 左右对照工作区 vs HEAD。这是普通 **difftool**，不是日常 `git diff`（delta），也不是 `git dft`。

`:gm`（或输入 `gm`）对当前文件跑 `git mergetool -y --tool=nvimdiff`：三路打开 LOCAL / BASE / REMOTE，改 **MERGED** 后 `:w`、`:qa`。只对已冲突（unmerged）的文件有意义；普通改动用 `:gd`。`Alt-g` 能把冲突文件筛出来。

两条都在动词里写死 `--tool=nvimdiff`，没改仓库里的 `diff.tool` / `merge.tool`。

### `Ctrl-u` / `Ctrl-d` 原先有没有？

**broot 默认没有绑这两键。** 默认翻页是键盘上的 **PageUp / PageDown**。

容易混的是：

| 键 | 默认是谁的 |
| --- | --- |
| PageUp / PageDown | broot：当前树翻页 |
| `Alt-PageUp` / `Alt-PageDown` | broot：右边面板翻页（已在 verbs 里） |
| `Ctrl-u` / `Ctrl-d` | 终端/Vim 里常见（删到行首 / EOF、半页滚动），**进 broot 之前不翻树** |

现在 `Ctrl-u` / `Ctrl-d` 在 broot 里明确是树翻页，和 `Ctrl-j` / `Ctrl-k` 一套。

未开：modal、`quit_on_last_cancel`、Kitty 扩展键、PDF/Office transformer。

## 常用命令行参数

`br` 和 `broot` 参数相同。写在启动时，或写进 `default_flags`（本机已有 `-g`）。

每个开显示的短选项几乎都有**大写反选项**，用来临时关掉配置里的默认。例如配置了 `-g`，这次不想看 Git：`br -G`。

官方常举的组合：

```bash
br                  # 日常（已带 -g）
br -sdp             # 当 ls：尺寸 + 日期 + 权限
br -w               # 谁占空间（whale-spotting）
br --sort-by-date ~ # 从家目录按修改时间找最近动过的
br --git-status     # 只看 git status 会列出的文件
```

### 显示列

| 参数 | 反选项 | 用途 |
| --- | --- | --- |
| `-g` / `--show-git-info` | `-G` | 文件旁 Git 状态、仓库统计。本机默认已开 |
| `-s` / `--sizes` | `-S` | 显示文件和目录大小（目录是整棵子树合计，后台算） |
| `-d` / `--dates` | `-D` | 显示最后修改时间 |
| `-p` / `--permissions` | `-P` | 显示权限 |
| `--show-root-fs` | | 顶部显示当前文件系统用量（里面也可用 `:fs`） |

### 看见什么 / 看不见什么

| 参数 | 反选项 | 用途 |
| --- | --- | --- |
| `-h` / `--hidden` | `-H` | 显示点文件。里面也可用 `Alt-h` |
| `-i` / `--git-ignored` | `-I` | 显示被 gitignore 的文件。里面也可用 `Alt-i` |
| `-f` / `--only-folders` | `-F` | 只显示目录，深层同名文件不会占满一屏 |
| `--git-status` | | 只留「有 Git 状态」的项（含隐藏），接近 `git status` / 里面的 `Alt-g` |
| `--max-depth <n>` | | 树最深只到 n 层，大仓库搜名字时少被深层淹没 |

### 排序和占空间

排序时**默认只展开一层**（按整棵子树的合计来排）。

| 参数 | 用途 |
| --- | --- |
| `--sort-by-size` | 按大小找占空间的目录/文件 |
| `--sort-by-date` | 按修改时间（含子目录里最新的那个） |
| `--sort-by-count` | 按文件数量 |
| `--sort-by-type` | 按类型，目录在前 |
| `--no-sort` | 取消排序 |
| `-w` / `--whale-spotting` | 按大小排，并打开隐藏 + gitignored，专门清磁盘 |
| `-W` | 关掉 whale 模式（不排序、不强制显示隐藏/忽略） |
| `--tree` / `--no-tree` | 排序时仍显示/不显示多级树 |

### 树怎么裁

| 参数 | 用途 |
| --- | --- |
| `-t` / `--trim-root` | 连第一层也裁，不显示滚动条（更「一屏概览」） |
| `-T` / `--no-trim-root` | 第一层尽量列全，出现滚动条 |

### 其它偶用

| 参数 | 用途 |
| --- | --- |
| `br <目录>` | 从指定根打开，例如 `br ~`、`br /etc` |
| `-c` / `--cmd` | 启动后自动执行动词，分号分隔 |
| `--install` | 重装 `br` shell 函数 |
| `--help` | 完整参数表 |

里面打 `-sdp` 再 Enter，和启动时加同样的开关等效。
