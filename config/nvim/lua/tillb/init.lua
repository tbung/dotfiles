require("tillb.options")
require("tillb.keymap")
vim.cmd.colorscheme("basic")
require("tillb.statusline")

if vim.g.basic or vim.env.NVIM_BASIC ~= nil then
  return
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("tillb.plugins", {
  dev = { path = "~/Projects", fallback = true },
  defaults = { lazy = true },
  change_detection = {
    enabled = false,
  },
  performance = {
    rtp = {
      reset = false, -- otherwise system-level files are not loaded (e.g. ghostty installs a syntax file on arch)
      disabled_plugins = {
        "gzip",
        "netrwPlugin", -- replaced by oil.nvim
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- needs to load after catppuccin has loaded
require("tillb.statusline")
