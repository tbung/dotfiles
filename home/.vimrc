filetype plugin indent on
syntax on

set nocompatible
set belloff=all
set hidden
set encoding=utf-8
set nohlsearch
set termguicolors
set incsearch
set laststatus=2
set number
set relativenumber
set smarttab
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set ttimeout
set ttimeoutlen=50
set noswapfile
set nobackup
set undofile
set autoread

if !isdirectory($HOME . "/.local/state/vim/undo")
    call mkdir($HOME . "/.local/state/vim/undo", "p", 0700)
endif
set undodir=~/.local/state/vim/undo

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
  runtime ftplugin/man.vim
endif

colorscheme catppuccin_mocha
