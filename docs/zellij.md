# Zellij（本机主用）

## 分工

| 场景 | 工具 |
| --- | --- |
| 本机日常分屏 / 会话 | **Zellij** |
| 偶尔 SSH 到服务器 | **tmux**（远端几乎都有，不必装 Zellij） |

自动命名会话 / 进 shell 就挂会话：先不做，需要时再说。

## 安装

```bash
sudo pacman -S --needed zellij
# 若以前装过用户目录二进制，可删：rm ~/.local/bin/zellij
```

## 配置链接

仓库：`setup/.config/zellij/` → `~/.config/zellij`

```bash
ln -sfn ~/setup/.config/zellij ~/.config/zellij
```

当前 UI：

- `default_layout "compact"`：单行底栏
- `simplified_ui true`：不用 powerline 尖角字体
- 底栏插件：**zjstatus**（模式 / 会话 / tabs / git 分支 / 时间）
- `hide_frame_for_single_pane` 必须为 **false**（Zellij 0.44.x 下开会触发窗口抖动 / 反复重布局）

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

## 日常用法

```bash
zellij                 # 新会话
zellij attach -c       # 有则附着，无则新建
zellij ls              # 列出会话
# Ctrl-o → d           # detach（会话保留）
# Ctrl-o → w           # session manager（含复活已退出会话）
```

改完 layout / zjstatus 后建议 **新开会话**（旧会话可能仍用旧布局）。

## 常用键

| 按键 | 作用 |
| --- | --- |
| `Alt h/j/k/l` | 窗格间移动（贴边时 `h/l` 切 tab） |
| `Alt n` | 新窗格 |
| `Alt f` | 浮动窗 |
| `Alt =` / `Alt -` | 放大 / 缩小 |
| `Ctrl p` | Pane 模式（再按 `d/r/x/f`…） |
| `Ctrl t` | Tab 模式 |
| `Ctrl n` | Resize 模式 |
| `Ctrl o` | Session 模式（`d` detach） |
| `Ctrl g` | 锁定 / 解锁（锁住后快捷键不抢应用） |
| `Ctrl q` | 退出会话 |

**已关闭** 默认的 `Ctrl-b`（Zellij「tmux 模式」），避免和 Neovim `<C-b>` 冲突。分屏/会话请用上面的 `Alt-*` / `Ctrl-p/t/o`。

Neovim 里继续用 `Ctrl-hjkl`（smart-splits）；Zellij 窗格导航优先用 `Alt-hjkl`，避免打架。

## 与 tmux

本机已有 `~/.config/tmux`，**保留**：SSH 上去仍用 `tmux`。不要在远端强依赖 Zellij。
