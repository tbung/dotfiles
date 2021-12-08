-- Always use utf-8
vim.opt.encoding = 'utf-8'

-- Display line numbers relative to current line, makes moving easier
vim.opt.relativenumber = true

-- Display real line number on current line
vim.opt.number = true

-- Highlight found stuff while still searching
vim.opt.incsearch = true

-- Spaces > tabs
vim.opt.expandtab = true

-- 4 spaces = 1 tab
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Display current position in bottom right
vim.opt.ruler = true

-- Autoindent based on previous line
vim.opt.autoindent = true

-- Make backspace behave as expected
vim.opt.backspace =  'indent,eol,start'

-- Disable warning bell
vim.opt.belloff = 'all'

-- Auto-linebreak after n characters
-- vim.opt.textwidth = 79
vim.opt.wrap = false
vim.opt.signcolumn = "yes"

-- Always keep 2 lines after cursor
vim.opt.scrolloff = 4

-- Disable swap files
vim.opt.swapfile = false

-- Allow switching between buffers without having to save
vim.opt.hidden = true

-- Since the cursor tells us the mode, vim does not need to
vim.opt.showmode = false

-- Fold by default
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldtext = "getline(v:foldstart).'...'.trim(getline(v:foldend))"
vim.opt.fillchars = [[fold: ]]
vim.opt.foldnestmax = 3
vim.opt.foldminlines = 1

-- Apparently faster
vim.opt.regexpengine = 0

-- Intuitive splits (bottom/right)
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Colors
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
-- vim.g.tokyonight_transparent = true
vim.cmd('colorscheme tokyonight')

vim.opt.completeopt = 'menuone,noinsert,noselect'
-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

vim.opt.spell = true
vim.opt.spelllang = 'en,de'

vim.cmd [[
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END
]]
