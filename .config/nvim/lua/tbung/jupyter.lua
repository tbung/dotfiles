local M = {}

local cell_delim = "^# %%"

function M.cell_start()
  return vim.fn.search(cell_delim, "bcWn")
end

function M.cell_end()
  local pos = vim.fn.search(cell_delim, "Wn") - 1
  if pos == -1 then
    pos = vim.api.nvim_buf_line_count(0)
  end
  return pos
end

function M.select_cell(buf)
  local start_row = M.cell_start()
  local end_row = M.cell_end()

  vim.cmd("normal! ")
  vim.fn.setpos(".", { buf, start_row, 0, 0 })
  vim.cmd("normal! V")
  vim.fn.setpos(".", { buf, end_row, 0, 0 })
end

function M.goto_previous_cell_start()
  vim.fn.setpos(".", { 0, M.cell_start() - 1, 0, 0 })
  vim.fn.setpos(".", { 0, M.cell_start(), 0, 0 })
end

function M.goto_previous_cell_end()
  vim.fn.setpos(".", { 0, M.cell_start() - 1, 0, 0 })
end

function M.goto_next_cell_start()
  vim.fn.setpos(".", { 0, M.cell_end() + 1, 0, 0 })
end

function M.goto_next_cell_end()
  vim.fn.setpos(".", { 0, M.cell_end() + 1, 0, 0 })
  vim.fn.setpos(".", { 0, M.cell_end(), 0, 0 })
end

return M
