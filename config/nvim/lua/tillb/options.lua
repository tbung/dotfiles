-- HACK: disable termsync while it's broken in wezterm mux
vim.opt.termsync = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "terminal", "options" }

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.laststatus = 3
vim.opt.showmode = false

vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
vim.opt.fillchars = {
  foldclose = "",
  foldopen = "",
}

vim.opt.statuscolumn = [[%!v:lua.require'tillb.signcol'.column()]]

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
end

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.highlight").on_yank({ timeout = 150 })
  end,
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
  group = vim.api.nvim_create_augroup("terminal_settings", {}),
})

vim.api.nvim_create_user_command("EditMakeprg", function()
  require("tillb.terminal").edit_makeprg()
end, {})

vim.api.nvim_create_user_command("TMake", function()
  require("tillb.terminal").terminal_make()
end, {})
