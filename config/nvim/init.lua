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
vim.o.wildoptions = "pum,fuzzy"
vim.o.wildmode = "longest:full,full"
if vim.fn.executable("fd") == 1 then
  function _G.Fd_findfunc(cmdarg, _cmdcomplete)
    return require("tillb.findfunc").fd_findfunc(cmdarg, _cmdcomplete)
  end

  vim.o.findfunc = "v:lua.Fd_findfunc"
end

-- NOTE: Could load this on CmdLineEnter, but that causes a flicker that bugs me
if vim.version().minor >= 12 then
  require("vim._extui").enable({})
end

vim.o.completeopt = "menuone,fuzzy,popup,noinsert"
vim.o.autocomplete = true
vim.o.complete = "."

vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.o.fillchars = "foldclose:,foldopen:"

vim.o.statuscolumn = [[%!v:lua.require("tillb.signcol").column()]]
vim.o.statusline = [[%<%{%v:lua.require("tillb.statusline").statusline()%}]]
vim.o.winbar = [[%<%{%v:lua.require("tillb.statusline").winbar()%}]]

vim.cmd.colorscheme("basic")

-- disable a bunch of legacy plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1
