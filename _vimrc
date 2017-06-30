set nocompatible

call plug#begin('~\vimfiles\bundle')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'joshdick/onedark.vim'
Plug 'kien/ctrlp.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'plasticboy/vim-markdown'

call plug#end()

set encoding=utf-8
set relativenumber
set number
set incsearch
set expandtab
set shiftwidth=4
set softtabstop=4
set ruler
set autoindent
set smartindent
set backspace=indent,eol,start
filetype plugin indent on
syntax on
set textwidth=100
set timeout timeoutlen=3000 ttimeoutlen=100

" Allow easy buffer switching
set hidden
map <C-T> :buffers<CR>:buffer<Space>

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

colorscheme onedark

" Configure Plugins
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onedark'

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Make Conemu work
if has('win32') && !has('gui_running') && !empty($CONEMUBUILD)
    set term=xterm
    "set t_ut=
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
    set termguicolors
endif

if has("gui_running")
    " GUI is running or is about to start.
    " Maximize gvim window.
    set lines=42 columns=120
    set guifont=Hack:h12:b
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
endif
