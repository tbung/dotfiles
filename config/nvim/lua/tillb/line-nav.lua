-- Inspired by https://github.com/jinh0/eyeliner.nvim

local M = {}

function M.highlight(direction)
  local line = vim.api.nvim_get_current_line()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))

  local start, end_, step
  if direction == "right" then
    start = col
    end_ = #line
    step = 1
  elseif direction == "left" then
    start = col
    end_ = 1
    step = -1
  end

  local freqs = {} --- @type table[string, integer]

  -- Skip until end of current word, but count freqs
  local char = line:sub(start, start)
  local byte = char:lower()
  while (byte >= "a" and byte <= "z") and start ~= end_ do
    freqs[char] = (freqs[char] or 0) + 1
    start = start + step
    char = line:sub(start, start)
    byte = char:lower()
  end

  local chars = {}

  local min_word = { idx = nil, freq = 99999 }
  for i = start, end_, step do
    char = line:sub(i, i)
    byte = char:lower()
    freqs[char] = (freqs[char] or 0) + 1

    if byte >= "a" and byte <= "z" then
      if freqs[char] < min_word.freq then
        min_word = { idx = i, freq = freqs[char] }
      end
    else
      if min_word.idx ~= nil and min_word.freq <= 2 then
        table.insert(chars, min_word)
      end
      min_word = { freq = 99999 }
    end
  end

  if direction == "right" then
    vim.api.nvim_buf_set_extmark(buf, vim.api.nvim_create_namespace("line-nav"), row - 1, col, {
      end_col = #line,
      hl_group = "Comment",
      invalidate = false,
    })
  else
    vim.api.nvim_buf_set_extmark(buf, vim.api.nvim_create_namespace("line-nav"), row - 1, 0, {
      end_col = col,
      hl_group = "Comment",
      invalidate = false,
    })
  end
  for _, char in ipairs(chars) do
    vim.api.nvim_buf_set_extmark(buf, vim.api.nvim_create_namespace("line-nav"), row - 1, char.idx - 1, {
      end_col = char.idx,
      hl_group = (char.freq == 1 and "Constant") or "Define",
      invalidate = false,
    })
  end
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    once = true,
    callback = function(args)
      vim.api.nvim_buf_clear_namespace(buf, vim.api.nvim_create_namespace("line-nav"), row - 1, row)
      vim.on_key(nil, vim.api.nvim_create_namespace("line-nav"))
    end,
  })
  vim.on_key(function(key, typed)
    if vim.fn.keytrans(key) == "<Esc>" then
      vim.api.nvim_buf_clear_namespace(buf, vim.api.nvim_create_namespace("line-nav"), row - 1, row)
      vim.on_key(nil, vim.api.nvim_create_namespace("line-nav"))
    end
  end, vim.api.nvim_create_namespace("line-nav"))
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
