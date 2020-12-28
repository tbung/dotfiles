" Make vim non-vi-compatible because that is useless
set nocompatible

" Call our plugin manager
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

" TPope utilities
Plug 'tpope/vim-surround'               " Easy surrounding things with brackets
Plug 'tpope/vim-fugitive'               " In-vim git stuff
Plug 'tpope/vim-commentary'             " Easy comment-out stuff
Plug 'tpope/vim-repeat'                 " Enable plugin motion repeat
Plug 'tpope/vim-dispatch'               " Dispatch console cmd
Plug 'tpope/vim-eunuch'                 " Unix commands made easy
Plug 'tpope/vim-abolish'		" Smart replace words

Plug 'justinmk/vim-sneak'
Plug 'wellle/targets.vim'
Plug 'junegunn/vim-easy-align'          " Align stuff easily

" Colors
Plug 'connorholyday/vim-snazzy'

" FZF
Plug 'junegunn/fzf'                     " Fzf integration
Plug 'junegunn/fzf.vim'                 " Preconfigured fzf integration

" IDE-like features
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jpalardy/vim-slime'
Plug 'ludovicchabant/vim-gutentags'     " CTAGS management
Plug 'preservim/nerdtree'
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for': ['python'] }
Plug 'psf/black', { 'branch': 'stable', 'for': ['python'] }
Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['javascript', 'typescript'] }
Plug 'dense-analysis/ale'               " Syntax checker, requires checker itself
                                        " to be installed

" Support all the languages
" let g:polyglot_disabled = ['latex', 'markdown']
" Plug 'sheerun/vim-polyglot'
" Plug 'HerringtonDarkholme/yats.vim'

" Writing
Plug 'godlygeek/tabular', { 'for': 'markdown' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'lervag/vimtex'                    " Better latex support
Plug 'junegunn/goyo.vim'                " Distraction free writing
Plug 'junegunn/limelight.vim'           " Even more distraction free writing
Plug 'vimwiki/vimwiki'

" Snippets
Plug 'SirVer/ultisnips'                 " Snippets engine
Plug 'honza/vim-snippets'               " Some default snippets

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

set regexpengine=0

" Intuitive splits (bottom/right)
set splitbelow
set splitright

set spell spelllang=en_us,de_de
highlight clear SpellBad
highlight SpellBad gui=undercurl

" Colors
let &t_8f = "38;2;%lu;%lu;%lum"
let &t_8b = "48;2;%lu;%lu;%lum"
set termguicolors
colorscheme snazzy
set background=dark

au! BufRead,BufNewFile *.md set filetype=markdown
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
