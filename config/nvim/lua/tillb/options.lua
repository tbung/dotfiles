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

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

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
    vim.opt_local.filetype = "terminal"
  end,
  group = vim.api.nvim_create_augroup("terminal_settings", {}),
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = true,
})

vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineError",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineError", true).special }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineWarn",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineWarn", true).special }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineInfo",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineInfo", true).special }
)
vim.api.nvim_set_hl(
  0,
  "DiagnosticUnderlineHint",
  { undercurl = true, special = vim.api.nvim_get_hl_by_name("DiagnosticUnderlineHint", true).special }
)

vim.cmd([[sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=]])
vim.cmd([[sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=]])
