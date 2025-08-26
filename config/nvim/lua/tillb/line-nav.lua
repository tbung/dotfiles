-- Inspired by https://github.com/jinh0/eyeliner.nvim

local M = {}

local function isalpha(str)
  return str and ((str <= "z" and str >= "a") or (str <= "Z" and str >= "A"))
end

function M.highlight(direction)
  local ns = vim.api.nvim_create_namespace("line-nav")
  local set_extmark = vim.api.nvim_buf_set_extmark

  local line = vim.api.nvim_get_current_line()
  local iter = vim.iter(vim.split(line, "")):enumerate()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))

  if direction == "right" then
    iter:skip(col + 1)

    if iter:peek() == nil then
      return
    end

    set_extmark(buf, ns, row - 1, col, { end_col = #line, hl_group = "Comment", invalidate = false })
  else
    if col == 0 then
      return
    end

    iter:take(col + 1):rev()

    set_extmark(buf, ns, row - 1, 0, { end_col = col, hl_group = "Comment", invalidate = false })
  end

  local freqs = {} --- @type table[string, integer]
  local acc = { idx = nil, freq = 99999 }

  iter:skip(function(_, c)
    freqs[c] = (freqs[c] or 0) + 1
    return isalpha(c)
  end):each(function(i, c)
    freqs[c] = (freqs[c] or 0) + 1

    if isalpha(c) then
      if freqs[c] < acc.freq then
        acc.idx = i
        acc.freq = freqs[c]
      end
    else
      if acc.freq <= 2 then
        set_extmark(buf, ns, row - 1, acc.idx - 1, {
          end_col = acc.idx,
          hl_group = (acc.freq == 1 and "Constant") or "Define",
          invalidate = false,
        })
      end
      acc.freq = 99999
    end
  end)

  -- ignore next {f, F, t, T}, then clear on the next key
  vim.on_key(function()
    vim.on_key(function()
      vim.api.nvim_buf_clear_namespace(buf, ns, row - 1, row)
      vim.on_key(nil, ns)
    end, ns)
  end, ns)

  vim.cmd.redraw()
end

function M.on_key(key)
  if key == "f" or key == "t" then
    M.highlight("right")
  else
    M.highlight("left")
  end

  return key
end

return M
