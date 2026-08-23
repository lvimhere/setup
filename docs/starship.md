# Starship

跨 shell 提示符。包见 [cli-tools.md](./cli-tools.md)。Arch / CachyOS 用官方 `extra/starship`，不用 AUR。

终端已是 Hack Nerd Font Mono（见 [font-setup.md](./font-setup.md)），Powerline 箭头和 Nerd 图标可以直接用。

## 配置链接

仓库：`setup/.config/starship.toml` → `~/.config/starship.toml`

```bash
ln -sfn ~/setup/.config/starship.toml ~/.config/starship.toml
```

`env.sh` / `env.fish` 在交互壳里执行 `starship init`（未安装则跳过）。

zsh 不直接 source 发行版那份 `/usr/share/cachyos-zsh-config/cachyos-config.zsh`（完整配置，里面写死了 Powerlevel10k）。仓库里有一份去掉 p10k、并改成 **vim 键位** 的副本，见 [shell.md](./shell.md)。Normal 模式下提示符变成 `❮`。

## 布局（官方 Tokyo Night + 社区常见五项）

主题底是 [Tokyo Night preset](https://starship.rs/presets/tokyo-night)，再按社区常见用法拼在一起：

| # | 做法 | 本机 |
| --- | --- | --- |
| 1 | Powerline 色块 | 左：OS → 路径 → git → 语言，圆角 `` |
| 2 | 两行提示 | 第一行状态，第二行只有 `❯` |
| 3 | 左侧尽量少 | 不显示用户名（SSH 时除外）、hostname、package 版本 |
| 4 | 开发信息、不刷版本号 | Node / Python / Rust / Go 只出图标；Python 有 venv 时带名字 |
| 5 | 右侧次要信息 | `$fill` 把耗时、jobs、k8s、AWS、时间推到第一行右边 |

k8s 只在项目里出现（`Chart.yaml` / `kustomization.yaml` / `.k8s` 等）或设了 `KUBECONFIG`。AWS 只在已有凭证 / profile 时出现。命令耗时超过 3 秒才显示。

`CachyOS` 的 OS 图标和 Arch 一样用 `󰣇`。

## 重装后

```bash
sudo pacman -S --needed starship
ln -sfn ~/setup/.config/starship.toml ~/.config/starship.toml
```

开一个新终端即可。当前会话可以 `exec zsh`（或 `exec fish` / `exec bash`）。