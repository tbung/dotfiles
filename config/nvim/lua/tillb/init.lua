require("tillb.options")
require("tillb.keymap")
vim.cmd.colorscheme("basic")
require("tillb.statusline")

if vim.g.basic or vim.env.NVIM_BASIC ~= nil then
  return
end

require("tillb.plugins.lsp")
require("tillb.plugins.colors")
require("tillb.plugins.treesitter")
require("tillb.plugins.misc")
