# 下载工具

把文件存到磁盘。和 [http-tools.md](./http-tools.md) 分开：那边是发请求、看响应、抓包；这边是续传、并行、镜像、网盘、同步。

本机选定：

| 场景 | 工具 | 来源 |
| --- | --- | --- |
| HTTP/HTTPS 下载、递归镜像 | `wget2` | AUR |
| 大文件多连接、磁力 / BT / Metalink | `aria2`（命令 `aria2c`） | extra |
| 网盘 / S3 / WebDAV | `rclone` | extra |
| FTP / SFTP 镜像 | `lftp` | extra |
| 主机之间同步 | `rsync` | extra（系统常已带） |

未选中的工具记在文末，只作对照，不要装进日常清单。

## 安装

```bash
sudo pacman -S --needed aria2 rclone lftp rsync
paru -S --needed wget2
```

核对：

```bash
wget2 --version
aria2c --version
rclone version
lftp --version
rsync --version
```

`wget2` 命令是 `wget2`，**不要** `alias wget=wget2`。系统里可能已有经典 `wget`（本机当前如此），脚本和别的包装会继续叫 `wget`。

## 怎么分工

- **一个 URL、镜像静态站** → `wget2`
- **要多连接、种子、磁力、Metalink** → `aria2c`
- **Google Drive / S3 / WebDAV 等网盘** → `rclone`
- **FTP/SFTP 整目录、断点** → `lftp`
- **两台机器、两个目录对齐** → `rsync`

试接口、看 JSON 仍用 `xh` / Bruno / Kulala。`xh -d` 能存文件，但没有镜像、种子、网盘。

---

## wget2

GNU wget 的继任：HTTP/2、默认多线程、brotli/zstd 等压缩。递归镜像语法接近 wget。AUR 包 `wget2`，不进 extra。

```bash
wget2 https://example.com/file.tar.gz
wget2 -O out.bin https://example.com/a
wget2 -c https://example.com/big.iso
wget2 -q --show-progress URL
wget2 --spider https://example.com/
wget2 -r -np -k -p https://example.com/docs/
```

常用差异（相对 wget 1.x）：默认可能走 HTTP/2 和并行连接；对 WAF / 按 UA 分流的站点表现可能不同。配置文件是 `.wget2rc`，不是 `.wgetrc`。不是 100% 掉包替换（WARC、完整 FTP 等 wget 更熟）。

完整选项：`man wget2`。项目：<https://gitlab.com/gnuwget/wget2>。

---

## aria2

命令 `aria2c`。多协议下载器：HTTP(S)、FTP、SFTP、BitTorrent、Metalink。单文件可分块并行，种子/磁力也能下。可开 RPC 给图形前端用。

```bash
aria2c https://example.com/file.tar.gz
aria2c -x 16 -s 16 https://example.com/big.iso    # 每服务器 16 连接，16 分片
aria2c -c URL                                     # 续传
aria2c -i urls.txt                                # 一批 URL
aria2c magnet:?xt=urn:btih:...
aria2c file.torrent
```

| 选项 | 作用 |
| --- | --- |
| `-x N` | 每台服务器最大连接数 |
| `-s N` | 分片数 |
| `-c` | 续传 |
| `-d DIR` | 保存目录 |
| `-o NAME` | 文件名 |
| `--bt-max-peers` | BT 对等数 |

会话文件、RPC（`aria2.launch` / `--enable-rpc`）见 `man aria2c`。Motrix 一类图形工具底层多半是 aria2，本机选定命令行即可。

---

## rclone

把各家网盘、S3、WebDAV 当成远端。拷贝、同步、挂载、加密。先配远端，再操作。

```bash
rclone config                          # 交互添加 remote
rclone lsd myremote:                   # 列顶层
rclone ls myremote:path
rclone copy ./local myremote:backup    # 拷过去（不删远端多余文件）
rclone sync ./local myremote:backup    # 对齐（会删远端多余的，小心）
rclone mount myremote: /mnt/cloud      # 挂载（需 FUSE）
```

配置默认在 `~/.config/rclone/rclone.conf`（可含密钥），**不要**提交进 `~/setup`。支持的后端很多：Drive、Dropbox、S3、B2、WebDAV、SFTP 等，`rclone listremotes` / 文档：<https://rclone.org/>。

`copy` 和 `sync` 不一样：`sync` 会让远端跟本地一模一样，可能删文件。先 `rclone copy` 或 `--dry-run`。

---

## lftp

交互式 / 脚本化 FTP、HTTP、SFTP 客户端，擅长整站镜像和断点。不是网盘聚合器。

```bash
lftp sftp://user@host
lftp -e 'mirror -c /remote ./local; quit' sftp://user@host
```

常用：`mirror`（下）、`mirror -R`（上）、`-c` 续传、`pget` 多连接下单文件。脚本里用 `-e` 或 `-f script`。手册：`man lftp`。

---

## rsync

按文件差异同步目录，走 SSH 或 rsync 协议。不是 HTTP 下载器。本机系统通常已有。

```bash
rsync -aP src/ dest/
rsync -aP ./dir/ user@host:~/dir/
rsync -aP --delete src/ dest/          # 让 dest 与 src 一致（会删）
```

| 选项 | 作用 |
| --- | --- |
| `-a` | 归档（权限、时间、递归等） |
| `-P` | 进度 + 部分文件续传 |
| `-n` / `--dry-run` | 只看将做什么 |
| `--delete` | 删目标上多余的 |

末尾斜杠有意义：`src/` 表示目录内容，`src` 表示连目录本身一起拷。先 `-n` 再真跑。

---

## 未选定（对照）

本机日常清单**不装**这些。功能记在这里，避免以后再搜一轮。

### 通用下载

| 工具 | 功能 |
| --- | --- |
| **wget** | GNU 经典下载器。HTTP/FTP、续传、递归镜像。单线程、无 HTTP/2。系统里可能已有；本机选定 `wget2` 做下载，脚本里的 `wget` 不要改成 wget2 |
| **curl** `-O` / `-C -` | 也能存文件、续传。协议极多。本机当库/脚本底层和 Kulala 后端，不当下载管理器 |
| **axel** | 老牌 HTTP 多线程加速，比 aria2 轻，没有 BT/磁力。extra 有包。并行下载已选 aria2 |
| **xh** `-d` | 把响应存盘。属于 [http-tools.md](./http-tools.md)，不是下载专题的主力 |

### 按网站扒内容

| 工具 | 功能 |
| --- | --- |
| **yt-dlp** | 从 YouTube 等站点下视频/音频。youtube-dl 的事实继任。extra |
| **gallery-dl** | 图站、画廊整页下。AUR |
| **streamlink** | 直播流转文件或丢给播放器。extra |

站点结构由工具解析，不是普通 URL 另存为。需要时再装，不进选定清单。

### 图形下载器 / BT

| 工具 | 功能 |
| --- | --- |
| **Motrix** | 开源图形下载器，引擎 aria2。原项目维护停滞 |
| **Motrix Next** | 用 Tauri 重写的继任，引擎为维护中的 aria2 fork（Aria2 Next）。AUR `motrix-next-bin` |
| **Persepolis** | aria2 的图形前端 |
| **qBittorrent** | BT/磁力图形客户端。extra |
| **Transmission** | 另一套 BT 客户端（CLI/图形）。extra 有 `transmission-cli` 等 |
| **FDM**（Free Download Manager） | 闭源图形下载器，Windows/Linux 都有人用 |
| **IDM** | Windows 商业下载器，不面向本机 Linux 工作流 |

图形层多半包的是 aria2 或 BT。本机用 `aria2c` 即可，不装桌面下载器。

### 其它

| 工具 | 功能 |
| --- | --- |
| **you-get** / **lux** | 中文圈常见的视频 CLI，覆盖面和活跃度一般不如 yt-dlp |
| **croc** / **magic-wormhole** | 人与人之间传文件，不是从 URL 下载 |
| **scp** / **sftp** | OpenSSH 自带拷文件；整目录镜像更适合 lftp/rsync |
