vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 4
vim.opt.linebreak = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.showmode = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.spell = true
vim.opt.spelllang = "en,de"
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.cmd([[set shortmess+=c]])

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.cmd("colorscheme tokyonight")

vim.cmd([[
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END
]])

vim.cmd([[
augroup terminal_settings
    autocmd!
    autocmd TermOpen * setlocal nospell
augroup END
]])
