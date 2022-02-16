function P(arg)
  print(vim.inspect(arg))
end

function R(arg)
  require("plenary.reload").reload_module(arg)
  return require(arg)
end
