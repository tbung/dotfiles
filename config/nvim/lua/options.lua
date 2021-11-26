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

-- Autoindent based on filetype
-- filetype plugin indent on

-- Make backspace behave as expected
vim.opt.backspace =  'indent,eol,start'

-- Syntax highlighting
-- syntax on

-- Stop vim from waiting for another cmd when pressing esc
-- vim.opt.timeout =truetimeoutlen=3000 ttimeoutlen=100

-- Disable warning bell
-- vim.opt.noerrorbells visualbell t_vb=
-- autocmd GUIEnter * vim.opt.visualbell t_vb=
vim.opt.belloff = 'all'

-- Auto-linebreak after n characters
-- vim.opt.textwidth = 79
vim.opt.wrap = false
vim.opt.signcolumn = "yes"

-- Always keep 2 lines after cursor
vim.opt.scrolloff = 2

-- Use LF as line ending character
-- vim.opt.fileformat = unix
-- vim.opt.fileformats=unix,dos

-- Disable swap files
vim.opt.swapfile = false

-- Allow switching between buffers without having to save
vim.opt.hidden = true

-- Since the cursor tells us the mode, vim does not need to
vim.opt.showmode = false

-- Fold by default
-- vim.opt.foldmethod=syntax
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
-- let &t_8f = --38;2;%lu;%lu;%lum--
-- let &t_8b = --48;2;%lu;%lu;%lum--
vim.opt.termguicolors = true
vim.opt.background = 'dark'
-- vim.g.colors_name = 'snazzy'
-- vim.g.tokyonight_style = "storm"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
-- vim.g.tokyonight_transparent = true
vim.cmd('colorscheme tokyonight')
-- vim.g.sonokai_style = 'andromeda'
-- vim.g.sonokai_enable_italic = true
-- vim.g.sonokai_diagnostic_virtual_text = 'colored'
-- vim.cmd('colorscheme sonokai')

vim.opt.completeopt = 'menuone,noinsert,noselect'
-- Don't show the dumb matching stuff.
vim.cmd [[set shortmess+=c]]

vim.opt.spell = true
vim.opt.spelllang = 'en,de'

function StatusLine()
    local statusline = table.concat({
        "%<%f",
        " %h%m%r",
    })

    local branch = git_worktree()

    if branch ~= "" then
        statusline = table.concat({
            statusline,
            " |  %-25.(" .. branch .. "%)",
        })
    end

    statusline = table.concat({
        statusline,
        "%=%-14.(%l,%c%V%) ",
        "%P"
    })
    return statusline
end

vim.opt.statusline = "%!luaeval('StatusLine()')"
