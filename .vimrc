" ╔══════════════════════════════════════════╗
" ║              Vim 基础配置                ║
" ╚══════════════════════════════════════════╝

" ── 基础设置 ──────────────────────────────
set nocompatible               " 关闭 Vi 兼容模式，启用 Vim 全部功能
filetype plugin indent on      " 启用文件类型检测、插件、自动缩进
syntax on                      " 语法高亮

" ── 界面显示 ──────────────────────────────
set number                     " 显示绝对行号
set relativenumber             " 显示相对行号（方便 5j / 10k 跳转）
set cursorline                 " 高亮当前行
set colorcolumn=80             " 80 列参考线
set list                       " 显示不可见字符
set listchars=tab:→\ ,trail:·,extends:›,precedes:‹  " 不可见字符样式
set showcmd                    " 右下角显示正在输入的命令
set wildmenu                   " 命令行补全增强（Tab 补全菜单）
set laststatus=2               " 始终显示状态栏
set scrolloff=5                " 光标距顶/底保留 5 行视野
set sidescrolloff=5            " 光标距左/右保留 5 列视野
set showmatch                  " 高亮匹配括号

" ── 剪贴板 ────────────────────────────────
set clipboard=unnamedplus      " y/p 直接读写系统剪贴板（需 vim 支持 +clipboard）

" ── 鼠标 ──────────────────────────────────
set mouse=a                    " 启用鼠标支持（所有模式）

" ── 缩进 ──────────────────────────────────
set autoindent                 " 自动缩进（新行继承上一行缩进）
set smartindent                " 智能缩进（根据语法自动调整）
set expandtab                  " Tab 转为空格
set tabstop=4                  " Tab 显示宽度为 4 空格
set shiftwidth=4               " 自动缩进宽度为 4 空格
set softtabstop=4              " 插入模式下 Tab 键宽度

" ── 搜索 ──────────────────────────────────
set hlsearch                   " 高亮所有匹配结果
set incsearch                  " 实时搜索（输入时即时跳转）
set ignorecase                 " 搜索时忽略大小写
set smartcase                  " 输入大写字母时区分大小写

" ── 文件 & 历史 ───────────────────────────
set noswapfile                 " 禁用 swap 文件（避免 .swp 垃圾文件）
set nobackup                   " 禁用备份文件
set undofile                   " 持久化撤销历史（重启后仍可撤销）
set undodir=~/.vim/undo        " 撤销历史存放目录
set history=500                " 命令历史记录条数
set autoread                   " 文件在外部被修改时自动重新读取
set encoding=utf-8             " 内部编码 UTF-8
set fileencodings=utf-8,gbk    " 文件编码自动检测顺序

" ── 性能 & 行为 ───────────────────────────
set updatetime=250             " 更快的响应（默认 4000ms，影响 CursorHold）
set timeoutlen=500             " 快捷键超时时间（ms）
set hidden                     " 切换 buffer 时不强制保存
set splitright                 " 垂直分屏在右侧打开
set splitbelow                 " 水平分屏在下方打开
set backspace=indent,eol,start " 退格键可删除缩进、换行、插入点前的字符

" ── 创建撤销历史目录 ──────────────────────
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p')
endif

" ══════════════════════════════════════════
"                  键位映射
" ══════════════════════════════════════════

" leader 键设为空格
let mapleader = " "

" ── 常用操作 ──────────────────────────────
nnoremap <leader>w :w<CR>         " 空格+w 保存
nnoremap <leader>q :q<CR>         " 空格+q 退出
nnoremap <leader>Q :q!<CR>        " 空格+Q 强制退出
nnoremap <leader>h :nohlsearch<CR> " 空格+h 取消搜索高亮

" ── 快速退出插入模式 ──────────────────────
inoremap jk <Esc>

" ── 缩进后保持选中 ────────────────────────
vnoremap < <gv
vnoremap > >gv

" ── 上下移动行 ────────────────────────────
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ── 分屏导航（与 kitty 对应） ─────────────
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ── 分屏大小调整 ──────────────────────────
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>
nnoremap <C-Up>    :resize -2<CR>
nnoremap <C-Down>  :resize +2<CR>

" ── Buffer 切换 ───────────────────────────
nnoremap <leader>bn :bnext<CR>     " 下一个 buffer
nnoremap <leader>bp :bprevious<CR> " 上一个 buffer
nnoremap <leader>bd :bdelete<CR>   " 关闭当前 buffer
