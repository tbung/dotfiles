require("tillb.options")
require("tillb.keymap")

if vim.g.basic or vim.env.NVIM_BASIC ~= nil then
  -- use default colors, but set background transparent
  for _, hl_name in ipairs({ "Normal", "NonText", "EndOfBuffer" }) do
    local hl = vim.api.nvim_get_hl(0, { name = hl_name })
    hl.bg = nil
    vim.api.nvim_set_hl(0, hl_name, hl)
  end

  return
end

local execute = vim.api.nvim_command
local fn = vim.fn

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
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
      disabled_plugins = {
        "gzip",
        "matchit", -- replaced by vim-matchup
        "matchparen", -- replaced by vim-matchup
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
