vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 4
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3)
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.showmode = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.spell = true
vim.opt.spelllang = "en"
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.cmd([[set shortmess+=c]])
vim.opt.wildoptions = "tagfile"
vim.opt.mouse = "a"
vim.opt.laststatus = 3
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.cmd("colorscheme tokyonight")

local id = vim.api.nvim_create_augroup("highlight_yank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.highlight").on_yank({ timeout = 40 })
  end,
  group = id,
})

id = vim.api.nvim_create_augroup("terminal_settings", {})
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
  group = id,
})

id = vim.api.nvim_create_augroup("packer_user_config", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {
    vim.fn.expand("$XDG_CONFIG_HOME/nvim/lua/plugins/*.lua"),
    vim.fn.expand("$HOME/Projects/dotfiles/config/nvim/lua/plugins/*.lua"),
    "config/nvim/lua/plugins/*.lua",
  },
  command = [[ source ~/.config/nvim/lua/plugins/init.lua | source <afile> | PackerCompile ]],
  group = id,
})
