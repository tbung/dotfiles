if vim.g.current_compiler ~= nil then
  return
end

vim.g.current_compiler = "uv"

local o = vim.go
if vim.api.nvim_get_commands({}).CompilerSet.definition:match("^setlocal") ~= nil then
  o = vim.bo
end

o.makeprg = [[uv run %]]
