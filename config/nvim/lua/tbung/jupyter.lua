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

  local mode = vim.api.nvim_get_mode().mode

  if not vim.tbl_contains({ "v", "V" }, mode) then
    mode = "V"
  end

  vim.cmd("normal! ")
  vim.fn.setpos(".", { buf, start_row, 0, 0 })
  vim.cmd("normal! " .. mode)
  vim.fn.setpos(".", { buf, end_row, 0, 0 })
  vim.cmd("normal! $")

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

function M.launch()
  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, bufnr)
  vim.fn.termopen("jupyter lab")
end

return M
