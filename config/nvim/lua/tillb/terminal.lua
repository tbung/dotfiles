local M = {}

---@class Terminal
---@field bufid integer

local terminal = nil ---@type Terminal?

M.create_terminal = function(cmd)
  local bufid = vim.api.nvim_create_buf(true, false)

  vim.api.nvim_buf_call(bufid, function()
    vim.cmd("terminal " .. (cmd or vim.o.shell))
  end)

  terminal = { bufid = bufid }
  return terminal
end

M.open_terminal = function()
  if not terminal or not vim.api.nvim_buf_is_valid(terminal.bufid) then
    terminal = M.create_terminal()
  end

  vim.api.nvim_set_current_buf(terminal.bufid)
end

M.terminal_make = function(args)
  local term = M.create_terminal(vim.o.makeprg)

  if not args or not args.bang then
    vim.api.nvim_set_current_buf(term.bufid)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
  end
end

M.edit_makeprg = function()
  vim.ui.input({ default = vim.o.makeprg }, function(input)
    if input ~= nil then
      vim.o.makeprg = input
    end
  end)
end

return M
