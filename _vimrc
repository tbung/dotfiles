" Make vim non-vi-compatible because that is useless
set nocompatible

" Call our plugin manager
call plug#begin('~\vimfiles\bundle')

Plug 'tpope/vim-surround'               " Easy surrounding things with brackets etc.
Plug 'tpope/vim-fugitive'               " In-vim git stuff
Plug 'tpope/vim-commentary'             " Easy comment-out stuff
Plug 'joshdick/onedark.vim'             " Nice color scheme
Plug 'kien/ctrlp.vim'                   " Fuzzy file finder
Plug 'scrooloose/nerdtree'              " Better file tree

Plug 'SirVer/ultisnips'                 " Snippets engine
Plug 'honza/vim-snippets'               " Some default snippets
Plug 'vim-syntastic/syntastic'          " Syntax checker, requires checker itself to be installed (e.g. flake8 for python)
Plug 'vim-airline/vim-airline'          " Nice status and tab bar
Plug 'vim-airline/vim-airline-themes'   " Make it theme compatible

Plug 'plasticboy/vim-markdown'          " Better markdown support
Plug 'PProvost/vim-ps1'                 " PowerShell support

call plug#end()

" Always use utf-8
set encoding=utf-8

" Display line numbers relative to current line, makes moving easier
set relativenumber

" Display real line number on current line
set number

" Highlight found stuff while still searching
set incsearch

" Spaces > tabs
set expandtab

" 4 spaces = 1 tab
set shiftwidth=4
set softtabstop=4

" Display current position in bottom right
set ruler

" Autoindent based on previous line
set autoindent

" Autoindent based on filetype
filetype plugin indent on

" Make backspace behave as expected
set backspace=indent,eol,start

" Syntax highlighting
syntax on

" Stop vim from waiting for another cmd when pressing esc
set timeout timeoutlen=3000 ttimeoutlen=100

" Disable warning bell
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Auto-linebreak afte 100 characters
set textwidth=100

" Always keep 2 lines after cursor
set scrolloff=2

" Use LF as line ending character
set fileformat=unix
set fileformats=unix,dos

" Disable swap files
set noswapfile

" Allow switching between buffers without having to save
set hidden

" Disable arrow keys in normal mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Disable arrow keys in insert mode
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

colorscheme onedark

" Configure Plugins
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onedark'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

let g:vim_markdown_folding_disabled = 1

map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Make Conemu work
if has('win32') && !has('gui_running') && !empty($CONEMUBUILD)
    set term=xterm
    set t_ut=
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
    onoremap <Char-0x07F> <BS>
    cnoremap <Char-0x07F> <BS>
    set termguicolors
endif
