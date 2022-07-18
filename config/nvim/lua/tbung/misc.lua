--- Sum integers in a table
---@param numbers number[]
---@return number
M.sum = function(numbers)
  local s = 0

  for _, n in ipairs(numbers) do
    s = s + n
  end

  return s
end

--- Sum over yanked numbers, separated by line
M.sum_yanked = function()
  local tbl = vim.split(vim.fn.getreg('"0'), "\n")
  tbl = vim.tbl_map(function(x)
    return tonumber(x)
  end, tbl)
  tbl = vim.tbl_filter(function(x)
    return x ~= nil
  end, tbl)
  return M.sum(tbl)
end
