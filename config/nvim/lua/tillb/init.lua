require("tillb.options")
require("tillb.keymap")
require("tillb.plugins")
require("tillb.statusline")

function P(arg)
  print(vim.inspect(arg))
end

function R(arg)
  local ok, plenary_reload = pcall(require, "plenary.reload")
  local reload
  if ok then
    reload = plenary_reload.reload_module
  else
    reload = require
  end
  reload(arg)
  return require(arg)
end
