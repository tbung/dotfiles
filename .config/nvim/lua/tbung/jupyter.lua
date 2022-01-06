local M = {}

local cell_delim = "^# %%"

function M.cell_start()
  return vim.fn.search(cell_delim, "bWn")
end

function M.cell_end()
  return vim.fn.search(cell_delim, "wn") - 1
end

function M.select_cell(buf)
  local start_row = M.cell_start()
  local end_row = M.cell_end()

  vim.fn.setpos(".", { buf, start_row, 0, 0 })

  -- Start visual selection in appropriate mode
  local v_table = { charwise = "v", linewise = "V", blockwise = "<C-v>" }
  ---- Call to `nvim_replace_termcodes()` is needed for sending appropriate
  ---- command to enter blockwise mode
  local mode_string = vim.api.nvim_replace_termcodes("V", true, true, true)
  vim.cmd("normal! " .. mode_string)
  vim.fn.setpos(".", { buf, end_row, 0, 0 })
end

return M

