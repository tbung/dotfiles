local M = {}

---@class Terminal
---@field bufid integer

local terminal = nil ---@type Terminal?

---@param cmd string|string[]?
M.create_terminal = function(cmd)
  if type(cmd) == "table" then
    cmd = table.concat(cmd, " ")
  end
  local bufid = vim.api.nvim_create_buf(true, false)

  vim.api.nvim_buf_call(bufid, function()
    vim.cmd.terminal(cmd)
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

---@param args string[]
---@param focus boolean
M.terminal_make = function(args, focus)
  local term = M.create_terminal({ vim.fn.expandcmd(vim.o.makeprg), unpack(args) })

  if focus then
    vim.api.nvim_set_current_buf(term.bufid)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
  end
end

M.edit_makeprg = function()
  vim.ui.input({
    default = vim.o.makeprg,
    prompt = "makeprg",
    highlight = function()
      local buf = vim.api.nvim_get_current_buf()
      local parser = assert(vim.treesitter.get_parser(buf, "bash", {}))
      local highlighter = vim.treesitter.highlighter.new(parser)
      highlighter.active[buf] = highlighter
    end,
  }, function(input)
    if input ~= nil then
      vim.o.makeprg = input
    end
  end)
end

return M
