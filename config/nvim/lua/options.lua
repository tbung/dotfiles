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
vim.opt.shortmess = vim.opt.shortmess + "c"
vim.opt.wildoptions = "tagfile"
vim.opt.mouse = "a"
vim.opt.laststatus = 3
-- vim.opt.cmdheight = 0
vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.textwidth = 100

-- TODO: Maybe only set this if the line is too long -> autocmd
vim.opt.colorcolumn = "+1"

vim.filetype.add({
  extension = {
    h = "c",
  },
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.highlight").on_yank({ timeout = 40 })
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

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {
    vim.fn.expand("$XDG_CONFIG_HOME/nvim/lua/plugins/*.lua"),
    vim.fn.expand("$HOME/Projects/dotfiles/config/nvim/lua/plugins/*.lua"),
    "config/nvim/lua/plugins/*.lua",
  },
  command = [[ source ~/.config/nvim/lua/plugins/init.lua | source <afile> | PackerCompile ]],
  group = vim.api.nvim_create_augroup("packer_user_config", {}),
})

vim.api.nvim_create_autocmd({ "WinClosed", "WinEnter" }, {
  callback = function()
    require("tbung").close_only_sidebars()
  end,
  group = vim.api.nvim_create_augroup("autoclose_sidebars", {}),
})

vim.api.nvim_create_user_command("UpdateEnv", function()
  require("tbung").update_ssh_env_from_tmux()
end, { desc = "Update SSH environment variables from tmux to enable agent and X11 forwarding", force = true })

vim.api.nvim_create_user_command("Scratch", function(args)
  require("tbung").create_scratch_buf(args.fargs[1])
end, { desc = "Update SSH environment variables from tmux to enable agent and X11 forwarding", force = true, nargs = 1, complete = "filetype" })

vim.api.nvim_create_user_command("InitPacker", function()
  require("plugins")
end, { desc = "Update SSH environment variables from tmux to enable agent and X11 forwarding", force = true })
