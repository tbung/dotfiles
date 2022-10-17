local function get_selection_range()
  local start_row = vim.fn.line("'[")
  local end_row = vim.fn.line("']")
  if start_row <= end_row then
    return start_row, end_row
  else
    return end_row, start_row
  end
end

vim.keymap.set("n", "d", function()
  _G.operator_qfdelete = function()
    local start_row, end_row = get_selection_range()
    local qflist = vim.fn.getqflist()
    local new = {}
    for i, item in ipairs(qflist) do
      if i < start_row or i > end_row then
        table.insert(new, item)
      end
    end
    vim.fn.setqflist(new)
  end

  vim.opt.operatorfunc = "v:lua.operator_qfdelete"
  return "g@"
end, { buffer = true, expr = true })

vim.keymap.set("n", "dd", function()
  local cur = vim.api.nvim_win_get_cursor(0)
  local qflist = vim.fn.getqflist()
  local new = {}
  for i, item in ipairs(qflist) do
    if i ~= cur[1] then
      table.insert(new, item)
    end
  end
  vim.fn.setqflist(new)
end, { buffer = true })

local function get_visual_range()
  local start_row = vim.fn.line([[v]])
  local end_row = vim.fn.line([[.]])
  if start_row <= end_row then
    return start_row, end_row
  else
    return end_row, start_row
  end
end

vim.keymap.set("x", "d", function()
  local start_row, end_row = get_visual_range()
  local qflist = vim.fn.getqflist()
  local new = {}
  for i, item in ipairs(qflist) do
    if i < start_row or i > end_row then
      table.insert(new, item)
    end
  end
  vim.fn.setqflist(new)
  return ""
end, { buffer = true, expr = true })
