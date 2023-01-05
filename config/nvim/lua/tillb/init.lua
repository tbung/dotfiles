require("tillb.options")
require("tillb.keymap")

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

vim.api.nvim_create_user_command("PackerInstall", function()
  R("tillb.plugins")
  require("packer").install()
end, {})
vim.api.nvim_create_user_command("PackerUpdate", function()
  R("tillb.plugins")
  require("packer").update()
end, {})
vim.api.nvim_create_user_command("PackerSync", function()
  R("tillb.plugins")
  require("packer").sync()
end, {})
vim.api.nvim_create_user_command("PackerClean", function()
  R("tillb.plugins")
  require("packer").clean()
end, {})
vim.api.nvim_create_user_command("PackerCompile", function()
  R("tillb.plugins")
  require("packer").compile()
end, {})
