# HTTP 工具

本机选定：

| 场景 | 工具 | 文件 |
| --- | --- | --- |
| 终端打一条 | `xh` | 无 |
| 图形界面维护集合 | Bruno | `.bru`（一请求一文件） |
| 同一份集合进 CI | Bruno CLI（`bru`） | 同上；**暂时不装** |
| Neovim 里写请求 | Kulala | `.http` |
| 看/改真实流量 | `mitmproxy` | 无（中间人） |

`jq` 见 [cli-tools.md](./cli-tools.md)，给 `xh` 管道用。  
Kulala 走 LazyVim extra `util.rest`，见 [lazyvim.md](./lazyvim.md)；旧 vimpack 细项见 [neovim-config.md](./neovim-config.md)。

落盘只有两种：项目集合用 **`.bru`**（GUI 和 CI 同一份）；nvim 里用 **`.http`**。不要再引入 Hurl / Posting。`.bru` 和 `.http` 不能互相打开。

## 安装

```bash
sudo pacman -S --needed xh mitmproxy
paru -S --needed bruno-bin
```

- `xh` / `mitmproxy`：extra
- Bruno 图形界面：AUR `bruno-bin`（官方 deb 解包，自带 Electron）。要从源码编、用系统 Electron 则装 `bruno`
- Bruno CLI：**暂时不装**。AUR/extra 没有官方 `bru` 包；图形包也不含 CLI。需要 CI 时再装，见下节。

核对：

```bash
xh --version
mitmproxy --version
command -v bruno
```

Neovim 打开 `.http` 应能 `<leader>Rs` 发送。extra 在 `setup/.config/nvim/lazyvim.json` 的 `util.rest`；关掉了就 `:LazyExtras` 再打开。

## 怎么分工

- **随手一条、看 JSON** → `xh`，需要时 `| jq`
- **收藏、环境、点着改** → Bruno 打开项目里的 collection 目录
- **CI / 回归** → 同一目录 `bru run`（本机暂不装 CLI）
- **在 nvim 里对着接口改草稿** → `.http` + Kulala（不必进 Bruno 集合）
- **浏览器/App/别的客户端实际发出去的包** → `mitmproxy`

系统 `curl` 给脚本和 Kulala 后端用，不当日常手感。下载、网盘、同步见 [download-tools.md](./download-tools.md)。

---

## xh

HTTPie 的 Rust 实现。发一次请求，默认 JSON，4xx/5xx 非零退出。HTTPS 用 `xhs`。

```bash
xh :8080/api/users
xhs example.com/health
xh POST :8080/login name=me age:=24
xh GET :8080/search q==nvim x-api-key:secret
xh POST :8080/upload --form file@photo.jpg
xh -v GET :8080/me
xh GET :8080/api/users | jq '.[0].id'
xh --curl POST :8080/login name=me
xh -d :8080/export -o out.json
```

| 写法 | 含义 |
| --- | --- |
| `key=value` | JSON 字符串字段（默认 POST 成 JSON） |
| `key:=24` | 非字符串 JSON |
| `key==value` | query |
| `Header:value` | 请求头 |
| `:8080/path` | `http://localhost:8080/path` |
| `-f` / `--form` | 表单，不是 JSON |
| `--session FILE` | 记住 cookie |
| `--curl` | 打印等价 curl |
| `--proxy http:http://127.0.0.1:8080` | 走 mitmproxy（见下） |

`xh help` 比 `--help` 长。

---

## Bruno

Git 原生 API 客户端：集合是磁盘上的文件夹，每个请求一个 `.bru`，用 Git 协作，不用账号。图形界面改、以后 CLI 跑，是**同一份文件**。当前只装图形界面。

在 Bruno 里 Open Collection，选仓库里的目录（例如 `api/`）。不要把业务请求丢进 App 的默认位置。

```bru
meta {
  name: login
  type: http
}

post {
  url: {{base_url}}/login
  body: json
  auth: none
}

headers {
  Content-Type: application/json
}

body:json {
  {
    "name": "me"
  }
}

assert {
  res.status: eq 200
  res.body.token: isString
}
```

简单校验用 `assert { }`；复杂逻辑用 `tests { }`（JavaScript，`res` / `expect`）。环境是 collection 旁的 `.bru` 环境文件，变量写成 `{{base_url}}`。可从 Postman v2.1 / OpenAPI 导入。

### CLI（暂时不装）

本机现在不需要 `bru`。Arch extra / AUR 没有官方 CLI 包。以后要进 CI 再装，不要 `npm install -g`（mise 换 Node 版本会丢）。用 mise：

```bash
mise use -g npm:@usebruno/cli
```

CI 不要依赖本机全局：workflow 里装 `@usebruno/cli`，或官方 `usebruno/cli` 镜像 / `usebruno/bruno-cli-action`。

本仓库**不**链 Bruno 的 App 配置。集合文件放各项目，不放 `~/setup`。

---

## Kulala（Neovim）

当前 `~/.config/nvim` 已开 **`util.rest`** → `mistweaverco/kulala.nvim`。打开 `.http` 即可。这是编辑器里的草稿/试调，**不是** Bruno 集合的替代格式。Leader `<Space>`，前缀 `<leader>R`。

```http
### login
POST http://localhost:8080/login
Content-Type: application/json

{
  "name": "me"
}

### me
GET http://localhost:8080/me
Authorization: Bearer {{token}}
```

请求之间用 `###` 分开。

| 按键 | 作用 | 范围 |
| --- | --- | --- |
| `<leader>Rs` | 发送当前请求 | `.http` |
| `<leader>Rr` | 重放上次 | 全局 |
| `<leader>Rb` | Scratchpad | 全局 |
| `<leader>Rn` / `<leader>Rp` | 下 / 上一条 | `.http` |
| `<leader>Rc` / `<leader>RC` | 复制为 curl / 从 curl 粘贴 | `.http` |
| `<leader>Re` | 选环境 | `.http` |
| `<leader>Rq` | 关响应窗 | `.http` |
| `<leader>Rt` | 切换 header / body | `.http` |

which-key 里 `<leader>R` 是 Rest。要以弹出为准。

依赖系统 `curl`（Kulala 下 `kulala-core`）。WSL 不要让 Windows `curl.exe` 排在 Linux `curl` 前面。旧 vimpack 为此改过 `PATH`，当前 extra **没有**这段；发不出请求先 `which curl`。

旧 vimpack 的右侧 split / LSP / 会话恢复见 [neovim-config.md](./neovim-config.md)，**不会**自动套到 LazyVim extra。

稳定下来的请求再拷进 Bruno 的 `.bru`，不要两套都当唯一真相。

---

## mitmproxy

交互式 HTTPS 代理，看别人发出去的流量（浏览器、App、`xh`、Bruno）。不是集合客户端。

三个入口：

| 命令 | 界面 |
| --- | --- |
| `mitmproxy` | 终端 TUI |
| `mitmweb` | 浏览器，类似 DevTools |
| `mitmdump` | 无界面 + Python addon |

默认监听 `127.0.0.1:8080`。第一次运行会在 `~/.mitmproxy/` 生成 CA。要解密 HTTPS，客户端必须信任 `mitmproxy-ca-cert.pem`（私钥在 `mitmproxy-ca.pem`，不要提交、不要外传）。浏览器可先走代理再打开 <http://mitm.it> 装证书。

`xh` 走代理：

```bash
xh --proxy http:http://127.0.0.1:8080 \
  --verify ~/.mitmproxy/mitmproxy-ca-cert.pem \
  GET https://example.com
```

Bruno：Preferences / 请求设置里把 HTTP(S) proxy 指到 `127.0.0.1:8080`，并信任上述 CA（或仅在调试时关 SSL verify）。调完关掉代理，避免平时流量都进 mitmproxy。

系统 `curl` 同类写法：`--proxy 127.0.0.1:8080 --cacert ~/.mitmproxy/mitmproxy-ca-cert.pem`。
