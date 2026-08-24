# Neovim 配置文档（LazyVim）

> 当前使用的配置：`~/setup/.config/nvim` → `~/.config/nvim`。  
> 旧版 `vim.pack` 配置见 [neovim-config.md](./neovim-config.md)（`~/setup/.config/nvim-vimpack`）。

本仓库在 [LazyVim](https://www.lazyvim.org/) 上只做少量覆盖：配色、缩进显示、SQL（dadbod）、splitjoin、与 Kitty / tmux 联动的 `<C-hjkl>`，以及若干 `Alt-Shift` 改键。nvim 里的 HTTP 客户端是 extra **`util.rest`**（Kulala / `.http`）。项目集合用 Bruno 图形界面，终端打一条用 `xh`，抓包用 `mitmproxy`；Bruno CLI 暂时不装。见 [http-tools.md](./http-tools.md)。

## 配置结构

```text
~/setup/.config/nvim/
├── init.lua
├── lazyvim.json                  # LazyExtras
├── kitty-scrollback-kitten.lua   # Ctrl+Shift+H 用的精简 -u（不进 LazyVim）
└── lua/
    ├── config/
    │   ├── lazy.lua
    │   ├── options.lua
    │   ├── keymaps.lua   # <C-hjkl> 跨窗格；q 关窗；gs 给 splitjoin
    │   └── autocmds.lua
    └── plugins/
        ├── snacks.lua        # picker / LSP words 的 Alt-Shift 改键
        ├── smart-splits.lua  # <C-hjkl> ↔ Kitty / tmux
        ├── kitty-scrollback.lua
        ├── indent.lua
        ├── colorscheme.lua
        ├── splitjoin.lua
        └── dadbod.lua
```

## `Alt-Shift` 改键

> **Zellij 已作废**（[zellij.md](./zellij.md)）。移动行已恢复 LazyVim 默认 `Alt-j` / `Alt-k`。下列改键当初是为了避开 Zellij Locked 白名单，配置仍保留。

| LazyVim 默认 | 本仓库 | 作用 | 配置位置 |
| --- | --- | --- | --- |
| `Alt-h` | `Alt-Shift-h` | picker：切换隐藏文件 | `lua/plugins/snacks.lua` |
| `Alt-f` | `Alt-Shift-f` | picker：toggle follow | `lua/plugins/snacks.lua` |
| `Alt-n` | `Alt-Shift-n` | LSP：下一处引用（Snacks words） | `lua/plugins/snacks.lua` |

`Alt-p`（words 上一处引用）仍是默认。Picker 内按 `?` 可核对当前键。

## smart-splits（`<C-hjkl>` 跨窗格）

插件：[mrjones2014/smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)。  
本机日常是 **Kitty 窗格里开 nvim**；远端 SSH 仍用 **tmux**。同一套 `<C-hjkl>` 在三种东西之间跳：

1. Neovim 自己的分屏（`:split` / `:vsplit`）
2. 旁边的 Kitty 窗格（例如一侧 nvim、一侧 `agent`）
3. tmux pane（`$TMUX` 有值时插件走 tmux，不走 Kitty）

只装插件不够。Kitty 默认不听 nvim 的话，`<C-h>` 到最左边分屏就停住，出不去。还要 Kitty 开遥控、两边键位对齐。这些已经写在配置里，**不用自己写脚本**。

### 一次按键怎么走

以 `Ctrl-h`（向左）为例：

```text
焦点在普通 Kitty 终端
  → Kitty 自己的 map：neighboring_window left（切到左边窗格）

焦点在 nvim（Kitty 用户变量 IS_NVIM=true）
  → Kitty 把 Ctrl-h 放行给 Neovim
  → smart-splits.move_cursor_left()
       ├─ 左边还有 nvim 分屏 → :wincmd h
       └─ 已经在最左边
            ├─ 在 Kitty 里 → 经 socket 让 Kitty 切到左边窗格
            └─ 在 tmux 里 → 让 tmux select-pane -L
```

`at_edge = "stop"`：贴边且外面没有窗格时停住。Kitty 侧不支持 `wrap`（绕到对面）。

### 为什么必须开 Kitty 遥控

遥控 = 已经在跑的 Kitty 听一个 Unix socket，允许 `kitty @` / kitten 对它发指令（切窗格、读滚动缓冲等）。  
nvim 贴边之后，smart-splits 就是靠这个 socket 说「切到左边那个窗格」。

本仓库：

| 项 | 值 | 作用 |
| --- | --- | --- |
| `allow_remote_control` | `socket-only` | 只认 socket，不认终端里打的遥控命令 |
| `listen_on` | `unix:${HOME}/.cache/kitty/kitty-{kitty_pid}` | 每个 Kitty 进程一个 socket；nvim 读环境变量 `KITTY_LISTEN_ON` |
| `~/.cache/kitty` | `env.sh` / `env.fish` 里建成 700 | 目录必须先存在 |

这不是 SSH，也不是保存 session。改 `allow_remote_control` / `listen_on` 后要**完全退出 Kitty 再开**，只 `Ctrl+Shift+F5` 不够，socket 不会在旧进程上长出来。

Kitty 侧键位见 [kitty-config.md](./kitty-config.md)。要点：

- 先 `map ctrl+h neighboring_window left`（以及 j/k/l）
- 再 `map --when-focus-on var:IS_NVIM ctrl+h`（无动作 = 放行给 nvim）

### 本仓库文件（都不用手写 kitten）

| 文件 | 做什么 |
| --- | --- |
| `lua/plugins/smart-splits.lua` | 装插件；`lazy = false`；`build` 拷官方 kitten |
| `lua/config/keymaps.lua` | 覆盖 LazyVim 的 `<C-w>hjkl`，改走 `smart_splits.move_cursor_*` |
| `~/.config/kitty/kitty.conf` | 遥控、socket、`Ctrl-hjkl` 与 `IS_NVIM` 条件映射 |
| `~/.config/kitty/*.py` | `install-kittens.bash` 从插件仓库拷来（`neighboring_window.py` 等），**不进 git** |

`lazy = false` 是必须的：插件一启动就给当前 Kitty 窗口写用户变量 `IS_NVIM`。若 lazy-load，第一次按 `<C-h>` 时 Kitty 还当这是普通终端，会把键吃掉，焦点出不去也进不来。

`build = "./kitty/install-kittens.bash"` 只是把插件自带的 Python kitten 拷到 `~/.config/kitty/`。第一次 `:Lazy` 同步或本机已跑过一次即可。丢了就再执行：

```bash
bash ~/.local/share/nvim/lazy/smart-splits.nvim/kitty/install-kittens.bash
```

### 键位（刻意没绑缩放）

| 键 | 焦点在 nvim | 焦点在普通 Kitty 窗格 |
| --- | --- | --- |
| `Ctrl-h/j/k/l` | 分屏 → 贴边再跳 Kitty / tmux 窗格 | 切 Kitty 窗格 |
| `Alt-j` / `Alt-k` | LazyVim 默认：上下移动行 | 终端自己的 Alt（本仓库不拿来缩放） |
| `Ctrl+Shift+Alt+hjkl` | Kitty 缩放窗格 | 同上 |

不把缩放绑到 `Alt-hjkl`：那是旧 nvim-vimpack / Zellij 时代的做法，会和移行使冲突。

tmux 里 `C-hjkl` 仍由 `tmux.conf.local` 的 `@pane-is-vim` 转发，见 [tmux-wsl.md](./tmux-wsl.md)。nvim 里 `Alt-j/k` 已是移行使；tmux 里未聚焦 nvim 时，`Alt-hjkl` 仍可能缩放 pane（那是 tmux 侧旧绑定）。

### 怎么确认在工作

1. 完全退出并重开 Kitty。
2. `Ctrl+Shift+\` 或 `'` 再开一个窗格，一边 `nvim`，一边留在 shell。
3. 在 nvim 里按 `<C-hjkl>`，应能进到 shell 窗格；再按应能回来。
4. 在 nvim 里 `:echo $KITTY_LISTEN_ON` 应是 `unix:/home/…/.cache/kitty/kitty-…`。空的 = 当前 Kitty 还是旧进程，或没读到 `listen_on`。

常见失败：只重载了 `kitty.conf`；`~/.cache/kitty` 不存在；smart-splits 被改成 lazy-load；Kitty 窗口里套了 tmux 又套 nvim（键会先被 tmux 接住，不要嵌套）。

### kitty-scrollback（同一套遥控）

`Ctrl+Shift+H` 用 [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim) 在 Neovim 里翻终端历史（同样依赖遥控读滚动缓冲）。为避开本仓库 `q` 关窗，kitten 走精简 `-u`：`kitty-scrollback-kitten.lua`（Tokyo Night + 本插件）。`Ctrl+Shift+G` 打开上一条命令输出；`Ctrl+Shift` + 右键打开点选的那条。

## 其它本仓库覆盖

| 文件 | 作用 |
| --- | --- |
| `lua/config/options.lua` | 空白字符显示；Nerd Font；GUI 字体 |
| `lua/plugins/indent.lua` | Snacks indent 用 `·`，与 listchars 对齐 |
| `lua/plugins/colorscheme.lua` | TokyoNight `night`：函数名加粗 |
| `lua/plugins/splitjoin.lua` | mini.splitjoin：`gS` / `gss` / `gsj` |
| `lua/plugins/dadbod.lua` | 练习库 MySQL 连接；避免占用 `<leader>S` |
| `lazyvim.json` → `util.rest` | Kulala：`.http` 文件里 `<leader>Rs` 发送请求 |

Leader 仍是 LazyVim 默认 `<Space>`。`<leader>ff` 找文件，`<leader>/` 或 `<leader>sg` grep。`.http` 快捷键见 [http-tools.md](./http-tools.md)。
