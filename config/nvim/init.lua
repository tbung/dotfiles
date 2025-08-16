vim.o.formatoptions = "cqj"

vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true

vim.o.wrap = false

vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.sessionoptions = table.concat({
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "terminal",
  "localoptions",
}, ",")
vim.o.exrc = true

vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"

vim.o.updatetime = 50
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.laststatus = 3
vim.o.showmode = false

vim.o.wildignorecase = true

vim.o.completeopt = "menuone,fuzzy,popup,noinsert"
vim.o.autocomplete = true
vim.o.complete = "."

vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.o.fillchars =  "foldclose:,foldopen:"

vim.o.statuscolumn = [[%!v:lua.require'tillb.signcol'.column()]]

vim.cmd.colorscheme("basic")

require("tillb.statusline")
