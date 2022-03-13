M = {}

M.bufferize = function(cmd)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, 0, vim.split(vim.api.nvim_exec(cmd, 1), "\n"))
  vim.api.nvim_buf_set_name(bufnr, cmd)
  vim.cmd([[
  split
  ]])
  vim.api.nvim_win_set_buf(0, bufnr)
end

return M
