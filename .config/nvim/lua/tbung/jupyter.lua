local M = {}

local cell_delim = "^# %%"

function M.cell_start()
  return vim.fn.search(cell_delim, "bcWn")
end

function M.cell_end()
  return vim.fn.search(cell_delim, "Wn") - 1
end

function M.select_cell(buf)
  local start_row = M.cell_start()
  local end_row = M.cell_end()

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
