" Make vim non-vi-compatible because that is useless
set nocompatible

" Call our plugin manager
call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-surround'               " Easy surrounding things with brackets
Plug 'tpope/vim-fugitive'               " In-vim git stuff
Plug 'tpope/vim-commentary'             " Easy comment-out stuff
Plug 'tpope/vim-repeat'                 " Enable plugin motion repeat
Plug 'tpope/vim-dispatch'               " Dispatch console cmd
Plug 'tpope/vim-vinegar'                " Better netrw browsing
Plug 'tpope/vim-eunuch'                 " Unix commands made easy
Plug 'junegunn/vim-easy-align'          " Align stuff easily
Plug 'chriskempson/base16-vim'          " All the colors one needs
Plug '/usr/bin/fzf'                     " Fzf integration
Plug 'junegunn/fzf.vim'                 " Preconfigured fzf integration
Plug 'SirVer/ultisnips'                 " Snippets engine
Plug 'honza/vim-snippets'               " Some default snippets
Plug 'w0rp/ale'                         " Syntax checker, requires checker itself
                                        " to be installed
Plug 'itchyny/lightline.vim'            " Statusline, deprecated soon
Plug 'sheerun/vim-polyglot'             " Support for basically all languages
Plug 'ludovicchabant/vim-gutentags'     " CTAGS management
Plug 'maralla/completor.vim'            " Async completion engine
Plug 'junegunn/goyo.vim'                " Distraction free writing
Plug 'junegunn/limelight.vim'           " Even more distraction free writing
Plug 'lervag/vimtex'                    " Better latex support

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

" Auto-linebreak after n characters
set textwidth=79

" Always keep 2 lines after cursor
set scrolloff=2

" Use LF as line ending character
set fileformat=unix
set fileformats=unix,dos

" Disable swap files
set noswapfile

" Allow switching between buffers without having to save
set hidden

" Since airline tells us the mode, vim does not need to
set noshowmode

" Fold by default
set foldmethod=syntax

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

" Colors
" let base16colorspace=256
colorscheme base16-dracula
set background=dark
set termguicolors

" Statusline config
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'Dracula',
      \ }

" Tell vim to assume latex instead of plaintex
let g:tex_flavor='latex'
let g:vimtex_compiler_latexmk = {'callback' : 0}
let g:vimtex_view_method="mupdf"

" UltiSnips config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Completor config
let g:completor_python_binary = 'python'

" EasyAlign key bindings
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Markdown plugin currently not highlighting headers
let g:polyglot_disabled = ['latex']

" Enter all the distraction free writing
autocmd! User GoyoEnter Limelight
autocmd User GoyoEnter ALEDisable
autocmd! User GoyoLeave Limelight!
autocmd User GoyoLeave ALEEnable

" FZF key bindings
nnoremap <silent> <C-p> :Files<cr>
nnoremap <silent> <C-t> :Buffers<cr>
