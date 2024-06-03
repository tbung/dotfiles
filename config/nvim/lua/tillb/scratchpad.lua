local M = {}

M.scratchpad = function(ft)
  local ft = ft or "markdown"
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_option_value("filetype", ft, { buf = buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_buf_set_name(buf, "[Scratch] (" .. ft .. ")")
  vim.api.nvim_win_set_buf(0, buf)
end

return M
