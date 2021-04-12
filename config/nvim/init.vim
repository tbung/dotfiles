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

Plug 'justinmk/vim-sneak'               " Fast moving around
Plug 'wellle/targets.vim'
Plug 'junegunn/vim-easy-align'          " Align stuff easily
Plug 'mbbill/undotree'

" Colors
Plug 'connorholyday/vim-snazzy'

" FZF
" Plug 'junegunn/fzf'                     " Fzf integration
" Plug 'junegunn/fzf.vim'                 " Preconfigured fzf integration
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" IDE-like features

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

Plug 'jpalardy/vim-slime'
Plug 'ludovicchabant/vim-gutentags'     " CTAGS management
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'liuchengxu/vista.vim'             " Tag tree sidebar
" Plug 'dense-analysis/ale'               " Syntax checker, requires checker itself
                                        " to be installed

" Language-specific stuff
" Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for': ['python'] }
Plug 'psf/black', { 'branch': 'stable', 'for': ['python'] }
Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['javascript', 'typescript'] }

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

" Since the cursor tells us the mode, vim does not need to
set noshowmode

" Fold by default
" set foldmethod=syntax
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Apparently faster
set regexpengine=0

" Intuitive splits (bottom/right)
set splitbelow
set splitright

" set spell spelllang=en_us,de_de
" highlight clear SpellBad
" highlight SpellBad gui=undercurl
highlight clear Conceal

" Colors
let &t_8f = "38;2;%lu;%lu;%lum"
let &t_8b = "48;2;%lu;%lu;%lum"
set termguicolors
colorscheme snazzy
set background=dark

au! BufRead,BufNewFile *.md set filetype=markdown
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1

let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

let g:vimtex_grammar_textidote =  {'jar': '/opt/textidote/textidote.jar',
                                  \ 'args': '--read-all'}

" Set up language servers
lua require('lspconfig').jedi_language_server.setup{}
lua require('lspconfig').texlab.setup{}
lua require('lspconfig').tsserver.setup{}


" Set up completion
autocmd BufEnter * lua require'completion'.on_attach()
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
" Show snippets in completion
let g:completion_enable_snippet = 'UltiSnips'
"map <c-p> to manually trigger completion
imap <silent> <c-p> <Plug>(completion_trigger)

" LSP Keybinding
" TODO: Only load them when an LSP is active
nnoremap <silent> 1gD        <cmd> lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <C-k>      <cmd> lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rn <cmd> lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <c-k>      <cmd> lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K          <cmd> lua vim.lsp.buf.hover()<CR>
nnoremap <silent> H          <cmd> lua vim.lsp.buf.hover()<CR>
nnoremap <silent> g0         <cmd> lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gD         <cmd> lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gW         <cmd> lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd         <cmd> lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-]>      <cmd> lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>sd <cmd> lua vim.lsp.buf.show_line_diagnostics()<CR>

" Enable treesitter based highlight, indent and text objects
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
EOF
