-- Always use utf-8
vim.o.encoding = 'utf-8'

-- Display line numbers relative to current line, makes moving easier
vim.wo.relativenumber = true

-- Display real line number on current line
vim.wo.number = true

-- Highlight found stuff while still searching
vim.o.incsearch = true

-- Spaces > tabs
vim.o.expandtab = true

-- 4 spaces = 1 tab
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Display current position in bottom right
vim.o.ruler = true

-- Autoindent based on previous line
vim.o.autoindent = true

-- Autoindent based on filetype
-- filetype plugin indent on

-- Make backspace behave as expected
vim.o.backspace =  'indent,eol,start' 

-- Syntax highlighting
-- syntax on

-- Stop vim from waiting for another cmd when pressing esc
-- vim.o.timeout =truetimeoutlen=3000 ttimeoutlen=100

-- Disable warning bell
-- vim.o.noerrorbells visualbell t_vb=
-- autocmd GUIEnter * vim.o.visualbell t_vb=
vim.o.belloff = 'all'

-- Auto-linebreak after n characters
vim.o.textwidth = 79

-- Always keep 2 lines after cursor
vim.o.scrolloff = 2

-- Use LF as line ending character
-- vim.o.fileformat = unix
-- vim.o.fileformats=unix,dos

-- Disable swap files
vim.o.swapfile = false

-- Allow switching between buffers without having to save
vim.o.hidden = true

-- Since the cursor tells us the mode, vim does not need to
vim.o.showmode = false

-- Fold by default
-- vim.o.foldmethod=syntax
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- Apparently faster
vim.o.regexpengine = 0

-- Intuitive splits (bottom/right)
vim.o.splitbelow = true
vim.o.splitright = true

-- Colors
-- let &t_8f = --38;2;%lu;%lu;%lum--
-- let &t_8b = --48;2;%lu;%lu;%lum--
vim.o.termguicolors = true
-- vim.g.colors_name = 'snazzy'
-- vim.g.tokyonight_style = "night"
vim.g.sonokai_style = 'andromeda'
vim.g.sonokai_enable_italic = true
vim.g.sonokai_diagnostic_virtual_text = 'colored'
vim.o.background = 'dark'
vim.cmd('colorscheme sonokai')

vim.o.completeopt = 'menuone,noinsert,noselect'
-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

vim.wo.spell = true
vim.o.spelllang = 'en_us,de_de'
