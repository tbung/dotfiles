vim.opt.formatoptions = "cqj"

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
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "terminal",
  "localoptions",
}
vim.opt.exrc = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.laststatus = 3
vim.opt.showmode = false

vim.opt.wildignorecase = true

vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.fillchars = {
  foldclose = "",
  foldopen = "",
}

vim.opt.statuscolumn = [[%!v:lua.require'tillb.signcol'.column()]]

local tty = false
for _, ui in ipairs(vim.api.nvim_list_uis()) do
  if ui.chan == 1 and ui.stdout_tty then
    tty = true
    break
  end
end

if tty and (vim.g.clipboard == nil or vim.o.clipboard == "") and (os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")) then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = function() end,
      ["*"] = function() end,
    },
  }
end

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.hl").on_yank({ timeout = 150 })
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
